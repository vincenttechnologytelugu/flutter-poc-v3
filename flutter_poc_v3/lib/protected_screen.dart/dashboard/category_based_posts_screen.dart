import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/controllers/cart_controller.dart';
import 'package:flutter_poc_v3/models/product_model.dart';
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
  final ScrollController _scrollController = ScrollController();
  List<ProductModel> posts = [];
  bool isLoading = false;
  bool hasMore = true;
  int page = 0;
  final int pageSize = 10;

  @override
  void initState() {
    super.initState();
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

  Future<void> _loadPosts() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final Uri uri = Uri.parse(widget.apiUrl).replace(
        queryParameters: {
          ...Uri.parse(widget.apiUrl).queryParameters,
          'page': page.toString(),
          'psize': pageSize.toString(),
        },
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
          posts.addAll(newPosts);
          hasMore = newPosts.length == pageSize;
          isLoading = false;
        });

        log('Number of posts loaded: ${newPosts.length}');
        log('Total posts: ${posts.length}');
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
      // backgroundColor: const Color.fromARGB(255, 172, 179, 180),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: posts.isEmpty && isLoading
          ? const Center(child: CircularProgressIndicator())
          : posts.isEmpty
              ? Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color.fromARGB(255, 11, 175, 224)!,
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
                  itemCount: posts.length + (hasMore ? 1 : 0),
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    if (index == posts.length) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: isLoading
                              ? const CircularProgressIndicator()
                              : const SizedBox(),
                        ),
                      );
                    }

                    final post = posts[index];
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
                                                      color: const Color.fromARGB(255, 127, 85, 85),
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
                                                  color: const Color.fromARGB(255, 113, 90, 90),
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
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.favorite_border,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          // Add your favorite functionality here using CartController
                                          Get.find<CartController>()
                                              .addToCart(context, post);
                                        },
                                      ),
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
                                            color: Color.fromARGB(255, 243, 6, 176),
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




















// class CategoryBasedPostsScreen extends StatefulWidget {
//   final String apiUrl;
//   final String title;

//   const CategoryBasedPostsScreen({
//     super.key,
//     required this.apiUrl,
//     required this.title,
//   });

//   @override
//   State<CategoryBasedPostsScreen> createState() => _CategoryBasedPostsScreenState();
// }

// class _CategoryBasedPostsScreenState extends State<CategoryBasedPostsScreen> {
//   final ScrollController _scrollController = ScrollController();
//   List<ProductModel> posts = [];
//   bool isLoading = false;
//   int page = 1;
//   bool hasMore = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadPosts();
//     _scrollController.addListener(_scrollListener);
//   }

//   void _scrollListener() {
//     if (_scrollController.position.pixels ==
//         _scrollController.position.maxScrollExtent) {
//       if (!isLoading && hasMore) {
//         _loadPosts();
//       }
//     }
//   }

//  Future<void> _loadPosts() async {
//   if (isLoading) return;

//   setState(() {
//     isLoading = true;
//   });

//   try {
//     // Don't add page parameter if it's already in the URL
//     final url = widget.apiUrl.contains('page=') 
//         ? Uri.parse(widget.apiUrl)
//         : Uri.parse('$widget.apiUrl');
    
//     log('Loading posts from: $url');
    
//     final response = await http.get(url);
//     log('Response status: ${response.statusCode}');
//     log('Response body: ${response.body}');

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> responseData = json.decode(response.body);
//       final List<dynamic> data = responseData['data'] ?? [];
//       log('Number of posts received: ${data.length}');
      
//       final newPosts = data.map((json) => ProductModel.fromJson(json)).toList();
//       log('Number of posts converted: ${newPosts.length}');

//       setState(() {
//         posts.addAll(newPosts);
//         page++;
//         hasMore = newPosts.isNotEmpty;
//         isLoading = false;
//       });
      
//       log('Total posts in state: ${posts.length}');
//     } else {
//       setState(() {
//         isLoading = false;
//       });
//       log('Error: ${response.statusCode}');
//     }
//   } catch (e, stackTrace) {
//     setState(() {
//       isLoading = false;
//     });
//     log('Exception: $e');
//     log('Stack trace: $stackTrace');
//   }
// }



// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: Text(widget.title),
//     ),
//     body: posts.isEmpty && isLoading
//         ? const Center(child: CircularProgressIndicator())
//         : ListView.builder(
//             controller: _scrollController,
//             itemCount: posts.length + (hasMore ? 1 : 0),
//             itemBuilder: (context, index) {
//               if (index == posts.length) {
//                 return Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: isLoading
//                         ? const CircularProgressIndicator()
//                         : const SizedBox(),
//                   ),
//                 );
//               }

//               final post = posts[index];
//               return Card(
//                 margin: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 8,
//                 ),
//                 child: Column(
//                   children: [
//                     ListTile(
//                       leading: SizedBox(
//                         width: 80,
//                         height: 80,
//                         child: post.thumb != null && post.thumb!.isNotEmpty
//                             ? ClipRRect(
//                                 borderRadius: BorderRadius.circular(4),
//                                 child: Image.network(
//                                   post.thumb!,
//                                   fit: BoxFit.cover,
//                                   errorBuilder: (context, error, stackTrace) {
//                                     return Container(
//                                       decoration: BoxDecoration(
//                                         color: Colors.grey[200],
//                                         borderRadius: BorderRadius.circular(4),
//                                       ),
//                                       child: const Icon(
//                                         Icons.image_not_supported,
//                                         color: Colors.grey,
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               )
//                             : Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey[200],
//                                   borderRadius: BorderRadius.circular(4),
//                                 ),
//                                 child: const Icon(
//                                   Icons.image_not_supported,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                       ),
//                       title: Text(
//                         post.title ?? 'No Title',
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       // subtitle: Text(
//                       //   post.description ?? 'No Description',
//                       //   maxLines: 1,
//                       //   overflow: TextOverflow.ellipsis,
//                       // ),
//                       trailing: Text(
//                         '₹${post.price ?? 'N/A'}',
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(
//                         left: 16,
//                         right: 16,
//                         bottom: 8,
//                       ),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               const Icon(
//                                 Icons.access_time,
//                                 size: 16,
//                                 color: Color.fromARGB(255, 21, 15, 15),
//                               ),
//                               const SizedBox(width: 4),
//                               Text(
//                                 post.posted_at != null
//                                     ? DateFormat('dd MMM yyyy, hh:mm a')
//                                         .format(DateTime.parse(post.posted_at!))
//                                     : 'No date',
//                                 style: const TextStyle(
//                                   color: Color.fromARGB(255, 17, 6, 6),
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 4),
//                           Row(
//                             children: [
//                               const Icon(
//                                 Icons.location_on,
//                                 size: 20,
//                                 color: Color.fromARGB(255, 14, 4, 4),
//                               ),
//                               const SizedBox(width: 4),
//                               Expanded(
//                                 child: Text(
//                                   [
//                                     post.location,
//                                     post.city,
//                                     post.state,
//                                   ].where((item) => item != null && item.isNotEmpty)
//                                       .join(', '),
//                                   style: const TextStyle(
//                                     color: Color.fromARGB(255, 18, 3, 3),
//                                     fontSize: 12,
//                                   ),
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//   );
// }


//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
// }




















// // category_based_posts_screen.dart
// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_poc_v3/controllers/cart_controller.dart';
// import 'package:flutter_poc_v3/controllers/categoty_based_posts_controller.dart';
// import 'package:flutter_poc_v3/models/product_model.dart';
// import 'package:flutter_poc_v3/protected_screen.dart/cart_screen.dart';
// import 'package:flutter_poc_v3/protected_screen.dart/product_details.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';

// class CategoryBasedPostsScreen extends StatefulWidget {
//   final String category;
  

//   const CategoryBasedPostsScreen({
//     super.key,
//     required this.category,
//   });

//   @override
//   State<CategoryBasedPostsScreen> createState() =>
//       _CategoryBasedPostsScreenState();
// }

// class _CategoryBasedPostsScreenState extends State<CategoryBasedPostsScreen> {
//   late CategoryBasedPostsController controller;
//   final ScrollController _scrollController = ScrollController();
//   CartController cartController = Get.put(CartController());

//   @override
//   void initState() {
//     super.initState();
//     controller =
//         Get.put(CategoryBasedPostsController(category: widget.category));
//     controller.getPosts();

//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels ==
//           _scrollController.position.maxScrollExtent) {
//         controller.getPosts(isLoadMore: true);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(137, 150, 115, 115),
//         // centerTitle: true,
//         title: Container(
//             margin: EdgeInsets.only(top: 0),
//             child: Text('${widget.category} Posts')),
//         actions: [
//           GetBuilder<CartController>(builder: (cartController) {
//             return Stack(
//               children: [
//                 Container(
//                   margin: EdgeInsets.only(top: 5),
//                   child: IconButton(
//                       onPressed: () {
//                         Navigator.of(context).push(MaterialPageRoute(
//                             builder: (builder) => const CartScreen()));
//                       },
//                       icon: const Icon(
//                         size: 30,
//                         Icons.favorite_rounded,
//                       )),
//                 ),
//                 Container(
//                   margin: EdgeInsets.only(top: 5, left: 30),
//                   child: CircleAvatar(
//                     radius: 12,
//                     backgroundColor: Colors.amber,
//                     child: Container(
//                         alignment: Alignment.center,
//                         padding: const EdgeInsets.all(2),
//                         margin: const EdgeInsets.all(1),
//                         decoration: const BoxDecoration(
//                             shape: BoxShape.circle, color: Colors.white),
//                         child: Text("${cartController.cartList.length}")),
//                   ),
//                 )
//               ],
//             );
//           })
//         ],
//       ),
//       body: GetBuilder<CategoryBasedPostsController>(
//         builder: (controller) {
//           if (controller.isLoading && controller.posts.isEmpty) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           return RefreshIndicator(
//             onRefresh: () async {
//               await controller.getPosts();
//             },
//             child: ListView.builder(
//               padding: const EdgeInsets.symmetric(vertical: 1),
//               controller: _scrollController,
//               itemCount:
//                   controller.posts.length + (controller.hasMoreData ? 1 : 0),
//               itemBuilder: (context, index) {
//                 if (index == controller.posts.length) {
//                   return controller.isLoading
//                       ? const Padding(
//                           padding: EdgeInsets.all(16.0),
//                           child: Center(child: CircularProgressIndicator()),
//                         )
//                       : const SizedBox();
//                 }

//                 final post = controller.posts[index];
//                 return ProductCard(product: post);
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
// }

// class ProductCard extends StatefulWidget {
//   final ProductModel product;

//   const ProductCard({super.key, required this.product});

//   @override
//   State<ProductCard> createState() => _ProductCardState();
// }

// class _ProductCardState extends State<ProductCard> {
//   final cartController = Get.find<CartController>();
//   final productsController = Get.find<CategoryBasedPostsController>();

//   @override
//   Widget build(BuildContext context) {
//     log("Posted at value: ${widget.product.posted_at}");

//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           SizedBox(
//             height: 1,
//             child: ListView.builder(
//                 // shrinkWrap: true,
//                 scrollDirection: Axis.horizontal,
//                 itemCount: productsController.categoriesList.length,
//                 itemBuilder: (context, index) {
//                   return InkWell(
//                     onTap: () {
//                       productsController.getProductsByCategory(
//                           productsController.categoriesList[index]);
//                     },
//                     child: Card(
//                         child: Padding(
//                       padding: const EdgeInsets.all(1.0),
//                       child: Text(productsController.categoriesList[index]),
//                     )),
//                   );
//                 }),
//           ),
//           InkWell(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ProductDetails(
//                     productModel: widget.product,
//                   ),
//                 ),
//               );
//             },
//             child: Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               color: const Color.fromARGB(255, 198, 203, 200),
//               elevation: 3,
//               margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//               child: IntrinsicHeight(
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Left side - Image
//                     Stack(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(5.0),
//                           child: ClipRRect(
//                             borderRadius: const BorderRadius.only(
//                               topLeft: Radius.circular(10),
//                               bottomLeft: Radius.circular(10),
//                               topRight: Radius.circular(10),
//                               bottomRight: Radius.circular(10),
//                             ),
//                             child: Image.network(
//                               widget.product.thumb ?? '',
//                               width: MediaQuery.of(context).size.width * 0.35,
//                               height: 160,
//                               fit: BoxFit.cover,
//                               errorBuilder: (context, error, stackTrace) {
//                                 return Container(
//                                   width: MediaQuery.of(context).size.width * 0.35,
//                                   height: 160,
//                                   color: Colors.grey[200],
//                                   child: const Icon(Icons.image_not_supported,
//                                       size: 40),
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           top: 5,
//                           right: 5,
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: const Color.fromARGB(255, 188, 168, 168),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: IconButton(
//                               onPressed: () {
//                                 cartController.addToCart(context, widget.product);
//                               },
//                               icon: const Icon(
//                                 Icons.favorite_border_outlined,
//                                 // Icons
//                                 //     .add_shopping_cart_outlined,
//                                 color: Colors.black,
//                                 size: 18,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
      
//                     // Right side - Details
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.all(12),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             // Title
//                             Text(
//                               widget.product.title ?? '',
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 8),
      
//                             // Price
//                             Text(
//                               '₹ ${widget.product.price?.toString() ?? ''}',
//                               style: const TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.green,
//                               ),
//                             ),
      
//                             Spacer(),
      
//                             // Location
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Icon(
//                                   Icons.location_on,
//                                   size: 18,
//                                   color: const Color.fromARGB(255, 9, 2, 2),
//                                 ),
//                                 const SizedBox(width: 4),
//                                 Flexible(
//                                   child: Text(
//                                     widget.product.city?.toString() ?? '',
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: const Color.fromARGB(255, 26, 5, 5),
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 10,
//                                 ),
//                                 Text(
//                                   maxLines: 2,
//                                   widget.product.location?.toString() ?? '',
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ],
//                             ),
//                             // After the location Row, add a new Row for the posted date
//                             Row(
//                               children: [
//                                 const Icon(
//                                   Icons.access_time,
//                                   size: 18,
//                                   color: Color.fromARGB(255, 9, 2, 2),
//                                 ),
//                                 const SizedBox(width: 4),
//                                 Flexible(
//                                   child: Text(
//                                     widget.product.posted_at != null
//                                         ? DateFormat('dd MMM yyyy, hh:mm a')
//                                             .format(DateTime.parse(
//                                                 widget.product.posted_at!))
//                                         : 'No date',
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: const TextStyle(
//                                       fontSize: 14,
//                                       color: Color.fromARGB(255, 26, 5, 5),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }





// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: Text(widget.title),
//     ),
//     body: posts.isEmpty && isLoading
//         ? const Center(child: CircularProgressIndicator())
//         : ListView.builder(
//             controller: _scrollController,
//             itemCount: posts.length + (hasMore ? 1 : 0),
//             itemBuilder: (context, index) {
//               if (index == posts.length) {
//                 return Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: isLoading
//                         ? const CircularProgressIndicator()
//                         : const SizedBox(),
//                   ),
//                 );
//               }

//               final post = posts[index];
//               return Card(
//                 margin: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 8,
//                 ),
//                 child: Column(
//                   children: [
//                     ListTile(
//                       leading: SizedBox(
//                         width: 80,
//                         height: 80,
//                         child: post.thumb != null && post.thumb!.isNotEmpty
//                             ? ClipRRect(
//                                 borderRadius: BorderRadius.circular(4),
//                                 child: Image.network(
//                                   post.thumb!,
//                                   fit: BoxFit.cover,
//                                   errorBuilder: (context, error, stackTrace) {
//                                     return Container(
//                                       decoration: BoxDecoration(
//                                         color: Colors.grey[200],
//                                         borderRadius: BorderRadius.circular(4),
//                                       ),
//                                       child: const Icon(
//                                         Icons.image_not_supported,
//                                         color: Colors.grey,
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               )
//                             : Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey[200],
//                                   borderRadius: BorderRadius.circular(4),
//                                 ),
//                                 child: const Icon(
//                                   Icons.image_not_supported,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                       ),
//                       title: Text(
//                         post.title ?? 'No Title',
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       subtitle: Text(
//                         post.description ?? 'No Description',
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       trailing: Text(
//                         '₹${post.price ?? 'N/A'}',
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(
//                         left: 16,
//                         right: 16,
//                         bottom: 8,
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(
//                             Icons.access_time,
//                             size: 16,
//                             color: Colors.grey,
//                           ),
//                           const SizedBox(width: 4),
//                           Text(
//                             post.posted_at != null
//                                 ? _formatDateTime(post.posted_at!)
//                                 : 'No date',
//                             style: const TextStyle(
//                               color: Colors.grey,
//                               fontSize: 12,
//                             ),
//                           ),
//                           const Spacer(),
//                           if (post.location != null) ...[
//                             const Icon(
//                               Icons.location_on,
//                               size: 16,
//                               color: Colors.grey,
//                             ),
//                             const SizedBox(width: 4),
//                             Text(
//                               post.location!,
//                               style: const TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//   );
// }

// String _formatDateTime(String dateTimeStr) {
//   try {
//     final dateTime = DateTime.parse(dateTimeStr);
//     final now = DateTime.now();
//     final difference = now.difference(dateTime);

//     if (difference.inDays > 0) {
//       return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
//     } else if (difference.inHours > 0) {
//       return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
//     } else if (difference.inMinutes > 0) {
//       return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
//     } else {
//       return 'Just now';
//     }
//   } catch (e) {
//     return 'Invalid date';
//   }
// }