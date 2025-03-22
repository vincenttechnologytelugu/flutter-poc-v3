



// location_controller.dart
import 'dart:developer';

// import 'package:flutter_poc_v3/protected_screen.dart/responsive_products_screen.dart';
import 'package:flutter_poc_v3/controllers/products_controller.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';



class LocationController extends GetxController {

  final RxBool isManuallySelected = false.obs;
    var currentCity = ''.obs;
  var currentState = ''.obs;
  var isManualSelection = false.obs; // Add this flag
  // Keep your existing variables
  final selectedCity = ''.obs;
  final selectedState = ''.obs;
  final selectedLocation = ''.obs;
  // var isManualLocation = true.obs;
    final isManualLocation = false.obs;
  final RxString location = ''.obs;
  final RxString city = ''.obs;
  final RxString state = ''.obs;
  var shouldRefreshProducts = false.obs; // Add this flag
final savedCity = ''.obs;  
 final savedState = ''.obs;
 final isManual = false.obs;

   // Add these new variables for latitude and longitude
  final RxDouble currentLatitude = 0.0.obs;
  final RxDouble currentLongitude = 0.0.obs;

 


  

  

  @override
  void onInit() {
    super.onInit();
       ever(currentCity, (_) => update()); // Add listeners to ensure updates
    ever(currentState, (_) => update());
    loadSavedLocation();


  }

  

 void updateCurrentLocation({
    required String city,
    required String state,
  }) {
    currentCity.value = city;
    currentState.value = state;
    update();
  }





Future<void> updateToCurrentLocation() async {
    if (isManualLocation.value) return; // Don't update if manual location is set
    try {
      Position position = await determinePosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        currentCity.value = placemarks[0].locality ?? '';
        currentState.value = placemarks[0].administrativeArea ?? '';
        shouldRefreshProducts.value = true;
        
        // Save to SharedPreferences
        await saveLocation(
          currentCity.value, 
          currentState.value, 
          isManual: false
        );
         update();
        log('Location updated - City: ${currentCity.value}, State: ${currentState.value}');
      }
    } catch (e) {
      log("Error updating to current location: $e");
    }
  }





    // Add this method to handle location permissions and get position
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
    } 

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 20),
    );
  }




// In location_controller.dart
void setManualLocation(String city, String state) {

     isManuallySelected.value = true;  // Set manual flag
  isManualSelection.value = true;
  isManualLocation.value = true; // Set this to true for manual selection
  currentCity.value = city;
  currentState.value = state;
  shouldRefreshProducts.value = true;
  saveLocation(city, state, isManual: true); // Save with manual flag
  update();
}

// Method to switch back to current location
  void useCurrentLocation() {
    isManuallySelected.value = false;  // Reset manual flag
    update();
  }

    Future<void> saveLocation(String city, String state, {bool isManual = false}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('city', city);
      await prefs.setString('state', state);
      await prefs.setBool('isManualLocation', isManual);
      
      currentCity.value = city;
      currentState.value = state;
      isManualLocation.value = isManual;
      update(); // Notify listeners of the update
    } catch (e) {
      log('Error saving location: $e');
    }
  }

  
 

  Future<void> loadSavedLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      currentCity.value = prefs.getString('city') ?? '';
      currentState.value = prefs.getString('state') ?? '';
      isManualLocation.value = prefs.getBool('isManualLocation') ?? false;
     
     
      if (savedCity.isNotEmpty && savedState.isNotEmpty) {
        currentCity.value = savedCity.string;
        currentState.value = savedState.string;
        isManualLocation.value = isManual.isFalse;
        update();
      }
    } catch (e) {
      log('Error loading saved location: $e');
    }
  }

 
 
void updateLocation({ String city="",  String state=""}) {
   currentCity.value = city;
    currentState.value = state;
      shouldRefreshProducts.value = true;  // Add this line
       // Refresh the products list or trigger a rebuild
   
      update();
    log('LocationController updated - city: $city, state: $state');
    
  // Only update if not in manual mode
  if (!isManualLocation.value) {
    this.city.value = city;
    this.state.value = state;
    update();
  }
}
 // Add this method to check if location is set
  bool hasLocation() {
    return city.value.isNotEmpty && state.value.isNotEmpty;
  }

 
    String get formattedLocation {
    if (currentCity.isEmpty && currentState.isEmpty) return '';
    return '${currentCity.value}, ${currentState.value}';
  }

  // Keep your existing clearLocation method but update it
  Future<void> clearLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('selected_city');
      await prefs.remove('selected_state');
      await prefs.remove('is_manual_location');
      await prefs.remove('city');
      await prefs.remove('state');
      await prefs.remove('isManualLocation');
      
      // Reset all values
      selectedCity.value = '';
      selectedState.value = '';
      selectedLocation.value = '';
      location.value = '';
      city.value = '';
      state.value = '';
      currentCity.value = '';
      currentState.value = '';
      isManualLocation.value = true;

      update();
    } catch (e) {
      log('Error clearing location: $e');
    }
  }

  // Add this method to persist state
  @override
  void onClose() {
    // Save state before controller is closed
    if (currentCity.value.isNotEmpty && currentState.value.isNotEmpty) {
      saveLocation(currentCity.value, currentState.value, isManual: isManualLocation.value);
    }
    super.onClose();
  }

 
  
}
