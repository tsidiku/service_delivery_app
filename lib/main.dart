import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:drift/drift.dart' as drift;
import 'package:service_delivery_app/database/database.dart' as db;
import 'package:service_delivery_app/database/supabase_sync.dart' as sync;

void main() {
  runApp(const ServiceDeliveryApp());
}

class ServiceDeliveryApp extends StatelessWidget {
  const ServiceDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Service Delivery',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MainShell(),
    );
  }
}

enum UserRole { customer, shopper }

class AppUser {
  final String id;
  final String name;
  final String email;
  final String password;
  final UserRole role;
  final String address;
  final String phone;
  final LatLng location;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.address,
    required this.phone,
    required this.location,
  });
}

enum OrderStatus {
  requested,
  inProgress,
  inTransit,
  delivered,
  completed,
  disputed,
}

class ServiceOrder {
  final String id;
  final String customerId;
  final String shopperId;
  final String title;
  final String pickupAddress;
  final String deliveryAddress;
  final LatLng pickupLocation;
  final LatLng deliveryLocation;
  OrderStatus status;
  LatLng shopperLocation;
  final List<String> items;
  final List<Map<String, String>> messages;
  final List<String> proofFiles;
  double? shopperRating;
  String? disputeReason;
  final DateTime createdAt;

  ServiceOrder({
    required this.id,
    required this.customerId,
    required this.shopperId,
    required this.title,
    required this.pickupAddress,
    required this.deliveryAddress,
    required this.pickupLocation,
    required this.deliveryLocation,
    required this.status,
    required this.shopperLocation,
    List<String>? items,
    List<Map<String, String>>? messages,
    List<String>? proofFiles,
    this.shopperRating,
    this.disputeReason,
    required this.createdAt,
  }) : items = items ?? [],
       messages = messages ?? [],
       proofFiles = proofFiles ?? [];

  String get statusLabel {
    switch (status) {
      case OrderStatus.requested:
        return 'Requested';
      case OrderStatus.inProgress:
        return 'In progress';
      case OrderStatus.inTransit:
        return 'In transit';
      case OrderStatus.delivered:
        return 'Delivered (awaiting customer confirmation)';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.disputed:
        return 'Disputed';
    }
  }
}

abstract class OrderSyncService {
  Stream<List<ServiceOrder>> get ordersStream;
  Future<void> connect();
  Future<void> addOrder(ServiceOrder order);
  Future<void> updateOrder(ServiceOrder order);
  Future<void> addMessage(String orderId, String senderId, String text);
  void dispose();
}

class DriftOrderSyncService implements OrderSyncService {
  final _controller = StreamController<List<ServiceOrder>>.broadcast();
  final db.ServiceDeliveryDatabase _db;
  final sync.SupabaseSyncService _sync;
  Timer? _periodicSync;

  DriftOrderSyncService(this._db, this._sync);

  @override
  Stream<List<ServiceOrder>> get ordersStream => _controller.stream;

  Future<void> _loadAndEmit() async {
    final dbOrders = await _db.getAllOrders();
    final List<ServiceOrder> out = [];
    for (final d in dbOrders) {
      final msgs = await _db.getOrderMessages(d.id);
      final proofs = await _db.getOrderProofs(d.id);
      List<String> items = [];
      try {
        final decoded = jsonDecode(d.itemsList);
        items = List<String>.from(decoded);
      } catch (_) {
        items = [];
      }

      out.add(
        ServiceOrder(
          id: d.id,
          customerId: d.customerId,
          shopperId: d.shopperId,
          title: d.title,
          pickupAddress: d.pickupAddress,
          deliveryAddress: d.deliveryAddress,
          pickupLocation: LatLng(d.pickupLat, d.pickupLng),
          deliveryLocation: LatLng(d.deliveryLat, d.deliveryLng),
          status: _stringToStatus(d.status),
          shopperLocation: LatLng(d.shopperLat, d.shopperLng),
          items: items,
          messages: msgs
              .map<Map<String, String>>(
                (m) => {
                  'sender': m.senderId,
                  'text': m.message,
                  'time': m.createdAt.toIso8601String(),
                },
              )
              .toList(),
          proofFiles: proofs.map((p) => p.filePath).toList(),
          shopperRating: d.shopperRating,
          disputeReason: d.disputeReason,
          createdAt: d.createdAt,
        ),
      );
    }
    _controller.add(List.unmodifiable(out));
  }

  OrderStatus _stringToStatus(String s) {
    switch (s) {
      case 'requested':
        return OrderStatus.requested;
      case 'inProgress':
        return OrderStatus.inProgress;
      case 'inTransit':
        return OrderStatus.inTransit;
      case 'delivered':
        return OrderStatus.delivered;
      case 'completed':
        return OrderStatus.completed;
      case 'disputed':
        return OrderStatus.disputed;
      default:
        return OrderStatus.requested;
    }
  }

  String _statusToString(OrderStatus s) => s.name;

  @override
  Future<void> connect() async {
    await _loadAndEmit();
    try {
      await _sync.initialize();
      await _sync.fullSync();
      await _loadAndEmit();
    } catch (e) {
      debugPrint('Sync init failed: $e');
    }

    _periodicSync = Timer.periodic(const Duration(seconds: 30), (_) async {
      try {
        await _sync.fullSync();
        await _loadAndEmit();
      } catch (e) {
        debugPrint('Periodic sync error: $e');
      }
    });
  }

  @override
  Future<void> addOrder(ServiceOrder order) async {
    final companion = db.ServiceOrdersCompanion(
      id: drift.Value(order.id),
      customerId: drift.Value(order.customerId),
      shopperId: drift.Value(order.shopperId),
      title: drift.Value(order.title),
      pickupAddress: drift.Value(order.pickupAddress),
      deliveryAddress: drift.Value(order.deliveryAddress),
      pickupLat: drift.Value(order.pickupLocation.latitude),
      pickupLng: drift.Value(order.pickupLocation.longitude),
      deliveryLat: drift.Value(order.deliveryLocation.latitude),
      deliveryLng: drift.Value(order.deliveryLocation.longitude),
      shopperLat: drift.Value(order.shopperLocation.latitude),
      shopperLng: drift.Value(order.shopperLocation.longitude),
      status: drift.Value(_statusToString(order.status)),
      itemsList: drift.Value(jsonEncode(order.items)),
      shopperRating: drift.Value(order.shopperRating),
      disputeReason: drift.Value(order.disputeReason),
      isSynced: const drift.Value(false),
      createdAt: drift.Value(order.createdAt),
      updatedAt: drift.Value(order.createdAt),
    );
    await _db.into(_db.serviceOrders).insert(companion);
    await _loadAndEmit();
  }

  @override
  Future<void> updateOrder(ServiceOrder order) async {
    final companion = db.ServiceOrdersCompanion(
      title: drift.Value(order.title),
      pickupAddress: drift.Value(order.pickupAddress),
      deliveryAddress: drift.Value(order.deliveryAddress),
      pickupLat: drift.Value(order.pickupLocation.latitude),
      pickupLng: drift.Value(order.pickupLocation.longitude),
      deliveryLat: drift.Value(order.deliveryLocation.latitude),
      deliveryLng: drift.Value(order.deliveryLocation.longitude),
      shopperLat: drift.Value(order.shopperLocation.latitude),
      shopperLng: drift.Value(order.shopperLocation.longitude),
      status: drift.Value(_statusToString(order.status)),
      itemsList: drift.Value(jsonEncode(order.items)),
      shopperRating: drift.Value(order.shopperRating),
      disputeReason: drift.Value(order.disputeReason),
      isSynced: const drift.Value(false),
      updatedAt: drift.Value(DateTime.now()),
    );

    await (_db.update(
      _db.serviceOrders,
    )..where((t) => t.id.equals(order.id))).write(companion);
    await _loadAndEmit();
  }

  @override
  Future<void> addMessage(String orderId, String senderId, String text) async {
    final companion = db.OrderMessagesCompanion(
      orderId: drift.Value(orderId),
      senderId: drift.Value(senderId),
      message: drift.Value(text),
      isSynced: const drift.Value(false),
      createdAt: drift.Value(DateTime.now()),
    );

    await _db.into(_db.orderMessages).insert(companion);
    await _loadAndEmit();
  }

  @override
  void dispose() {
    _periodicSync?.cancel();
    _controller.close();
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  AppUser? _currentUser;
  final List<AppUser> _users = List.of(sampleUsers);
  late final db.ServiceDeliveryDatabase _database;
  late final sync.SupabaseSyncService _syncService;
  late final OrderSyncService _orderSyncService;
  List<ServiceOrder> _orders = [];
  StreamSubscription<List<ServiceOrder>>? _ordersSubscription;
  int _selectedIndex = 0;
  Timer? _trackingTimer;

  @override
  void initState() {
    super.initState();
    _initServices();
  }

  Future<void> _initServices() async {
    _database = db.ServiceDeliveryDatabase();
    _syncService = sync.SupabaseSyncService(_database);
    _orderSyncService = DriftOrderSyncService(_database, _syncService);
    await _orderSyncService.connect();
    _ordersSubscription = _orderSyncService.ordersStream.listen((orders) {
      setState(() {
        _orders = List<ServiceOrder>.from(orders);
      });
    });
  }

  @override
  void dispose() {
    _trackingTimer?.cancel();
    _ordersSubscription?.cancel();
    _orderSyncService.dispose();
    try {
      _database.close();
    } catch (_) {}
    super.dispose();
  }

  void _login(String email, String password) {
    final match = _users.firstWhere(
      (user) => user.email == email && user.password == password,
      orElse: () => throw Exception('Invalid credentials'),
    );
    setState(() {
      _currentUser = match;
      _selectedIndex = 0;
    });
  }

  Future<void> _register(
    String name,
    String email,
    String password,
    UserRole role,
    String address,
    String phone,
  ) async {
    if (_users.any((user) => user.email == email)) {
      throw Exception('Email already registered');
    }
    LatLng loc;
    try {
      final results = await locationFromAddress(address);
      if (results.isNotEmpty) {
        loc = LatLng(results.first.latitude, results.first.longitude);
      } else {
        loc = role == UserRole.customer
            ? const LatLng(37.7749, -122.4194)
            : LatLng(37.7800 + _users.length * 0.002, -122.4100);
      }
    } catch (_) {
      loc = role == UserRole.customer
          ? const LatLng(37.7749, -122.4194)
          : LatLng(37.7800 + _users.length * 0.002, -122.4100);
    }

    final newUser = AppUser(
      id: 'user${_users.length + 1}',
      name: name,
      email: email,
      password: password,
      role: role,
      address: address,
      phone: phone,
      location: loc,
    );

    setState(() {
      _users.add(newUser);
      _currentUser = newUser;
      _selectedIndex = 0;
    });
  }

  void _logout() {
    setState(() {
      _currentUser = null;
      _selectedIndex = 0;
      _trackingTimer?.cancel();
      _trackingTimer = null;
    });
  }

  List<ServiceOrder> get _myOrders {
    if (_currentUser == null) {
      return [];
    }
    final result = _orders.where((order) {
      return order.customerId == _currentUser!.id ||
          order.shopperId == _currentUser!.id;
    }).toList();
    return result;
  }

  ServiceOrder? get _activeOrder {
    final active = _orders.where((order) {
      return order.status != OrderStatus.completed &&
          (order.customerId == _currentUser?.id ||
              order.shopperId == _currentUser?.id);
    }).toList();
    return active.isNotEmpty ? active.first : null;
  }

  void _requestNearestShopper() {
    if (_currentUser == null || _currentUser!.role != UserRole.customer) {
      return;
    }

    if (_activeOrder != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You already have an active request.')),
      );
      return;
    }

    final shoppers = _users.where((user) => user.role == UserRole.shopper);
    if (shoppers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No available shoppers found.')),
      );
      return;
    }

    final customerLocation = _currentUser!.location;
    final nearest = shoppers.reduce((a, b) {
      final da = const Distance().as(
        LengthUnit.Meter,
        a.location,
        customerLocation,
      );
      final db = const Distance().as(
        LengthUnit.Meter,
        b.location,
        customerLocation,
      );
      return da <= db ? a : b;
    });

    final order = ServiceOrder(
      id: 'o${_orders.length + 1}',
      customerId: _currentUser!.id,
      shopperId: nearest.id,
      title: 'Grocery shopping and delivery',
      pickupAddress: nearest.address,
      deliveryAddress: _currentUser!.address,
      pickupLocation: nearest.location,
      deliveryLocation: customerLocation,
      status: OrderStatus.requested,
      shopperLocation: nearest.location,
      createdAt: DateTime.now(),
    );

    setState(() {
      _orders.add(order);
    });
    _orderSyncService.addOrder(order);
    debugPrint(
      'DEBUG [_requestNearestShopper]: Created order ${order.id} for shopper ${order.shopperId} (customer ${order.customerId})',
    );
    debugPrint('  Total orders now: ${_orders.length}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Request sent to ${nearest.name}. Waiting for response.'),
      ),
    );
  }

  void _requestShopper(String shopperId) {
    if (_currentUser == null || _currentUser!.role != UserRole.customer) {
      return;
    }

    if (_activeOrder != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You already have an active request.')),
      );
      return;
    }

    final shoppers = _users
        .where((user) => user.id == shopperId && user.role == UserRole.shopper)
        .toList();
    if (shoppers.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Shopper not found.')));
      return;
    }

    final shopper = shoppers.first;
    final customerLocation = _currentUser!.location;
    final order = ServiceOrder(
      id: 'o${_orders.length + 1}',
      customerId: _currentUser!.id,
      shopperId: shopper.id,
      title: 'Grocery shopping and delivery',
      pickupAddress: shopper.address,
      deliveryAddress: _currentUser!.address,
      pickupLocation: shopper.location,
      deliveryLocation: customerLocation,
      status: OrderStatus.requested,
      shopperLocation: shopper.location,
      createdAt: DateTime.now(),
    );

    setState(() {
      _orders.add(order);
    });
    _orderSyncService.addOrder(order);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Request sent to ${shopper.name}. Waiting for response.'),
      ),
    );
  }

  void _acceptOrder(String orderId) {
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx == -1) return;
    final order = _orders[idx];
    setState(() {
      order.status = OrderStatus.inProgress;
    });
    _orderSyncService.updateOrder(order);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order ${order.id} accepted and now in progress.'),
      ),
    );
    // If the current user is the assigned shopper, open the order session
    // so they can immediately view the customer's shopping list.
    if (_currentUser != null &&
        _currentUser!.role == UserRole.shopper &&
        order.shopperId == _currentUser!.id) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => OrderSessionScreen(
            order: order,
            currentUser: _currentUser!,
            onSendMessage: _sendMessage,
            ordersStream: _orderSyncService.ordersStream,
            onAddItem: _addItemToOrder,
            onUploadProof: _uploadProof,
            onStartTransit: _setOrderInTransit,
            onConfirmDelivery: _confirmDelivery,
            onDisputeDelivery: _startDispute,
          ),
        ),
      );
    }
  }

  void _setOrderInTransit(String orderId) {
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx == -1) return;
    final order = _orders[idx];
    setState(() {
      order.status = OrderStatus.inTransit;
    });
    _orderSyncService.updateOrder(order);
    _startTracking(order);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order ${order.id} is now in transit.')),
    );
  }

  void _markDelivered(String orderId) {
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx == -1) return;
    final order = _orders[idx];
    setState(() {
      order.status = OrderStatus.delivered;
    });
    _orderSyncService.updateOrder(order);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order ${order.id} marked as delivered.')),
    );
  }

  void _confirmDelivery(String orderId, double rating) {
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx == -1) return;
    final order = _orders[idx];
    setState(() {
      order.status = OrderStatus.completed;
      order.shopperRating = rating;
    });
    _orderSyncService.updateOrder(order);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Order ${order.id} confirmed. Thank you for rating the shopper.',
        ),
      ),
    );
  }

  void _startDispute(String orderId, String reason) {
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx == -1) return;
    final order = _orders[idx];
    setState(() {
      order.status = OrderStatus.disputed;
      order.disputeReason = reason;
    });
    _orderSyncService.updateOrder(order);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order ${order.id} marked as disputed.')),
    );
  }

  void _declineOrder(String orderId) {
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx == -1) return;
    final order = _orders[idx];
    setState(() {
      order.status = OrderStatus.disputed;
      order.disputeReason = 'Shopper declined the order';
    });
    _orderSyncService.updateOrder(order);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order ${order.id} declined by shopper.')),
    );
  }

  Future<void> _sendMessage(
    String orderId,
    String senderId,
    String text,
  ) async {
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx == -1) return;
    final order = _orders[idx];
    final message = <String, String>{
      'sender': senderId,
      'text': text,
      'time': DateTime.now().toIso8601String(),
    };

    setState(() {
      order.messages.add(message);
    });

    await _orderSyncService.addMessage(orderId, senderId, text);
    _orderSyncService.updateOrder(order);
  }

  void _addItemToOrder(String orderId, String item) {
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx == -1) return;
    final order = _orders[idx];
    setState(() {
      order.items.add(item);
    });
    _orderSyncService.updateOrder(order);
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _uploadProof(String orderId) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
        allowMultiple: false,
        dialogTitle: 'Select proof of delivery',
      );
      if (result == null || result.files.isEmpty) {
        _showSnackBar('Proof upload cancelled.');
        return;
      }

      final path = result.files.first.path;
      if (path == null || path.isEmpty) {
        _showSnackBar('Selected file path is invalid.');
        return;
      }

      final file = File(path);
      if (!await file.exists()) {
        _showSnackBar('Selected proof file does not exist.');
        return;
      }

      final idx = _orders.indexWhere((o) => o.id == orderId);
      if (idx == -1) {
        _showSnackBar('Order not found for proof upload.');
        return;
      }

      final fileName = path.split(RegExp(r'[\\/]')).last;
      final proof = db.ProofFilesCompanion(
        orderId: drift.Value(orderId),
        filePath: drift.Value(path),
        fileName: drift.Value(fileName),
        isSynced: const drift.Value(false),
        createdAt: drift.Value(DateTime.now()),
      );

      await _database.into(_database.proofFiles).insert(proof);

      final order = _orders[idx];
      setState(() {
        order.proofFiles.add(path);
      });
      _orderSyncService.updateOrder(order);
      _showSnackBar('Proof document uploaded successfully.');
    } on Exception catch (error, stackTrace) {
      debugPrint('Proof upload failed: $error');
      debugPrint('$stackTrace');
      _showSnackBar('Error uploading proof document. Please try again.');
    }
  }

  void _startTracking(ServiceOrder order) {
    _trackingTimer?.cancel();
    const steps = 20;
    int step = 0;
    final from = order.shopperLocation;
    final to = order.deliveryLocation;

    _trackingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      step += 1;
      final progress = step / steps;
      final nextLat = from.latitude + (to.latitude - from.latitude) * progress;
      final nextLng =
          from.longitude + (to.longitude - from.longitude) * progress;
      setState(() {
        order.shopperLocation = LatLng(nextLat, nextLng);
      });
      if (step >= steps) {
        timer.cancel();
        setState(() {
          order.shopperLocation = order.deliveryLocation;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Shopper has reached the destination. Mark as delivered when ready.',
            ),
          ),
        );
      }
    });
  }

  void _selectIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> get _pages {
    if (_currentUser == null) {
      return [
        AuthScreen(users: _users, onLogin: _login, onRegister: _register),
      ];
    }

    return [
      HomeScreen(
        currentUser: _currentUser!,
        orders: _myOrders,
        ordersStream: _orderSyncService.ordersStream,
        onRequestNearest: _requestNearestShopper,
        onSendMessage: _sendMessage,
        onAddItem: _addItemToOrder,
        onUploadProof: _uploadProof,
        onStartTransit: _setOrderInTransit,
        onConfirmDelivery: _confirmDelivery,
        onDisputeDelivery: _startDispute,
      ),
      JobsScreen(
        currentUser: _currentUser!,
        users: _users,
        orders: _myOrders,
        ordersStream: _orderSyncService.ordersStream,
        onRequestNearest: _requestNearestShopper,
        onRequestShopper: _requestShopper,
        onAccept: _acceptOrder,
        onDecline: _declineOrder,
        onStartTransit: _setOrderInTransit,
        onMarkDelivered: _markDelivered,
        onUploadProof: _uploadProof,
        onConfirmDelivery: _confirmDelivery,
        onDisputeDelivery: _startDispute,
        onSendMessage: _sendMessage,
        onAddItem: _addItemToOrder,
      ),
      MapScreen(
        currentUser: _currentUser!,
        activeOrder: _activeOrder,
        users: _users,
      ),
      ProfileScreen(currentUser: _currentUser!, onLogout: _logout),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return Scaffold(body: _pages.first);
    }

    return Scaffold(
      body: SafeArea(child: _pages[_selectedIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _selectIndex,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.work), label: 'Jobs'),
          NavigationDestination(icon: Icon(Icons.map), label: 'Map'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class AuthScreen extends StatefulWidget {
  final List<AppUser> users;
  final void Function(String email, String password) onLogin;
  final Future<void> Function(
    String name,
    String email,
    String password,
    UserRole role,
    String address,
    String phone,
  )
  onRegister;

  const AuthScreen({
    super.key,
    required this.users,
    required this.onLogin,
    required this.onRegister,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isRegister = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  UserRole _role = UserRole.customer;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (_isRegister) {
      final name = _nameController.text.trim();
      final address = _addressController.text.trim();
      final phone = _phoneController.text.trim();
      if (name.isEmpty ||
          email.isEmpty ||
          password.isEmpty ||
          address.isEmpty ||
          phone.isEmpty) {
        _showError('Please fill in all fields.');
        return;
      }
      try {
        await widget.onRegister(name, email, password, _role, address, phone);
      } catch (e) {
        _showError(e.toString());
      }
      return;
    }

    if (email.isEmpty || password.isEmpty) {
      _showError('Please enter email and password.');
      return;
    }
    try {
      widget.onLogin(email, password);
    } catch (e) {
      _showError(e.toString());
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Card(
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isRegister ? 'Create Profile' : 'Sign in',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                if (_isRegister)
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                const SizedBox(height: 12),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                if (_isRegister) ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(labelText: 'Address'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: 'Phone'),
                    keyboardType: TextInputType.phone,
                  ),
                  RadioGroup<UserRole>(
                    groupValue: _role,
                    onChanged: (UserRole? selected) {
                      if (selected != null) {
                        setState(() => _role = selected);
                      }
                    },
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text('Customer'),
                          leading: const Radio<UserRole>(
                            value: UserRole.customer,
                          ),
                          onTap: () =>
                              setState(() => _role = UserRole.customer),
                        ),
                        ListTile(
                          title: const Text('Shopper'),
                          leading: const Radio<UserRole>(
                            value: UserRole.shopper,
                          ),
                          onTap: () => setState(() => _role = UserRole.shopper),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(_isRegister ? 'Register' : 'Login'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => setState(() => _isRegister = !_isRegister),
                  child: Text(
                    _isRegister
                        ? 'Already have an account? Sign in'
                        : 'Create a profile',
                  ),
                ),
                if (!_isRegister)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      'Try: alex@example.com / customer123 or maria@example.com / shopper123',
                      style: const TextStyle(color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (_isRegister)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      'Enter a real address to enable location matching.',
                      style: const TextStyle(color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final AppUser currentUser;
  final List<ServiceOrder> orders;
  final Stream<List<ServiceOrder>> ordersStream;
  final VoidCallback onRequestNearest;
  final Future<void> Function(String orderId, String senderId, String text)
  onSendMessage;
  final void Function(String orderId, String item) onAddItem;
  final Future<void> Function(String orderId) onUploadProof;
  final void Function(String orderId) onStartTransit;
  final void Function(String orderId, double rating) onConfirmDelivery;
  final void Function(String orderId, String reason) onDisputeDelivery;

  const HomeScreen({
    super.key,
    required this.currentUser,
    required this.orders,
    required this.ordersStream,
    required this.onRequestNearest,
    required this.onSendMessage,
    required this.onAddItem,
    required this.onUploadProof,
    required this.onStartTransit,
    required this.onConfirmDelivery,
    required this.onDisputeDelivery,
  });

  @override
  Widget build(BuildContext context) {
    final activeOrders = orders
        .where((order) => order.status != OrderStatus.completed)
        .toList();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello, ${currentUser.name}',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            currentUser.role == UserRole.customer
                ? 'Request a shopper for grocery and delivery'
                : 'View your assigned orders',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          if (currentUser.role == UserRole.customer)
            Card(
              elevation: 3,
              child: ListTile(
                leading: const Icon(
                  Icons.local_grocery_store,
                  color: Colors.blue,
                ),
                title: const Text('Find closest shopper'),
                subtitle: Text(currentUser.address),
                trailing: ElevatedButton(
                  onPressed: onRequestNearest,
                  child: const Text('Request'),
                ),
              ),
            ),
          const SizedBox(height: 16),
          const Text(
            'Active orders',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          if (activeOrders.isEmpty) const Text('No active orders yet.'),
          if (activeOrders.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: activeOrders.length,
                itemBuilder: (context, index) {
                  final order = activeOrders[index];
                  return Card(
                    child: ListTile(
                      title: Text(order.title),
                      subtitle: Text(
                        'Deliver to ${order.deliveryAddress}\nStatus: ${order.statusLabel}${order.items.isNotEmpty ? '\nItems: ${order.items.length}' : ''}',
                      ),
                      isThreeLine: true,
                      trailing: currentUser.role == UserRole.customer
                          ? IconButton(
                              icon: const Icon(Icons.chat_bubble_outline),
                              tooltip: 'Open order session',
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => OrderSessionScreen(
                                      order: order,
                                      currentUser: currentUser,
                                      onSendMessage: onSendMessage,
                                      ordersStream: ordersStream,
                                      onAddItem: onAddItem,
                                      onUploadProof: onUploadProof,
                                      onStartTransit: onStartTransit,
                                      onConfirmDelivery: onConfirmDelivery,
                                      onDisputeDelivery: onDisputeDelivery,
                                    ),
                                  ),
                                );
                              },
                            )
                          : null,
                    ),
                  );
                },
              ),
            ),
          if (activeOrders.isEmpty) const Spacer(),
        ],
      ),
    );
  }
}

class JobsScreen extends StatelessWidget {
  final AppUser currentUser;
  final List<AppUser> users;
  final List<ServiceOrder> orders;
  final Stream<List<ServiceOrder>> ordersStream;
  final VoidCallback onRequestNearest;
  final void Function(String shopperId) onRequestShopper;
  final void Function(String orderId) onAccept;
  final void Function(String orderId) onDecline;
  final void Function(String orderId) onStartTransit;
  final void Function(String orderId) onMarkDelivered;
  final Future<void> Function(String orderId) onUploadProof;
  final void Function(String orderId, double rating) onConfirmDelivery;
  final void Function(String orderId, String reason) onDisputeDelivery;
  final Future<void> Function(String orderId, String senderId, String text)
  onSendMessage;
  final void Function(String orderId, String item) onAddItem;

  const JobsScreen({
    super.key,
    required this.currentUser,
    required this.users,
    required this.orders,
    required this.ordersStream,
    required this.onRequestNearest,
    required this.onRequestShopper,
    required this.onAccept,
    required this.onDecline,
    required this.onStartTransit,
    required this.onMarkDelivered,
    required this.onUploadProof,
    required this.onConfirmDelivery,
    required this.onDisputeDelivery,
    required this.onSendMessage,
    required this.onAddItem,
  });

  @override
  Widget build(BuildContext context) {
    final shoppers = users
        .where((user) => user.role == UserRole.shopper)
        .toList();
    final activeOrders = orders
        .where((order) => order.status != OrderStatus.completed)
        .toList();
    final shopperOrders = activeOrders
        .where((o) => o.shopperId == currentUser.id)
        .toList();

    final requestedOrders = shopperOrders
        .where((order) => order.status == OrderStatus.requested)
        .toList();

    return Column(
      children: [
        if (currentUser.role == UserRole.shopper && requestedOrders.isNotEmpty)
          MaterialBanner(
            leading: const Icon(
              Icons.notifications_active,
              color: Colors.white,
            ),
            backgroundColor: Colors.blue.shade700,
            content: Text(
              'You have ${requestedOrders.length} new requested order(s). Accept a shopper request to begin.',
              style: const TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () {},
                child: const Text(
                  'View orders',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Shopper Network',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              Icon(
                currentUser.role == UserRole.customer
                    ? Icons.search
                    : Icons.assignment,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (currentUser.role == UserRole.customer) ...[
                const Text(
                  'Available shoppers',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                ...shoppers.map((shopper) {
                  final distance = const Distance().as(
                    LengthUnit.Kilometer,
                    currentUser.location,
                    shopper.location,
                  );
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.person_pin_circle),
                      title: Text(shopper.name),
                      subtitle: Text(
                        '${shopper.address} • ${distance.toStringAsFixed(1)} km',
                      ),
                      trailing: ElevatedButton(
                        onPressed: () => onRequestShopper(shopper.id),
                        child: const Text('Request'),
                      ),
                    ),
                  );
                }),
              ] else ...[
                // For shoppers: show only orders assigned to this shopper
                if (shopperOrders.isNotEmpty) ...[
                  const Text(
                    'Assigned orders',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  ...shopperOrders.map((order) {
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.delivery_dining),
                        title: Text(order.title),
                        subtitle: Text(
                          'Deliver to ${order.deliveryAddress}\nStatus: ${order.statusLabel}${order.items.isNotEmpty ? '\nItems: ${order.items.length}' : ''}',
                        ),
                        isThreeLine: true,
                        trailing: order.status == OrderStatus.requested
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextButton(
                                    onPressed: () => onAccept(order.id),
                                    child: const Text('Accept'),
                                  ),
                                  TextButton(
                                    onPressed: () => onDecline(order.id),
                                    child: const Text('Decline'),
                                  ),
                                ],
                              )
                            : order.status == OrderStatus.inProgress
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => OrderSessionScreen(
                                            order: order,
                                            currentUser: currentUser,
                                            onSendMessage: onSendMessage,
                                            ordersStream: ordersStream,
                                            onAddItem: onAddItem,
                                            onUploadProof: onUploadProof,
                                            onStartTransit: onStartTransit,
                                            onConfirmDelivery:
                                                onConfirmDelivery,
                                            onDisputeDelivery:
                                                onDisputeDelivery,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text('View order'),
                                  ),
                                  TextButton(
                                    onPressed: () => onStartTransit(order.id),
                                    child: const Text('Start transit'),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.chat),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => OrderSessionScreen(
                                            order: order,
                                            currentUser: currentUser,
                                            onSendMessage: onSendMessage,
                                            ordersStream: ordersStream,
                                            onAddItem: onAddItem,
                                            onUploadProof: onUploadProof,
                                            onStartTransit: onStartTransit,
                                            onConfirmDelivery:
                                                onConfirmDelivery,
                                            onDisputeDelivery:
                                                onDisputeDelivery,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              )
                            : order.status == OrderStatus.inTransit
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => OrderSessionScreen(
                                            order: order,
                                            currentUser: currentUser,
                                            onSendMessage: onSendMessage,
                                            ordersStream: ordersStream,
                                            onAddItem: onAddItem,
                                            onUploadProof: onUploadProof,
                                            onStartTransit: onStartTransit,
                                            onConfirmDelivery:
                                                onConfirmDelivery,
                                            onDisputeDelivery:
                                                onDisputeDelivery,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text('View order'),
                                  ),
                                  TextButton(
                                    onPressed: () => onMarkDelivered(order.id),
                                    child: const Text('Mark delivered'),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.chat),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => OrderSessionScreen(
                                            order: order,
                                            currentUser: currentUser,
                                            onSendMessage: onSendMessage,
                                            ordersStream: ordersStream,
                                            onAddItem: onAddItem,
                                            onUploadProof: onUploadProof,
                                            onStartTransit: onStartTransit,
                                            onConfirmDelivery:
                                                onConfirmDelivery,
                                            onDisputeDelivery:
                                                onDisputeDelivery,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => OrderSessionScreen(
                                            order: order,
                                            currentUser: currentUser,
                                            onSendMessage: onSendMessage,
                                            ordersStream: ordersStream,
                                            onAddItem: onAddItem,
                                            onUploadProof: onUploadProof,
                                            onStartTransit: onStartTransit,
                                            onConfirmDelivery:
                                                onConfirmDelivery,
                                            onDisputeDelivery:
                                                onDisputeDelivery,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text('View order'),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.chat),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => OrderSessionScreen(
                                            order: order,
                                            currentUser: currentUser,
                                            onSendMessage: onSendMessage,
                                            ordersStream: ordersStream,
                                            onAddItem: onAddItem,
                                            onUploadProof: onUploadProof,
                                            onStartTransit: onStartTransit,
                                            onConfirmDelivery:
                                                onConfirmDelivery,
                                            onDisputeDelivery:
                                                onDisputeDelivery,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                      ),
                    );
                  }),
                ] else
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text('No assigned orders yet.'),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class OrderSessionScreen extends StatefulWidget {
  final ServiceOrder order;
  final AppUser currentUser;
  final Future<void> Function(String orderId, String senderId, String text)
  onSendMessage;
  final Stream<List<ServiceOrder>> ordersStream;
  final void Function(String orderId, String item) onAddItem;
  final Future<void> Function(String orderId) onUploadProof;
  final void Function(String orderId) onStartTransit;
  final void Function(String orderId, double rating) onConfirmDelivery;
  final void Function(String orderId, String reason) onDisputeDelivery;

  const OrderSessionScreen({
    required this.order,
    required this.currentUser,
    required this.onSendMessage,
    required this.ordersStream,
    required this.onAddItem,
    required this.onUploadProof,
    required this.onStartTransit,
    required this.onConfirmDelivery,
    required this.onDisputeDelivery,
    super.key,
  });

  @override
  State<OrderSessionScreen> createState() => _OrderSessionScreenState();
}

class _OrderSessionScreenState extends State<OrderSessionScreen> {
  final TextEditingController _msgController = TextEditingController();
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _disputeController = TextEditingController();
  bool _isSendingMessage = false;
  double _rating = 4.0;
  late ServiceOrder _order;
  StreamSubscription<List<ServiceOrder>>? _ordersSub;

  @override
  void dispose() {
    _msgController.dispose();
    _itemController.dispose();
    _disputeController.dispose();
    _ordersSub?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _order = widget.order;
    _ordersSub = widget.ordersStream.listen((orders) {
      try {
        final updated = orders.firstWhere((o) => o.id == widget.order.id);
        if (updated != _order) {
          setState(() => _order = updated);
        }
      } catch (_) {
        // order not found in emitted list
      }
    });
  }

  Future<void> _viewProofFile(String filePath) async {
    final acceptImage =
        filePath.toLowerCase().endsWith('.jpg') ||
        filePath.toLowerCase().endsWith('.jpeg') ||
        filePath.toLowerCase().endsWith('.png');

    if (acceptImage) {
      await showDialog<void>(
        context: context,
        builder: (context) {
          return Dialog(
            child: InteractiveViewer(
              child: Image.file(File(filePath), fit: BoxFit.contain),
            ),
          );
        },
      );
      return;
    }

    if (Platform.isWindows) {
      await Process.start('explorer.exe', [filePath]);
    } else if (Platform.isMacOS) {
      await Process.start('open', [filePath]);
    } else if (Platform.isLinux) {
      await Process.start('xdg-open', [filePath]);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to open this proof file on your platform.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = _order;
    final roleLabel = widget.currentUser.id == order.customerId
        ? 'Customer'
        : 'Shopper';

    return Scaffold(
      appBar: AppBar(
        title: Text('Order ${order.id} Session'),
        elevation: 1,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 10.0,
            ),
            child: Chip(
              label: Text(order.statusLabel),
              backgroundColor: order.status == OrderStatus.inTransit
                  ? Colors.green[100]
                  : order.status == OrderStatus.inProgress
                  ? Colors.yellow[100]
                  : order.status == OrderStatus.requested
                  ? Colors.orange[100]
                  : order.status == OrderStatus.delivered
                  ? Colors.blue[100]
                  : order.status == OrderStatus.completed
                  ? Colors.green[50]
                  : Colors.red[100],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      order.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Pickup: ${order.pickupAddress}'),
                    Text('Drop-off: ${order.deliveryAddress}'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      children: [
                        Chip(
                          avatar: const Icon(Icons.person),
                          label: Text('Shopper ${order.shopperId}'),
                        ),
                        Chip(
                          avatar: const Icon(Icons.location_on),
                          label: Text(order.statusLabel),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Delivery proof',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (order.proofFiles.isEmpty)
                      const Text(
                        'No delivery proof uploaded yet. Shoppers can upload receipts or proof documents here.',
                        style: TextStyle(color: Colors.black54),
                      )
                    else ...[
                      ...order.proofFiles.map((path) {
                        final fileName = path.split(RegExp(r'[\\/]')).last;
                        return ListTile(
                          leading: const Icon(Icons.insert_drive_file),
                          title: Text(fileName),
                          subtitle: Text(path),
                          trailing: IconButton(
                            icon: const Icon(Icons.open_in_new),
                            onPressed: () => _viewProofFile(path),
                          ),
                          onTap: () => _viewProofFile(path),
                        );
                      }),
                    ],
                    const SizedBox(height: 12),
                    if (widget.currentUser.role == UserRole.shopper &&
                        order.status == OrderStatus.inProgress)
                      ElevatedButton.icon(
                        onPressed: () async {
                          widget.onStartTransit(order.id);
                          setState(() {});
                        },
                        icon: const Icon(Icons.local_shipping),
                        label: const Text('Start transit'),
                      ),
                    if (widget.currentUser.role == UserRole.shopper &&
                        (order.status == OrderStatus.inTransit ||
                            order.status == OrderStatus.delivered))
                      ElevatedButton.icon(
                        onPressed: () async {
                          await widget.onUploadProof(order.id);
                          setState(() {});
                        },
                        icon: const Icon(Icons.upload_file),
                        label: const Text('Upload delivery proof'),
                      ),
                    if (widget.currentUser.role == UserRole.customer &&
                        order.status == OrderStatus.delivered)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 8),
                          const Text(
                            'Rate the shopper',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Slider(
                            value: _rating,
                            min: 1,
                            max: 5,
                            divisions: 4,
                            label: _rating.toStringAsFixed(0),
                            onChanged: (value) {
                              setState(() {
                                _rating = value;
                              });
                            },
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Rating: ${_rating.toStringAsFixed(0)}',
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  widget.onConfirmDelivery(order.id, _rating);
                                  setState(() {});
                                },
                                child: const Text('Confirm delivery'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[600],
                            ),
                            onPressed: () {
                              showDialog<void>(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Start dispute'),
                                    content: TextField(
                                      controller: _disputeController,
                                      decoration: const InputDecoration(
                                        hintText: 'Describe the issue',
                                      ),
                                      maxLines: 3,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          final reason = _disputeController.text
                                              .trim();
                                          if (reason.isEmpty) return;
                                          widget.onDisputeDelivery(
                                            order.id,
                                            reason,
                                          );
                                          Navigator.of(context).pop();
                                          setState(() {});
                                        },
                                        child: const Text('Submit dispute'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text('Start dispute'),
                          ),
                        ],
                      ),
                    if (order.status == OrderStatus.completed)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: Text(
                              'Delivery confirmed. Thank you for using the service.',
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                          if (order.shopperRating != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Shopper rating: ${order.shopperRating!.toStringAsFixed(0)}/5',
                                style: const TextStyle(color: Colors.black87),
                              ),
                            ),
                        ],
                      ),
                    if (order.status == OrderStatus.disputed)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          'Dispute raised: ${order.disputeReason ?? 'No details provided'}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 2,
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Shopping list',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                              child: order.items.isEmpty
                                  ? const Center(
                                      child: Text(
                                        'Start by sharing the items the customer needs.',
                                        style: TextStyle(color: Colors.black54),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  : ListView.separated(
                                      itemCount: order.items.length,
                                      separatorBuilder: (context, index) =>
                                          const Divider(),
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          leading: const Icon(
                                            Icons.check_box_outlined,
                                          ),
                                          title: Text(order.items[index]),
                                        );
                                      },
                                    ),
                            ),
                            const SizedBox(height: 12),
                            if (widget.currentUser.role == UserRole.customer &&
                                order.status != OrderStatus.completed)
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _itemController,
                                      decoration: const InputDecoration(
                                        hintText:
                                            'Add item(s), comma-separated',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.add_shopping_cart),
                                    onPressed: () {
                                      final rawItems = _itemController.text
                                          .trim();
                                      if (rawItems.isEmpty) return;
                                      final items = rawItems
                                          .split(RegExp(r'[\n,]+'))
                                          .map((text) => text.trim())
                                          .where((text) => text.isNotEmpty)
                                          .toList();
                                      if (items.isEmpty) return;
                                      for (final item in items) {
                                        widget.onAddItem(order.id, item);
                                      }
                                      _itemController.clear();
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Live chat',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            if (order.status == OrderStatus.requested)
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.yellow[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'The shopper has not accepted the request yet. Chat starts once the shopper accepts.',
                                  style: TextStyle(color: Colors.black87),
                                ),
                              )
                            else
                              const SizedBox.shrink(),
                            const SizedBox(height: 12),
                            Expanded(
                              child: order.messages.isEmpty
                                  ? Center(
                                      child: Text(
                                        order.status == OrderStatus.requested
                                            ? 'No chat is available until the shopper accepts the order.'
                                            : 'No messages yet. Keep the shopper informed in real time.',
                                        style: const TextStyle(
                                          color: Colors.black54,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: order.messages.length,
                                      itemBuilder: (context, index) {
                                        final message = order.messages[index];
                                        final isMe =
                                            message['sender'] ==
                                            widget.currentUser.id;
                                        return Align(
                                          alignment: isMe
                                              ? Alignment.centerRight
                                              : Alignment.centerLeft,
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                              vertical: 6,
                                            ),
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: isMe
                                                  ? Colors.blue[100]
                                                  : Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: isMe
                                                  ? CrossAxisAlignment.end
                                                  : CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  message['text'] ?? '',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  '${(message['sender'] ?? '') == order.customerId ? 'Customer' : 'Shopper'} • ${(message['time'] ?? '').length >= 16 ? (message['time'] ?? '').substring(11, 16) : (message['time'] ?? '')}',
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                            const Divider(),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _msgController,
                                    readOnly:
                                        order.status == OrderStatus.requested,
                                    decoration: InputDecoration(
                                      hintText:
                                          order.status == OrderStatus.requested
                                          ? 'Chat opens after shopper accepts'
                                          : 'Message $roleLabel',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed:
                                      order.status == OrderStatus.requested ||
                                          _isSendingMessage
                                      ? null
                                      : () async {
                                          final text = _msgController.text
                                              .trim();
                                          if (text.isEmpty) return;
                                          setState(() {
                                            _isSendingMessage = true;
                                          });
                                          try {
                                            await widget.onSendMessage(
                                              order.id,
                                              widget.currentUser.id,
                                              text,
                                            );
                                            _msgController.clear();
                                          } finally {
                                            if (mounted) {
                                              setState(() {
                                                _isSendingMessage = false;
                                              });
                                            }
                                          }
                                        },
                                  child: _isSendingMessage
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Icon(Icons.send),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MapScreen extends StatefulWidget {
  final AppUser currentUser;
  final ServiceOrder? activeOrder;
  final List<AppUser> users;

  const MapScreen({
    super.key,
    required this.currentUser,
    required this.activeOrder,
    required this.users,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Position? _position;
  LatLng? _searchedLocation;
  String? _currentAddress;
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  final Map<String, List<Map<String, dynamic>>> _autocompleteCache = {};
  List<Map<String, dynamic>> _suggestions = [];
  Timer? _debounce;
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _initLocation() async {
    try {
      final hasPermission = await _handlePermission();
      if (!hasPermission) return;
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      setState(() => _position = pos);
      _mapController.move(LatLng(pos.latitude, pos.longitude), 13.0);
      _getAddressFromLatLng(pos.latitude, pos.longitude);
    } catch (_) {
      // ignore errors for now
    }
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  Future<void> _getAddressFromLatLng(double latitude, double longitude) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        if (!mounted) return;
        setState(() {
          _currentAddress = [
            place.street,
            place.subLocality,
            place.locality,
            place.administrativeArea,
            place.postalCode,
          ].whereType<String>().join(', ');
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _currentAddress = 'Unable to resolve address';
      });
    }
  }

  Future<void> _searchAddress() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    try {
      final locations = await locationFromAddress(query);
      if (!mounted) return;
      if (locations.isEmpty) {
        final suggestions = await _fetchCachedSuggestions(query);
        if (!mounted) return;
        if (suggestions.isNotEmpty) {
          _selectSuggestion(suggestions.first);
          return;
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Address not found.')));
        return;
      }

      final found = locations.first;
      final target = LatLng(found.latitude, found.longitude);
      setState(() {
        _searchedLocation = target;
      });
      _mapController.move(target, 15.0);
      _getAddressFromLatLng(target.latitude, target.longitude);
    } catch (e) {
      final cached = await _fetchCachedSuggestions(query);
      if (!mounted) return;
      if (cached.isNotEmpty) {
        _selectSuggestion(cached.first);
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Search failed: ${e.toString()}')));
    }
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    if (value.trim().isEmpty) {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      final q = value.trim();
      final results = await _fetchNominatim(q);
      if (!mounted) return;
      setState(() {
        _suggestions = results;
        _showSuggestions = results.isNotEmpty;
      });
    });
  }

  Future<List<Map<String, dynamic>>> _fetchCachedSuggestions(
    String query,
  ) async {
    if (_autocompleteCache.containsKey(query)) {
      return _autocompleteCache[query]!;
    }

    final prefixMatch = _autocompleteCache.entries
        .where(
          (entry) => entry.key.startsWith(query) || query.startsWith(entry.key),
        )
        .expand((entry) => entry.value)
        .toList();
    if (prefixMatch.isNotEmpty) {
      return prefixMatch;
    }

    final fallback = _getOfflineFallback(query);
    if (fallback.isNotEmpty) {
      return fallback;
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> _fetchNominatim(String query) async {
    if (_autocompleteCache.containsKey(query)) {
      return _autocompleteCache[query]!;
    }

    final uri = Uri.parse('https://nominatim.openstreetmap.org/search').replace(
      queryParameters: {
        'q': query,
        'format': 'json',
        'addressdetails': '1',
        'limit': '5',
      },
    );
    try {
      final resp = await http.get(
        uri,
        headers: {'User-Agent': 'service-delivery-app/1.0'},
      );
      if (resp.statusCode != 200) {
        return _getOfflineFallback(query);
      }
      final List<dynamic> list = resp.body.isEmpty
          ? []
          : (jsonDecode(resp.body) as List<dynamic>);
      final results = list.map((e) => e as Map<String, dynamic>).toList();
      _autocompleteCache[query] = results;
      return results.isNotEmpty ? results : _getOfflineFallback(query);
    } catch (_) {
      return _fetchCachedSuggestions(query);
    }
  }

  List<Map<String, dynamic>> _getOfflineFallback(String query) {
    final lowerQuery = query.toLowerCase();
    final matching = sampleUsers
        .where((user) {
          final text = '${user.name} ${user.address}'.toLowerCase();
          return text.contains(lowerQuery);
        })
        .map((user) {
          return {
            'display_name': '${user.name}, ${user.address}',
            'lat': user.location.latitude.toString(),
            'lon': user.location.longitude.toString(),
          };
        })
        .toList();
    if (matching.isNotEmpty) {
      _autocompleteCache[query] = matching;
    }
    return matching;
  }

  void _selectSuggestion(Map<String, dynamic> item) {
    final lat = double.tryParse(item['lat']?.toString() ?? '0') ?? 0;
    final lon = double.tryParse(item['lon']?.toString() ?? '0') ?? 0;
    final display = item['display_name'] ?? '$lat, $lon';
    final target = LatLng(lat, lon);
    setState(() {
      _searchedLocation = target;
      _searchController.text = display;
      _showSuggestions = false;
      _suggestions = [];
    });
    _mapController.move(target, 15.0);
    _getAddressFromLatLng(lat, lon);
  }

  LatLng get _mapCenter {
    if (_position != null) {
      return LatLng(_position!.latitude, _position!.longitude);
    }
    return widget.currentUser.location;
  }

  @override
  Widget build(BuildContext context) {
    final activeOrder = widget.activeOrder;
    final shopper = activeOrder == null
        ? null
        : widget.users.firstWhere((user) => user.id == activeOrder.shopperId);
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(initialCenter: _mapCenter, initialZoom: 13.0),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 80,
                    height: 80,
                    point: widget.currentUser.location,
                    child: const Icon(
                      Icons.person,
                      color: Colors.blue,
                      size: 36,
                    ),
                  ),
                  if (activeOrder != null) ...[
                    Marker(
                      width: 80,
                      height: 80,
                      point: activeOrder.deliveryLocation,
                      child: const Icon(
                        Icons.home,
                        color: Colors.green,
                        size: 36,
                      ),
                    ),
                    Marker(
                      width: 80,
                      height: 80,
                      point: activeOrder.shopperLocation,
                      child: const Icon(
                        Icons.local_shipping,
                        color: Colors.red,
                        size: 36,
                      ),
                    ),
                  ],
                  if (_searchedLocation != null)
                    Marker(
                      width: 80,
                      height: 80,
                      point: _searchedLocation!,
                      child: const Icon(
                        Icons.search,
                        color: Colors.orange,
                        size: 32,
                      ),
                    ),
                  ...widget.users
                      .where((user) => user.role == UserRole.shopper)
                      .map(
                        (user) => Marker(
                          width: 80,
                          height: 80,
                          point: user.location,
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.purple,
                            size: 30,
                          ),
                        ),
                      ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search address',
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        onChanged: _onSearchChanged,
                        onSubmitted: (_) => _searchAddress(),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _searchAddress,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_showSuggestions && _suggestions.isNotEmpty)
            Positioned(
              top: 72,
              left: 16,
              right: 16,
              child: Card(
                elevation: 4,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _suggestions.length,
                    itemBuilder: (context, i) {
                      final item = _suggestions[i];
                      final display = item['display_name'] ?? '';
                      return ListTile(
                        title: Text(display),
                        onTap: () => _selectSuggestion(item),
                      );
                    },
                  ),
                ),
              ),
            ),
          if (_currentAddress != null)
            Positioned(
              top: 88,
              left: 16,
              right: 16,
              child: Card(
                color: const Color.fromRGBO(255, 255, 255, 0.9),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.black54),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _currentAddress!,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (activeOrder != null)
            Positioned(
              bottom: 24,
              left: 16,
              right: 16,
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tracking ${shopper?.name ?? 'shopper'}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Order: ${activeOrder.title}'),
                      const SizedBox(height: 4),
                      Text('Status: ${activeOrder.statusLabel}'),
                      const SizedBox(height: 4),
                      Text('Destination: ${activeOrder.deliveryAddress}'),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mapController.move(_mapCenter, 13.0);
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final AppUser currentUser;
  final VoidCallback onLogout;

  const ProfileScreen({
    super.key,
    required this.currentUser,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
          const SizedBox(height: 12),
          Text(
            currentUser.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(currentUser.email),
          const SizedBox(height: 6),
          Text('Phone: ${currentUser.phone}'),
          const SizedBox(height: 12),
          Text('Role: ${currentUser.role.name}'),
          const SizedBox(height: 8),
          Text('Address: ${currentUser.address}'),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: onLogout,
            icon: const Icon(Icons.logout),
            label: const Text('Log out'),
          ),
        ],
      ),
    );
  }
}

const sampleUsers = [
  AppUser(
    id: 'customer1',
    name: 'Alex Perez',
    email: 'alex@example.com',
    password: 'customer123',
    role: UserRole.customer,
    address: '210 Market St, San Francisco',
    phone: '555-0101',
    location: LatLng(37.7749, -122.4194),
  ),
  AppUser(
    id: 'shopper1',
    name: 'Maria Ortiz',
    email: 'maria@example.com',
    password: 'shopper123',
    role: UserRole.shopper,
    address: '128 Mission St, San Francisco',
    phone: '555-0202',
    location: LatLng(37.7841, -122.4075),
  ),
  AppUser(
    id: 'shopper2',
    name: 'Danny Kim',
    email: 'danny@example.com',
    password: 'shopper123',
    role: UserRole.shopper,
    address: '99 Embarcadero',
    phone: '555-0303',
    location: LatLng(37.7975, -122.3986),
  ),
  AppUser(
    id: 'shopper3',
    name: 'Priya Singh',
    email: 'priya@example.com',
    password: 'shopper123',
    role: UserRole.shopper,
    address: '118 Folsom St',
    phone: '555-0404',
    location: LatLng(37.7847, -122.3967),
  ),
];
