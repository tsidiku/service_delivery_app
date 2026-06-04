import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'database.dart';

// Supabase credentials are read from compile/runtime environment variables.
// Use `--dart-define=SUPABASE_URL=https://...` and
// `--dart-define=SUPABASE_ANON_KEY=your-anon-key` when running:
// flutter run --dart-define=SUPABASE_URL="https://..." --dart-define=SUPABASE_ANON_KEY="..."
// If not provided, these defaults are safe placeholders that must be replaced
// with your real project values before enabling real cloud sync.
const String _supabaseUrl = String.fromEnvironment(
  'SUPABASE_URL',
  defaultValue: 'https://nukurjltgczkkdzholff.supabase.co',
);
const String _supabaseAnonKey = String.fromEnvironment(
  'SUPABASE_ANON_KEY',
  defaultValue: 'sb_publishable_rrbjK7a3LjAxE1EAjUxHRQ_NvHuIQuz',
);

class SupabaseSyncService {
  final ServiceDeliveryDatabase db;
  late final SupabaseClient supabase;
  final Set<String> _unauthorizedProofs = <String>{};

  /// Returns a copy of unauthorized proof file names (403/RLS) detected during uploads
  List<String> get unauthorizedProofs => List.unmodifiable(_unauthorizedProofs);

  /// Clear tracked unauthorized proof file names (user dismissed)
  void clearUnauthorizedProofs() => _unauthorizedProofs.clear();

  SupabaseSyncService(this.db);

  /// Initialize Supabase (call this once at app startup)
  /// Replace with your actual Supabase credentials
  Future<void> initialize() async {
    await Supabase.initialize(url: _supabaseUrl, anonKey: _supabaseAnonKey);
    supabase = Supabase.instance.client;
  }

  /// Sync orders from local DB to Supabase
  Future<void> syncOrdersToCloud() async {
    try {
      final unsyncedOrders = await db.getUnsyncedOrders();

      for (final order in unsyncedOrders) {
        try {
          await supabase.from('service_orders').upsert({
            'id': order.id,
            'customer_id': order.customerId,
            'shopper_id': order.shopperId,
            'title': order.title,
            'pickup_address': order.pickupAddress,
            'delivery_address': order.deliveryAddress,
            'pickup_lat': order.pickupLat,
            'pickup_lng': order.pickupLng,
            'delivery_lat': order.deliveryLat,
            'delivery_lng': order.deliveryLng,
            'shopper_lat': order.shopperLat,
            'shopper_lng': order.shopperLng,
            'status': order.status,
            'items_list': order.itemsList,
            'shopper_rating': order.shopperRating,
            'dispute_reason': order.disputeReason,
            'created_at': order.createdAt.toIso8601String(),
            'updated_at': order.updatedAt.toIso8601String(),
          });

          // Mark as synced in local DB
          await db
              .update(db.serviceOrders)
              .replace(order.copyWith(isSynced: true));
        } catch (e) {
          debugPrint('Error syncing order ${order.id}: $e');
        }
      }
    } catch (e) {
      debugPrint('Error syncing orders to cloud: $e');
    }
  }

  /// Sync messages to Supabase
  Future<void> syncMessagesToCloud() async {
    try {
      final unsyncedMessages = await db.getUnsyncedMessages();

      for (final message in unsyncedMessages) {
        try {
          await supabase.from('order_messages').insert({
            'order_id': message.orderId,
            'sender_id': message.senderId,
            'message': message.message,
            'created_at': message.createdAt.toIso8601String(),
          });

          await db.markMessageSynced(message.id);
        } catch (e) {
          debugPrint('Error syncing message ${message.id}: $e');
        }
      }
    } catch (e) {
      debugPrint('Error syncing messages to cloud: $e');
    }
  }

  /// Sync messages from Supabase for orders that already exist locally.
  Future<void> syncMessagesFromCloud() async {
    try {
      final localOrders = await db.getAllOrders();
      final orderIds = localOrders.map((order) => order.id).toList();

      if (orderIds.isEmpty) {
        debugPrint('No local orders found; skipping remote message sync.');
        return;
      }

      final response = await supabase
          .from('order_messages')
          .select()
          .filter(
            'order_id',
            'in',
            "(${orderIds.map((id) => "'$id'").join(',')})",
          )
          .order('created_at', ascending: true);

      for (final raw in response) {
        try {
          final orderId = raw['order_id'] as String;
          final senderId = raw['sender_id'] as String;
          final messageText = raw['message'] as String;
          final createdAtValue = raw['created_at'];
          final createdAt = createdAtValue is String
              ? DateTime.parse(createdAtValue)
              : DateTime.parse(createdAtValue.toString());

          final existing = await db.findMessage(
            orderId,
            senderId,
            messageText,
            createdAt,
          );

          if (existing == null) {
            final companion = OrderMessagesCompanion(
              orderId: drift.Value(orderId),
              senderId: drift.Value(senderId),
              message: drift.Value(messageText),
              isSynced: const drift.Value(true),
              createdAt: drift.Value(createdAt),
            );
            await db.into(db.orderMessages).insert(companion);
          }
        } catch (e) {
          debugPrint('Error syncing remote message to local DB: $e');
        }
      }
    } catch (e) {
      debugPrint('Error syncing messages from cloud: $e');
    }
  }

  /// Sync proof files to Supabase storage
  Future<void> syncProofsToCloud() async {
    const maxUploadAttempts = 3;
    try {
      final unsyncedProofs = await db
          .select(db.proofFiles)
          .get()
          .then((proofs) => proofs.where((p) => !p.isSynced).toList());

      for (final proof in unsyncedProofs) {
        final file = File(proof.filePath);
        if (!await file.exists()) {
          debugPrint('Proof file missing, skipping upload: ${proof.filePath}');
          continue;
        }

        final bytes = await file.readAsBytes();
        final storagePath = 'proofs/${proof.orderId}/${proof.fileName}';
        var attempt = 0;

        while (attempt < maxUploadAttempts) {
          attempt += 1;
          try {
            await supabase.storage
                .from('order-proofs')
                .uploadBinary(
                  storagePath,
                  bytes,
                  fileOptions: const FileOptions(upsert: true),
                );

            await db.markProofSynced(proof.id);
            break;
          } catch (e) {
            final statusCode = e is StorageException
                ? e.statusCode?.toString()
                : null;
            final isUnauthorized = statusCode == '401' || statusCode == '403';
            final isTransient = e is SocketException || e is TimeoutException;

            if (isUnauthorized) {
              if (!_unauthorizedProofs.contains(proof.fileName)) {
                debugPrint(
                  'Unauthorized uploading proof ${proof.fileName}: ${e.toString()}. '
                  'Check Supabase storage policy / RLS permissions.',
                );
                _unauthorizedProofs.add(proof.fileName);
              }
              break;
            }

            if (attempt >= maxUploadAttempts || !isTransient) {
              debugPrint(
                'Failed syncing proof ${proof.fileName} after $attempt attempt(s): $e',
              );
              break;
            }

            debugPrint(
              'Transient error uploading proof ${proof.fileName} (attempt $attempt): $e',
            );
            await Future.delayed(Duration(seconds: 1 << attempt));
          }
        }
      }
    } catch (e) {
      debugPrint('Error syncing proofs to cloud: $e');
    }
  }

  /// Fetch orders from Supabase (for multi-device sync)
  Future<void> syncOrdersFromCloud() async {
    try {
      final response = await supabase
          .from('service_orders')
          .select()
          .order('updated_at', ascending: false);

      for (final orderData in response) {
        try {
          final order = ServiceOrder(
            id: orderData['id'] as String,
            customerId: orderData['customer_id'] as String,
            shopperId: orderData['shopper_id'] as String,
            title: orderData['title'] as String,
            pickupAddress: orderData['pickup_address'] as String,
            deliveryAddress: orderData['delivery_address'] as String,
            pickupLat: (orderData['pickup_lat'] as num).toDouble(),
            pickupLng: (orderData['pickup_lng'] as num).toDouble(),
            deliveryLat: (orderData['delivery_lat'] as num).toDouble(),
            deliveryLng: (orderData['delivery_lng'] as num).toDouble(),
            shopperLat: (orderData['shopper_lat'] as num).toDouble(),
            shopperLng: (orderData['shopper_lng'] as num).toDouble(),
            status: orderData['status'] as String,
            itemsList: orderData['items_list'] as String,
            shopperRating: (orderData['shopper_rating'] as num?)?.toDouble(),
            disputeReason: orderData['dispute_reason'] as String?,
            createdAt: DateTime.parse(orderData['created_at'] as String),
            updatedAt: DateTime.parse(orderData['updated_at'] as String),
            isSynced: true,
          );

          // Upsert into local DB
          await db.into(db.serviceOrders).insertOnConflictUpdate(order);
        } catch (e) {
          debugPrint('Error parsing order data: $e');
        }
      }
    } catch (e) {
      debugPrint('Error syncing orders from cloud: $e');
    }
  }

  /// Get signed proof URL from cloud storage (production-safe, expires in 1 hour)
  Future<String> getProofUrl(String orderId, String fileName) async {
    try {
      final signedUrl = await supabase.storage
          .from('order-proofs')
          .createSignedUrl(
            'proofs/$orderId/$fileName',
            3600,
          ); // expires in 1 hour
      return signedUrl;
    } catch (e) {
      debugPrint('Error creating signed URL for $fileName: $e');
      rethrow;
    }
  }

  /// Perform full sync (bidirectional)
  Future<void> fullSync() async {
    debugPrint('Starting full sync...');
    await syncOrdersFromCloud(); // Pull latest orders from cloud
    await syncMessagesFromCloud(); // Pull latest messages from cloud
    await syncOrdersToCloud(); // Push local order changes
    await syncMessagesToCloud(); // Push local message changes
    await syncProofsToCloud(); // Sync proof files
    debugPrint('Sync complete!');
  }
}
