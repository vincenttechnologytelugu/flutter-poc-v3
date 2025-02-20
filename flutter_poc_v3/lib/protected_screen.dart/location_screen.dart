// In location_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/controllers/location_controller.dart';
import 'package:flutter_poc_v3/controllers/products_controller.dart';
import 'package:flutter_poc_v3/protected_screen.dart/state_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  Set<Marker> markers = {};
  List<Map<String, dynamic>> searchResults = [];
  String selectedLocation = '';
  String selectedAddress = '';

  LatLng position =
      const LatLng(20.5937, 78.9629); // Default to center of India
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
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

  Future<void> _fetchAddress(LatLng position) async {
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

  // Future<void> _initializeWithCurrentLocation() async {
  //   try {
  //     Position? position = await Geolocator.getCurrentPosition();
  //     List<Placemark> placemarks = await placemarkFromCoordinates(
  //       position.latitude,
  //       position.longitude,
  //     );

  //     if (placemarks.isNotEmpty) {
  //       Placemark place = placemarks[0];
  //       String address =
  //           '${place.locality ?? ''}, ${place.administrativeArea ?? ''}';
  //       setState(() {
  //         selectedLocation = address;
  //         searchController.text = address;
  //       });

  //       _moveToLocation(address);
  //     }
  //   } catch (e) {
  //     debugPrint('Error initializing location: $e');
  //   }
  // }

  // Future<void> _getCurrentLocation() async {
  //   try {
  //     Position currentPosition = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high);
  //     setState(() {
  //       position = LatLng(currentPosition.latitude, currentPosition.longitude);
  //     });
  //     _fetchAddress(position);
  //   } catch (e) {
  //     debugPrint('Error getting current location: $e');
  //     _fetchAddress(
  //         position); // Use default position if cannot get current location
  //   }
  // }

  Future<void> _getCurrentLocation() async {
    try {
      Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        position = LatLng(currentPosition.latitude, currentPosition.longitude);
      });

      // Update search bar and selectedAddress with current location
      List<Placemark> placemarks = await placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address =
            '${place.locality ?? ''}, ${place.administrativeArea ?? ''}';
        setState(() {
          searchController.text = address;
          selectedLocation = address;
          selectedAddress = address; // Add this line to update selectedAddress
        });
      }

      // Update map camera position
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: position,
            zoom: 15,
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search location in India',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          setState(() {
                            searchResults.clear();
                          });
                        },
                      )
                    : null,
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

          // Map with reduced height
          if (searchResults.isEmpty)
            SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.3, // Adjust map height to 60% of screen
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: position,
                  // target: _initialPosition,
                  zoom: 15,
                ),
                onMapCreated: (GoogleMapController controller) {
                  setState(() {
                    mapController = controller;
                  });
                  // mapController = controller;
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
              ),
            ),

          // Confirm Button
          if (searchResults.isEmpty && selectedLocation.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (selectedAddress.isNotEmpty) {
                      final prefs = await SharedPreferences.getInstance();
                      String city = prefs.getString('city') ?? '';
                      String state = prefs.getString('state') ?? '';

                      // Create location data object
                      Map<String, String> locationData = {
                        'city': city,
                        'state': state,
                      };

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Location Confirmed: $city, $state")),
                      );

                      Navigator.pop(context, locationData);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("No location selected")),
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
                  child: const Text(
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
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StateScreen()),
              );
            },
            child: Text(
              'Choose Location in India',
              style: TextStyle(fontSize: 18),
            ),
          )
        ],
      ),
    );
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

  Future<void> _moveToLocation(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
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
          selectedAddress = address; // Add this line
        });

        mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: latLng,
              zoom: 15,
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error moving to location: $e');
    }
  }
}







