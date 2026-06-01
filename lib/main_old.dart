import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const HomeScreen(),
    const JobsScreen(),
    const MapScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_selectedIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
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

class ServiceRequest {
  final String id;
  final String title;
  final String address;
  final DateTime time;
  final String status;
  final LatLng location;

  const ServiceRequest({
    required this.id,
    required this.title,
    required this.address,
    required this.time,
    required this.status,
    required this.location,
  });
}

final sampleRequests = [
  ServiceRequest(
    id: 'r1',
    title: 'Fix leaking sink',
    address: '12 Oak St',
    time: DateTime(2026, 5, 24, 9, 30),
    status: 'Assigned',
    location: LatLng(37.773972, -122.431297),
  ),
  ServiceRequest(
    id: 'r2',
    title: 'Install new router',
    address: '48 Pine Ave',
    time: DateTime(2026, 5, 24, 11, 0),
    status: 'Pending',
    location: LatLng(37.779026, -122.419906),
  ),
  ServiceRequest(
    id: 'r3',
    title: 'AC maintenance',
    address: '7 Maple Road',
    time: DateTime(2026, 5, 25, 14, 0),
    status: 'Completed',
    location: LatLng(37.768390, -122.510894),
  ),
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome back',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text('Today’s jobs', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: sampleRequests.length,
              itemBuilder: (context, i) {
                final r = sampleRequests[i];
                return Card(
                  child: ListTile(
                    title: Text(r.title),
                    subtitle: Text(
                      '${r.address} • ${r.time.hour}:${r.time.minute.toString().padLeft(2, '0')}',
                    ),
                    trailing: Text(r.status),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RequestDetail(request: r),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class JobsScreen extends StatelessWidget {
  const JobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: const [
              Expanded(
                child: Text(
                  'All Jobs',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              Icon(Icons.filter_list),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sampleRequests.length,
            itemBuilder: (context, i) {
              final r = sampleRequests[i];
              return ListTile(
                leading: CircleAvatar(child: Text(r.id.substring(1))),
                title: Text(r.title),
                subtitle: Text(r.address),
                trailing: Text(r.status),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => RequestDetail(request: r)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

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
      _mapController.move(LatLng(pos.latitude, pos.longitude), 15.0);
      _getAddressFromLatLng(pos.latitude, pos.longitude);
    } catch (e) {
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
    } catch (e) {
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
          final item = suggestions.first;
          _selectSuggestion(item);
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
    final matching = sampleRequests
        .where((request) {
          final text = '${request.title} ${request.address}'.toLowerCase();
          return text.contains(lowerQuery);
        })
        .map((request) {
          return {
            'display_name': '${request.title}, ${request.address}',
            'lat': request.location.latitude.toString(),
            'lon': request.location.longitude.toString(),
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

  void _onRequestTap(ServiceRequest request) {
    _mapController.move(request.location, 15.0);
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => RequestDetail(request: request)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _position == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: LatLng(
                      _position!.latitude,
                      _position!.longitude,
                    ),
                    initialZoom: 13.0,
                  ),
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
                          point: LatLng(
                            _position!.latitude,
                            _position!.longitude,
                          ),
                          child: const Icon(
                            Icons.my_location,
                            color: Colors.blue,
                            size: 36,
                          ),
                        ),
                        if (_searchedLocation != null)
                          Marker(
                            width: 80,
                            height: 80,
                            point: _searchedLocation!,
                            child: const Icon(
                              Icons.place,
                              color: Colors.green,
                              size: 36,
                            ),
                          ),
                        ...sampleRequests.map(
                          (request) => Marker(
                            width: 80,
                            height: 80,
                            point: request.location,
                            child: GestureDetector(
                              onTap: () => _onRequestTap(request),
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 36,
                              ),
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
                            const Icon(
                              Icons.location_on,
                              color: Colors.black54,
                            ),
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
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_position != null) {
            _mapController.move(
              LatLng(_position!.latitude, _position!.longitude),
              15.0,
            );
          }
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
          SizedBox(height: 12),
          Text(
            'Technician Name',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 6),
          Text('technician@example.com'),
        ],
      ),
    );
  }
}

class RequestDetail extends StatelessWidget {
  final ServiceRequest request;

  const RequestDetail({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(request.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(request.address, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Scheduled: ${request.time}'),
            const SizedBox(height: 12),
            Text('Status: ${request.status}'),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.check),
              label: const Text('Mark complete'),
            ),
          ],
        ),
      ),
    );
  }
}
