// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/public_screen.dart/login_screen.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_poc_v3/models/product_model.dart';
import 'dart:ui'; // Import for blur effect

class CartController extends GetxController {
  List<ProductModel> cartList = [];
  List<String> favouriteIds = [];

  // Check server-side favorites and load saved favorites
  Future<void> loadFavorites(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
    

      // First check server favorites
      final response = await http.get(
        Uri.parse('http://13.200.179.78/favourites'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> serverFavorites = jsonDecode(response.body);
        // Get server favorite IDs
        favouriteIds = serverFavorites
            .map((item) => item['adpost_id'].toString())
            .toList();

        update(); // Update UI with server favorites first
        log('Server favorites loaded: $favouriteIds');

        // Then load additional favorites from local storage
        final savedFavorites = prefs.getStringList('favoriteAdposts');
        if (savedFavorites != null && savedFavorites.isNotEmpty) {
          // Add local favorites that aren't already in the list
          for (String id in savedFavorites) {
            if (!favouriteIds.contains(id)) {
              favouriteIds.add(id);
            }
          }
          update();
          log('Combined with local favorites: $favouriteIds');
        }

        // Save complete list back to SharedPreferences
        await prefs.setStringList('favoriteAdposts', favouriteIds);
      }
    } catch (e) {
      log('Error loading favorites: $e');
      // If server check fails, try loading from local storage as fallback
      final prefs = await SharedPreferences.getInstance();
      final savedFavorites = prefs.getStringList('favoriteAdposts');
      if (savedFavorites != null && savedFavorites.isNotEmpty) {
        favouriteIds = savedFavorites;
        update();
        log('Loaded from local storage after server error: $favouriteIds');
      }
    }
  }

  
  Future<void> addToFavourite(BuildContext context, String adpostId, {String? screenName}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      favouriteIds = prefs.getStringList('favoriteAdposts') ?? [];
      final token = prefs.getString('token');
      log('Token: $token');

      if (token == null) {
          await prefs.setString('previous_route', screenName ?? 'home_screen');
        // Check if context is still valid
        if (!context.mounted) return;

        Get.snackbar(
          'Login Required',
          'Please login to continue',
          snackStyle: SnackStyle.FLOATING,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor:
              const Color.fromARGB(255, 232, 235, 239).withOpacity(0.8),
          colorText: const Color.fromARGB(255, 12, 65, 0),
          margin: const EdgeInsets.all(10),
          duration: const Duration(seconds: 2),
        );

        // Use Get.to instead of Navigator
        // Get.to(() => const LoginScreen());
           // Use Navigator.push instead of Get.to to maintain the stack
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        return;
      }

      final response = await http.post(
        Uri.parse('http://13.200.179.78/add_to_favourite'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'adpost_id': adpostId}),
      );

      if (response.statusCode == 200) {
        if (!favouriteIds.contains(adpostId)) {
          favouriteIds.add(adpostId);
          await prefs.setStringList('favoriteAdposts', favouriteIds);
          update();
        }

        // Check if context is still valid
        if (!context.mounted) return;

        // Get.snackbar(
        //   'Success',
        //   'Added to Favourites',
        //   snackPosition: SnackPosition.TOP,
        //   backgroundColor: Colors.green.withOpacity(0.8),
        //   colorText: Colors.white,
        //   margin: const EdgeInsets.all(10),
        //   duration: const Duration(seconds: 2),
        // );

        Get.snackbar(
          'Success ✅',
          'Added to Favourites',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.transparent,
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 1),
          borderRadius: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          boxShadows: [
            BoxShadow(
              color: const Color.fromARGB(66, 215, 210, 210),
              blurRadius: 8,
              offset: Offset(1, 1),
            ),
          ],
          messageText: Text(
            'Added to Favourites',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color.fromARGB(255, 62, 245, 1),
            ),
          ),
          titleText: Text(
            'Success ✅',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 66, 255, 3),
            ),
          ),
          overlayBlur: 0,
          isDismissible: true,
          forwardAnimationCurve: Curves.easeOutBack,
          backgroundGradient: LinearGradient(
            colors: [Colors.teal, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        );
        update();
      }
    } catch (e) {
      // Check if context is still valid
      if (!context.mounted) return;

      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
      );
    }
  }

  // Get Favourites List
  Future<void> getFavouritesList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse('http://13.200.179.78/favourites'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        favouriteIds = data.map((item) => item['id'].toString()).toList();
        log('Fetched favourite ids: $favouriteIds'); // Debug log
        update();
      }
    } catch (e) {
      log("Error fetching favourites: $e");
    }
  }

  // Check if post is favourite
  bool isFavourite(String adpostId) {
    return favouriteIds.contains(adpostId);
  }

  @override
  void onInit() async {
    super.onInit();
    loadFavorites(Get.context!);
    final prefs = await SharedPreferences.getInstance();
    favouriteIds = prefs.getStringList('favoriteAdposts') ?? [];
    //  loadSavedFavorites(); // Load favorites when controller initializes
    getFavouritesList();
    update();
  }

 

  Future<void> removeFromFavourite(
      BuildContext context, String adpostId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.post(
        Uri.parse('http://13.200.179.78/remove_from_favourite'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'adpost_id': adpostId}),
      );

      if (response.statusCode == 200) {
        favouriteIds.remove(adpostId);
        await prefs.setStringList('favoriteAdposts', favouriteIds);
        update();

        if (!context.mounted) return;

        // Get.snackbar(
        //   'Success',
        //   'Removed from Favourites',
        //   snackPosition: SnackPosition.TOP,
        //   backgroundColor: Colors.red.withOpacity(0.8),
        //   colorText: Colors.white,
        //   margin: const EdgeInsets.all(10),
        //   duration: const Duration(seconds: 2),
        // );




Get.snackbar(
  '', // No title for a cleaner look
  '',
  snackPosition: SnackPosition.BOTTOM,
  backgroundColor: Colors.transparent,
  colorText: Colors.white,
  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  duration: const Duration(seconds: 2),
  borderRadius:0 ,
  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
  boxShadows: [
    BoxShadow(
      color: const Color.fromARGB(96, 240, 237, 237),
      blurRadius: 10,
      offset: Offset(3, 4),
    ),
  ],
  overlayBlur: 0,
  isDismissible: true,
  forwardAnimationCurve: Curves.easeOutQuad,
  backgroundGradient: LinearGradient(
    colors: [Colors.black87, Colors.redAccent.shade700],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  titleText: Row(
    children: [
      Icon(
        Icons.delete_forever_rounded,
         color: const Color.fromARGB(179, 253, 1, 52),
        size: 28,
      ),
      SizedBox(width: 5),
      Text(
        'Removed from Favourites',
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w600,
           color: const Color.fromARGB(179, 253, 1, 52),
        ),
      ),
    ],
  ),
  messageText: Padding(
    padding: const EdgeInsets.only(top: 4),
    child: Text(
      '',
      style: GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: const Color.fromARGB(179, 253, 1, 52),
      
    
      ),
    ),
  ),
  mainButton: TextButton(
    onPressed: () {},
    child: Text(
      '',
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  ),
);


      }
    } catch (e) {
      if (!context.mounted) return;

      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
      );
    }
  }
}















