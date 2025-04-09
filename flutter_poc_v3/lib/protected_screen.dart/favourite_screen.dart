// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/controllers/cart_controller.dart';
import 'package:flutter_poc_v3/models/product_model.dart';
import 'package:flutter_poc_v3/protected_screen.dart/product_details.dart';
import 'package:flutter_poc_v3/public_screen.dart/login_screen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  List<ProductModel> favouriteAdposts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getFavouriteAdposts();
  }

  Future<void> getFavouriteAdposts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      log('Fetching with token: $token');
      //  if (token == null) {

      //   //  error = 'No authentication token found';
      //    ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text("Token Not Found")),
      //   );
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => LoginScreen()),
      //   );
        
      //   return;
      // }

      final response = await http.get(
        Uri.parse('http://13.200.179.78/favourite_adposts'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        // Check if the data is in a nested field
        final List<dynamic> data =
            jsonResponse['data'] ?? jsonResponse['adposts'] ?? [];

        setState(() {
          favouriteAdposts = data
              .map(
                  (item) => ProductModel.fromJson(item as Map<String, dynamic>))
              .toList();
          isLoading = false;
        });

        log('Parsed ${favouriteAdposts.length} favourite posts');
      } else {
        log('Error status code: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      log("Error fetching favourite adposts: $e");
      log("Stack trace: $stackTrace"); // Added stack trace for better debugging
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 180, 170, 177),
      appBar: AppBar(
          automaticallyImplyLeading: false, // This removes the back arrow
        title: const Text(
          'Favourite Posts',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color.fromARGB(255, 24, 8, 241)),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : favouriteAdposts.isEmpty
              ? Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border_rounded,
                      size: 80,
                      color: const Color.fromARGB(255, 224, 77, 77),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No favourite posts found',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add some favourite posts to see them here.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Explore Posts',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ))
              : ListView.builder(
                  itemCount: favouriteAdposts.length,
                  itemBuilder: (context, index) {
                    final post = favouriteAdposts[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetails(
                              productModel: post,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        // clipBehavior: Clip.antiAlias,
                        elevation: 9,
                        surfaceTintColor:
                            const Color.fromARGB(255, 156, 125, 200),
                        color: const Color.fromARGB(255, 225, 219, 219),
                        shadowColor: const Color.fromARGB(255, 113, 99, 104),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Color.fromARGB(255, 52, 48, 59),
                            width: 1,
                            style: BorderStyle.solid,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: const EdgeInsets.all(2),
                        child: ListTile(
                          leading: post.thumb != null && post.thumb!.isNotEmpty
                              ? Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 187, 186, 186),
                                      width: 1,
                                    ),
                                  ),
                                  width: 120, // Keep the width the same
                                  height:
                                      220, // Increased height of the container
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Image.network(
                                      // post.thumb!,
                                       'http://13.200.179.78/${post.thumb}', // Updated URL construction
                                      width: 120, // Keep the width the same
                                      height:
                                          220, // Increased height of the image
                                      fit: BoxFit.fill,
                                      errorBuilder: (context, error,
                                              stackTrace) =>
                                          const Icon(Icons.image_not_supported,
                                              size: 50),
                                    ),
                                  ),
                                )
                              : const Icon(Icons.image_not_supported),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.title ?? 'No Title',
                                maxLines: 2,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                  height:
                                      4), // Add some spacing between title and location
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 16,
                                    color: Color.fromARGB(255, 26, 16, 16),
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      post.location ?? 'Location not available',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: const Color.fromARGB(
                                            255, 28, 24, 24),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (post.price != null)
                                Text(
                                  '₹${post.price}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pink,
                                    fontSize: 16,
                                  ),
                                ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  await Get.find<CartController>()
                                      .removeFromFavourite(
                                          context, post.id.toString());
                                  getFavouriteAdposts();
                                },
                              ),
                            ],
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          tileColor: const Color.fromARGB(255, 239, 238, 243),
                          selectedTileColor:
                              const Color.fromARGB(255, 11, 2, 2),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}




















