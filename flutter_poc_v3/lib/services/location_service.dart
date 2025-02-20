


// lib/services/location_service.dart

import 'dart:developer';
// import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:geolocator/geolocator.dart';

class LocationService {
  
  // Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Check location permission status
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  // Request location permission
  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }
  

  // Get current position with error handling
  Future<Position?> getCurrentPosition() async {
    try {
      // First check if location service is enabled
      bool serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled';
      }

      // Check permission status
      LocationPermission permission = await checkPermission();
      
      if (permission == LocationPermission.denied) {
        // Request permission if denied
        permission = await requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permission denied';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied';
      }

      // Get position if all permissions are granted
      // return await Geolocator.getCurrentPosition(
      //   desiredAccuracy: LocationAccuracy.high
      // );
      return await Geolocator.getCurrentPosition(
  locationSettings: const LocationSettings(
    accuracy: LocationAccuracy.high,
  )
);




    } catch (e) {
      log('Error getting location: $e');
      return null;
    }
  }

//   // Add this to your LocationService class
// Future<void> debugLocationServices() async {
//   try {
//     final serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     log('Location services enabled: $serviceEnabled');

//     final permission = await Geolocator.checkPermission();
//     log('Current permission status: $permission');

//     if (kIsWeb) {
//       log('Running on web platform');
//     }
//   } catch (e) {
//     log('Debug error: $e');
//   }
// }

}
