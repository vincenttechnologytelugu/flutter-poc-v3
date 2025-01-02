
import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/services/location_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geocoding/geocoding.dart';


class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
   TextEditingController searchController = TextEditingController();
     final LocationService _locationService = LocationService();
   List<String> searchResults = [];
    List<String> allCities = []; // Add this line to store all cities
     String? locationError;

  Position? currentPosition;
  List<String> states = [
    
  ];
  List<String> cities = [

  ];
  String? selectedState;
  String? selectedCity;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
     _fetchAllCities(); // Add this line to fetch cities on init
         _initializeLocation();
  }

 Future<void> _initializeLocation() async {
    try {
      // Check if location service is enabled
      bool serviceEnabled = await _locationService.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showLocationServiceDialog();
        return;
      }

      // Check and request permissions
      LocationPermission permission = await _locationService.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await _locationService.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            locationError = 'Location permission denied';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          locationError = 'Location permissions are permanently denied';
        });
        _showPermissionDeniedDialog();
        return;
      }

      // Get current position
      Position? position = await _locationService.getCurrentPosition();
      if (position != null) {
        setState(() {
          currentPosition = position;
          locationError = null;
        });
      }
    } catch (e) {
      setState(() {
        locationError = e.toString();
      });
    }
  }
// Show dialog when permissions are permanently denied
  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Permission Required'),
          content: const Text(
            'Location permissions are permanently denied. Please enable them in your device settings.'
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Open Settings'),
              onPressed: () async {
                await Geolocator.openAppSettings();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


// Show dialog when location service is disabled
  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Services Disabled'),
          content: const Text(
            'Please enable location services to use this feature.'
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Open Settings'),
              onPressed: () async {
                await Geolocator.openLocationSettings();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


// Add this method to fetch all cities initially
  Future<void> _fetchAllCities() async {
    try {
      final response = await http.get(
        Uri.parse('http://172.26.0.1:8080/cities'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> citiesData = json.decode(response.body);
        setState(() {
          allCities = citiesData.map((city) => city.toString()).toList();
          cities = allCities; // Initialize cities with all cities
        });
      }
    } catch (e) {
      debugPrint('Error fetching all cities: $e');
    }
  }

void _performSearch(String query) {
  if (query.isEmpty) {
    setState(() {
      searchResults.clear();
    });
    return;
  }

  setState(() {
    searchResults = [
      ...states.where((state) =>
          state.toLowerCase().contains(query.toLowerCase())),
      ...cities.where((city) =>
          city.toLowerCase().contains(query.toLowerCase())),
    ].toList();
  });
}


  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        currentPosition = position;
      });
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

 // Modify the _fetchCities method for state-specific cities
  Future<void> _fetchCities(String state) async {
    try {
      final response = await http.get(
        Uri.parse('http://172.26.0.1:8080/cities?state=$state'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> citiesData = json.decode(response.body);
        setState(() {
          cities = citiesData.map((city) => city.toString()).toList();
        });
      }
    } catch (e) {
      debugPrint('Error fetching cities for state: $e');
    }
  }

 // Update the _updateLocation method
  // Future<void> _updateLocation(String city) async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('http://172.26.0.1:8080/adposts?city=$city')
  //     );
      
  //     if (response.statusCode == 200) {
  //       if (mounted) {
  //           //  Navigator.pop(context, '$city, $selectedState'.replaceAll(RegExp(r'[()]'), ''));
  //                 Navigator.pop(context, '$selectedState, $city');
  //       }
  //     } else {
  //       // Handle error case
  //       debugPrint('Error updating location: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     debugPrint('Error updating location: $e');
  //   }
  // }

Future<void> _updateLocation(String city) async {
  try {
    final response = await http.get(
      Uri.parse('http://172.26.0.1:8080/adposts?city=$city')
    );
    
    if (response.statusCode == 200) {
      if (mounted) {
        // Format the location string properly, removing any null values
        String locationString = selectedState != null && selectedState!.isNotEmpty
            ? '$selectedState, $city'
            : city;
            
        // Trim any extra spaces and remove any null text
        locationString = locationString.replaceAll('null', '').trim();
        // Remove any consecutive commas that might appear
        locationString = locationString.replaceAll(RegExp(r',+'), ',');
        // Remove comma if it's at the start or end
        locationString = locationString.replaceAll(RegExp(r'^,|,$,{}'), '');
        
        Navigator.pop(context, locationString);
      }
    } else {
      debugPrint('Error updating location: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('Error updating location: $e');
  }
}



@override
void dispose() {
  searchController.dispose();
  super.dispose();
}

void _showError(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("Error API call"),
      backgroundColor: Colors.red,
    ),
  );
}

void _showSuccess(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("Success"),
      backgroundColor: Colors.green,
    ),
  );
}



  // Add this method to get address from coordinates
  Future<String> _getAddressFromCoordinates(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return '${place.locality ?? ''}, ${place.administrativeArea ?? ''}';
      }
      return 'Current Location';
    } catch (e) {
      debugPrint('Error getting address: $e');
      return 'Current Location';
    }
  }

  // // Add this method to handle current location selection
  // Future<void> _handleCurrentLocationSelection() async {
  //   if (currentPosition != null) {
  //     try {
  //       // Show loading indicator
  //       showDialog(
  //         context: context,
  //         barrierDismissible: false,
  //         builder: (BuildContext context) {
  //           return const Center(
  //             child: CircularProgressIndicator(),
  //           );
  //         },
  //       );

  //       // Get address from coordinates
  //       String address = await _getAddressFromCoordinates(currentPosition!);

  //       // Update location in backend
  //       await _updateLocationWithCoordinates(
  //         currentPosition!.latitude,
  //         currentPosition!.longitude,
  //         address,
  //       );

  //       // Remove loading indicator
  //       if (mounted) {
  //         Navigator.pop(context); // Remove loading dialog
  //           Navigator.pop(context, address.replaceAll(RegExp(r'[{}()]'), '')); // Remove brackets if any
  //       }
  //     } catch (e) {
  //       // Remove loading indicator
  //       if (mounted) {
  //         Navigator.pop(context); // Remove loading dialog
  //       }
  //       _showError('Failed to update location: $e');
  //     }
  //   }
  // }





Future<void> _handleCurrentLocationSelection() async {
  if (currentPosition != null) {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // Get address from coordinates
      String address = await _getAddressFromCoordinates(currentPosition!);

      // Remove loading indicator and return the formatted address
      if (mounted) {
        Navigator.pop(context); // Remove loading dialog
        // Format the address string and remove any special characters
        String formattedAddress = address
            .replaceAll(RegExp(r'[{}()]'), '')
            .replaceAll(RegExp(r',+'), ',')
            .trim();
        // Remove any leading or trailing commas
        formattedAddress = formattedAddress.replaceAll(RegExp(r'^,|,$'), '');
        
        Navigator.pop(context, formattedAddress);
      }
    } catch (e) {
      // Remove loading indicator
      if (mounted) {
        Navigator.pop(context); // Remove loading dialog
      }
      _showError('Failed to get location: $e');
    }
  }
}












  // Add this method to update location with coordinates
  Future<void> _updateLocationWithCoordinates(
    double latitude,
    double longitude,
    String address,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('http://172.26.0.1:8080/adposts/location'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'latitude': latitude,
          'longitude': longitude,
          'address': address,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update location');
      }
    } catch (e) {
      debugPrint('Error updating location: $e');
      throw e;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
      ),
      body:allCities.isEmpty
        ? const Center(child: CircularProgressIndicator()) // Show loading indicator
      : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


               // Add search bar
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search city, area, or neighbourhood',
                hintText: 'Enter location to search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: _performSearch,
            ),
            const SizedBox(height: 16),


             // Show search results if any
            if (searchResults.isNotEmpty) ...[
              const Text(
                'Search Results',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final result = searchResults[index];
                  return ListTile(
                    title: Text(result),
                    onTap: () {
                      if (states.contains(result)) {
                        setState(() {
                          selectedState = result;
                          selectedCity = null;
                          searchController.clear();
                          searchResults.clear();
                        });
                        _fetchCities(result);
                      } else {
                        setState(() {
                          selectedCity = result;
                          searchController.clear();
                          searchResults.clear();
                        });
                        _updateLocation(result);
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
            ],

 // Show error if any
            if (locationError != null)
                Card(
                  color: Colors.red[100],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            locationError!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    // Current location card
              if (currentPosition != null)
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.my_location),
                    title: const Text('Use Current Location'),
                    subtitle: Text(
                      'Lat: ${currentPosition!.latitude}, Long: ${currentPosition!.longitude}',
                    ),
                    onTap: _handleCurrentLocationSelection,
                  ),
                ),
              const SizedBox(height: 20),
              const Text(
                'Select State',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: states.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(states[index]),
                    selected: selectedState == states[index],
                    onTap: () {
                      setState(() {
                        selectedState = states[index];
                        selectedCity = null;
                      });
                      _fetchCities(states[index]);
                    },
                  );
                },
              ),
              if (cities.isNotEmpty) ...[
                const SizedBox(height: 20),
                const Text(
                  // 'Select City',
                  "Select Location",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cities.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(cities[index]),
                      selected: selectedCity == cities[index],
                      onTap: () {
                        setState(() {
                          selectedCity = cities[index];
                        });
                        _updateLocation(cities[index]);
                      },
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
