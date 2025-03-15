import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/controllers/cart_controller.dart';
import 'package:flutter_poc_v3/controllers/location_controller.dart';
import 'package:flutter_poc_v3/models/product_model.dart';
import 'package:flutter_poc_v3/protected_screen.dart/homeappbar_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/product_details.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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

  String _formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null) return 'No date';

    try {
      final dateTime = DateTime.parse(dateTimeStr);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 7) {
        // Show full date for posts older than a week
        return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
      } else if (difference.inDays > 0) {
        return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Invalid date';
    }
  }

  // Future<void> _loadPosts() async {
  //   if (isLoading) return;

  //   setState(() {
  //     isLoading = true;
  //   });

  //   try {
  //     final Uri uri = Uri.parse(widget.apiUrl).replace(
  //       queryParameters: {
  //         ...Uri.parse(widget.apiUrl).queryParameters,
  //         'page': page.toString(),
  //         'psize': pageSize.toString(),
          
  //       },
  //     );

  //     log('Loading posts from: $uri');

  //     final response = await http.get(uri);
  //     log('Response status: ${response.statusCode}');
  //     log('Response body: ${response.body}');

  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> responseData = json.decode(response.body);
  //       final List<dynamic> data = responseData['data'] ?? [];

  //       final List<ProductModel> newPosts =
  //           data.map((json) => ProductModel.fromJson(json)).toList();

  //       setState(() {
  //         productModel.addAll(newPosts);
  //         hasMore = newPosts.length == pageSize;
  //         isLoading = false;
  //       });

  //       log('Number of posts loaded: ${newPosts.length}');
  //       log('Total posts: ${productModel.length}');
  //     } else {
  //       log('Error: ${response.statusCode}');
  //       setState(() {
  //         isLoading = false;
  //       });
  //     }
  //   } catch (e, stackTrace) {
  //     log('Exception: $e');
  //     log('Stack trace: $stackTrace');
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }








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
    queryParams.removeWhere((key, value) => value == null || value.isEmpty);

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
          onLocationTap: () async{
            
            // Handle location tap if needed
          },
        ), // Add HomeAppBar here
        AppBar(
       centerTitle: true,

           automaticallyImplyLeading: false,  // Add this line to remove b
        title: Text(widget.title.toUpperCase(),style:TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold,),textAlign: TextAlign.center),
          elevation: 0,
          
          backgroundColor: Colors.transparent, // Make it transparent to avoid double background
        
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
                            color: Colors.grey.withOpacity(0.1),
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
                                    child: post.thumb != null &&
                                            post.thumb!.isNotEmpty
                                        ? Image.network(
                                            post.thumb!,
                                            fit: BoxFit.cover,
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

                                  // Favorite Button
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.9),
                                          shape: BoxShape.circle,
                                        ),
                                        child: GetBuilder<CartController>(
                                          builder: (controller) => IconButton(
                                            onPressed: () {
                                              if (cartController.isFavourite(
                                                  post.id.toString())) {
                                                cartController
                                                    .removeFromFavourite(
                                                        context,
                                                        post.id.toString());
                                              } else {
                                                cartController.addToFavourite(
                                                    context,
                                                    post.id.toString());
                                              }
                                            },
                                            icon: Icon(
                                              Icons.favorite,
                                              color: cartController.isFavourite(
                                                      post.id.toString())
                                                  ? Colors.pink
                                                  : Colors.grey,
                                              size: 20,
                                            ),
                                          ),
                                        )

                                        //  child: IconButton(
                                        //         onPressed: () {
                                        //           if (cartController
                                        //               .isFavourite(post
                                        //                   .id
                                        //                   .toString())) {
                                        //             cartController
                                        //                 .removeFromFavourite(
                                        //                     context,
                                        //                     post.id
                                        //                         .toString());
                                        //           } else {
                                        //             cartController
                                        //                 .addToFavourite(
                                        //                     context,
                                        //                     post.id
                                        //                         .toString());
                                        //           }

                                        //           // cartController.addToCart(
                                        //           //     context, productModel);
                                        //         },
                                        //         icon:  Icon(
                                        //           Icons.favorite,

                                        //           // Icons
                                        //           //     .add_shopping_cart_outlined,
                                        //           color: cartController
                                        //                   .isFavourite(
                                        //                       post.id
                                        //                           .toString())
                                        //               ? Colors.pink
                                        //               : Colors.grey,
                                        //           size: 20,
                                        //         ),
                                        //       ),
                                        // child: IconButton(
                                        //   icon: const Icon(
                                        //     Icons.favorite_border,
                                        //     color: Colors.red,
                                        //   ),
                                        //   onPressed: () {
                                        //     // Add your favorite functionality here using CartController
                                        //     // Get.find<CartController>()
                                        //     //     .addToCart(context, post);
                                        //   },
                                        // ),
                                        ),
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
                                        Expanded(
                                          child: Text(
                                            post.title ?? 'No Title',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(
                                          '₹${post.price ?? 'N/A'}',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color:Colors.red,
                                            // color: Color.fromARGB(
                                            //     255, 243, 6, 176),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on,
                                            size: 16, color: Colors.grey[600]),
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
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(Icons.access_time,
                                            size: 16, color: Colors.grey[600]),
                                        const SizedBox(width: 4),
                                              
                                    Text(
                                          _formatDateTime(post.posted_at),
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
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

      // : ListView.builder(
      //     controller: _scrollController,
      //     itemCount: posts.length + (hasMore ? 1 : 0),
      //     itemBuilder: (context, index) {
      //       if (index == posts.length) {
      //         return Center(
      //           child: Padding(
      //             padding: const EdgeInsets.all(8.0),
      //             child: isLoading
      //                 ? const CircularProgressIndicator()
      //                 : const SizedBox(),
      //           ),
      //         );
      //       }

      //       final post = posts[index];
      //       return InkWell(
      //         onTap: () => _navigateToProductDetails(post),
      //         child: Card(
      //           margin: const EdgeInsets.symmetric(
      //             horizontal: 16,
      //             vertical: 8,
      //           ),
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               ListTile(
      //                 leading: SizedBox(
      //                   width: 80,
      //                   height: 80,
      //                   child: post.thumb != null &&
      //                           post.thumb!.isNotEmpty
      //                       ? ClipRRect(
      //                           borderRadius: BorderRadius.circular(4),
      //                           child: Image.network(
      //                             post.thumb!,
      //                             fit: BoxFit.cover,
      //                             errorBuilder:
      //                                 (context, error, stackTrace) {
      //                               return Container(
      //                                 decoration: BoxDecoration(
      //                                   color: Colors.grey[200],
      //                                   borderRadius:
      //                                       BorderRadius.circular(4),
      //                                 ),
      //                                 child: const Icon(
      //                                   Icons.image_not_supported,
      //                                   color: Colors.grey,
      //                                 ),
      //                               );
      //                             },
      //                           ),
      //                         )
      //                       : Container(
      //                           decoration: BoxDecoration(
      //                             color: Colors.grey[200],
      //                             borderRadius:
      //                                 BorderRadius.circular(4),
      //                           ),
      //                           child: const Icon(
      //                             Icons.image_not_supported,
      //                             color: Colors.grey,
      //                           ),
      //                         ),
      //                 ),
      //                 title: Text(
      //                   post.title ?? 'No Title',
      //                   maxLines: 2,
      //                   overflow: TextOverflow.ellipsis,
      //                 ),

      //                 trailing: Text(
      //                   '₹${post.price ?? 'N/A'}',
      //                   style: const TextStyle(
      //                     fontWeight: FontWeight.bold,
      //                     fontSize: 16,
      //                   ),
      //                 ),
      //               ),
      //               Padding(
      //                 padding: const EdgeInsets.only(
      //                   left: 16,
      //                   right: 16,
      //                   bottom: 12,
      //                 ),
      //                 child: Row(
      //                   children: [
      //                     Icon(
      //                       Icons.access_time,
      //                       size: 16,
      //                       color: Colors.grey[600],
      //                     ),
      //                     const SizedBox(width: 4),
      //                     Text(
      //                       _formatDateTime(post.posted_at),
      //                       style: TextStyle(
      //                         color: Colors.grey[600],
      //                         fontSize: 12,
      //                       ),
      //                     ),
      //                     const SizedBox(width: 16),
      //                     Icon(
      //                       Icons.location_on,
      //                       size: 16,
      //                       color: Colors.grey[600],
      //                     ),
      //                     const SizedBox(width: 4),
      //                     Expanded(
      //                       child: Text(
      //                         [
      //                           post.location,
      //                           post.city,
      //                           post.state,
      //                         ]
      //                             .where((item) =>
      //                                 item != null && item.isNotEmpty)
      //                             .join(', '),
      //                         style: TextStyle(
      //                           color: Colors.grey[600],
      //                           fontSize: 12,
      //                         ),
      //                         maxLines: 1,
      //                         overflow: TextOverflow.ellipsis,
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       );
      //     },
      //   ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}



