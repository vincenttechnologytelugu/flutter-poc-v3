import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/controllers/cart_controller.dart';
import 'package:flutter_poc_v3/models/product_model.dart';
import 'package:flutter_poc_v3/protected_screen.dart/cart_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/product_details.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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

  Future<void> fetchPosts() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final encodedCategory =
          Uri.encodeComponent(widget.category.toLowerCase());
      final encodedSubCategory = Uri.encodeComponent(widget.subCategory);

      final url =
          'http://192.168.0.179:8080/adposts?category=$encodedCategory&page=$currentPage&psize=50&findkey=$encodedSubCategory';
      log('Fetching URL: $url');

      final response = await http.get(Uri.parse(url));
      log('Response Status: ${response.statusCode}');
      log('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null && data['data'] is List) {
          final List<dynamic> jsonList = data['data'];
          // final List<ProductModel> newPosts = jsonList
          //     .map((item) => ProductModel(
          //       icon: item['icon'],

          //           title: item['title']?.toString(),
          //           description: item['description']?.toString(),
          //           price: double.tryParse(item['price']?.toString() ?? '0'),
          //           location: item['location']?.toString(),
          //           city: item['city']?.toString(),
          //           category: item['category']?.toString(),
          //           thumb: item['thumb']?.toString(),
          //           posted_at: item['posted_at']?.toString(),
          //           brand: item['brand']?.toString(),
          //           warranty: item['warranty']?.toString(),
          //           condition: item['condition']?.toString(),
          //           // Real Estate
          //           bedrooms: item['bedrooms']?.toString(),
          //           bathrooms: item['bathrooms']?.toString(),
          //           area: item['area']?.toString(),
          //           furnishing: item['furnishing']?.toString(),
          //           // Vehicles
          //           year: int.tryParse(item['year']?.toString() ?? '0'),
          //           kilometers:
          //               int.tryParse(item['kilometers']?.toString() ?? '0'),
          //           fuelType: item['fuel_type']?.toString(),
          //           transmission: item['transmission']?.toString(),
          //           // Electronics
          //           model: item['model']?.toString(),
          //           storage: item['storage']?.toString(),
          //           ram: item['ram']?.toString(),
          //           // Furniture
          //           material: item['material']?.toString(),
          //           //  dimensions: item['dimensions']?.toString(),

          //         ))
          //     .toList();
          final List<ProductModel> newPosts = jsonList
              .map((item) => ProductModel(
                    icon: item['icon'] ??
                        '', // Add null check with default empty string
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
                    // Real Estate
                    bedrooms: item['bedrooms']?.toString() ?? '',
                    bathrooms: item['bathrooms']?.toString() ?? '',
                    area: item['area']?.toString() ?? '',
                    furnishing: item['furnishing']?.toString() ?? '',
                    // Vehicles
                    year: int.tryParse(item['year']?.toString() ?? '0'),
                    kilometers:
                        int.tryParse(item['kilometers']?.toString() ?? '0'),
                    fuelType: item['fuel_type']?.toString() ?? '',
                    transmission: item['transmission']?.toString() ?? '',
                    // Electronics
                    model: item['model']?.toString() ?? '',
                    storage: item['storage']?.toString() ?? '',
                    ram: item['ram']?.toString() ?? '',
                    // Furniture
                    material: item['material']?.toString() ?? '',
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
      log('Stack trace: $stackTrace'); // Added stack trace for better debugging
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
      appBar: AppBar(
        title: Text('${widget.category} - ${widget.subCategory}'),
        actions: [
          GetBuilder<CartController>(builder: (cartController) {
            return Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (builder) => const CartScreen()));
                      },
                      icon: const Icon(
                        size: 30,
                        Icons.favorite_rounded,
                      )),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5, left: 30),
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.amber,
                    child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(2),
                        margin: const EdgeInsets.all(1),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: Text("${cartController.cartList.length}")),
                  ),
                )
              ],
            );
          })
        ],
      ),
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
                      childAspectRatio: constraints.maxWidth > 600 ? 0.9 : 0.7,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemCount: posts.length + (isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == posts.length) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      final post = posts[index];
                      return ProductDetailsScreen(product: post);
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
  final ProductModel product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final cartController = Get.find<CartController>();
   String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return 'No date';
    }

    try {
      // First try parsing the date
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
    } catch (e) {
      // If parsing fails, return a default message
      return 'Invalid date';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      //  color:const Color.fromARGB(255, 126, 89, 87),
      elevation: 4,
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
                      ProductDetails(productModel: widget.product),
                ),
              );
              // Navigate to product details
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image

                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12), bottom: Radius.circular(12)),
                  child: widget.product.thumb != null &&
                          widget.product.thumb!.isNotEmpty
                      ? Image.network(
                          widget.product.thumb!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color.fromARGB(255, 235, 224, 232),
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 120,
                                  color: Color.fromARGB(255, 225, 97, 97),
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          color: const Color.fromARGB(255, 181, 75, 75),
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 120,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                ),

                Flexible(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.title ?? 'No Title',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '₹ ${widget.product.price ?? 'N/A'}',
                          style: const TextStyle(
                           color: Color.fromARGB(255, 243, 6, 176),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 18),
                            Expanded(
                              child: Text(
                                '${widget.product.city ?? ''}, ${widget.product.location ?? ''}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 4),
                              child: const Icon(
                                Icons.access_time,
                                size: 18,
                                color: Color.fromARGB(255, 9, 2, 2),
                              ),
                            ),
                            const SizedBox(width: 4),
                             Flexible(
                              child: Text(
                                formatDate(widget.product.posted_at),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 12, 0, 0),
                                ),
                              ),
                            ),
                            // Flexible(
                            //   child: Text(
                            //     widget.product.posted_at != null
                            //         ? DateFormat('dd MMM yyyy, hh:mm a').format(
                            //             DateTime.parse(
                            //                 widget.product.posted_at!))
                            //         : 'No date',
                            //     maxLines: 1,
                            //     overflow: TextOverflow.ellipsis,
                            //     style: const TextStyle(
                            //       fontSize: 14,
                            //       fontWeight: FontWeight.bold,
                            //       color: Color.fromARGB(255, 12, 0, 0),
                            //     ),
                            //   ),
                            // ),
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
            top: 2,
            right: 2,
            child: Container(
              decoration: BoxDecoration(
                color:  Colors.yellow,
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                onPressed: () {
                  cartController.addToCart(context, widget.product);
                },
                icon: const Icon(
                  Icons.favorite_border_outlined,
                  // Icons
                  //     .add_shopping_cart_outlined,
                  color: Colors.black,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
