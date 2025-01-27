

// import 'package:flutter/foundation.dart';


import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/controllers/products_controller.dart';
import 'package:flutter_poc_v3/protected_screen.dart/location_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_poc_v3/public_screen.dart/login_screen.dart';

class HomeappbarScreen extends StatefulWidget {
  final String location;

  const HomeappbarScreen({super.key, this.location = "Select Location"});

  @override
  State<HomeappbarScreen> createState() => _HomeappbarScreenState();
}

class _HomeappbarScreenState extends State<HomeappbarScreen> {
  final ProductsController productsController = ProductsController();



  String? locationText;
  String? userName;
//  String? selectedLocationFromMap = "Location";  // Initial value




 




  // Add this method to check storage
  void checkStorageData() {
    checkSharedPreferences();
  }

// Check SharedPreferences
  Future<void> checkSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();
    if (!mounted) return;

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

  @override
  void initState() {
    super.initState();
    loadUserData();
    // Initialize location from widget if provided
    locationText = widget.location;
  }



  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('first_name') ?? 'User';
      //  selectedLocationFromMap = prefs.getString('pickedLocation') ?? 'Location';  // Load the saved location
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
      backgroundColor: const Color.fromARGB(255, 173, 171, 171),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(padding: EdgeInsets.only(top: 10)),
              const Text(
                "U Sales",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              const Icon(
                Icons.location_on_outlined,
                size: 30,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LocationScreen(),
                      ),
                    );

                   
                    if (result != null) {
                      setState(() {
                        // Update the location text
                        locationText =
                            result.toString().replaceAll(RegExp(r'[{}()]'), '');
                        //      selectedLocationFromMap = result.toString().replaceAll(RegExp(r'[{}()]'), '');
                        // _saveLocationToPreferences(selectedLocationFromMap!);  // Save updated location
                          
                      });
                    }
                  },
                  child: Column(
                    children: [
                      Text(
                        locationText ?? 'Location',
                        // selectedLocationFromMap ?? 'Location',  // Display selected locatin
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // // Method to save the selected location to SharedPreferences
  // Future<void> _saveLocationToPreferences(String location) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('pickedLocation', location);  // Store location in SharedPreferences
  // }
}
