// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/controllers/cart_controller.dart';
import 'package:flutter_poc_v3/models/product_model.dart';
import 'package:flutter_poc_v3/protected_screen.dart/favourite_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/homeappbar_screen.dart';
// import 'package:flutter_poc_v3/protected_screen.dart/cart_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/product_details.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' show sin, pi;

class SubCategoryPostsScreen extends StatefulWidget {
  final String category;
  final String subCategory;

  const SubCategoryPostsScreen({
    super.key,
    required this.category,
    required this.subCategory,
  });

  @override
  State<SubCategoryPostsScreen> createState() => _SubCategoryPostsScreenState();
}

class _SubCategoryPostsScreenState extends State<SubCategoryPostsScreen> {
  final ScrollController _scrollController = ScrollController();
  List<ProductModel> posts = [];
  int currentPage = 0;
  bool isLoading = false;
  bool hasMore = true;
  final CartController cartController = Get.put(CartController());
  String location = "Select Location";

  @override
  void initState() {
    super.initState();
    fetchPosts();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!isLoading && hasMore) {
        fetchPosts();
      }
    }
  }

  // Future<void> fetchPosts() async {
  //   if (isLoading) return;

  //   setState(() {
  //     isLoading = true;
  //   });

  //   try {
  //     final encodedCategory =
  //         Uri.encodeComponent(widget.category.toLowerCase());
  //     final encodedSubCategory = Uri.encodeComponent(widget.subCategory);

  //     final url =
  //         'http://13.200.179.78/adposts?category=$encodedCategory&page=$currentPage&psize=50&findkey=$encodedSubCategory';
  //     log('Fetching URL: $url');

  //     final response = await http.get(Uri.parse(url));
  //     log('Response Status: ${response.statusCode}');
  //     log('Response Body: ${response.body}');

  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       if (data['data'] != null && data['data'] is List) {
  //         final List<dynamic> jsonList = data['data'];

  //         final List<ProductModel> newPosts = jsonList
  //             .map((item) => ProductModel(
  //                   id: item['_id']?.toString(), // Add this line
  //                   icon: item['icon'] ??
  //                       '', // Add null check with default empty string
  //                   title: item['title']?.toString() ?? 'No Title',
  //                   description: item['description']?.toString() ?? '',
  //                   price: double.tryParse(item['price']?.toString() ?? '0'),
  //                   location: item['location']?.toString() ?? '',
  //                   city: item['city']?.toString() ?? '',
  //                   category: item['category']?.toString() ?? '',
  //                   thumb: item['thumb']?.toString() ?? '',
  //                   posted_at: item['posted_at']?.toString() ?? '',
  //                   brand: item['brand']?.toString() ?? '',
  //                   warranty: item['warranty']?.toString() ?? '',
  //                   condition: item['condition']?.toString() ?? '',
  //                   // Real Estate
  //                   bedrooms: item['bedrooms']?.toString() ?? '',
  //                   bathrooms: item['bathrooms']?.toString() ?? '',
  //                   area: item['area']?.toString() ?? '',
  //                   furnishing: item['furnishing']?.toString() ?? '',
  //                   // Vehicles
  //                   year: int.tryParse(item['year']?.toString() ?? '0'),
  //                   kilometers:
  //                       int.tryParse(item['kilometers']?.toString() ?? '0'),
  //                   fuelType: item['fuel_type']?.toString() ?? '',
  //                   transmission: item['transmission']?.toString() ?? '',
  //                   // Electronics
  //                   model: item['model']?.toString() ?? '',
  //                   storage: item['storage']?.toString() ?? '',
  //                   ram: item['ram']?.toString() ?? '',
  //                   // Furniture
  //                   material: item['material']?.toString() ?? '',
  //                 ))
  //             .toList();

  //         setState(() {
  //           posts.addAll(newPosts);
  //           currentPage++;
  //           hasMore = newPosts.length == 50;
  //         });

  //         log('Loaded ${newPosts.length} new posts');
  //       } else {
  //         setState(() {
  //           hasMore = false;
  //         });
  //         log('No data in response or invalid format');
  //       }
  //     }
  //   } catch (e, stackTrace) {
  //     log('Error fetching posts: $e');
  //     log('Stack trace: $stackTrace'); // Added stack trace for better debugging
  //     setState(() {
  //       hasMore = false;
  //     });
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  Future<void> fetchPosts() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      // Get current location from shared preferences
      final prefs = await SharedPreferences.getInstance();
      final currentCity = prefs.getString('city') ?? '';
      final currentState = prefs.getString('state') ?? '';

      final encodedCategory =
          Uri.encodeComponent(widget.category.toLowerCase());
      final encodedSubCategory = Uri.encodeComponent(widget.subCategory);

      // Add location parameters to the URL
      final url = 'http://13.200.179.78/adposts?'
          'category=$encodedCategory'
          '&page=$currentPage'
          '&psize=50'
          '&findkey=$encodedSubCategory'
          '&city=${Uri.encodeComponent(currentCity)}'
          '&state=${Uri.encodeComponent(currentState)}';

      log('Fetching URL: $url');

      final response = await http.get(Uri.parse(url));
      log('Response Status: ${response.statusCode}');
      log('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null && data['data'] is List) {
          final List<dynamic> jsonList = data['data'];
          log('First item featured_at: ${jsonList.isNotEmpty ? jsonList[0]['featured_at'] : 'no items'}');
          final List<ProductModel> newPosts = jsonList
              .map((item) => ProductModel(
                    id: item['_id']?.toString(),
                    icon: item['icon'] ?? '',
                    title: item['title']?.toString() ?? 'No Title',
                    description: item['description']?.toString() ?? '',
                    price: double.tryParse(item['price']?.toString() ?? '0'),
                    location: item['location']?.toString() ?? '',
                    city: item['city']?.toString() ?? '',
                    category: item['category']?.toString() ?? '',
                    thumb: item['thumb']?.toString() ?? '',
                    posted_at: item['posted_at']?.toString() ?? '',
                    brand: item['brand']?.toString() ?? '',
                    warranty: item['warranty']?.toString() ?? '',
                    condition: item['condition']?.toString() ?? '',
                    bedrooms: item['bedrooms']?.toString() ?? '',
                    bathrooms: item['bathrooms']?.toString() ?? '',
                    area: item['area']?.toString() ?? '',
                    furnishing: item['furnishing']?.toString() ?? '',
                    year: int.tryParse(item['year']?.toString() ?? '0'),
                    kilometers:
                        int.tryParse(item['kilometers']?.toString() ?? '0'),
                    fuelType: item['fuelType']?.toString() ?? '',
                    transmission: item['transmission']?.toString() ?? '',
                    model: item['model']?.toString() ?? '',
                    storage: item['storage']?.toString() ?? '',
                    ram: item['ram']?.toString() ?? '',
                    material: item['material']?.toString() ?? '',
                    publishedAt: item['published_at']?.toString() ?? '',
                    assets: item['assets'] != null
                        ? List<Map<String, dynamic>>.from(item['assets'])
                        : [], // Make sure to parse
                    featured_at: item['featured_at']?.toString() ??
                        '', // Update this line
                    valid_till:
                        item['valid_till']?.toString() ?? '', // Update this
                    state: item['state']?.toString() ?? '',
                    electronics_category:
                        item['electronics_category']?.toString() ?? '',
                    product: item['product']?.toString() ?? '',
                    operatingSystem: item['operatingSystem']?.toString() ?? '',
                    camera: item['camera']?.toString() ?? '',
                    screenSize: item['screenSize']?.toString() ?? '',
                    color: item['color']?.toString() ?? '',
                    battery: item['battery']?.toString() ?? '',
                    floorNumber: item['floorNumber']?.toString() ?? '',
                    totalFloors: item['totalFloors']?.toString() ?? '',
                    type:item['type']?.toString() ?? '',
                    ownerType: item['ownerType']?.toString() ?? '',
                    company: item['company']?.toString() ?? '',
                    industry: item['industry']?.toString() ?? '',
                    position: item['position']?.toString() ?? '',
                    experienceLevel: item['experienceLevel']?.toString() ?? '',
                    salary:item['salary'],
                    // salary: item['salary']?.toString() ?? '',
                    jobType: item['jobType']?.toString() ?? '',
                    qualifications: item['qualifications']?.toString() ?? '',
                    contact_info: item['contact_info']?.toString() ?? '',
                     pet_category:item['pet_category']?.toString() ?? '',
                     vaccinationType: item['vaccinationType']?.toString() ?? '',
                     breed: item['breed']?.toString() ?? '',
                     
                     dimensions:int.tryParse(item['dimensions']?.toString() ?? '0'),
                     hobby_category:item['hobby_category']?.toString() ?? '',
                     fashion_category: item['fashion_category']?.toString() ?? '',
                     size: item['size']?.toString() ?? '',


                    
                    

                  
                  ))
              .toList();

          setState(() {
            posts.addAll(newPosts);
            currentPage++;
            hasMore = newPosts.length == 50;
          });

          log('Loaded ${newPosts.length} new posts');
        } else {
          setState(() {
            hasMore = false;
          });
          log('No data in response or invalid format');
        }
      }
    } catch (e, stackTrace) {
      log('Error fetching posts: $e');
      log('Stack trace: $stackTrace');
      setState(() {
        hasMore = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
                title: Text('${widget.category} - ${widget.subCategory}'),
                actions: [
                  GetBuilder<CartController>(builder: (cartController) {
                    return Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          child: IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (builder) =>
                                        const FavouriteScreen()));
                              },
                              icon: Icon(
                                size: 30,
                                Icons.favorite_rounded,
                                color: cartController.favouriteIds.isNotEmpty
                                    ? Colors.pink
                                    : Color.fromARGB(255, 141, 138, 128),
                              )),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 15, left: 30),
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor:
                                const Color.fromARGB(255, 81, 7, 255),
                            child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(2),
                                margin: const EdgeInsets.all(1),
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                child: Text(
                                    "${cartController.favouriteIds.length}")),
                          ),
                        )
                      ],
                    );
                  })
                ],
                elevation: 0,

                backgroundColor: Colors
                    .transparent, // Make it transparent to avoid double background
              ),
            ],
          ),
        ),
      ),
      // appBar: AppBar(
      //   title: Text('${widget.category} - ${widget.subCategory}'),
      //   actions: [
      //     GetBuilder<CartController>(builder: (cartController) {
      //       return Stack(
      //         children: [
      //           Container(
      //             margin: EdgeInsets.only(top: 15),
      //             child: IconButton(
      //                 onPressed: () {
      //                   Navigator.of(context).push(MaterialPageRoute(
      //                       builder: (builder) => const FavouriteScreen()));
      //                 },
      //                 icon: Icon(
      //                   size: 30,
      //                   Icons.favorite_rounded,
      //                   color: cartController.favouriteIds.isNotEmpty
      //                       ? Colors.pink
      //                       : Color.fromARGB(255, 141, 138, 128),
      //                 )),
      //           ),
      //           Container(
      //             margin: EdgeInsets.only(top: 15, left: 30),
      //             child: CircleAvatar(
      //               radius: 12,
      //               backgroundColor: const Color.fromARGB(255, 81, 7, 255),
      //               child: Container(
      //                   alignment: Alignment.center,
      //                   padding: const EdgeInsets.all(2),
      //                   margin: const EdgeInsets.all(1),
      //                   decoration: const BoxDecoration(
      //                       shape: BoxShape.circle, color: Colors.white),
      //                   child: Text("${cartController.favouriteIds.length}")),
      //             ),
      //           )
      //         ],
      //       );
      //     })
      //   ],
      // ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            posts.clear();
            currentPage = 0;
            hasMore = true;
          });
          await fetchPosts();
        },
        child: posts.isEmpty && !isLoading
            ? Center(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: 1.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withAlpha(51),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.search_off_rounded,
                          size: 64,
                          color: Colors.blue[300],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'No Posts Found',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'We couldn\'t find any posts matching your search criteria',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            height: 1.5,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text(
                          'Go Back',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              )

            // child: posts.isEmpty && !isLoading
            //     ? const Center(
            //         child: Text('No posts found'),
            //       )
            : LayoutBuilder(
                builder: (context, constraints) {
                  return GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: constraints.maxWidth > 600 ? 3 : 2,
                      //  mainAxisExtent: constraints.maxWidth > 600 ? 400 : 300,
                      childAspectRatio: constraints.maxWidth > 600 ? 0.9 : 0.7,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1,
                    ),
                    itemCount: posts.length + (isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == posts.length) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      final post = posts[index];
                      return ProductDetailsScreen(productModel: post);
                    },
                  );
                },
              ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel productModel;

  const ProductDetailsScreen({
    super.key,
    required this.productModel,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final CartController cartController = Get.find<CartController>();
  String _formatDateTime(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return 'Recently'; // Default text if date is null or empty
    }

    try {
      final DateTime dateTime = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays == 0) {
        if (difference.inHours == 0) {
          if (difference.inMinutes == 0) {
            return 'Just now';
          }
          return '${difference.inMinutes} minutes ago';
        }
        return '${difference.inHours} hours ago';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      }
    } catch (e) {
      return 'Recently'; // Return default text if date parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    // log('Product ID in details: ${widget.productModel.id}');
    // log('Building product card with ID: ${widget.productModel.id}');
    // log('Assets: ${widget.productModel.assets}');
    // log('Image URL: ${widget.productModel.getFirstImageUrl()}');
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      ProductDetails(productModel: widget.productModel),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image Container with Stack for Featured Badge
                Stack(
                  children: [
                    // Image Container
                    Container(
                      padding: const EdgeInsets.all(0),
                      height: 130,
                      width: double.infinity,
                      child: Builder(
                        builder: (context) {
                          final imageUrl =
                              widget.productModel.getFirstImageUrl();
                          log('Attempting to load image URL: $imageUrl');
                          // Log the timestamp values for debugging
                          log('Featured at: ${widget.productModel.featured_at}');
                          log('Valid till: ${widget.productModel.valid_till}');

                          return Stack(
                            children: [
                              // Image
                              imageUrl.isNotEmpty
                                  ? Image.network(
                                      imageUrl,
                                      fit: BoxFit.fill,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        log('Error loading image: $error');
                                        return const Center(
                                          child: Icon(
                                            Icons.error_outline,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                        );
                                      },
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                    )
                                  : const Center(
                                      child: Icon(
                                        Icons.image_not_supported,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                    ),

                              // Featured Badge
                              if (widget.productModel.featured_at?.isNotEmpty ==
                                  true)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF6A1B9A), // Deep Purple
                                        Color(0xFFE91E63), // Pink
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    "FEATURED",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color.fromARGB(255, 242, 244, 246),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),

                Flexible(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.only(left: 9, right: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (widget.productModel.title ?? 'No Title')
                              .toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  // Color(0xFF046368),
                                  Color.fromARGB(255, 97, 76, 181),
                                  Color.fromARGB(255, 97, 76, 181),
                                ], // Stylish gradient
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(
                                  12), // Smooth rounded edges
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.15), // Soft shadow effect
                                  blurRadius: 6,
                                  offset: Offset(2, 4),
                                ),
                              ],
                            ),
                            child:
                                //  Text(
                                //   "₹ ${productModel.price.toString()}",
                                //   style: const TextStyle(
                                //     color: Colors
                                //         .white, // White text for contrast
                                //     fontSize: 15,
                                //     fontWeight: FontWeight.bold,
                                //     fontFamily: 'Poppins',
                                //     fontStyle: FontStyle.normal,
                                //     letterSpacing:
                                //         0.8, // Slight spacing for elegance
                                //   ),
                                //   overflow: TextOverflow.ellipsis,
                                // ),

                                Text(
                              widget.productModel.price != null
                                  ? '₹${NumberFormat('#,##0', 'en_IN').format(widget.productModel.price)}'
                                  : 'N/A',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 1.2,
                                fontFamily: 'Poppins',
                                fontStyle: FontStyle.normal,
                              ),
                              overflow: TextOverflow.ellipsis,
                            )),

                        // Text(
                        //   '₹ ${widget.productModel.price ?? 'N/A'}',
                        //   style: const TextStyle(
                        //     color: Color.fromARGB(255, 243, 6, 176),
                        //     fontWeight: FontWeight.bold,
                        //     fontSize: 14,
                        //   ),
                        //   overflow: TextOverflow.ellipsis,
                        // ),
                        const SizedBox(
                          height: 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.location_on, size: 18),
                            Expanded(
                              child: Text(
                                '${widget.productModel.location ?? ''}, ${widget.productModel.city ?? ''}, ${widget.productModel.state ?? ''}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 16),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                _formatDateTime(
                                    widget.productModel.publishedAt),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 14, 3, 3),
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 203, 203, 189),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white,
                  width: 3.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.5 * 255).round()),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: GetBuilder<CartController>(
                builder: (cartController) => TweenAnimationBuilder(
                  duration: Duration(milliseconds: 100),
                  tween: Tween<double>(
                    begin: 0,
                    end: cartController
                            .isFavourite(widget.productModel.id.toString())
                        ? 1
                        : 0,
                  ),
                  builder: (context, double value, _) {
                    return IconButton(
                      onPressed: () {
                        if (cartController
                            .isFavourite(widget.productModel.id.toString())) {
                          cartController.removeFromFavourite(
                            context,
                            widget.productModel.id.toString(),
                          );
                        } else {
                          cartController.addToFavourite(
                            context,
                            widget.productModel.id.toString(),
                          );
                        }
                      },
                      icon: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (cartController
                              .isFavourite(widget.productModel.id.toString()))
                            ...List.generate(
                              5,
                              (index) => AnimatedOpacity(
                                duration: const Duration(milliseconds: 100),
                                opacity: value,
                                child: Transform.scale(
                                  scale: 1 + (index * 0.2) * value,
                                  child: Transform.rotate(
                                    angle: (index * 0.0) * value * 0.10,
                                    child: Icon(
                                      Icons.favorite,
                                      color: HSLColor.fromAHSL(
                                        1.0,
                                        (index * 10.0 * value) % 20,
                                        0.8,
                                        0.5 + (value * 0.3),
                                      )
                                          .toColor()
                                          .withOpacity(1 - (index * 0.15)),
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                              // ignore: unnecessary_to_list_in_spreads
                            ).toList(),
                          if (cartController
                              .isFavourite(widget.productModel.id.toString()))
                            ...List.generate(
                              6,
                              (index) => TweenAnimationBuilder(
                                tween: Tween(begin: 0.0, end: 1.0),
                                duration:
                                    Duration(milliseconds: 1000 + index * 200),
                                curve: Curves.easeInExpo,
                                builder: (context, value, child) {
                                  return Transform.translate(
                                    offset: Offset(
                                      sin(value * pi * 2) * 15,
                                      -value * 50,
                                    ),
                                    child: Opacity(
                                      opacity: 1 - value,
                                      child: Transform.scale(
                                        scale: 1 - value * 0.5,
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                    255, 246, 3, 226)
                                                .withOpacity(0.9),
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.white
                                                    .withOpacity(0.4),
                                                blurRadius: 10,
                                                spreadRadius: 2,
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
                            color: TweenSequence<Color?>([
                              TweenSequenceItem(
                                weight: 1.0,
                                tween: ColorTween(
                                  begin: Colors.grey,
                                  end: const Color.fromARGB(255, 205, 4, 241),
                                ),
                              ),
                              TweenSequenceItem(
                                weight: 1.0,
                                tween: ColorTween(
                                  begin: const Color.fromARGB(255, 213, 4, 250),
                                  end: const Color.fromARGB(255, 6, 82, 157),
                                ),
                              ),
                              TweenSequenceItem(
                                weight: 1.0,
                                tween: ColorTween(
                                  begin: Colors.blue,
                                  end: const Color.fromARGB(255, 160, 243, 7),
                                ),
                              ),
                              TweenSequenceItem(
                                weight: 1.0,
                                tween: ColorTween(
                                  begin: const Color.fromARGB(255, 247, 1, 112),
                                  end: const Color.fromARGB(255, 241, 2, 2),
                                ),
                              ),
                            ]).evaluate(AlwaysStoppedAnimation(value)),
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
        ],
      ),
    );
  }
}
