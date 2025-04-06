// In location_screen.dart

// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/controllers/location_controller.dart';

import 'package:flutter_poc_v3/protected_screen.dart/state_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io'; // Import for Platform

import 'package:shared_preferences/shared_preferences.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  GoogleMapController? mapController;
  final TextEditingController searchController = TextEditingController();
  final TextEditingController selectedLocationText = TextEditingController();

  bool hasLocationChanged = false;
  String lastConfirmedCity = '';
  String lastConfirmedState = '';
  LatLng? lastConfirmedLocation;

  Set<Marker> markers = {};
  List<Map<String, dynamic>> searchResults = [];
  String selectedLocation = '';
  String selectedAddress = '';
  bool _mapLoaded = false; // Add this flag
  bool _isMapInitialized = false;
  bool _isLoading = false;
  LatLng position =
      const LatLng(20.5937, 78.9629); // Default to center of India
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializeMap();
      await _checkPermissionsAndInitialize();
      await _getCurrentLocation();
    });
    // _initializeMap();
    // _checkPermissionsAndInitialize();
    // _getCurrentLocation();
  }

  // When location is selected (either manually or current location)
  void onLocationSelected(String city, String state) {
    Navigator.pop(context, {
      'city': city,
      'state': state,
    });
  }

  // Future<void> _initializeMap() async {
  //   await _checkPermissionsAndInitialize();
  //   setState(() {
  //     _isMapInitialized = true;
  //   });
  // }

  Future<void> _initializeMap() async {
    try {
      // Check location permission first
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      // Get current position
      Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );

      if (mounted) {
        setState(() {
          position =
              LatLng(currentPosition.latitude, currentPosition.longitude);
          _isMapInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error initializing map: $e');
    }
  }

  void _handleNoAddressFound() {
    setState(() {
      selectedLocationText.text = "Address not found";
      selectedAddress = "";
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Could not determine address")),
    );
  }

  Future<void> fetchAddress(LatLng position) async {
    try {
      List<Placemark> placeMarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placeMarks.isNotEmpty) {
        Placemark placeMark = placeMarks[0];
        String city = placeMark.subLocality?.isNotEmpty == true
            ? placeMark.subLocality!
            : placeMark.locality ?? '';
        String state = placeMark.administrativeArea ?? '';

        setState(() {
          selectedLocationText.text = "$city, $state";
          selectedAddress = "$city, $state";
        });

        // Store in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('city', city);
        await prefs.setString('state', state);
      } else {
        _handleNoAddressFound();
      }
    } catch (e) {
      debugPrint('Error fetching address: $e');
      _handleNoAddressFound();
    }
  }

// location_screen.dart
// When current location button is clicked on Google Map
  // Future<void> _getCurrentLocation() async {
  //   if (!mounted) return;

  //   try {
  //     Position currentPosition = await Geolocator.getCurrentPosition(

  //       desiredAccuracy: LocationAccuracy.high,

  //       timeLimit: const Duration(seconds: 20),
  //     );

  //     if (!mounted) return;

  //     final newPosition =
  //         LatLng(currentPosition.latitude, currentPosition.longitude);
  //     List<Placemark> placemarks = await placemarkFromCoordinates(
  //       currentPosition.latitude,
  //       currentPosition.longitude,
  //     );

  //     if (!mounted) return;

  //     if (placemarks.isNotEmpty) {
  //       Placemark place = placemarks[0];
  //       String city = place.locality ?? '';
  //       String state = place.administrativeArea ?? '';

  //       // Update location controller
  //       Get.find<LocationController>().updateToCurrentLocation();

  //       setState(() {
  //         position = newPosition;
  //         searchController.text = '$city, $state';
  //         selectedLocation = '$city, $state';
  //         selectedAddress = '$city, $state';
  //       });

  //       mapController?.animateCamera(
  //         CameraUpdate.newCameraPosition(
  //           CameraPosition(
  //             target: newPosition,
  //             zoom: 15,
  //           ),
  //         ),
  //       );
  //     }
  //   } on TimeoutException {
  //     log('Location request timed out. Please check your GPS settings.');
  //   } catch (e) {
  //     debugPrint('Error getting location: $e');
  //   }
  // }

  Future<void> _getCurrentLocation() async {
    if (!mounted) return;

    try {
      Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium, // Change to medium
        timeLimit: const Duration(seconds: 20),
      );

      if (!mounted) return;

      final newPosition =
          LatLng(currentPosition.latitude, currentPosition.longitude);

      // Add debouncing
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;

      List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPosition.latitude,
        currentPosition.longitude,
      );

      if (!mounted) return;

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String city = place.locality ?? '';
        String state = place.administrativeArea ?? '';

        Get.find<LocationController>().updateToCurrentLocation();

        setState(() {
          position = newPosition;
          searchController.text = '$city, $state';
          selectedLocation = '$city, $state';
          selectedAddress = '$city, $state';
        });

        // Add throttling to camera movement
        await Future.delayed(const Duration(milliseconds: 150));
        if (mounted && mapController != null) {
          await mapController?.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: newPosition,
                zoom: 15,
              ),
            ),
          );
        }
      }
    } on TimeoutException {
      log('Location request timed out. Please check your GPS settings.');
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Select Location'),
        ),
        body: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                readOnly: true,
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search location in India',
                  prefixIcon: const Icon(Icons.search),
                  // suffixIcon: searchController.text.isNotEmpty
                  //     ? IconButton(
                  //         icon: const Icon(Icons.clear),
                  //         onPressed: () {
                  //           searchController.clear();
                  //           setState(() {
                  //             searchResults.clear();
                  //           });
                  //         },
                  //       )
                  //     : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    searchPlaces(value);
                  } else {
                    setState(() {
                      searchResults.clear();
                    });
                  }
                },
              ),
            ),

            // Search Results
            if (searchResults.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(searchResults[index]['description'] ?? ''),
                      onTap: () async {
                        final place = searchResults[index];
                        searchController.text = place['description'] ?? '';
                        setState(() {
                          selectedLocation = place['description'] ?? '';
                          selectedAddress =
                              place['description'] ?? ''; // Add this line
                          searchResults.clear();
                        });
                        await _moveToLocation(place['description'] ?? '');
                      },
                    );
                  },
                ),
              ),

            if (searchResults.isEmpty)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: _isMapInitialized
                    ? GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: position,
                          zoom: 15,
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          setState(() {
                            mapController = controller;
                            _mapLoaded = true;
                          });
                        },
                        markers: {
                          Marker(
                            markerId: const MarkerId('current_location'),
                            position: position,
                            infoWindow: InfoWindow(title: selectedLocation),
                          ),
                        },
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        mapType: MapType.normal,
                        // Add these parameters

                         liteModeEnabled: Platform.isAndroid,
                    
                        zoomControlsEnabled: false,
                        mapToolbarEnabled: false,
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),

            if (searchResults.isEmpty && selectedLocation.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    // In location_screen.dart, update the confirm location button onPressed callback
                    onPressed: _isLoading
                        ? null
                        : () async {
                            if (selectedAddress.isNotEmpty) {
                              setState(() {
                                _isLoading = true;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Updating location...")),
                              );
                              final prefs =
                                  await SharedPreferences.getInstance();
                              // Preserve the existing token before clearing prefs
                              final existingToken = prefs.getString('token');
                              // Clear previous location data
                              await prefs.clear();

                              if (existingToken != null) {
                                await prefs.setString('token', existingToken);
                              }

                              // Get current location details
                              Position currentPosition =
                                  await Geolocator.getCurrentPosition(
                                desiredAccuracy: LocationAccuracy.high,
                              );

                              // Get address from coordinates
                              List<Placemark> placemarks =
                                  await placemarkFromCoordinates(
                                currentPosition.latitude,
                                currentPosition.longitude,
                              );

                              if (placemarks.isNotEmpty && mounted) {
                                Placemark place = placemarks[0];
                                String city = place.locality ?? '';
                                String state = place.administrativeArea ?? '';

                                // Save to SharedPreferences
                                await prefs.setString('city', city);
                                await prefs.setString('state', state);
                                await prefs.setDouble(
                                    'latitude', currentPosition.latitude);
                                await prefs.setDouble(
                                    'longitude', currentPosition.longitude);

                                try {
                                  // Fetch new adposts based on location
                                  final response = await http.get(
                                    Uri.parse(
                                        'http://13.200.179.78/adposts?city=$city&state=$state'),
                                    headers: {
                                      'Content-Type': 'application/json',
                                      // 'Authorization': 'Bearer $existingToken', // Add this line
                                    },
                                  );

                                  // In location_screen.dart, in the confirm location button's onPressed
                                  if (response.statusCode == 200) {
                                    final dynamic responseData =
                                        json.decode(response.body);
                                    List<dynamic> newAdPosts =
                                        responseData is List
                                            ? responseData
                                            : responseData['data'] ?? [];

                                    // Create result object with location and adposts data
                                    final result = {
                                      'locationData': {
                                        'city': city,
                                        'state': state,
                                        'latitude': currentPosition.latitude,
                                        'longitude': currentPosition.longitude,
                                      },
                                      'adPosts': newAdPosts,
                                    };

                                    // Update location controller
                                    Get.find<LocationController>()
                                        .updateLocation(
                                            city: city, state: state);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Location Updated: $city, $state")),
                                    );

                                    // // Pop and return the result
                                    // Navigator.pop(context, result);
                                    // Pop and return the result
                                    if (mounted) {
                                      Navigator.pop(context, result);
                                    }
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Error updating ads: ${e.toString()}")),
                                    );
                                  }
                                } finally {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("No location selected")),
                              );
                            }
                          },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              )
                   : const Text(
                      'Confirm Location',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor:
                    Colors.transparent, // Needed for gradient effect
                shadowColor: Colors.blueGrey.withOpacity(0.2),
                elevation: 3,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StateScreen()),
                );
              },
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade600, Colors.blue.shade800],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  constraints: const BoxConstraints(minWidth: 200),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: const Text(
                    'Choose Location in India',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            )

            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.blue,
            //     padding: const EdgeInsets.symmetric(vertical: 15),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //   ),
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const StateScreen()),
            //     );
            //   },
            //   child: Text(
            //     'Choose Location in India',
            //     style: TextStyle(fontSize: 18),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    mapController?.dispose(); // Properly dispose of the controller

    searchController.dispose();
    selectedLocationText.dispose();
    markers.clear();
    super.dispose();
  }

  // Rest of your existing methods remain the same
  Future<void> searchPlaces(String query) async {
    if (query.isEmpty) return;

    try {
      final response = await http.get(
        Uri.parse('https://maps.googleapis.com/maps/api/place/autocomplete/json'
            '?input=$query'
            '&components=country:in'
            '&key=AIzaSyAQDoRVBeKnpSEC63iRXgJcaiMMDyy9gOk' // Replace with your API key
            ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          setState(() {
            searchResults = (data['predictions'] as List)
                .map((prediction) => {
                      'description': prediction['description'],
                      'place_id': prediction['place_id'],
                    })
                .toList();
          });
        }
      }
    } catch (e) {
      debugPrint('Error searching places: $e');
    }
  }

  // Future<void> _moveToLocation(String address) async {
  //   try {
  //     List<Location> locations = await locationFromAddress(address);
  //     if (locations.isNotEmpty) {
  //       final LatLng latLng = LatLng(
  //         locations.first.latitude,
  //         locations.first.longitude,
  //       );

  //       setState(() {
  //         markers = {
  //           Marker(
  //             markerId: const MarkerId('selected_location'),
  //             position: latLng,
  //             infoWindow: InfoWindow(title: address),
  //           ),
  //         };
  //         selectedAddress = address; // Add this line
  //       });

  //       mapController?.animateCamera(
  //         CameraUpdate.newCameraPosition(
  //           CameraPosition(
  //             target: latLng,
  //             zoom: 15,
  //           ),
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     debugPrint('Error moving to location: $e');
  //   }
  // }
  Future<void> _moveToLocation(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty && mounted) {
        final LatLng latLng = LatLng(
          locations.first.latitude,
          locations.first.longitude,
        );

        setState(() {
          markers = {
            Marker(
              markerId: const MarkerId('selected_location'),
              position: latLng,
              infoWindow: InfoWindow(title: address),
            ),
          };
          selectedAddress = address;
        });

        // Add throttling to camera movement
        if (mapController != null) {
          await Future.delayed(const Duration(milliseconds: 150));
          if (mounted) {
            await mapController?.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: latLng,
                  zoom: 15,
                ),
              ),
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Error moving to location: $e');
    }
  }

  Future<void> _checkPermissionsAndInitialize() async {
    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Handle denied permission
          return;
        }
      }

      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Handle location services disabled
        return;
      }

      await _getCurrentLocation();
    } catch (e) {
      debugPrint('Error initializing location: $e');
    }
  }
}
