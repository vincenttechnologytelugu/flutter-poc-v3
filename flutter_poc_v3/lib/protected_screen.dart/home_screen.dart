import 'dart:async';

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:flutter_poc_v3/protected_screen.dart/dashboard/chat_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/dashboard/dashhome_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/dashboard/my_adds.dart';
import 'package:flutter_poc_v3/protected_screen.dart/dashboard/profile_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/dashboard/sell_screen.dart';

import 'package:flutter_poc_v3/protected_screen.dart/homeappbar_screen.dart';

import 'package:flutter_poc_v3/protected_screen.dart/location_screen.dart';

import 'package:flutter_poc_v3/public_screen.dart/login_screen.dart';
import 'package:flutter_poc_v3/services/my_ads_sevice.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final pageController = PageController();
  final Color selectedColor = Color.fromARGB(255, 1, 179, 25);

  final Color unselectedColor = Color.fromARGB(255, 15, 12, 17);
  final Color backgroundColor = Color.fromARGB(255, 169, 171, 168);

  // Add this helper method in your widget class
  Color getIconColor(int index) {
    return currentIndex == index ? selectedColor : unselectedColor;
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = currentIndex == index;
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 50, // Fixed height for the container
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 23,
            color: isSelected
                ? const Color.fromARGB(255, 244, 246, 245)
                : unselectedColor, // White when selected
          ),
          // SizedBox(height: 2), // Small spacing between icon and text
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected
                  ? Colors.white
                  : unselectedColor, // White when selected
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  String? userName;
  int currentIndex = 0;
  String selectedLocation = 'Fetching location...';
  // Position? currentPosition;
  StreamSubscription<Position>? _locationSubscription; // Add this line

// String selectedLocation = 'Select Location';
  // Define screens list properly
  final List<Widget> _screens = [
    const DashhomeScreen(),
    // IntroductionScreen(),
    const ChatScreen(),
    const SellScreen(),
    const MyAdds(),
    const ProfileScreen(),
  ];

  // List of screen titles
  // final List<String> _screenTitles = [
  //   '', // Empty for home screen as it uses HomeappbarScreen
  //   'Chat',
  //   'Sell',
  //   'My Ads',
  //   'Profile',
  // ];

  @override
  void initState() {
    super.initState();
    loadUserData();
    //  _getCurrentLocation(); // Add this line
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showLocationDialog(
            'Location services are disabled. Please enable location services.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showLocationDialog('Location permission denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showLocationDialog('Location permissions are permanently denied');
        return;
      }

      // If permission granted, start location updates
      _startLocationUpdates();
    } catch (e) {
      debugPrint('Error checking location permission: $e');
    }
  }

  void _startLocationUpdates() {
    // First get current location
    _getCurrentLocation();

    // Then start listening to location updates
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100, // Update every 100 meters
    );

    _locationSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
            (Position position) {
      _updateLocation(position);
    }, onError: (error) {
      debugPrint('Error getting location updates: $error');
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
          // ignore: deprecated_member_use
          desiredAccuracy: LocationAccuracy.high);
      await _updateLocation(position);
    } catch (e) {
      debugPrint('Error getting current location: $e');
      setState(() {
        selectedLocation = 'Error getting location';
      });
    }
  }

  Future<void> _updateLocation(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String newLocation = '';

        if (place.locality?.isNotEmpty ?? false) {
          newLocation += place.locality!;
        }

        if (place.administrativeArea?.isNotEmpty ?? false) {
          if (newLocation.isNotEmpty) {
            newLocation += ', ';
          }
          newLocation += place.administrativeArea!;
        }

        setState(() {
          selectedLocation =
              newLocation.isNotEmpty ? newLocation : 'Location found';
        });

        // Save to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('current_location', selectedLocation);
      }
    } catch (e) {
      debugPrint('Error updating location: $e');
    }
  }

  void _showLocationDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Required'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Settings'),
              onPressed: () async {
                Navigator.pop(context);
                await Geolocator.openLocationSettings();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    if (currentIndex == 0) {
      return PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: HomeappbarScreen(
          location: selectedLocation ?? "",
          onLocationTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LocationScreen()),
            );
            if (result != null && result is String) {
              setState(() {
                selectedLocation = result;
                _locationSubscription?.cancel();
              });
            }
          },
        ),
      );
    } else {
      return AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white70,
        title: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 250,
                  height: 250,
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width *
                        0.3, // 30% of screen width
                    maxHeight: 100,
                  ),
                  child: Image.asset(
                    //                 width: 200, // Specify desired width
                    // height: 200, // Specify desired height

                    "assets/images/homelogo.jpg",
                    fit: BoxFit.contain,
                    scale: 0.8,
                  ),
                ),
                SizedBox(width: 8),
                // Flexible(
                //   child: Text(
                //     "U Sales",
                //     style: TextStyle(
                //       fontSize: MediaQuery.of(context).size.width * 0.06, // Responsive font size
                //       fontWeight: FontWeight.w600,
                //       color: Color.fromARGB(255, 152, 10, 247),
                //     ),
                //     overflow: TextOverflow.ellipsis,
                //   ),
                // ),
              ],
            );
          },
        ),
        centerTitle: false,
      );
    }
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('first_name') ?? 'User';
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
            child: const Text('Logout'),
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
  void dispose() {
    _locationSubscription?.cancel(); // Cancel location
    super.dispose();
  }

  // Future<void> _updateLocation(Position position) async {
  //   try {
  //     List<Placemark> placemarks = await placemarkFromCoordinates(
  //       position.latitude,
  //       position.longitude,
  //     );

  //     if (placemarks.isNotEmpty) {
  //       Placemark place = placemarks[0];
  //       setState(() {
  //         selectedLocation = '${place.locality ?? ''}, ${place.administrativeArea ?? ''}';
  //         currentPosition = position;
  //       });

  //       // Save location to SharedPreferences
  //       final prefs = await SharedPreferences.getInstance();
  //       await prefs.setString('last_known_location', selectedLocation);
  //     }
  //   } catch (e) {
  //     debugPrint('Error updating location: $e');
  //   }
  // }
  // Add the _buildAppBar method here

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: _buildAppBar(),
      // drawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: [
      //       DrawerHeader(
      //         decoration: const BoxDecoration(
      //           color: Color.fromARGB(255, 173, 171, 171),
      //         ),
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             const Text(
      //               'Welcome!',
      //               style: TextStyle(
      //                 color: Colors.white,
      //                 fontSize: 24,
      //               ),
      //             ),
      //             const SizedBox(height: 10),
      //             Text(
      //               userName ?? 'User',
      //               style: const TextStyle(
      //                 color: Colors.white,
      //                 fontSize: 18,
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.location_on),
      //         title: Text(selectedLocation),
      //         onTap: _showLocationScreen,
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.logout),
      //         title: const Text('Logout'),
      //         onTap: logout,
      //       ),
      //     ],
      //   ),
      // ),

      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: backgroundColor,
        buttonBackgroundColor: selectedColor,
        height: 70,
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.easeInOutCubic,
        index: currentIndex,
        items: <Widget>[
          _buildNavItem(Icons.home, "Home", 0),
          _buildNavItem(Icons.chat, "Chats", 1),
          _buildNavItem(Icons.add_circle_outline, "Selling", 2),
          _buildNavItem(Icons.favorite_rounded, "Myadds", 3),
          _buildNavItem(Icons.person, "Profile", 4),
        ],
        // onTap: (index) {
        //   setState(() {
        //     currentIndex = index;
        //   });
        // },

        // In home_screen.dart, modify your onTap handler:

   onTap: (index) async {
      if (index == 2) { // Sell Screen
    // Navigate to SellScreen without bottom nav
    Navigator.pushAndRemoveUntil( // Use push instead of pushReplacement
      context,
      MaterialPageRoute(
        builder: (context) => const SellScreen(),
      ),
      (route) => false,
    );
    return; // Return early to prevent further execution
  }
  if (index == 1 || index == 3 || index == 4) { // Chat, MyAds, or Profile
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      // Save the previous route before navigating
      await prefs.setString('previous_route', 
        index == 1 ? 'chat_screen' : 
        index == 3 ? 'my_adds' : 'profile_screen'
      );
      
      // if (mounted) {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => const LoginScreen()),
      //   );
      // }
       if (mounted) {
        // Store the attempted index before navigating
        await prefs.setInt('attempted_index', index);
        
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        ).then((_) async {
          // When returning from login screen, check token
          final updatedToken = await prefs.getString('token');
          if (updatedToken == null) {
            setState(() {
              currentIndex = 0; // Reset to home if no token
            });
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
          }
        });
      }
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://13.200.179.78/authentication/auth_user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Authentication successful
        setState(() {
          currentIndex = index;
        });

        // Navigate based on index
        if (mounted) {
          if (index == 1) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const ChatScreen(),
              ),
              (route) => false,
            );
          } else if (index == 3) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MyAdds(),
              ),
              (route) => false,
            );
            
          } else if (index == 4) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen(),
              ),
               (route) => false,
            );
          }
        }
      } else {
        // Token invalid, navigate to DashhomeScreen
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      }
    } catch (e) {
      // Error occurred, navigate to DashhomeScreen
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    }
  } else {
    setState(() {
      currentIndex = index;
    });
  }
},

      ),

      body: IndexedStack(
        // Replace direct array access with IndexedStack
        index: currentIndex,
        children: _screens,
      ),
    );
  }
}
