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
      // if (token == null) {

      //      ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(content: Text("Token Not Found")),
      //     );
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => LoginScreen()),
      //     );

      //     return;
      //   }

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

  //  // Load saved favorites from SharedPreferences
  // Future<void> loadSavedFavorites() async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final token = prefs.getString('token');

  //     // First try to load from local storage
  //     final savedFavorites = prefs.getStringList('favoriteAdposts');
  //     if (savedFavorites != null && savedFavorites.isNotEmpty) {
  //       favouriteIds = savedFavorites;
  //       update();
  //     }

  //     // Then fetch from server to sync
  //     final response = await http.get(
  //       Uri.parse('http://13.200.179.78/favourite_adposts'),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Content-Type': 'application/json',
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
  //       final List<dynamic> data = jsonResponse['data'] ?? [];

  //       // Update favorites list with server data
  //       favouriteIds = data.map((item) => item['id'].toString()).toList();

  //       // Save updated list to SharedPreferences
  //       await prefs.setStringList('favoriteAdposts', favouriteIds);
  //       update();
  //       log('Loaded favorites: $favouriteIds');
  //     }
  //   } catch (e) {
  //     log('Error loading favorites: $e');
  //   }
  // }

  // Add to Favourite
//   Future<void> addToFavourite(BuildContext context, String adpostId) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       favouriteIds =
//           prefs.getStringList('favoriteAdposts') ?? []; // Get latest list
//       final token = prefs.getString('token');
//       log('Token: $token');

//       if (token == null) {
//         // ScaffoldMessenger.of(context).showSnackBar(
//         //   const SnackBar(content: Text("Token Not Found")),
//         // );

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Container(
//               padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Colors.blueAccent, Colors.purpleAccent],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black26,
//                     blurRadius: 8,
//                     offset: Offset(2, 2),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(Icons.warning_amber_rounded,
//                       color: Colors.white, size: 22),
//                   SizedBox(width: 10),
//                   Text(
//                     "Login To Continue",
//                     style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white),
//                   ),
//                 ],
//               ),
//             ),
//             backgroundColor: Colors.transparent,
//             behavior: SnackBarBehavior.floating,
//             elevation: 0,
//             margin: EdgeInsets.all(16),
//             duration: Duration(seconds: 3),
//           ),
//         );

// // Navigator.push(
// //   context,
// //   MaterialPageRoute(builder: (context) => LoginScreen()),

// // );
//         // Use Get.to instead of Navigator
//         Get.to(() => LoginScreen());
//         return;
//       }

//       final response = await http.post(
//         Uri.parse('http://13.200.179.78/add_to_favourite'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({'adpost_id': adpostId}),
//       );

//       if (response.statusCode == 200) {
//         if (!favouriteIds.contains(adpostId)) {
//           favouriteIds.add(adpostId);
//           await prefs.setStringList('favoriteAdposts', favouriteIds);
//           update();
//         }

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             behavior: SnackBarBehavior
//                 .floating, // Makes it appear above the bottom bar
//             elevation: 6, // Adds depth
//             duration: const Duration(seconds: 2), // Auto-dismiss
//             backgroundColor:
//                 Colors.transparent, // Transparent for custom styling
//             content: Center(
//               child: Container(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       Colors.green.shade700,
//                       Colors.greenAccent.shade400
//                     ], // Gradient effect
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius:
//                       BorderRadius.circular(12), // Soft rounded corners
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.green.withOpacity(0.3),
//                       blurRadius: 8,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Icon(Icons.check_circle,
//                         color: Colors.white, size: 22), // Success icon
//                     const SizedBox(width: 10), // Spacing
//                     const Text(
//                       "Added to Favourites",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: 'Poppins',
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       } else if (response.statusCode == 400) {
//         // If already in favorites, make sure it's in our local list
//         if (!favouriteIds.contains(adpostId)) {
//           favouriteIds.add(adpostId);
//           await prefs.setStringList('favoriteAdposts', favouriteIds);
//           update();
//         }
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Adpost already in favourites")),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: $e")),
//       );
//     }
//   }

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

  // Remove from Favourite
//   Future<void> removeFromFavourite(
//       BuildContext context, String adpostId) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('token');
//       log('Removing post with ID: $adpostId'); // Debug log
//       //  if (token == null) {

//       //    ScaffoldMessenger.of(context).showSnackBar(
//       //     const SnackBar(content: Text("Token Not Found")),
//       //   );
//       //   Navigator.pushReplacement(
//       //     context,
//       //     MaterialPageRoute(builder: (context) => LoginScreen()),
//       //   );

//       //   return;
//       // }
//       final response = await http.post(
//         Uri.parse('http://13.200.179.78/remove_from_favourite'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({'adpost_id': adpostId}),
//       );

//       if (response.statusCode == 200) {
//         favouriteIds.remove(adpostId);
//         await prefs.setStringList('favoriteAdposts', favouriteIds);
//         update();
//         // ScaffoldMessenger.of(context).showSnackBar(
//         //   const SnackBar(content: Text("Removed from Favourites")),
//         // );

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             behavior: SnackBarBehavior.floating, // Floating for a sleek UI
//             elevation: 0, // Removes default shadow for custom styling
//             duration: const Duration(seconds: 2), // Auto-dismiss
//             backgroundColor: Colors.transparent, // Transparent for blur effect
//             content: Center(
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(15), // Soft rounded edges
//                 child: BackdropFilter(
//                   filter: ImageFilter.blur(
//                       sigmaX: 8, sigmaY: 8), // Glassmorphism effect
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 16, horizontal: 20),
//                     decoration: BoxDecoration(
//                       color:
//                           Colors.red.withOpacity(0.2), // Semi-transparent red
//                       borderRadius: BorderRadius.circular(15),
//                       border: Border.all(
//                           color: Colors.redAccent
//                               .withOpacity(0.4)), // Light red glow border
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.redAccent.withOpacity(0.3),
//                           blurRadius: 10,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(Icons.delete,
//                             color: Colors.white, size: 22), // Trash icon
//                         const SizedBox(width: 10), // Spacing
//                         const Text(
//                           "Removed from Favourites",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: 'Poppins',
//                             letterSpacing: 0.5,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       } else {
//         // ScaffoldMessenger.of(context).showSnackBar(
//         //   const SnackBar(content: Text("Failed to remove from favourites")),
//         // );

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             behavior: SnackBarBehavior.floating, // Floating for modern look
//             elevation: 0, // Removes default shadow
//             duration: const Duration(seconds: 3), // Auto-dismiss after 3 sec
//             backgroundColor: Colors.transparent, // Transparent for blur effect
//             content: Center(
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(15), // Smooth rounded edges
//                 child: BackdropFilter(
//                   filter:
//                       ImageFilter.blur(sigmaX: 8, sigmaY: 8), // Glass effect
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 16, horizontal: 20),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           Colors.redAccent.withOpacity(0.8),
//                           Colors.red.withOpacity(0.9)
//                         ],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       borderRadius: BorderRadius.circular(15),
//                       border: Border.all(
//                           color: Colors.redAccent
//                               .withOpacity(0.5)), // Subtle border
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.red.withOpacity(0.4),
//                           blurRadius: 12,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Icon(Icons.error_outline,
//                             color: Colors.white, size: 22), // Error icon
//                         const SizedBox(width: 10), // Spacing
//                         const Text(
//                           "Failed to remove from favourites",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: 'Poppins',
//                             letterSpacing: 0.5,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: $e")),
//       );
//     }
//   }
// }

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















// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_state_manager/get_state_manager.dart';
// import 'package:flutter_poc_v3/models/product_model.dart';

// class CartController extends GetxController {
//   List<ProductModel> cartList = [];
  


//   addToCart(BuildContext context, ProductModel productModel) {
//     cartList.add(productModel);
//     ScaffoldMessenger.of(context)
//         .showSnackBar(const SnackBar(content: Text("Added to Favourite")));
//     update();
//   }
  

//   removeFromCart(BuildContext context, ProductModel productModel) {
//     // Find the index of the first matching item
//     final index = cartList.indexWhere((e) => e.id == productModel.id);
//     if (index != -1) {
//       // Remove only one item at that index
//       cartList.removeAt(index);
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text("Removed from Favourite")));
//       update();
//       } else {
//       // Handle the case where the item is not found in the cartList
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text("Item not found in cart")));
//       update();
//     }

// }


//   // removeFromCart(BuildContext context, ProductModel productModel) {
//   //   cartList.removeWhere((e) => e.id == productModel.id);
//   //   ScaffoldMessenger.of(context)
//   //       .showSnackBar(const SnackBar(content: Text("Added to cart")));
//   //   update();
//   // }
// }
