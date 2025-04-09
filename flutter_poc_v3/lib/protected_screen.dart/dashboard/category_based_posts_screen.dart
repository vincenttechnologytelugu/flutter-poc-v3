import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/controllers/cart_controller.dart';
import 'package:flutter_poc_v3/controllers/location_controller.dart';
import 'package:flutter_poc_v3/models/product_model.dart';
import 'package:flutter_poc_v3/protected_screen.dart/homeappbar_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/product_details.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:math' show sin, pi;

class CategoryBasedPostsScreen extends StatefulWidget {
  final String apiUrl;
  final String title;
  

  const CategoryBasedPostsScreen({
    super.key,
    required this.apiUrl,
    required this.title,
  });

  @override
  State<CategoryBasedPostsScreen> createState() =>
      _CategoryBasedPostsScreenState();
}

class _CategoryBasedPostsScreenState extends State<CategoryBasedPostsScreen> {
  CartController cartController = Get.put(CartController());
  final ScrollController _scrollController = ScrollController();
  // At the top of the class, add:
  LocationController locationController = Get.find<LocationController>();

  List<ProductModel> productModel = [];

  bool isLoading = false;
  bool hasMore = true;
  int page = 0;
  final int pageSize = 50;
  String location = "Select Location"; // Add this line
  @override
  void initState() {
    super.initState();

    // Listen to location changes
    ever(locationController.currentCity, (_) {
      _loadPosts();
    });

    ever(locationController.currentState, (_) {
      _loadPosts();
    });

    _loadPosts();

    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!isLoading && hasMore) {
        page++;
        _loadPosts();
      }
    }
  }

  String formatDate(String dateString) {
    try {
      // Parse ISO 8601 format string to DateTime
      DateTime dateTime = DateTime.parse(dateString);

      // Convert to local time zone
      dateTime = dateTime.toLocal();

      // Format the date
      return DateFormat('EEE, MMM d, yyyy').format(dateTime);
    } catch (e) {
      log('Error parsing date: $e');
      return 'Invalid date';
    }
  }

  Future<void> _loadPosts() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
      // Clear existing posts when location changes
      if (page == 0) {
        productModel.clear();
      }
    });

    try {
      // Get current location details from LocationController
      final currentCity = locationController.currentCity.value;
      final currentState = locationController.currentState.value;

      // Create query parameters map
      final queryParams = {
        'page': page.toString(),
        'psize': pageSize.toString(),

        'city': currentCity,
        'state': currentState,

        // Add any other existing query parameters from the original URL
        ...Uri.parse(widget.apiUrl).queryParameters,
      };

      // Remove null or empty values
      queryParams.removeWhere((key, value) => value.isEmpty);

      final Uri uri = Uri.parse(widget.apiUrl).replace(
        queryParameters: queryParams,
      );

      log('Loading posts from: $uri');

      final response = await http.get(uri);
      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'] ?? [];

        final List<ProductModel> newPosts =
            data.map((json) => ProductModel.fromJson(json)).toList();

        setState(() {
          productModel.addAll(newPosts);
          hasMore = newPosts.length == pageSize;
          isLoading = false;
          // Update location in the UI
          location = '$currentCity, $currentState';
        });

        log('Number of posts loaded: ${newPosts.length}');
        log('Total posts: ${productModel.length}');
      } else {
        log('Error: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      log('Exception: $e');
      log('Stack trace: $stackTrace');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _navigateToProductDetails(ProductModel product) {
    Get.to(() => ProductDetails(productModel: product));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(130), // Adjust height as needed
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Added this to minimize height
            children: [
              HomeappbarScreen(
                location: location,
                onLocationTap: () async {
                  // Handle location tap if needed
                },
              ), // Add HomeAppBar here
              AppBar(
                centerTitle: true,

                automaticallyImplyLeading: false, // Add this line to remove b
                title: Text(widget.title.toUpperCase(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center),
                elevation: 0,

                backgroundColor: Colors
                    .transparent, // Make it transparent to avoid double background
              ),
            ],
          ),
        ),
      ),
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: Text(widget.title),
      // ),
      body: productModel.isEmpty && isLoading
          ? const Center(child: CircularProgressIndicator())
          : productModel.isEmpty
              ? Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color.fromARGB(255, 11, 175, 224),
                        Colors.grey[100]!,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            // color: Colors.grey.withOpacity(0.1),
                            color: Colors.grey.withAlpha((0.1 * 255).round()),
                            spreadRadius: 5,
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.search_off_rounded,
                              size: 100,
                              color: const Color.fromARGB(255, 224, 61, 61),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'No Posts Found',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Try Change your search criteria',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.blue[100]!,
                                width: 1,
                              ),
                            ),
                            child: InkWell(
                              onTap: () =>
                                  Navigator.pop(context), // Navigate back
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Icon(
                                  //   Icons
                                  //       .arrow_back_rounded, // Changed to back arrow icon
                                  //   size: 20,
                                  //   color: Colors.blue[700],
                                  // ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Go Back', // Changed text from "Refresh" to "Go Back"
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: productModel.length + (hasMore ? 1 : 0),
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    if (index == productModel.length) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: isLoading
                              ? const CircularProgressIndicator()
                              : const SizedBox(),
                        ),
                      );
                    }

                    final post = productModel[index];
                    return Card(
                      elevation: 8,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () => _navigateToProductDetails(post),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white,
                                Colors.grey.shade50,
                              ],
                            ),
                          ),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  // Product Image
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    height: 190,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(12)),
                                      color: Colors.grey[
                                          100], // Light background for placeholder
                                    ),
                                    // child: post.thumb != null &&
                                    //         post.thumb!.isNotEmpty
                                    //     ? Image.network(
                                    //         post.thumb!,
                                    //         fit: BoxFit.cover,
                                    child: post.thumbnailUrl.isNotEmpty
                                        ? Image.network(
                                            'http://13.200.179.78/${post.thumbnailUrl}',
                                            height: 200,
                                            width: double.infinity,
                                            fit: BoxFit.fill,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.image_outlined,
                                                      size: 70,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 127, 85, 85),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      'No Image Available',
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          )
                                        : Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.image_outlined,
                                                  size: 70,
                                                  color: const Color.fromARGB(
                                                      255, 113, 90, 90),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  'No Image Available',
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ),

                                  Positioned(
                                    top: 12,
                                    right: 12,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 203, 203, 189),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 1.0,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black
                                                .withAlpha((0.5 * 255).round()),
                                            blurRadius: 2,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: GetBuilder<CartController>(
                                        builder: (cartController) =>
                                            TweenAnimationBuilder(
                                          duration: Duration(milliseconds: 100),
                                          tween: Tween<double>(
                                            begin: 0,
                                            end: cartController.isFavourite(
                                                    post.id.toString())
                                                ? 1
                                                : 0,
                                          ),
                                          builder: (context, double value, _) {
                                            return IconButton(
                                              onPressed: () {
                                                if (cartController.isFavourite(
                                                    post.id.toString())) {
                                                  cartController
                                                      .removeFromFavourite(
                                                    context,
                                                    post.id.toString(),
                                                  );
                                                } else {
                                                  cartController.addToFavourite(
                                                    context,
                                                    post.id.toString(),
                                                     screenName: 'category_based_posts_screen'  // Add this parameter
                                                  );
                                                }
                                              },
                                              icon: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  if (cartController
                                                      .isFavourite(
                                                          post.id.toString()))
                                                    ...List.generate(
                                                      5,
                                                      (index) =>
                                                          AnimatedOpacity(
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    100),
                                                        opacity: value,
                                                        child: Transform.scale(
                                                          scale: 1 +
                                                              (index * 0.2) *
                                                                  value,
                                                          child:
                                                              Transform.rotate(
                                                            angle:
                                                                (index * 0.0) *
                                                                    value *
                                                                    0.10,
                                                            child: Icon(
                                                              Icons.favorite,
                                                              color: HSLColor
                                                                      .fromAHSL(
                                                                1.0,
                                                                (index *
                                                                        10.0 *
                                                                        value) %
                                                                    20,
                                                                0.8,
                                                                0.5 +
                                                                    (value *
                                                                        0.3),
                                                              )
                                                                  .toColor()
                                                                  // .withOpacity(1 -
                                                                  //     (index *
                                                                  //         0.15)),
                                                                  .withAlpha(((1 -
                                                                              (index * 0.15)) *
                                                                          255)
                                                                      .round()),
                                                              size: 20,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      // ignore: unnecessary_to_list_in_spreads
                                                    ).toList(),
                                                  if (cartController
                                                      .isFavourite(
                                                          post.id.toString()))
                                                    ...List.generate(
                                                      6,
                                                      (index) =>
                                                          TweenAnimationBuilder(
                                                        tween: Tween(
                                                            begin: 0.0,
                                                            end: 1.0),
                                                        duration: Duration(
                                                            milliseconds: 1000 +
                                                                index * 200),
                                                        curve:
                                                            Curves.easeInExpo,
                                                        builder: (context,
                                                            value, child) {
                                                          return Transform
                                                              .translate(
                                                            offset: Offset(
                                                              sin(value *
                                                                      pi *
                                                                      2) *
                                                                  15,
                                                              -value * 50,
                                                            ),
                                                            child: Opacity(
                                                              opacity:
                                                                  1 - value,
                                                              child: Transform
                                                                  .scale(
                                                                scale: 1 -
                                                                    value * 0.5,
                                                                child:
                                                                    Container(
                                                                  width: 10,
                                                                  height: 10,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: const Color
                                                                            .fromARGB(
                                                                            255,
                                                                            246,
                                                                            3,
                                                                            226)
                                                                        // .withOpacity(
                                                                        //     0.9),
                                                                        .withAlpha((0.9 *
                                                                                255)
                                                                            .round()),
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .white
                                                                            .withAlpha((0.4 * 255).round()),
                                                                        blurRadius:
                                                                            10,
                                                                        spreadRadius:
                                                                            2,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  Icon(
                                                    Icons.favorite,
                                                    color: TweenSequence<
                                                        Color?>([
                                                      TweenSequenceItem(
                                                        weight: 1.0,
                                                        tween: ColorTween(
                                                          begin: Colors.grey,
                                                          end: const Color
                                                              .fromARGB(
                                                              255, 205, 4, 241),
                                                        ),
                                                      ),
                                                      TweenSequenceItem(
                                                        weight: 1.0,
                                                        tween: ColorTween(
                                                          begin: const Color
                                                              .fromARGB(
                                                              255, 213, 4, 250),
                                                          end: const Color
                                                              .fromARGB(
                                                              255, 6, 82, 157),
                                                        ),
                                                      ),
                                                      TweenSequenceItem(
                                                        weight: 1.0,
                                                        tween: ColorTween(
                                                          begin: Colors.blue,
                                                          end: const Color
                                                              .fromARGB(
                                                              255, 160, 243, 7),
                                                        ),
                                                      ),
                                                      TweenSequenceItem(
                                                        weight: 1.0,
                                                        tween: ColorTween(
                                                          begin: const Color
                                                              .fromARGB(
                                                              255, 247, 1, 112),
                                                          end: const Color
                                                              .fromARGB(
                                                              255, 241, 2, 2),
                                                        ),
                                                      ),
                                                    ]).evaluate(
                                                        AlwaysStoppedAnimation(
                                                            value)),
                                                    size: 20,
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),

                                  Builder(
                                    builder: (context) {
                                      // More detailed debug prints
                                      log('Raw product data: ${jsonEncode(post.toJson())}'); // Add toJson() method if not exists
                                      log('Featured at: ${post.featured_at}');
                                      log('Valid till: ${post.valid_till}');
                                      log('Current time: ${DateTime.now().millisecondsSinceEpoch ~/ 1000}');

                                      // Simplified featured check
                                      bool isFeatured = false;
                                      if (post.featured_at != null &&
                                          post.valid_till != null) {
                                        final now = DateTime.now()
                                                .millisecondsSinceEpoch ~/
                                            1000;
                                        isFeatured = post.featured_at! <= now &&
                                            post.valid_till! >= now;
                                        log('Time check: $now is between ${post.featured_at} and ${post.valid_till}');
                                      }

                                      log('Is Featured: $isFeatured');

                                      if (!isFeatured) {
                                        return const SizedBox.shrink();
                                      }

                                      return Positioned(
                                        top: 10,
                                        left: 10,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color.fromARGB(255, 252, 252,
                                                    252), // Deep Purple
                                                Color.fromARGB(
                                                    255, 252, 252, 252), // Pink
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    // .withOpacity(0.3),
                                                    .withAlpha(
                                                        (0.3 * 255).round()),
                                                spreadRadius: 1,
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: const Text(
                                            'FEATURED',
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 1, 179, 25),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Expanded(
                                        //   child: Text(
                                        //     post.title ?? 'No Title',
                                        //     style: const TextStyle(
                                        //       fontSize: 18,
                                        //       fontWeight: FontWeight.bold,
                                        //     ),
                                        //     maxLines: 2,
                                        //     overflow: TextOverflow.ellipsis,
                                        //   ),
                                        // ),
                                        Expanded(
                                          child: Text(
                                            (post.title ?? 'No Title')
                                                .toUpperCase(),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),

                                        // Text(
                                        //   '₹${post.price ?? 'N/A'}',
                                        //   style: const TextStyle(
                                        //     fontSize: 20,
                                        //     fontWeight: FontWeight.bold,
                                        //     color: Color.fromARGB(255, 3, 151, 20),
                                        //     // color: Color.fromARGB(
                                        //     //     255, 243, 6, 176),
                                        //   ),
                                        // ),

                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 16),
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color.fromARGB(255, 1, 179, 25),
                                                Color.fromARGB(255, 1, 179, 25)
                                              ], // Green gradient
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius: BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(20),
                                                topLeft: Radius.circular(20)),
                                            boxShadow: [
                                              BoxShadow(
                                                // color: Colors.black.withOpacity(0.15),
                                                color: Colors.black.withAlpha(
                                                    (0.15 * 255).round()),
                                                blurRadius: 8,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                post.price != null
                                                    ? '₹${NumberFormat('#,##0', 'en_IN').format(post.price)}'
                                                    : 'N/A',
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w900,
                                                  color: Colors.white,
                                                  letterSpacing: 1.2,
                                                ),
                                              )

                                              // Text(
                                              //   post.price != null ? '₹${post.price}' : 'N/A',
                                              //   style: const TextStyle(
                                              //     fontSize: 20,
                                              //     fontWeight: FontWeight.bold,
                                              //     color: Colors.white,
                                              //     letterSpacing: 1.2,
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on_outlined,
                                            size: 18,
                                            color: const Color.fromARGB(
                                                255, 18, 17, 17)),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            [
                                              post.location,
                                              post.city,
                                              post.state
                                            ]
                                                .where((item) =>
                                                    item != null &&
                                                    item.isNotEmpty)
                                                .join(', '),
                                            style: TextStyle(
                                              color: const Color.fromARGB(
                                                  255, 23, 22, 22),
                                              fontSize: 16,
                                              fontFamily:
                                                  GoogleFonts.abhayaLibre()
                                                      .fontFamily,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    // Row(
                                    //   children: [
                                    //     Icon(Icons.access_time,
                                    //         size: 16, color: Colors.grey[600]),
                                    //     const SizedBox(width: 4),

                                    // Text(
                                    //       (post.getFormattedDateWithTime()),
                                    //       style: TextStyle(
                                    //         color: Colors.grey[600],
                                    //         fontSize: 14,
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),

                                    const SizedBox(
                                        height:
                                            8), // Add spacing between location and published date
                                    Row(
                                      children: [
                                        Icon(
                                            Icons
                                                .calendar_today, // Using calendar icon for published date
                                            size: 18,
                                            color: const Color.fromARGB(
                                                255, 18, 17, 17)),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Published: ${post.published_at != null ? DateFormat('MMM dd, yyyy').format(DateTime.parse(post.published_at!)) : 'Not available'}',
                                          style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 23, 22, 22),
                                            fontSize: 16,
                                            fontFamily:
                                                GoogleFonts.abhayaLibre()
                                                    .fontFamily,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
