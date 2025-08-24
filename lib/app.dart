import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Hospital {
  final String name;
  final double latitude;
  final double longitude;

  Hospital({
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}

class SampleNavigationApp extends StatefulWidget {
  const SampleNavigationApp({super.key});

  @override
  State<SampleNavigationApp> createState() => _SampleNavigationAppState();
}

class _SampleNavigationAppState extends State<SampleNavigationApp> {
  Position? _currentPosition;
  bool _isFetchingLocation = true;
  List<Hospital> _hospitals = [];
  MapBoxNavigationViewController? _controller;
  late MapBoxOptions _navigationOption;

  @override
  void initState() {
    super.initState();
    _navigationOption = MapBoxNavigation.instance.getDefaultOptions();
    _navigationOption.simulateRoute = false;
    _navigationOption.language = "en";
    MapBoxNavigation.instance.registerRouteEventListener(_onRouteEvent);
    _initializeLocation();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  /// Fetch current location and generate nearby hospitals list.
  Future<void> _initializeLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = position;
      _isFetchingLocation = false;
      _hospitals = _getNearbyHospitals(position);
    });
  }

  List<Hospital> _getNearbyHospitals(Position currentPosition) {
    return [];
  }

  /// Starts navigation from current location to the selected hospital.
  void _startNavigation(Hospital hospital) {
    if (_currentPosition == null) return;

    var wayPoints = <WayPoint>[
      WayPoint(
        name: "Current Location",
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        isSilent: false,
      ),
      WayPoint(
        name: hospital.name,
        latitude: hospital.latitude,
        longitude: hospital.longitude,
        isSilent: false,
      ),
    ];

    _controller?.buildRoute(wayPoints: wayPoints, options: _navigationOption);
  }

  /// Handle MapBox navigation events.
  Future<void> _onRouteEvent(e) async {
    print("Route event: ${e.eventType}");
    switch (e.eventType) {
      case MapBoxEvent.route_built:
        break;
      case MapBoxEvent.route_build_failed:
        break;
      case MapBoxEvent.navigation_running:
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        backgroundColor: Colors.black,
        body:
            _isFetchingLocation || _currentPosition == null
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: 120,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: false,
                          viewportFraction: 0.75,
                        ),
                        items:
                            _hospitals.map((hospital) {
                              return GestureDetector(
                                onTap: () => _startNavigation(hospital),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color.fromARGB(221, 248, 52, 52),
                                        Color.fromARGB(221, 248, 52, 52),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.redAccent.withOpacity(
                                          0.4,
                                        ),
                                        spreadRadius: 2,
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 12),
                                      // Hospital Icon
                                      const Icon(
                                        Icons.local_hospital,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                      const SizedBox(width: 10),
                                      // Hospital Name & Tap-to-Navigate Text
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              hospital.name,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              "Tap to Navigate",
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(
                                                  0.7,
                                                ),
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                    Expanded(
                      child: MapBoxNavigationView(
                        options: _navigationOption,
                        onRouteEvent: _onRouteEvent,
                        onCreated: (
                          MapBoxNavigationViewController controller,
                        ) async {
                          _controller = controller;
                          controller.initialize();
                        },
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
