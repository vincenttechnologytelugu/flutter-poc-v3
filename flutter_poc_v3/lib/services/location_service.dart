


// lib/services/location_service.dart

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
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );

    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }
}
