
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_poc_v3/models/product_model.dart';

class CartController extends GetxController {
  List<ProductModel> cartList = [];
  List<String> favouriteIds = [];
  

    // Check server-side favorites and load saved favorites
  Future<void> loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      // First check server favorites
      final response = await http.get(
        Uri.parse('http://192.168.0.167:8080/favourites'),
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
  //       Uri.parse('http://192.168.0.167:8080/favourite_adposts'),
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
  Future<void> addToFavourite(BuildContext context, String adpostId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
       favouriteIds = prefs.getStringList('favoriteAdposts') ?? [];  // Get latest list
      final token = prefs.getString('token');

      final response = await http.post(
        Uri.parse('http://192.168.0.167:8080/add_to_favourite'),
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
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Added to Favourites")),
        );
      } else if(response.statusCode == 400){
        // If already in favorites, make sure it's in our local list
        if (!favouriteIds.contains(adpostId)) {
          favouriteIds.add(adpostId);
          await prefs.setStringList('favoriteAdposts', favouriteIds);
          update();
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Adpost already in favourites")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

   // Get Favourites List
  Future<void> getFavouritesList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse('http://192.168.0.167:8080/favourites'),
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
   loadFavorites();
  final prefs = await SharedPreferences.getInstance();
  favouriteIds = prefs.getStringList('favoriteAdposts') ?? [];
    //  loadSavedFavorites(); // Load favorites when controller initializes
    getFavouritesList();
    update();
  }

  // Remove from Favourite
  Future<void> removeFromFavourite(BuildContext context, String adpostId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
  log('Removing post with ID: $adpostId'); // Debug log
      final response = await http.post(
        Uri.parse('http://192.168.0.167:8080/remove_from_favourite'),
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Removed from Favourites")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to remove from favourites")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
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
