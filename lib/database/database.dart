import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

// Tables
class AppUsers extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get email => text()();
  TextColumn get password => text()();
  TextColumn get role => text()(); // 'customer' or 'shopper'
  TextColumn get address => text()();
  TextColumn get phone => text()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ServiceOrders extends Table {
  TextColumn get id => text()();
  TextColumn get customerId => text()();
  TextColumn get shopperId => text()();
  TextColumn get title => text()();
  TextColumn get pickupAddress => text()();
  TextColumn get deliveryAddress => text()();
  RealColumn get pickupLat => real()();
  RealColumn get pickupLng => real()();
  RealColumn get deliveryLat => real()();
  RealColumn get deliveryLng => real()();
  RealColumn get shopperLat => real()();
  RealColumn get shopperLng => real()();
  TextColumn get status =>
      text()(); // 'requested', 'inTransit', 'delivered', 'completed', 'disputed'
  TextColumn get itemsList => text()(); // JSON array stored as string
  RealColumn get shopperRating => real().nullable()();
  TextColumn get disputeReason => text().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class OrderMessages extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get orderId => text().customConstraint(
    'NOT NULL REFERENCES service_orders(id) ON DELETE CASCADE',
  )();
  TextColumn get senderId => text()();
  TextColumn get message => text()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class ProofFiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get orderId => text().customConstraint(
    'NOT NULL REFERENCES service_orders(id) ON DELETE CASCADE',
  )();
  TextColumn get filePath => text()();
  TextColumn get fileName => text()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [AppUsers, ServiceOrders, OrderMessages, ProofFiles])
class ServiceDeliveryDatabase extends _$ServiceDeliveryDatabase {
  ServiceDeliveryDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // User queries
  Future<AppUser?> getUserById(String userId) =>
      (select(appUsers)..where((t) => t.id.equals(userId))).getSingleOrNull();

  Future<List<AppUser>> getAllUsers() => select(appUsers).get();

  Future<void> insertUser(AppUser user) => into(appUsers).insert(user);

  Future<void> updateUser(AppUser user) => update(appUsers).replace(user);

  // Order queries
  Future<ServiceOrder?> getOrderById(String orderId) => (select(
    serviceOrders,
  )..where((t) => t.id.equals(orderId))).getSingleOrNull();

  Future<List<ServiceOrder>> getOrdersByCustomerId(String customerId) =>
      (select(
        serviceOrders,
      )..where((t) => t.customerId.equals(customerId))).get();

  Future<List<ServiceOrder>> getOrdersByShopperId(String shopperId) => (select(
    serviceOrders,
  )..where((t) => t.shopperId.equals(shopperId))).get();

  Future<List<ServiceOrder>> getAllOrders() => select(serviceOrders).get();

  Future<List<ServiceOrder>> getUnsyncedOrders() =>
      (select(serviceOrders)..where((t) => t.isSynced.equals(false))).get();

  Future<void> insertOrder(ServiceOrder order) =>
      into(serviceOrders).insert(order);

  Future<void> updateOrder(ServiceOrder order) =>
      update(serviceOrders).replace(order);

  // Message queries
  Future<List<OrderMessage>> getOrderMessages(String orderId) =>
      (select(orderMessages)..where((t) => t.orderId.equals(orderId))).get();

  Future<List<OrderMessage>> getUnsyncedMessages() =>
      (select(orderMessages)..where((t) => t.isSynced.equals(false))).get();

  Future<OrderMessage?> findMessage(
    String orderId,
    String senderId,
    String message,
    DateTime createdAt,
  ) {
    final query = select(orderMessages)
      ..where((t) => t.orderId.equals(orderId));

    query.where((t) => t.senderId.equals(senderId));
    query.where((t) => t.message.equals(message));
    query.where((t) => t.createdAt.equals(createdAt));

    return query.getSingleOrNull();
  }

  Future<void> markMessageSynced(int messageId) =>
      (update(orderMessages)..where((t) => t.id.equals(messageId))).write(
        const OrderMessagesCompanion(isSynced: Value(true)),
      );

  Future<void> insertMessage(OrderMessage message) =>
      into(orderMessages).insert(message);

  // Proof file queries
  Future<List<ProofFile>> getOrderProofs(String orderId) =>
      (select(proofFiles)..where((t) => t.orderId.equals(orderId))).get();

  Future<void> insertProof(ProofFile proof) => into(proofFiles).insert(proof);

  Future<void> markProofSynced(int proofId) =>
      (update(proofFiles)..where((t) => t.id.equals(proofId))).write(
        const ProofFilesCompanion(isSynced: Value(true)),
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'service_delivery.db'));
    return NativeDatabase(file);
  });
}
