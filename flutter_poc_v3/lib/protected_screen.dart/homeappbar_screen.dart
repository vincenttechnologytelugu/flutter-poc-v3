import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/controllers/location_controller.dart';
import 'package:flutter_poc_v3/controllers/products_controller.dart';
import 'package:flutter_poc_v3/models/product_model.dart';

import 'package:flutter_poc_v3/protected_screen.dart/location_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/responsive_products_screen.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter_poc_v3/public_screen.dart/login_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

class HomeappbarScreen extends StatefulWidget {
  final String location;
  final Function()? onLocationTap; // Add this parameter
  const HomeappbarScreen(
      {super.key, required this.location, this.onLocationTap});

  @override
  State<HomeappbarScreen> createState() => _HomeappbarScreenState();
}

class _HomeappbarScreenState extends State<HomeappbarScreen>
    with AutomaticKeepAliveClientMixin {
  final LocationController locationController = Get.find<LocationController>();
  StreamSubscription<Position>? _locationSubscription;

  String? city;
  String? state;
  // Add these variables
  String? currentCity;
  String? currentState;
  final ProductsController productsController = Get.find<ProductsController>();

  @override
  bool get wantKeepAlive => true; // Keep state alive

  @override
  void initState() {
    super.initState();
    loadLocationFromPrefs();
    loadSavedLocation();
    // Load location data after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _initializeLocation();
      }
    });
  }

  Future<void> loadLocationFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final city = prefs.getString('city') ?? '';
      final state = prefs.getString('state') ?? '';

      if (city.isNotEmpty && state.isNotEmpty) {
        locationController.updateLocation(
          city: city,
          state: state,
        );
        if (mounted) {
          setState(() {});
        }
        log('Location loaded in HomeAppBar - City: $city, State: $state');
      }
    } catch (e) {
      log('Error loading location in HomeAppBar: $e');
    }
  }

  Future<void> loadSavedLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCity = prefs.getString('user_city') ?? '';
      final savedState = prefs.getString('user_state') ?? '';

      if (savedCity.isNotEmpty && savedState.isNotEmpty) {
        locationController.setManualLocation(savedCity, savedState);

        // Fetch products for saved location
        final response = await http.get(
          Uri.parse(
              'http://13.200.179.78/adposts?city=$savedCity&state=$savedState'),
        );

        if (response.statusCode == 200) {
          final productsController = Get.find<ProductsController>();
          productsController.updateProducts(response.body);
        }
      }
    } catch (e) {
      log('Error loading saved location: $e');
    }
  }

  // Future<void> _initializeLocation() async {
  //   await locationController.loadSavedLocation();
  //   if (!locationController.isManualLocation.value) {
  //     await checkLocationPermission();
  //   }
  // }

  Future<void> _initializeLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isManual = prefs.getBool('isManualLocation') ?? false;

      if (!isManual) {
        // Only update location if not manually set
        await locationController.loadSavedLocation();
        if (locationController.currentCity.isEmpty ||
            locationController.currentState.isEmpty) {
          await locationController.updateToCurrentLocation();
        }
      }
    } catch (e) {
      log('Error initializing location: $e');
    }
  }

  Future<void> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    _startLocationUpdates();
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      city = prefs.getString('city');
      state = prefs.getString('state');
    });
  }

// In home_app_bar_screen.dart
  void _startLocationUpdates() {
    // Don't start location updates if manual location is selected
    if (locationController.isManualLocation.value) {
      _locationSubscription?.cancel(); // Cancel any existing subscription
      return;
    }

    _locationSubscription?.cancel();

    _locationSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen(
      (Position position) async {
        // Only process location updates if not in manual mode
        if (!locationController.isManualLocation.value) {
          try {
            List<Placemark> placemarks = await placemarkFromCoordinates(
              position.latitude,
              position.longitude,
            );

            if (placemarks.isNotEmpty && mounted) {
              Placemark place = placemarks[0];
              String newCity = place.subLocality?.isNotEmpty == true
                  ? place.subLocality!
                  : place.locality ?? '';
              String newState = place.administrativeArea ?? '';

              // Update location in controller
              locationController.updateLocation(
                city: newCity,
                state: newState,
              );
            }
          } catch (e) {
            log('Error getting address: $e');
          }
        }
      },
      onError: (error) {
        log('Location stream error: $error');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required by AutomaticKeepAliveClientMixin
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white70,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            "assets/images/homelogo.jpg",
            width: 100,
            height: 100,
          ),
          const SizedBox(width: 50),
          Icon(Icons.location_on, color: Colors.red),
          SizedBox(width: 1),
          // Add this GetX widget for location display
          Expanded(
            child: GetX<LocationController>(
              builder: (controller) => GestureDetector(
                // Where you navigate to LocationScreen (usually in your bottom navigation or menu)
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LocationScreen()),
                  );
            
                  if (result != null && mounted) {
                    final locationData = result['locationData'];
                    final adPosts = result['adPosts'];
            
                    // Update products
                    setState(() {
                      productsController.productModelList.clear();
                      for (var post in adPosts) {
                        productsController.productModelList
                            .add(ProductModel.fromJson(post));
                      }
                    });
                  }
                },
            
                // onTap:() => {
                //   navigator?.push(
                //     MaterialPageRoute(
                //       builder: (context) => LocationScreen(),
                //     ),
                //   ),
            
                // } ,
                child: Text(
                  '${controller.currentCity.value}, ${controller.currentState.value}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
        ],
        // children: [
        //   Image.asset(
        //     "assets/images/homelogo.jpg",
        //     width: 100,
        //     height: 100,
        //   ),
        //   const SizedBox(width: 10),
        //   Expanded(
        //     child: _buildLocationWidget(),
        //   ),
        // ],
      ),
    );
  }

  Widget buildLocationWidget() {
    return Obx(() {
      return GestureDetector(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LocationScreen()),
          );

          if (result != null && result is Map<String, dynamic>) {
            // Location will be updated through LocationController
            if (result['adPosts'] != null) {
              Get.find<ProductsController>().updateAdPosts(result['adPosts']);
            }
          }
        },
        child: Container(
          constraints: const BoxConstraints(maxWidth: 200),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_on, size: 20),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  locationController.formattedLocation.isEmpty
                      ? 'Select Location'
                      : locationController.formattedLocation,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<void> handleLocationSelection(Map<String, String> result) async {
    final LocationController locationController =
        Get.find<LocationController>();

    // Set manual location and stop current location updates
    locationController.setManualLocation(
        result['city'] ?? '', result['state'] ?? '');

    // Cancel any existing location subscription if you have one
    _locationSubscription?.cancel();

    if (ResponsiveProductsScreen.globalKey.currentState != null) {
      ResponsiveProductsScreen.globalKey.currentState!.refreshData();
    }

    return; // Add return statement to avoid the error
  }

  Future<void> handleCurrentLocation() async {
    await locationController.saveLocation('', '', isManual: false);
    await checkLocationPermission();
  }
}
