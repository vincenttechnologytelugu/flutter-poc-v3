// import 'dart:convert';
// import 'dart:developer';
// import 'dart:math' show sin, pi;

// import 'package:flutter/material.dart';
// import 'package:flutter_poc_v3/controllers/location_controller.dart';
// import 'package:flutter_poc_v3/protected_screen.dart/favourite_screen.dart';

// // import 'package:flutter_poc_v3/protected_screen.dart/cart_screen.dart';
// import 'package:get/get.dart';
// import 'package:flutter_poc_v3/controllers/cart_controller.dart';
// import 'package:flutter_poc_v3/controllers/products_controller.dart';
// import 'package:flutter_poc_v3/models/product_model.dart';

// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';

// import 'product_details.dart';

// class ResponsiveProductsScreen extends StatefulWidget {
//   static final GlobalKey<_ResponsiveProductsScreenState> globalKey = GlobalKey();

//   // Remove the key from the constructor
//   const ResponsiveProductsScreen({Key? key}) : super(key: key);  // Changed this line

//   @override
//   State<ResponsiveProductsScreen> createState() => _ResponsiveProductsScreenState();
// }

// class _ResponsiveProductsScreenState extends State<ResponsiveProductsScreen> {

//  final locationController = Get.find<LocationController>();
//   final productsController = Get.find<ProductsController>();
//   CartController cartController = Get.put(CartController());
//   final ScrollController _scrollController = ScrollController();

//   bool initialLoadDone = false;
//   bool isLoadingMore = false;
//   int currentPage = 0;
//   final int pageSize = 50;
//   bool hasMoreData = true;

//   @override
//   void initState() {
//     super.initState();
//       // Initialize data when screen loads
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {
//         _initializeData();
//       }
//     });
//     // if (!initialLoadDone) {
//     //   _loadInitialProducts();
//     //   initialLoadDone = true;
//     // }

//     _scrollController.addListener(_scrollListener);

//     // Listen to location changes only when manual location is selected
//     ever(locationController.selectedCity, (_) {
//       if (mounted && locationController.isManualLocation.value) {
//         refreshData();
//       }
//     });
//   }
//     Future<void> _initializeData() async {
//     if (locationController.currentCity.value.isNotEmpty ||
//         locationController.currentState.value.isNotEmpty) {
//       await getData();
//     }
//   }

//   // void _loadInitialProducts() {
//   //   if (locationController.hasLocation) {
//   //     getData();
//   //   }
//   // }

//   void refreshData() {
//     setState(() {
//       productsController.productModelList.clear();
//       currentPage = 0;
//       hasMoreData = true;
//       isLoadingMore = false;
//     });
//     getData();
//   }

//     void _scrollListener() {
//     if (!_scrollController.hasClients) return;

//     final maxScroll = _scrollController.position.maxScrollExtent;
//     final currentScroll = _scrollController.position.pixels;

//     if (currentScroll >= maxScroll && !isLoadingMore && hasMoreData) {
//       getData();
//     }
//   }

//  Future<void> getData() async {
//   if (isLoadingMore) return;

//   setState(() {
//     isLoadingMore = true;
//   });

//   try {
//     String city = locationController.currentCity.value;
//     String state = locationController.currentState.value;

//     if (city.isEmpty && state.isEmpty) return;

//     String url = "http://13.200.179.78/adposts?page=$currentPage&psize=$pageSize";
//     if (city.isNotEmpty) url += "&city=$city";
//     if (state.isNotEmpty) url += "&state=$state";

//     final response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> jsonResponse = json.decode(response.body);

//       // Access the 'posts' array from the response
//       if (jsonResponse.containsKey('posts')) {
//         final List<dynamic> posts = jsonResponse['posts'] as List<dynamic>;

//         setState(() {
//           if (currentPage == 0) {
//             productsController.productModelList.clear();
//           }

//           for (var post in posts) {
//             final product = ProductModel(
//               id: post['_id'],
//               title: post['title'],
//               description: post['description'],
//               price: post['price'],
//               thumb: post['images']?[0] ?? '', // Assuming first image is thumb
//               city: post['city'],
//               state: post['state'],
//               icon:post['icon'],

//               // Add other fields as needed
//             );
//             productsController.productModelList.add(product);
//           }

//           hasMoreData = posts.length >= pageSize;
//           if (posts.isNotEmpty) {
//             currentPage++;
//           }
//         });
//       }
//     }
//   } catch (e) {
//     log('Error fetching products: $e');
//   } finally {
//     setState(() {
//       isLoadingMore = false;
//     });
//   }
// }

// bool _shouldAddProduct(dynamic item, String city, String state) {
//   String productCity = item['city']?.toString().toLowerCase() ?? '';
//   String productState = item['state']?.toString().toLowerCase() ?? '';

//   return productCity.contains(city.toLowerCase()) &&
//          productState.contains(state.toLowerCase());
// }

//   Future<void> loadMoreData() async {
//     if (!isLoadingMore && hasMoreData) {
//       setState(() {
//         isLoadingMore = true;
//       });

//       try {
//         final locationController = Get.find<LocationController>();
//         final selectedArea = locationController.selectedLocation.value;
//         final currentCity = locationController.selectedCity.value;
//         final currentState = locationController.selectedState.value;

//         // Build URL with proper sequence
//         String url =
//             "http://13.200.179.78/adposts?page=$currentPage&psize=$pageSize";

//         // Add parameters based on what's available
//         if (selectedArea.isNotEmpty) url += "&location=$selectedArea";
//         if (currentCity.isNotEmpty) url += "&city=$currentCity";
//         if (currentState.isNotEmpty) url += "&state=$currentState";

//         final response = await http.get(Uri.parse(url));

//         if (response.statusCode == 200) {
//           final Map<String, dynamic> responseData = json.decode(response.body);
//           final List<dynamic> newProducts = responseData['data'];

//           List<dynamic> matchedProducts = newProducts.where((product) {
//             String productArea =
//                 product['location']?.toString().toLowerCase() ?? '';
//             String productCity =
//                 product['city']?.toString().toLowerCase() ?? '';
//             String productState =
//                 product['state']?.toString().toLowerCase() ?? '';

//             bool matches = false;

//             // Check all three parameters
//             if (selectedArea.isNotEmpty &&
//                 currentCity.isNotEmpty &&
//                 currentState.isNotEmpty) {
//               matches = productArea.contains(selectedArea.toLowerCase()) &&
//                   productCity.contains(currentCity.toLowerCase()) &&
//                   productState.contains(currentState.toLowerCase());
//             }
//             // Check combinations of two parameters
//             else if (selectedArea.isNotEmpty && currentCity.isNotEmpty) {
//               matches = productArea.contains(selectedArea.toLowerCase()) &&
//                   productCity.contains(currentCity.toLowerCase());
//             } else if (selectedArea.isNotEmpty && currentState.isNotEmpty) {
//               matches = productArea.contains(selectedArea.toLowerCase()) &&
//                   productState.contains(currentState.toLowerCase());
//             } else if (currentCity.isNotEmpty && currentState.isNotEmpty) {
//               matches = productCity.contains(currentCity.toLowerCase()) &&
//                   productState.contains(currentState.toLowerCase());
//             }
//             // Check single parameters
//             else if (selectedArea.isNotEmpty) {
//               matches = productArea.contains(selectedArea.toLowerCase());
//             } else if (currentCity.isNotEmpty) {
//               matches = productCity.contains(currentCity.toLowerCase());
//             } else if (currentState.isNotEmpty) {
//               matches = productState.contains(currentState.toLowerCase());
//             }

//             return matches;
//           }).toList();

//           setState(() {
//             for (var item in matchedProducts) {
//               productsController.productModelList
//                   .add(ProductModel.fromJson(item));
//             }

//             hasMoreData = matchedProducts.isNotEmpty &&
//                 matchedProducts.length >= pageSize;
//             if (matchedProducts.isNotEmpty) {
//               currentPage++;
//             }
//           });
//         }
//       } catch (e) {
//         log('Error loading more data: $e');
//         setState(() {
//           hasMoreData = false;
//         });
//       } finally {
//         setState(() {
//           isLoadingMore = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     // log("buildsize width ${size.width}");
//     // log("buildsize height ${size.height}");
//     return GetBuilder<ProductsController>(
//         // key: ResponsiveProductsScreen.globalKey, // Add key here

//         builder: (productsController) {
//           return Scaffold(
//             appBar: AppBar(
//               centerTitle: true,
//               title: Container(
//                   alignment: Alignment.centerLeft,
//                   padding: const EdgeInsets.all(10),
//                   margin: EdgeInsets.only(top: 5),
//                   child: const Text(
//                     "Updated Suggestions",
//                     style: TextStyle(color: Color.fromARGB(255, 234, 17, 2)),
//                   )),
//               actions: [
//                 GetBuilder<CartController>(builder: (cartController) {
//                   return Stack(
//                     children: [
//                       Container(
//                         margin: EdgeInsets.only(top: 15),
//                         child: IconButton(
//                             onPressed: () {
//                               Navigator.of(context).push(MaterialPageRoute(
//                                   builder: (builder) =>
//                                       const FavouriteScreen()));
//                             },
//                             icon: Icon(
//                               size: 30,
//                               Icons.favorite_rounded,
//                               color: cartController.favouriteIds.isNotEmpty
//                                   ? const Color.fromARGB(255, 243, 3, 3)
//                                   : Color.fromARGB(255, 141, 138, 128),
//                             )),
//                       ),
//                       Container(
//                         margin: EdgeInsets.only(top: 15, left: 30),
//                         child: CircleAvatar(
//                           radius: 12,
//                           backgroundColor:
//                               const Color.fromARGB(255, 81, 7, 255),
//                           child: Container(
//                               alignment: Alignment.center,
//                               padding: const EdgeInsets.all(2),
//                               margin: const EdgeInsets.all(1),
//                               decoration: const BoxDecoration(
//                                   shape: BoxShape.circle, color: Colors.white),
//                               child: Text(
//                                   "${cartController.favouriteIds.length}")),
//                         ),
//                       )
//                     ],
//                   );
//                 })
//               ],
//             ),
//             body: Column(
//               children: [
//                  Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 'Showing ads in: ${locationController.formattedLocation}',
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//                 SizedBox(
//                   height: 5,
//                   child: ListView.builder(
//                       // shrinkWrap: true,
//                       scrollDirection: Axis.horizontal,
//                       itemCount: productsController.categoriesList.length,
//                       itemBuilder: (context, index) {
//                         return InkWell(
//                           onTap: () {
//                             productsController.getProductsByCategory(
//                                 productsController.categoriesList[index]);
//                           },
//                           child: Card(
//                               child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child:
//                                 Text(productsController.categoriesList[index]),
//                           )),
//                         );
//                       }),
//                 ),
//                 Expanded(
//                   child: productsController.isLoading.value
//                       ? const Center(child: CircularProgressIndicator())
//                       : GridView.builder(
//                           padding: EdgeInsets.only(
//                               bottom: MediaQuery.of(context).padding.bottom),
//                           controller: _scrollController,
//                           shrinkWrap: true,
//                           gridDelegate:
//                               SliverGridDelegateWithFixedCrossAxisCount(
//                                   crossAxisCount: size.width > 1368
//                                       ? 6
//                                       : size.width > 767 && size.width < 1368
//                                           ? 4
//                                           : 2,
//                                   childAspectRatio: size.width > 1368
//                                       ? 0.8
//                                       : size.width > 767 && size.width < 1368
//                                           ? 2.0
//                                           : 0.8,
//                                   crossAxisSpacing: 1,
//                                   mainAxisSpacing: 1),
//                           itemCount: productsController.productModelList.length,
//                           itemBuilder: (context, index) {
//                             ProductModel productModel =
//                                 productsController.productModelList[index];
//                             return GestureDetector(
//                                 onTap: () {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (builder) => ProductDetails(
//                                                 productModel: productModel,
//                                               )));
//                                 },
//                                 child: Card(
//                                   elevation: 2,
//                                   color:
//                                       const Color.fromARGB(255, 245, 242, 242),
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(15)),
//                                   // surfaceTintColor: Colors.amber,
//                                   shadowColor:
//                                       const Color.fromARGB(255, 35, 252, 2),
//                                   margin: const EdgeInsets.all(4),
//                                   child: Column(
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.all(6.0),
//                                         child: SizedBox(
//                                           height:
//                                               105, // Fixed height for the image container
//                                           child: Stack(
//                                             children: [
//                                               ClipRRect(
//                                                 borderRadius:
//                                                     const BorderRadius.only(
//                                                   topLeft: Radius.circular(20),
//                                                   topRight: Radius.circular(20),
//                                                   bottomLeft:
//                                                       Radius.circular(20),
//                                                   bottomRight:
//                                                       Radius.circular(20),
//                                                 ),
//                                                 child: Image.network(
//                                                   productModel.thumb.toString(),
//                                                   width: double.infinity,
//                                                   height: 130,
//                                                   fit: BoxFit.cover,
//                                                   loadingBuilder:
//                                                       (BuildContext context,
//                                                           Widget child,
//                                                           ImageChunkEvent?
//                                                               loadingProgress) {
//                                                     if (loadingProgress ==
//                                                         null) {
//                                                       return child;
//                                                     } else {
//                                                       return const Center(
//                                                           child:
//                                                               CircularProgressIndicator());
//                                                     }
//                                                   },
//                                                   errorBuilder: (BuildContext
//                                                           context,
//                                                       Object exception,
//                                                       StackTrace? stackTrace) {
//                                                     return const Center(
//                                                       child: Icon(
//                                                         Icons
//                                                             .image_not_supported_outlined, // You can change this icon
//                                                         size:
//                                                             50, // Adjust size as needed
//                                                         color: Color.fromARGB(
//                                                             255,
//                                                             123,
//                                                             74,
//                                                             74), // Adjust color as needed
//                                                       ),
//                                                     );
//                                                   },
//                                                 ),
//                                               ),
//                                               Positioned(
//                                                 top: 5,
//                                                 right: 5,
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                     color: const Color.fromARGB(
//                                                         255, 203, 203, 189),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             20),
//                                                     border: Border.all(
//                                                       color: Colors.white,
//                                                       width:
//                                                           3.0, // Thick white border
//                                                     ),
//                                                     boxShadow: [
//                                                       BoxShadow(
//                                                         color: Colors.black
//                                                             .withAlpha(
//                                                                 (0.5 * 255)
//                                                                     .round()),
//                                                         blurRadius: 4,
//                                                         spreadRadius: 1,
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   child: TweenAnimationBuilder(
//                                                     duration: Duration(
//                                                         milliseconds: 100),
//                                                     tween: Tween<double>(
//                                                       begin: 0,
//                                                       end: cartController
//                                                               .isFavourite(
//                                                                   productModel
//                                                                       .id
//                                                                       .toString())
//                                                           ? 1
//                                                           : 0,
//                                                     ),
//                                                     builder: (context,
//                                                         double value, _) {
//                                                       return IconButton(
//                                                           onPressed: () {
//                                                             if (cartController
//                                                                 .isFavourite(
//                                                                     productModel
//                                                                         .id
//                                                                         .toString())) {
//                                                               cartController
//                                                                   .removeFromFavourite(
//                                                                       context,
//                                                                       productModel
//                                                                           .id
//                                                                           .toString());
//                                                             } else {
//                                                               cartController
//                                                                   .addToFavourite(
//                                                                       context,
//                                                                       productModel
//                                                                           .id
//                                                                           .toString());
//                                                             }
//                                                           },
//                                                           icon: Stack(
//                                                             alignment: Alignment
//                                                                 .center,
//                                                             children: [
//                                                               if (cartController
//                                                                   .isFavourite(
//                                                                       productModel
//                                                                           .id
//                                                                           .toString()))
//                                                                 ...List
//                                                                     .generate(
//                                                                   5,
//                                                                   (index) =>
//                                                                       AnimatedOpacity(
//                                                                     duration: const Duration(
//                                                                         milliseconds:
//                                                                             100),
//                                                                     opacity:
//                                                                         value,
//                                                                     child: Transform
//                                                                         .scale(
//                                                                       scale: 1 +
//                                                                           (index * 0.2) *
//                                                                               value,
//                                                                       child: Transform
//                                                                           .rotate(
//                                                                         angle: (index *
//                                                                                 0.0) *
//                                                                             value *
//                                                                             0.10,
//                                                                         child:
//                                                                             Icon(
//                                                                           Icons
//                                                                               .favorite,
//                                                                           color: HSLColor
//                                                                               .fromAHSL(
//                                                                             1.0,
//                                                                             (index * 10.0 * value) %
//                                                                                 20,
//                                                                             0.8,
//                                                                             0.5 +
//                                                                                 (value * 0.3),
//                                                                           ).toColor().withOpacity(1 -
//                                                                               (index * 0.15)),
//                                                                           size:
//                                                                               20,
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                                 ).toList(),
//                                                               // Bubble floating animation
//                                                               if (cartController
//                                                                   .isFavourite(
//                                                                       productModel
//                                                                           .id
//                                                                           .toString()))
//                                                                 ...List
//                                                                     .generate(
//                                                                   6,
//                                                                   (index) =>
//                                                                       TweenAnimationBuilder(
//                                                                     tween: Tween(
//                                                                         begin:
//                                                                             0.0,
//                                                                         end:
//                                                                             1.0),
//                                                                     duration: Duration(
//                                                                         milliseconds:
//                                                                             1000 +
//                                                                                 index * 200),
//                                                                     curve: Curves
//                                                                         .easeInExpo,
//                                                                     builder: (context,
//                                                                         value,
//                                                                         child) {
//                                                                       return Transform
//                                                                           .translate(
//                                                                         offset:
//                                                                             Offset(
//                                                                           sin(value * pi * 2) *
//                                                                               15, // Horizontal sway
//                                                                           -value *
//                                                                               50, // Vertical movement
//                                                                         ),
//                                                                         child:
//                                                                             Opacity(
//                                                                           opacity:
//                                                                               1 - value,
//                                                                           child:
//                                                                               Transform.scale(
//                                                                             scale:
//                                                                                 1 - value * 0.5,
//                                                                             child:
//                                                                                 Container(
//                                                                               width: 10,
//                                                                               height: 10,
//                                                                               decoration: BoxDecoration(
//                                                                                 color: const Color.fromARGB(255, 246, 3, 226).withOpacity(0.9),
//                                                                                 shape: BoxShape.circle,
//                                                                                 boxShadow: [
//                                                                                   BoxShadow(
//                                                                                     color: Colors.white.withOpacity(0.4),
//                                                                                     blurRadius: 10,
//                                                                                     spreadRadius: 2,
//                                                                                   ),
//                                                                                 ],
//                                                                               ),
//                                                                             ),
//                                                                           ),
//                                                                         ),
//                                                                       );
//                                                                     },
//                                                                   ),
//                                                                 ),
//                                                               Icon(
//                                                                 Icons.favorite,
//                                                                 color: TweenSequence<
//                                                                     Color?>([
//                                                                   TweenSequenceItem(
//                                                                     weight: 1.0,
//                                                                     tween:
//                                                                         ColorTween(
//                                                                       begin: Colors
//                                                                           .grey,
//                                                                       end: const Color
//                                                                           .fromARGB(
//                                                                           255,
//                                                                           205,
//                                                                           4,
//                                                                           241),
//                                                                     ),
//                                                                   ),
//                                                                   TweenSequenceItem(
//                                                                     weight: 1.0,
//                                                                     tween:
//                                                                         ColorTween(
//                                                                       begin: const Color
//                                                                           .fromARGB(
//                                                                           255,
//                                                                           213,
//                                                                           4,
//                                                                           250),
//                                                                       end: const Color
//                                                                           .fromARGB(
//                                                                           255,
//                                                                           6,
//                                                                           82,
//                                                                           157),
//                                                                     ),
//                                                                   ),
//                                                                   TweenSequenceItem(
//                                                                     weight: 1.0,
//                                                                     tween:
//                                                                         ColorTween(
//                                                                       begin: Colors
//                                                                           .blue,
//                                                                       end: const Color
//                                                                           .fromARGB(
//                                                                           255,
//                                                                           160,
//                                                                           243,
//                                                                           7),
//                                                                     ),
//                                                                   ),
//                                                                   TweenSequenceItem(
//                                                                     weight: 1.0,
//                                                                     tween:
//                                                                         ColorTween(
//                                                                       begin: const Color
//                                                                           .fromARGB(
//                                                                           255,
//                                                                           247,
//                                                                           1,
//                                                                           112),
//                                                                       end: const Color
//                                                                           .fromARGB(
//                                                                           255,
//                                                                           241,
//                                                                           2,
//                                                                           2),
//                                                                     ),
//                                                                   ),
//                                                                 ]).evaluate(
//                                                                     AlwaysStoppedAnimation(
//                                                                         value)),
//                                                                 size: 20,
//                                                               )
//                                                             ],
//                                                           )

//                                                           );
//                                                     },
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(height: 20),
//                                       Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 8,
//                                             vertical: 1), // Reduced padding
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                                 "₹ ${productModel.price.toString()}",
//                                                 style: const TextStyle(
//                                                     color: Color.fromARGB(
//                                                         255, 243, 6, 176),
//                                                     fontSize: 16,
//                                                     fontWeight:
//                                                         FontWeight.bold)),
//                                             Text(
//                                               productModel.title.toString(),
//                                               style: const TextStyle(
//                                                   color: Colors.black,
//                                                   fontWeight: FontWeight.bold),
//                                               maxLines: 1,
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       const SizedBox(height: 2),
//                                       Container(
//                                         margin: EdgeInsets.all(0),
//                                         width: MediaQuery.of(context)
//                                                 .size
//                                                 .width -
//                                             32, // Subtract total horizontal paddin
//                                         child: Row(
//                                           children: [
//                                             const Icon(
//                                               Icons.location_on_outlined,
//                                               color: Colors.black,
//                                               size: 20,
//                                             ),
//                                             const SizedBox(
//                                               width: 2,
//                                             ),
//                                             Flexible(
//                                               flex: 0,
//                                               child: Text(
//                                                 productModel.location
//                                                     .toString(),
//                                                 maxLines: 1,
//                                                 overflow: TextOverflow.ellipsis,
//                                                 style: const TextStyle(
//                                                     color: Colors.black,
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               ),
//                                             ),
//                                             Flexible(
//                                               flex: 1,
//                                               child: Text(
//                                                 productModel.city.toString(),
//                                                 maxLines: 1,
//                                                 overflow: TextOverflow.ellipsis,
//                                                 style: const TextStyle(
//                                                     color: Colors.black,
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               ),
//                                             ),
//                                             const SizedBox(
//                                               width: 2,
//                                             ),
//                                             Flexible(
//                                               flex: 2,
//                                               child: Text(
//                                                 productModel.state.toString(),
//                                                 maxLines: 1,
//                                                 overflow: TextOverflow.ellipsis,
//                                                 style: const TextStyle(
//                                                     color: Colors.black,
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       const SizedBox(height: 2),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           Container(
//                                             margin: EdgeInsets.only(left: 4),
//                                             child: const Icon(
//                                               Icons.access_time,
//                                               size: 18,
//                                               color:
//                                                   Color.fromARGB(255, 9, 2, 2),
//                                             ),
//                                           ),
//                                           const SizedBox(width: 4),
//                                           Flexible(
//                                             child: Text(
//                                               productModel.posted_at != null
//                                                   ? DateFormat(
//                                                           'dd MMM yyyy, hh:mm a')
//                                                       .format(DateTime.parse(
//                                                           productModel
//                                                               .posted_at!))
//                                                   : 'No date',
//                                               maxLines: 1,
//                                               overflow: TextOverflow.ellipsis,
//                                               style: const TextStyle(
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight.bold,
//                                                 color: Color.fromARGB(
//                                                     255, 12, 0, 0),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ));
//                           }),
//                 ),
//                 if (productsController.hasMoreData)
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: ElevatedButton(
//                       onPressed: isLoadingMore
//                           ? null
//                           : () async {
//                               await loadMoreData();
//                             },
//                       child: isLoadingMore
//                           ? const CircularProgressIndicator()
//                           : const Text(
//                               'Load More',
//                               style: TextStyle(color: Colors.red),
//                             ),
//                     ),
//                   )
//               ],
//             ),
//           );
//         });
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     _scrollController.removeListener(_scrollListener);

//     super.dispose();
//   }
// }

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/models/product_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_poc_v3/controllers/location_controller.dart';
import 'package:flutter_poc_v3/controllers/products_controller.dart';
import 'package:flutter_poc_v3/controllers/cart_controller.dart';
import 'package:flutter_poc_v3/protected_screen.dart/favourite_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/product_details.dart';
import 'dart:math' show sin, pi;
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

  // @override
  // void initState() {
  //   super.initState();

  //   // Clear existing products first
  //   productsController.productModelList.clear();

  //   // Initial load
  //    loadProductsForLocation();

  //   // Listen to location changes
  //   ever(locationController.currentCity, (_) {
  //     log('Location changed: ${locationController.currentCity.value}');
  //     refreshProducts();
  //   });

  //   _scrollController.addListener(_scrollListener);
  // }

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

    _scrollController.addListener(_scrollListener);
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
      }
    } catch (e) {
      log('Error loading products: $e');
    }
  }

// Add this method to handle location updates
  void _updateProductsForLocation(String city, String state) async {
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
    log('ResponsiveProductsScreen - Loaded location: City: $city, State: $state');

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

  // String _formatDate(String dateString) {
  //   try {
  //     final DateTime date = DateTime.parse(dateString);
  //     return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  //   } catch (e) {
  //     return 'Invalid date';
  //   }
  // }

String _formatDate(String dateString) {
  try {
    // Parse ISO 8601 format string to DateTime
    DateTime dateTime = DateTime.parse(dateString);
    
    // Convert to local time zone
    dateTime = dateTime.toLocal();
    
    // Format the date
    return DateFormat('EEE, MMM d, yyyy').format(dateTime);
  } catch (e) {
    print('Error parsing date: $e');
    return 'Invalid date';
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

  //  Future<void> loadMoreData() async {
  //   if (!isLoadingMore && hasMoreData) {
  //     setState(() {
  //       isLoadingMore = true;
  //     });

  //     try {
  //       final locationController = Get.find<LocationController>();
  //       final selectedArea = locationController.selectedLocation.value;
  //       final currentCity = locationController.selectedCity.value;
  //       final currentState = locationController.selectedState.value;

  //       // Build URL with proper sequence
  //       String url =
  //           "http://13.200.179.78/adposts?page=$currentPage&psize=$pageSize";

  //       // Add parameters based on what's available
  //       if (selectedArea.isNotEmpty) url += "&location=$selectedArea";
  //       if (currentCity.isNotEmpty) url += "&city=$currentCity";
  //       if (currentState.isNotEmpty) url += "&state=$currentState";

  //       final response = await http.get(Uri.parse(url));

  //       if (response.statusCode == 200) {
  //         final Map<String, dynamic> responseData = json.decode(response.body);
  //         final List<dynamic> newProducts = responseData['data'];

  //         List<dynamic> matchedProducts = newProducts.where((product) {
  //           String productArea =
  //               product['location']?.toString().toLowerCase() ?? '';
  //           String productCity =
  //               product['city']?.toString().toLowerCase() ?? '';
  //           String productState =
  //               product['state']?.toString().toLowerCase() ?? '';

  //           bool matches = false;

  //           // Check all three parameters
  //           if (selectedArea.isNotEmpty &&
  //               currentCity.isNotEmpty &&
  //               currentState.isNotEmpty) {
  //             matches = productArea.contains(selectedArea.toLowerCase()) &&
  //                 productCity.contains(currentCity.toLowerCase()) &&
  //                 productState.contains(currentState.toLowerCase());
  //           }
  //           // Check combinations of two parameters
  //           else if (selectedArea.isNotEmpty && currentCity.isNotEmpty) {
  //             matches = productArea.contains(selectedArea.toLowerCase()) &&
  //                 productCity.contains(currentCity.toLowerCase());
  //           } else if (selectedArea.isNotEmpty && currentState.isNotEmpty) {
  //             matches = productArea.contains(selectedArea.toLowerCase()) &&
  //                 productState.contains(currentState.toLowerCase());
  //           } else if (currentCity.isNotEmpty && currentState.isNotEmpty) {
  //             matches = productCity.contains(currentCity.toLowerCase()) &&
  //                 productState.contains(currentState.toLowerCase());
  //           }
  //           // Check single parameters
  //           else if (selectedArea.isNotEmpty) {
  //             matches = productArea.contains(selectedArea.toLowerCase());
  //           } else if (currentCity.isNotEmpty) {
  //             matches = productCity.contains(currentCity.toLowerCase());
  //           } else if (currentState.isNotEmpty) {
  //             matches = productState.contains(currentState.toLowerCase());
  //           }

  //           return matches;
  //         }).toList();

  //         setState(() {
  //           for (var item in matchedProducts) {
  //             productsController.productModelList
  //                 .add(ProductModel.fromJson(item));
  //           }

  //           hasMoreData = matchedProducts.isNotEmpty &&
  //               matchedProducts.length >= pageSize;
  //           if (matchedProducts.isNotEmpty) {
  //             currentPage++;
  //           }
  //         });
  //       }
  //     } catch (e) {
  //       log('Error loading more data: $e');
  //       setState(() {
  //         hasMoreData = false;
  //       });
  //     } finally {
  //       setState(() {
  //         isLoadingMore = false;
  //       });
  //     }
  //   }
  // }

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
            child: const Text(
              "Updated Suggestions",
              style: TextStyle(color: Color.fromARGB(255, 234, 17, 2)),
            )),
        actions: [
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
                    backgroundColor: const Color.fromARGB(255, 81, 7, 255),
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
              'Showing ads in: ${locationController.currentCity.value}, ${locationController.currentState.value}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                        color: const Color.fromARGB(255, 245, 242, 242),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        margin: const EdgeInsets.all(4),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: SizedBox(
                                height: 105,
                                child: Stack(
                                  children: [
                                    // ClipRRect(
                                    //   borderRadius: BorderRadius.circular(20),
                                    //   child: Image.network(
                                    //     product.thumb.toString(),
                                    //     width: double.infinity,
                                    //     height: 130,
                                    //     fit: BoxFit.cover,
                                    //     loadingBuilder:
                                    //         (context, child, loadingProgress) {
                                    //       if (loadingProgress == null)
                                    //         return child;
                                    //       return const Center(
                                    //           child:
                                    //               CircularProgressIndicator());
                                    //     },
                                    //     errorBuilder:
                                    //         (context, error, stackTrace) {
                                    //       return const Center(
                                    //         child: Icon(
                                    //           Icons
                                    //               .image_not_supported_outlined,
                                    //           size: 50,
                                    //           color: Color.fromARGB(
                                    //               255, 123, 74, 74),
                                    //         ),
                                    //       );
                                    //     },
                                    //   ),
                                    // ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Stack(
                                        children: [
                                          // Image.network(
                                          //   product.thumb.toString(),
                                          //   width: double.infinity,
                                          //   height: 130,
                                          //   fit: BoxFit.cover,
                                          //   loadingBuilder: (context, child,
                                          //       loadingProgress) {
                                          //     if (loadingProgress == null)
                                          //       return child;
                                          //     return const Center(
                                          //         child:
                                          //             CircularProgressIndicator());
                                          //   },
                                          //   errorBuilder:
                                          //       (context, error, stackTrace) {
                                          //     return const Center(
                                          //       child: Icon(
                                          //         Icons
                                          //             .image_not_supported_outlined,
                                          //         size: 50,
                                          //         color: Color.fromARGB(
                                          //             255, 123, 74, 74),
                                          //       ),
                                          //     );
                                          //   },
                                          // ),

                                          product.thumbnailUrl.isNotEmpty
                                              ? Image.network(
                                                  'http://13.200.179.78/${product.thumbnailUrl}',
                                                  height: 200,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Image.asset(
                                                      'assets/images/placeholder.png',
                                                      height: 200,
                                                      width: double.infinity,
                                                      fit: BoxFit.cover,
                                                    );
                                                  },
                                                )
                                              : Image.asset(
                                                  'assets/images/placeholder.png',
                                                  height: 200,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                ),
                                          Builder(
                                            builder: (context) {
                                              // More detailed debug prints
                                              log('Raw product data: ${jsonEncode(product.toJson())}'); // Add toJson() method if not exists
                                              log('Featured at: ${product.featured_at}');
                                              log('Valid till: ${product.valid_till}');
                                              log('Current time: ${DateTime.now().millisecondsSinceEpoch ~/ 1000}');

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
                                                log('Time check: $now is between ${product.featured_at} and ${product.valid_till}');
                                              }

                                              log('Is Featured: $isFeatured');

                                              if (!isFeatured)
                                                return const SizedBox.shrink();

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
                                                        Color(
                                                            0xFF6A1B9A), // Deep Purple
                                                        Color(
                                                            0xFFE91E63), // Pink
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
                                                        color: Colors.black
                                                            .withOpacity(0.3),
                                                        blurRadius: 4,
                                                        offset:
                                                            const Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  child: const Text(
                                                    'FEATURED',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                    ),

                                    Positioned(
                                      top: 5,
                                      right: 5,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 203, 203, 189),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 3.0, // Thick white border
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withAlpha(
                                                  (0.5 * 255).round()),
                                              blurRadius: 4,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),
                                        child: TweenAnimationBuilder(
                                          duration: Duration(milliseconds: 100),
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
                                                    cartController
                                                        .addToFavourite(
                                                            context,
                                                            productModel.id
                                                                .toString());
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
                                                                  1000 +
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
                            SizedBox(height: 2),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 1), // Reduced padding
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("₹ ${productModel.price.toString()}",
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 243, 6, 176),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                    productModel.title.toString(),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 2),
                            Container(
                              margin: EdgeInsets.all(0),
                              width: MediaQuery.of(context).size.width -
                                  32, // Subtract total horizontal paddin
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Flexible(
                                    flex: 0,
                                    child: Text(
                                      productModel.location.toString(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Text(
                                      productModel.city.toString(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Flexible(
                                    flex: 2,
                                    child: Text(
                                      productModel.state.toString(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 2),
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
                                  // Your Text widget:
                                  child: Text(
                                     productModel.getFormattedDateWithTime(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 12, 0, 0),
                                    ),
                                  ),
                                  // child: Text(
                                  //   productModel.posted_at != null
                                  //       ? _formatDate(productModel.posted_at!)
                                  //       : 'No date',
                                  //   maxLines: 1,
                                  //   overflow: TextOverflow.ellipsis,
                                  //   style: const TextStyle(
                                  //     fontSize: 14,
                                  //     fontWeight: FontWeight.bold,
                                  //     color: Color.fromARGB(255, 12, 0, 0),
                                  //   ),
                                  // ),

                                  // child: Text(
                                  //   productModel.posted_at != null
                                  //       ? DateFormat(
                                  //               'dd MMM yyyy, hh:mm a')
                                  //           .format(DateTime.parse(
                                  //               productModel
                                  //                   .posted_at!))
                                  //       : 'No date',
                                  //   maxLines: 1,
                                  //   overflow: TextOverflow.ellipsis,
                                  //   style: const TextStyle(
                                  //     fontSize: 14,
                                  //     fontWeight: FontWeight.bold,
                                  //     color: Color.fromARGB(
                                  //         255, 12, 0, 0),
                                  //   ),
                                  // ),
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

  //   @override
  // void dispose() {
  //   _scrollController.dispose();
  //   _scrollController.removeListener(_scrollListener);

  //   super.dispose();
  // }
}
