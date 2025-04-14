// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/models/product_model.dart';
import 'package:flutter_poc_v3/protected_screen.dart/invoice_billing_screen.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_poc_v3/controllers/location_controller.dart';
import 'package:flutter_poc_v3/controllers/products_controller.dart';
import 'package:flutter_poc_v3/controllers/cart_controller.dart';
import 'package:flutter_poc_v3/protected_screen.dart/favourite_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/product_details.dart';
import 'dart:math' show sin, cos, pi;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResponsiveProductsScreen extends StatefulWidget {
  static final globalKey = GlobalKey<_ResponsiveProductsScreenState>();

  ResponsiveProductsScreen({Key? key}) : super(key: globalKey);

  @override
  State<ResponsiveProductsScreen> createState() =>
      _ResponsiveProductsScreenState();
}

class _ResponsiveProductsScreenState extends State<ResponsiveProductsScreen> {
  final ProductsController productsController = Get.put(ProductsController());
  final LocationController locationController = Get.find<LocationController>();
  CartController cartController = Get.put(CartController());
  ScrollController _scrollController = ScrollController();
  List<ProductModel> productModelList = [];

  bool isLoadingMore = false;
  int currentPage = 0;
  final int pageSize = 50;
  bool hasMoreData = true;
  String city = '';
  String state = '';
  bool _isInitialized = false;

  late Worker _locationWorker;
  late Worker _refreshWorker;
  @override
  void initState() {
    super.initState();
    _loadInitialData();
    verifyLocationAndProducts();

    // Load initial products
    refreshProductsAfterRegistration();
    _scrollController = ScrollController();
    productsController.productModelList.clear();

// Initial load only if not already initialized
    if (!_isInitialized) {
      productsController.productModelList.clear();
      loadProductsForLocation();
      _isInitialized = true;
    }

    // Add this worker to listen for location changes
    ever(locationController.shouldRefreshProducts, (shouldRefresh) {
      if (shouldRefresh && mounted) {
        _loadProductsForLocation(locationController.currentCity.value,
            locationController.currentState.value);
        locationController.shouldRefreshProducts.value = false;
      }
    });

    _locationWorker =
        ever(locationController.shouldRefreshProducts, (shouldRefresh) {
      if (mounted && shouldRefresh) {
        refreshProducts();
        locationController.shouldRefreshProducts.value =
            false; // Reset the flag
      }
    });

    // Listen for refresh triggers
    _refreshWorker =
        ever(locationController.shouldRefreshProducts, (shouldRefresh) {
      if (mounted && shouldRefresh) {
        refreshProducts();
        locationController.shouldRefreshProducts.value =
            false; // Reset the flag
      }
    });

    // // Add this to show the subscription dialog
    // Future.delayed(const Duration(milliseconds: 100), () {
    //   if (mounted) {
    //     showSubscriptionDialog(context);
    //   }
    // });

    _scrollController.addListener(_scrollListener);
  }

// Add this helper function at the top of your file
  String? formatSalary(dynamic salary) {
    if (salary == null || salary.toString().isEmpty) return null;
    try {
      double salaryValue = 0.0;
      if (salary is int) {
        salaryValue = salary.toDouble();
      } else if (salary is String && salary.isNotEmpty) {
        salaryValue = double.tryParse(salary) ?? 0.0;
      } else if (salary is double) {
        salaryValue = salary;
      }

      if (salaryValue >= 100000) {
        return '₹${(salaryValue / 100000).toStringAsFixed(2)} LPA';
      } else {
        return '₹${NumberFormat('#,##0', 'en_IN').format(salaryValue)}';
      }
    } catch (e) {
      log('Error formatting salary: $e');
      return null;
    }
  }

// Function to show the subscription dialog
  void showSubscriptionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: backgroundColor,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Center(
                      child: Text(
                        'Subscription Packages',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: primaryColor),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.grey, height: 20),
                SizedBox(
                  height: 400,
                  child: ListView(
                    children: [
                      _buildPackageCard(
                        context,
                        'Free',
                        '₹0',
                        '1 Month',
                        [
                          '1 Post',
                          '2 Image Attachments',
                          'Basic Features',
                          'No Contacts',
                        ],
                        false,
                      ),
                      const SizedBox(height: 10),
                      _buildPackageCard(
                        context,
                        'Silver',
                        '₹1000',
                        '3 Months',
                        [
                          '6 Posts',
                          '4 Image Attachments',
                          'Manual boost every 15 days',
                          '5 Contacts',
                        ],
                        true,
                      ),
                      const SizedBox(height: 10),
                      _buildPackageCard(
                        context,
                        'Gold',
                        '₹1200',
                        '6 Months',
                        [
                          '12 Posts',
                          '4 Image Attachments',
                          '1 Video Attachment',
                          'Manual boost every 3 days',
                          '12 Contacts',
                        ],
                        false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

// Helper method to build package cards
  Widget _buildPackageCard(
    BuildContext context,
    String title,
    String price,
    String validity,
    List<String> features,
    bool isPopular,
  ) {
    return Card(
      color: isPopular ? const Color(0xFFFFF3E0) : Colors.white,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                if (isPopular)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'BEST VALUE',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AnimatedPrice(price: price),
                const SizedBox(width: 5),
                Text(
                  '/ $validity',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            ...features.map(
              (feature) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feature,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            AnimatedSubscribeButton(
              onPressed: () {
                // Replace with your navigation logic, e.g., InvoiceBillingScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InvoiceBillingScreen(),
                  ),
                );
              },
              isPopular: isPopular,
            ),
          ],
        ),
      ),
    );
  }

// Add this method to load products based on location
  Future<void> _loadProductsForLocation(String city, String state) async {
    if (city.isEmpty || state.isEmpty) return;

    try {
      final response = await http.get(
        Uri.parse('http://13.200.179.78/adposts?city=$city&state=$state'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 && mounted) {
        final dynamic responseData = json.decode(response.body);
        final List<dynamic> newAdPosts = responseData['data'] ?? [];

        setState(() {
          productsController.productModelList.clear(); // Clear old products
          for (var post in newAdPosts) {
            productsController.productModelList
                .add(ProductModel.fromJson(post));
          }
        });
      } else if (response.statusCode == 401) {
        log('Error: Token expired. Please log in again.');
      }
    } catch (e) {
      log('Error loading products: $e');
    }
  }

// Add this method to handle location updates
  void updateProductsForLocation(String city, String state) async {
    try {
      final response = await http.get(
        Uri.parse('http://13.200.179.78/adposts?city=$city&state=$state'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 && mounted) {
        final dynamic responseData = json.decode(response.body);
        final List<dynamic> newAdPosts =
            responseData is List ? responseData : responseData['data'] ?? [];

        setState(() {
          productsController.productModelList.clear();
          for (var post in newAdPosts) {
            productsController.productModelList
                .add(ProductModel.fromJson(post));
          }
        });
      }
    } catch (e) {
      log('Error updating products: $e');
    }
  }

// In responsive_products_screen.dart
  Future<void> _loadInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    String city = prefs.getString('city') ?? '';
    String state = prefs.getString('state') ?? '';

    if (city.isNotEmpty && state.isNotEmpty) {
      try {
        final response = await http.get(
          Uri.parse('http://13.200.179.78/adposts?city=$city&state=$state'),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200 && mounted) {
          final dynamic responseData = json.decode(response.body);
          final List<dynamic> newAdPosts = responseData['data'] ?? [];

          setState(() {
            // Clear existing products and add new ones
            productsController.productModelList.clear();
            for (var post in newAdPosts) {
              productsController.productModelList
                  .add(ProductModel.fromJson(post));
            }
          });
        }
      } catch (e) {
        log('Error loading initial ads: $e');
      }
    }
  }

  Future<void> verifyLocationAndProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final city = prefs.getString('city');
    final state = prefs.getString('state');
    log('ResponsiveProductsScreen - Loaded location: city: $city, state: $state');

    // Your existing products loading logic
  }

// Example of how to use manual location selection
  onLocationSelected(String city, String state) {
    updateManualLocation(city, state);
  }

  @override
  void dispose() {
    _locationWorker.dispose(); // Dispose the worker
    _refreshWorker.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  // Add this refresh method
  Future<void> refreshProducts() async {
    if (!mounted) return;

    // Only refresh if it's not a manual selection
    if (!locationController.isManualSelection.value) {
      setState(() {
        currentPage = 0;
        hasMoreData = true;
        productsController.productModelList.clear();
      });
      await loadProductsForLocation();
    }
  }

  void refreshData() {
    setState(() {
      currentPage = 0;
      hasMoreData = true;
      productsController.productModelList.clear();
    });
    loadMoreData();
  }

  void _scrollListener() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !isLoadingMore &&
        hasMoreData) {
      loadProductsForLocation();
    }
  }

  // Add this method in _ResponsiveProductsScreenState class
  Future<void> refreshProductsAfterRegistration() async {
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final city = prefs.getString('city') ?? '';
    final state = prefs.getString('state') ?? '';

    try {
      final response = await http.get(
        Uri.parse('http://13.200.179.78/adposts?city=$city&state=$state'),
      );

      if (response.statusCode == 200 && mounted) {
        final productsController = Get.find<ProductsController>();
        productsController.updateProducts(response.body);
        setState(() {}); // Refresh UI
      }
    } catch (e) {
      log('Error refreshing products: $e');
    }
  }

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

// Add method for manual location update
  void updateManualLocation(String city, String state) {
    locationController.setManualLocation(city, state);
    setState(() {
      currentPage = 0;
      hasMoreData = true;
      productsController.productModelList.clear();
    });
    loadProductsForLocation();
  }

  Future<void> loadProductsForLocation() async {
    if (isLoadingMore || !mounted) return;

    try {
      setState(() {
        isLoadingMore = true;
      });

      final city = locationController.currentCity.value;
      final state = locationController.currentState.value;

      if (city.isEmpty || state.isEmpty) return;

      final url =
          "http://13.200.179.78/adposts?page=$currentPage&psize=$pageSize&city=$city&state=$state";

      final response = await http.get(Uri.parse(url));

      if (!mounted) return; // Check mounted again after async operation

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> adposts = responseData['data'] ?? [];
        final pagination = responseData['pagination'];

        setState(() {
          if (currentPage == 0) {
            productsController.productModelList.clear();
          }

          for (var post in adposts) {
            try {
              productsController.productModelList
                  .add(ProductModel.fromJson(post));
            } catch (e) {
              log('Error processing product: $e');
            }
          }

          hasMoreData =
              pagination['currentPage'] < pagination['totalPages'] - 1;
          if (adposts.isNotEmpty) {
            currentPage++;
          }
          isLoadingMore = false;
        });
      }
    } catch (e) {
      log('Error loading products: $e');
      if (mounted) {
        setState(() {
          isLoadingMore = false;
        });
      }
    }
  }

  static const primaryColor = Color.fromARGB(255, 240, 107, 31);
  static const backgroundColor = Color(0xFFF5F5F5);
  static const textColor = Colors.black87;

  Future<void> loadMoreData() async {
    if (isLoadingMore || !hasMoreData) return;

    try {
      setState(() {
        isLoadingMore = true;
      });

      final String baseUrl = 'http://13.200.179.78/adposts';
      final String city = locationController.city.value;
      final String state = locationController.state.value;

      // Construct URL with pagination parameters
      final url = Uri.parse(
          '$baseUrl?city=$city&state=$state&page=$currentPage&psize=$pageSize');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> newProducts = responseData['data'] ?? [];
        final pagination = responseData['pagination'];

        setState(() {
          // Clear existing products if it's first page
          if (currentPage == 0) {
            productsController.productModelList.clear();
          }

          // Add new products
          for (var item in newProducts) {
            productsController.productModelList
                .add(ProductModel.fromJson(item));
          }

          // Update pagination state
          hasMoreData = pagination['matchingCount'] >
              (currentPage + 1) * pagination['pageSize'];

          if (newProducts.isNotEmpty) {
            currentPage++;
          }
        });
      }
    } catch (e) {
      log('Error loading more data: $e');
    } finally {
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(top: 5),
            child: Text(
              "Updated Ads",
              style: GoogleFonts.tenorSans(
                textStyle: TextStyle(
                    color: const Color.fromARGB(255, 4, 25, 18),
                    letterSpacing: .1),
                fontSize: 15,
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.normal,
              ),
            )),
        actions: [
          Stack(
            clipBehavior: Clip.none, // Allows children to overflow
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 2 * pi),
                duration: const Duration(seconds: 1),
                builder: (context, value, child) {
                  return Transform.rotate(
                    angle: value,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: SweepGradient(
                          colors: const [
                            Color(0xFFFF6B6B),
                            Color(0xFF4ECDC4),
                            Color(0xFFFFBE0B),
                            Color(0xFF7400B8),
                            Color(0xFFFF6B6B),
                          ],
                          stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                          transform: GradientRotation(value),
                        ),
                      ),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.card_membership,
                      color: Color.fromARGB(255, 4, 74, 50),
                      size: 28,
                    ),
                    onPressed: () => showSubscriptionDialog(context),
                  ),
                ),
              ),
              Positioned(
                top: 6,
                right: 55,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.black87, Colors.black54],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Silver Text Animation
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: const Duration(seconds: 1),
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: 0.8 + (value * 0.2),
                            child: ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                colors: [
                                  Colors.grey.shade300,
                                  Colors.white,
                                  Colors.grey.shade300,
                                ],
                                stops: [0.0, value, 1.0],
                              ).createShader(bounds),
                              child: Text(
                                'Silver',
                                style: GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: value * 1.5,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const Text(
                        ' • ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      // Gold Text Animation
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: const Duration(seconds: 2),
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: 1.0 + (sin(value * pi * 2) * 0.1),
                            child: ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                colors: const [
                                  Color(0xFFFFD700),
                                  Color(0xFFFFC000),
                                  Color(0xFFFFD700),
                                ],
                                stops: [0.0, value, 1.0],
                              ).createShader(bounds),
                              child: Text(
                                'Gold',
                                style: GoogleFonts.cinzelDecorative(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: value * 1.5,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          GetBuilder<CartController>(builder: (cartController) {
            return Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (builder) => const FavouriteScreen()));
                      },
                      icon: Icon(
                        Icons.favorite_rounded,
                        size: 30,
                        color: cartController.favouriteIds.isNotEmpty
                            ? const Color.fromARGB(255, 243, 3, 3)
                            : const Color.fromARGB(255, 141, 138, 128),
                      )),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15, left: 30),
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: const Color.fromARGB(255, 250, 252, 250),
                    child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(2),
                        margin: const EdgeInsets.all(1),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: Text("${cartController.favouriteIds.length}")),
                  ),
                )
              ],
            );
          })
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'SHOWING ADS IN: ${locationController.currentCity.value.toUpperCase()}, ${locationController.currentState.value.toUpperCase()}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          Expanded(
            child: GetBuilder<ProductsController>(
              builder: (controller) {
                if (controller.productModelList.isEmpty && isLoadingMore) {
                  return const Center(child: CircularProgressIndicator());
                }
                return GridView.builder(
                  controller: _scrollController,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: size.width > 1368
                          ? 6
                          : size.width > 767
                              ? 4
                              : 2,
                      childAspectRatio: size.width > 1368
                          ? 0.8
                          : size.width > 767
                              ? 2.0
                              : 0.8,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1),
                  itemCount: controller.productModelList.length,
                  itemBuilder: (context, index) {
                    final ProductModel productModel =
                        productsController.productModelList[index];

                    final product = controller.productModelList[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) =>
                                    ProductDetails(productModel: product)));
                      },
                      child: Card(
                        elevation: 2,
                        // color: const Color.fromARGB(255, 245, 242, 242),
                        color: const Color.fromARGB(255, 246, 248, 246),

                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        margin: const EdgeInsets.all(2),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: SizedBox(
                                height: 120,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Stack(
                                        children: [
                                          product.thumbnailUrl.isNotEmpty
                                              ? Image.network(
                                                  'http://13.200.179.78/${product.thumbnailUrl}',
                                                  height: 300,
                                                  width: double.infinity,
                                                  fit: BoxFit.fill,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Container(
                                                      height: 200,
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 245, 242, 242),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: const Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .image_not_supported_outlined,
                                                            size: 50,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    123,
                                                                    74,
                                                                    74),
                                                          ),
                                                          SizedBox(height: 8),
                                                          Text(
                                                            'Image not available',
                                                            style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      123,
                                                                      74,
                                                                      74),
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                )
                                              : Container(
                                                  height: 200,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        255, 245, 242, 242),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: const Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .image_not_supported_outlined,
                                                        size: 50,
                                                        color: Color.fromARGB(
                                                            255, 123, 74, 74),
                                                      ),
                                                      SizedBox(height: 8),
                                                      Text(
                                                        'Image not available',
                                                        style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 123, 74, 74),
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          Builder(
                                            builder: (context) {
                                              // More detailed debug prints
                                              // log('Raw product data: ${jsonEncode(product.toJson())}'); // Add toJson() method if not exists
                                              // log('Featured at: ${product.featured_at}');
                                              // log('Valid till: ${product.valid_till}');
                                              // log('Current time: ${DateTime.now().millisecondsSinceEpoch ~/ 1000}');

                                              // Simplified featured check
                                              bool isFeatured = false;
                                              if (product.featured_at != null &&
                                                  product.valid_till != null) {
                                                final now = DateTime.now()
                                                        .millisecondsSinceEpoch ~/
                                                    1000;
                                                isFeatured = product
                                                            .featured_at! <=
                                                        now &&
                                                    product.valid_till! >= now;
                                                // log('Time check: $now is between ${product.featured_at} and ${product.valid_till}');
                                              }

                                              // log('Is Featured: $isFeatured');

                                              if (!isFeatured) {
                                                return const SizedBox.shrink();
                                              }

                                              return Positioned(
                                                top: 10,
                                                left: 10,
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    gradient:
                                                        const LinearGradient(
                                                      colors: [
                                                        Color.fromARGB(
                                                            255,
                                                            255,
                                                            221,
                                                            2), // Deep Purple
                                                        Color.fromARGB(255, 255,
                                                            221, 2), // Pink
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: const Color
                                                                .fromARGB(255,
                                                                252, 250, 250)
                                                            .withAlpha(
                                                                77), // 0.3 * 255 ≈ 77

                                                        blurRadius: 4,
                                                        offset:
                                                            const Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize
                                                        .min, // To keep the container tight
                                                    children: [
                                                      const Icon(
                                                        Icons
                                                            .check_circle, // Tick mark icon
                                                        size:
                                                            16, // Small icon size
                                                        color: Color.fromARGB(
                                                            255,
                                                            251,
                                                            250,
                                                            246), // Same color as text
                                                      ),
                                                      const SizedBox(
                                                          width:
                                                              4), // Space between icon and text
                                                      Text(
                                                        'FEATURED',
                                                        style:
                                                            GoogleFonts.roboto(
                                                          color:
                                                              Color(0xFFFAFAFA),
                                                          // color: Color.fromARGB(
                                                          //     255,
                                                          //     251,
                                                          //     250,
                                                          //     246),
                                                          // color: Color.fromARGB(255, 173, 179, 1),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12,
                                                          letterSpacing: 0.5,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),

                                    Positioned(
                                      top: 8,
                                      right: 5,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 254, 254, 253),
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1, // Thick white border
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withAlpha(
                                                  (0.1 * 255).round()),
                                              blurRadius: 2,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),
                                        child: TweenAnimationBuilder(
                                          duration:
                                              Duration(milliseconds: 1000),
                                          tween: Tween<double>(
                                            begin: 0,
                                            end: cartController.isFavourite(
                                                    productModel.id.toString())
                                                ? 1
                                                : 0,
                                          ),
                                          builder: (context, double value, _) {
                                            return IconButton(
                                                onPressed: () {
                                                  if (cartController
                                                      .isFavourite(productModel
                                                          .id
                                                          .toString())) {
                                                    cartController
                                                        .removeFromFavourite(
                                                            context,
                                                            productModel.id
                                                                .toString());
                                                  } else {
                                                    cartController.addToFavourite(
                                                        context,
                                                        productModel.id
                                                            .toString(),
                                                        screenName:
                                                            'responsive_products_screen' // Add this parameter
                                                        );
                                                  }
                                                },
                                                icon: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    if (cartController
                                                        .isFavourite(
                                                            productModel.id
                                                                .toString()))
                                                      ...List.generate(
                                                        5,
                                                        (index) =>
                                                            AnimatedOpacity(
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      100),
                                                          opacity: value,
                                                          child:
                                                              Transform.scale(
                                                            scale: 1 +
                                                                (index * 0.2) *
                                                                    value,
                                                            child: Transform
                                                                .rotate(
                                                              angle: (index *
                                                                      0.0) *
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
                                                                    .withOpacity(1 -
                                                                        (index *
                                                                            0.15)),
                                                                size: 20,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        // ignore: unnecessary_to_list_in_spreads
                                                      ).toList(),
                                                    // Bubble floating animation
                                                    if (cartController
                                                        .isFavourite(
                                                            productModel.id
                                                                .toString()))
                                                      ...List.generate(
                                                        6,
                                                        (index) =>
                                                            TweenAnimationBuilder(
                                                          tween: Tween(
                                                              begin: 0.0,
                                                              end: 1.0),
                                                          duration: Duration(
                                                              milliseconds:
                                                                  100 +
                                                                      index *
                                                                          200),
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
                                                                    15, // Horizontal sway
                                                                -value *
                                                                    50, // Vertical movement
                                                              ),
                                                              child: Opacity(
                                                                opacity:
                                                                    1 - value,
                                                                child: Transform
                                                                    .scale(
                                                                  scale: 1 -
                                                                      value *
                                                                          0.5,
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
                                                                          .withOpacity(
                                                                              0.9),
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: Colors
                                                                              .white
                                                                              .withOpacity(0.4),
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
                                                                .fromARGB(255,
                                                                205, 4, 241),
                                                          ),
                                                        ),
                                                        TweenSequenceItem(
                                                          weight: 1.0,
                                                          tween: ColorTween(
                                                            begin: const Color
                                                                .fromARGB(255,
                                                                213, 4, 250),
                                                            end: const Color
                                                                .fromARGB(255,
                                                                6, 82, 157),
                                                          ),
                                                        ),
                                                        TweenSequenceItem(
                                                          weight: 1.0,
                                                          tween: ColorTween(
                                                            begin: Colors.blue,
                                                            end: const Color
                                                                .fromARGB(255,
                                                                160, 243, 7),
                                                          ),
                                                        ),
                                                        TweenSequenceItem(
                                                          weight: 1.0,
                                                          tween: ColorTween(
                                                            begin: const Color
                                                                .fromARGB(255,
                                                                247, 1, 112),
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
                                                ));
                                          },
                                        ),
                                      ),
                                    ),
                                    // Favorite button and other UI elements...
                                  ],
                                ),
                              ),
                            ),
                            // Product details...
                            SizedBox(height: 0),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 3,
                                  vertical: 3), // Reduced padding
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                 mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6, horizontal: 6),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            // Color(0xFF046368),
                                            Color.fromARGB(255, 254, 255, 254),
                                            Color.fromARGB(255, 254, 255, 254),
                                          ], // Stylish gradient
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            12), // Smooth rounded edges
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withAlpha(
                                                38), // 0.15 * 255 ≈ 38
                                            blurRadius: 6,
                                            offset: Offset(2, 4),
                                          ),
                                        ],
                                      ),
                                      // child: Text(
                                      //   productModel.price != null
                                      //       ? '₹${NumberFormat('#,##0', 'en_IN').format(productModel.price)}'
                                      //       : 'N/A',
                                      //   style: const TextStyle(
                                      //     fontSize: 15,
                                      //     fontWeight: FontWeight.w900,
                                      //     color: Colors.white,
                                      //     letterSpacing: 1.2,
                                      //     fontFamily: 'Poppins',
                                      //     fontStyle: FontStyle.normal,
                                      //   ),
                                      //   overflow: TextOverflow.ellipsis,
                                      // )
                                      // child: Text(
                                      //   productModel.price != null &&
                                      //           productModel.price != 0
                                      //       ? '₹${NumberFormat('#,##0', 'en_IN').format(productModel.price)}'
                                      //       : productModel.salary != null &&
                                      //               productModel
                                      //                   .salary != null && productModel.salary! > 0
                                      //           ? 'Salary: ${productModel.salary}'
                                      //           : productModel.category
                                      //                       ?.toLowerCase() ==
                                      //                   'jobs'
                                      //               ? 'Salary: Negotiable'
                                      //               : 'N/A',
                                      //   style: const TextStyle(
                                      //     fontSize: 15,
                                      //     fontWeight: FontWeight.w900,
                                      //     color: Colors.white,
                                      //     letterSpacing: 1.2,
                                      //     fontFamily: 'Poppins',
                                      //     fontStyle: FontStyle.normal,
                                      //   ),
                                      //   overflow: TextOverflow.ellipsis,
                                      // )
                                      
                                      child: Text(
                                        productModel.category?.toLowerCase() ==
                                                'jobs'
                                            ? 'Salary: ${formatSalary(productModel.salary) ?? 'N/A'}'
                                            : productModel.price != null &&
                                                    productModel.price != 0
                                                ? 'Price: ₹${NumberFormat('#,##0', 'en_IN').format(productModel.price)}'
                                                : productModel.category
                                                            ?.toLowerCase() ==
                                                        'jobs'
                                                    ? 'Salary: Negotiable'
                                                    : 'Price: N/A',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 7, 13, 6),
                                          letterSpacing: 1.2,
                                          // fontFamily: 'Poppins',
                                          fontStyle: FontStyle.normal,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      )
                                      ),
                                      SizedBox(height: 5,),
                                  Row(
                                    children: [
                                    
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      Expanded(
                                        child: Text(
                                          productModel.title
                                              .toString()
                                              .toUpperCase(),
                                          style: const TextStyle(
                                            color:
                                                Color.fromARGB(255, 12, 8, 8),
                                            // color: Color.fromARGB(255, 251, 38, 38),
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Poppins',
                                            overflow: TextOverflow.ellipsis,
                                            letterSpacing: 1,
                                          ),
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 2),
                            Container(
                              margin: EdgeInsets.all(2),
                              width: MediaQuery.of(context).size.width -
                                  32, // Subtract total horizontal paddin
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color.fromARGB(255, 6, 3, 0),
                                    ),
                                    child: const Icon(
                                      Icons.location_on_outlined,
                                      color: Color.fromARGB(255, 251, 248, 248),
                                      size: 16,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Flexible(
                                    flex: 0,
                                    child: Text(
                                      // productModel.location.toString(),
                                      "${productModel.location.toString()}, ",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1,
                                        fontFamily: GoogleFonts.abhayaLibre()
                                            .fontFamily,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Text(
                                      // productModel.city.toString(),
                                      "${productModel.city.toString()} ",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1,
                                        fontFamily: GoogleFonts.abhayaLibre()
                                            .fontFamily,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  // Flexible(
                                  //   flex: 2,
                                  //   child: Text(
                                  //     productModel.state.toString(),
                                  //     maxLines: 1,
                                  //     overflow: TextOverflow.ellipsis,
                                  //     style: TextStyle(
                                  //       color: Colors.black,
                                  //       fontWeight: FontWeight.w900,
                                  //       letterSpacing: 1,
                                  //       fontFamily: GoogleFonts.abhayaLibre()
                                  //           .fontFamily,
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 2),
                            // Update the Row widget after location
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Container(
                                //   decoration: BoxDecoration(
                                //     color:
                                //         const Color.fromARGB(255, 243, 127, 12),
                                //     shape: BoxShape.circle,
                                //   ),
                                //   margin: const EdgeInsets.only(left: 5),
                                //   child: const Icon(
                                //     Icons.access_time,
                                //     size: 20,
                                //     color: Color.fromARGB(255, 243, 240, 240),
                                //   ),
                                // ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    'Posted: ${_formatDateTime(productModel.publishedAt)}', // Remove DateTime.parse here
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 47, 46, 46),
                                      overflow: TextOverflow.ellipsis,
                                      letterSpacing: 1,
                                      fontFamily:
                                          GoogleFonts.abhayaLibre().fontFamily,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          if (productsController.hasMoreData)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: isLoadingMore
                    ? null
                    : () async {
                        await loadMoreData();
                      },
                child: isLoadingMore
                    ? const CircularProgressIndicator()
                    : const Text(
                        'Load More',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
              ),
            )
        ],
      ),
    );
  }
}

class _AnimatedBorderCard extends StatefulWidget {
  final Widget child;
  final bool isPopular;
  final Color baseColor;

  const _AnimatedBorderCard({
    required this.child,
    required this.isPopular,
    required this.baseColor,
  });

  @override
  _AnimatedBorderCardState createState() => _AnimatedBorderCardState();
}

class _AnimatedBorderCardState extends State<_AnimatedBorderCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: widget.isPopular
                ? LinearGradient(
                    colors: [
                      widget.baseColor,
                      widget.baseColor.withOpacity(0.5),
                      widget.baseColor.withOpacity(0.2),
                    ],
                    begin: Alignment(
                      cos(_controller.value * 2 * pi),
                      sin(_controller.value * 2 * pi),
                    ),
                    end: Alignment(
                      cos((_controller.value + 0.5) * 2 * pi),
                      sin((_controller.value + 0.5) * 2 * pi),
                    ),
                  )
                : null,
            color: widget.isPopular ? null : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.baseColor.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            margin: const EdgeInsets.all(2),
            child: widget.child,
          ),
        );
      },
    );
  }
}

class ShimmerText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const ShimmerText({
    super.key,
    required this.text,
    required this.style,
  });

  @override
  State<ShimmerText> createState() => _ShimmerTextState();
}

class _ShimmerTextState extends State<ShimmerText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: const [
              Colors.white24,
              Colors.white,
              Colors.white24,
            ],
            stops: [
              0.0,
              _controller.value,
              1.0,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            widget.text,
            style: widget.style,
          ),
        );
      },
    );
  }
}

// Animated Price Widget with blinking effect
class AnimatedPrice extends StatefulWidget {
  final String price;

  const AnimatedPrice({super.key, required this.price});

  @override
  _AnimatedPriceState createState() => _AnimatedPriceState();
}

class _AnimatedPriceState extends State<AnimatedPrice>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Text(
        widget.price,
        style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 136, 167, 1)),
      ),
    );
  }
}

// Animated Subscribe Button with press effect
class AnimatedSubscribeButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isPopular;

  const AnimatedSubscribeButton({
    super.key,
    required this.onPressed,
    this.isPopular = false,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AnimatedSubscribeButtonState createState() =>
      _AnimatedSubscribeButtonState();
}

class _AnimatedSubscribeButtonState extends State<AnimatedSubscribeButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: Transform.scale(
        scale: _isPressed ? 0.95 : 1.0,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: widget.isPopular
                ? LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 240, 107, 31),
                      const Color.fromARGB(255, 255, 140, 0)
                    ],
                  )
                : const LinearGradient(
                    colors: [Colors.blue, Colors.blueAccent],
                  ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Center(
            child: Text(
              'Subscribe Now',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
