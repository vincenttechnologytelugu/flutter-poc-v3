import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/controllers/location_controller.dart';
import 'package:flutter_poc_v3/controllers/products_controller.dart';
import 'package:flutter_poc_v3/protected_screen.dart/location_screen.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_poc_v3/public_screen.dart/login_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class HomeappbarScreen extends StatefulWidget {
  final String location;
  
  // final VoidCallback onLocationTap;

  const HomeappbarScreen({
    super.key,
    required this.location,
    required Future<Null> Function() onLocationTap,
  });

  @override
  State<HomeappbarScreen> createState() => _HomeappbarScreenState();
}

class _HomeappbarScreenState extends State<HomeappbarScreen> {
  String? locationText;
  String? userName;
    String? city;
  String? state;
  // String? selectedLocationFromMap = "Location"; // Initial value
  String? selectedLocationFromMap = "Select City, State"; // Initial value
  StreamSubscription<Position>? _locationSubscription;
  final locationController = Get.put(LocationController());






  @override
  void initState() {
    super.initState();
    loadUserData();
    locationText = widget.location;
 
    // Initialize location from widget if provided
    _startLocationUpdates();
  }



// Update the _startLocationUpdates() method
void _startLocationUpdates() {
  _locationSubscription = Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
      timeLimit: Duration(seconds: 10), // Add timeout
    ),
  ).listen(
    (Position position) async {
      try {
        // Add timeout to geocoding operation
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        ).timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            throw TimeoutException('Geocoding timed out');
          },
        );

        if (placemarks.isNotEmpty && mounted) {
          Placemark place = placemarks[0];
          setState(() {
            city = place.subLocality?.isNotEmpty == true 
                ? place.subLocality 
                : place.locality;
            state = place.administrativeArea;
          });
          
          // Save to SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('city', city ?? '');
          await prefs.setString('state', state ?? '');
        }
      } catch (e) {
        log('Error getting address: $e');
        // Handle error gracefully
        if (mounted) {
          setState(() {
            city = 'Location unavailable';
            state = '';
          });
        }
      }
    },
    onError: (error) {
      log('Location stream error: $error');
    },
  );
}

Widget _buildLocationWidget() {
  return GestureDetector(
    onTap: () async {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LocationScreen(),
        ),
      );
      if (result != null && result is Map<String, String>) {
        setState(() {
          city = result['city'];
          state = result['state'];
        });
        // Save to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('city', city ?? '');
        await prefs.setString('state', state ?? '');
      }
    },
    child: Row(
      children: [
        const Icon(Icons.location_on, size: 20),
        const SizedBox(width: 4),
        Obx(() {
          // First check if there's a manually selected location
          String displayLocation = locationController.formattedLocation;
          
          // If no manually selected location, use current location
          if (displayLocation.isEmpty) {
            displayLocation = (city?.isNotEmpty == true && state?.isNotEmpty == true)
                ? '$city, $state'
                : 'Select Location';
          }
          
          return Text(
            displayLocation,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          );
        }),
      ],
    ),
  );
}










  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  // Add this method to check storage

  void checkStorageData() {
    checkSharedPreferences();
  }

  // Check SharedPreferences
  Future<void> checkSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stored Data'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var key in allKeys)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text('$key: ${prefs.getString(key)}'),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  
   Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('first_name') ?? 'User';
      city = prefs.getString('city') ?? '';
      state = prefs.getString('state') ?? '';
    });
  }

  Future<void> logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout ?? false) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        Fluttertoast.showToast(
          msg: "Logged out successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
        );

        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Logout failed: $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white70,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Padding(padding: EdgeInsets.only(top: 10)),
              Image.asset(
                "assets/images/homelogo.jpg",
                width: 100,
                height: 100,
              ),
           
              const SizedBox(width: 30),
              
                _buildLocationWidget(),

            ],
          ),
        ],
      ),
    );
  }

  // Method to save the selected location to SharedPreferences
  Future<void> saveLocationToPreferences(String location) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'pickedLocation', location); // Store location in SharedPreferences
  }
}












