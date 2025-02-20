import 'dart:convert';
import 'dart:developer';
import 'dart:math' show sin, pi;

import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/protected_screen.dart/favourite_screen.dart';

// import 'package:flutter_poc_v3/protected_screen.dart/cart_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_poc_v3/controllers/cart_controller.dart';
import 'package:flutter_poc_v3/controllers/products_controller.dart';
import 'package:flutter_poc_v3/models/product_model.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'product_details.dart';

class ResponsiveProductsScreen extends StatefulWidget {
  const ResponsiveProductsScreen({super.key});

  @override
  State<ResponsiveProductsScreen> createState() =>
      _ResponsiveProductsScreenState();
}

class _ResponsiveProductsScreenState extends State<ResponsiveProductsScreen> {
  // final ProductsController productsController = Get.put(ProductsController());

  CartController cartController = Get.put(CartController());
  final ScrollController _scrollController = ScrollController();
    final productsController = Get.find<ProductsController>();

  bool isLoadingMore = false;
  int currentPage = 0;
  final int pageSize = 50; // Adjust page size as needed
  bool hasMoreData = true;

  @override
  void initState() {
    productsController.getData();
    _loadInitialData();

    // Add scroll listener
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  // Update scroll listener to be more precise
  void _scrollListener() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    // Load more when user reaches the bottom
    if (currentScroll >= maxScroll && !isLoadingMore && hasMoreData) {
      loadMoreData();
    }
  }

  Future<void> _loadInitialData() async {
    await productsController.getData(); // Load initial data
  }

// Update your loadMoreData function
  Future<void> loadMoreData() async {
    if (!isLoadingMore && hasMoreData) {
      setState(() {
        isLoadingMore = true;
      });

      try {
        final response = await http.get(
          Uri.parse(
              "http://192.168.0.167:8080/adposts?page=$currentPage&psize=$pageSize"),
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          final List<dynamic> newProducts = responseData['data'];
          final pagination = responseData['pagination'];

          // Update hasMoreData based on pagination
          hasMoreData = currentPage < (pagination['totalPages'] - 1);

          if (newProducts.isNotEmpty) {
            setState(() {
              for (var item in newProducts) {
                productsController.productModelList
                    .add(ProductModel.fromJson(item));
              }
              currentPage++;
            });
          } else {
            // If no new products, set hasMoreData to false
            setState(() {
              hasMoreData = false;
            });
          }
        }
      } catch (e) {
        log('Error loading more data: $e');
        setState(() {
          hasMoreData = false; // Set to false on error
        });
      } finally {
        setState(() {
          isLoadingMore = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // log("buildsize width ${size.width}");
    // log("buildsize height ${size.height}");
    return GetBuilder<ProductsController>(builder: (productsController) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(10),
              margin: EdgeInsets.only(top: 5),
              child: const Text(
                "Updated Suggestions",
                style: TextStyle(color: Color.fromARGB(255, 234, 17, 2)),
              )),
          actions: [
            GetBuilder<CartController>(builder: (cartController) {
              return Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (builder) => const FavouriteScreen()));
                        },
                        icon: Icon(
                          size: 30,
                          Icons.favorite_rounded,
                          color: cartController.favouriteIds.isNotEmpty
                              ? const Color.fromARGB(255, 243, 3, 3)
                              : Color.fromARGB(255, 141, 138, 128),
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15, left: 30),
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
            SizedBox(
              height: 5,
              child: ListView.builder(
                  // shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: productsController.categoriesList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        productsController.getProductsByCategory(
                            productsController.categoriesList[index]);
                      },
                      child: Card(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(productsController.categoriesList[index]),
                      )),
                    );
                  }),
            ),
            Expanded(
              child: productsController.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom),
                      controller: _scrollController,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: size.width > 1368
                              ? 6
                              : size.width > 767 && size.width < 1368
                                  ? 4
                                  : 2,
                          childAspectRatio: size.width > 1368
                              ? 0.8
                              : size.width > 767 && size.width < 1368
                                  ? 2.0
                                  : 0.8,
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1),
                      itemCount: productsController.productModelList.length,
                      itemBuilder: (context, index) {
                        ProductModel productModel =
                            productsController.productModelList[index];
                        return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) => ProductDetails(
                                            productModel: productModel,
                                          )));
                            },
                            child: Card(
                              elevation: 2,
                              color: const Color.fromARGB(255, 245, 242, 242),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              // surfaceTintColor: Colors.amber,
                              shadowColor:
                                  const Color.fromARGB(255, 35, 252, 2),
                              margin: const EdgeInsets.all(4),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: SizedBox(
                                      height:
                                          105, // Fixed height for the image container
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                              bottomLeft: Radius.circular(20),
                                              bottomRight: Radius.circular(20),
                                            ),
                                            child: Image.network(
                                              productModel.thumb.toString(),
                                              width: double.infinity,
                                              height: 130,
                                              fit: BoxFit.cover,
                                              loadingBuilder:
                                                  (BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent?
                                                          loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                } else {
                                                  return const Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                }
                                              },
                                              errorBuilder:
                                                  (BuildContext context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                return const Center(
                                                  child: Icon(
                                                    Icons
                                                        .image_not_supported_outlined, // You can change this icon
                                                    size:
                                                        50, // Adjust size as needed
                                                    color: Color.fromARGB(
                                                        255,
                                                        123,
                                                        74,
                                                        74), // Adjust color as needed
                                                  ),
                                                );
                                              },
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
                                                  width:
                                                      3.0, // Thick white border
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withAlpha((0.5 * 255)
                                                            .round()),
                                                    blurRadius: 4,
                                                    spreadRadius: 1,
                                                  ),
                                                ],
                                              ),
                                              child: TweenAnimationBuilder(
                                                duration:
                                                    Duration(milliseconds: 100),
                                                tween: Tween<double>(
                                                  begin: 0,
                                                  end: cartController
                                                          .isFavourite(
                                                              productModel.id
                                                                  .toString())
                                                      ? 1
                                                      : 0,
                                                ),
                                                builder:
                                                    (context, double value, _) {
                                                  return IconButton(
                                                      onPressed: () {
                                                        if (cartController
                                                            .isFavourite(
                                                                productModel.id
                                                                    .toString())) {
                                                          cartController
                                                              .removeFromFavourite(
                                                                  context,
                                                                  productModel
                                                                      .id
                                                                      .toString());
                                                        } else {
                                                          cartController
                                                              .addToFavourite(
                                                                  context,
                                                                  productModel
                                                                      .id
                                                                      .toString());
                                                        }
                                                      },
                                                      icon: Stack(
                                                        alignment:
                                                            Alignment.center,
                                                        children: [
                                                          if (cartController
                                                              .isFavourite(
                                                                  productModel
                                                                      .id
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
                                                                child: Transform
                                                                    .scale(
                                                                  scale: 1 +
                                                                      (index *
                                                                              0.2) *
                                                                          value,
                                                                  child: Transform
                                                                      .rotate(
                                                                    angle: (index *
                                                                            0.0) *
                                                                        value *
                                                                        0.10,
                                                                    child: Icon(
                                                                      Icons
                                                                          .favorite,
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
                                                                      ).toColor().withOpacity(1 -
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
                                                                  productModel
                                                                      .id
                                                                      .toString()))
                                                            ...List.generate(
                                                              6,
                                                              (index) =>
                                                                  TweenAnimationBuilder(
                                                                tween: Tween(
                                                                    begin: 0.0,
                                                                    end: 1.0),
                                                                duration: Duration(
                                                                    milliseconds: 1000 +
                                                                        index *
                                                                            200),
                                                                curve: Curves
                                                                    .easeInExpo,
                                                                builder:
                                                                    (context,
                                                                        value,
                                                                        child) {
                                                                  return Transform
                                                                      .translate(
                                                                    offset:
                                                                        Offset(
                                                                      sin(value *
                                                                              pi *
                                                                              2) *
                                                                          15, // Horizontal sway
                                                                      -value *
                                                                          50, // Vertical movement
                                                                    ),
                                                                    child:
                                                                        Opacity(
                                                                      opacity: 1 -
                                                                          value,
                                                                      child: Transform
                                                                          .scale(
                                                                        scale: 1 -
                                                                            value *
                                                                                0.5,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              10,
                                                                          height:
                                                                              10,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                const Color.fromARGB(255, 246, 3, 226).withOpacity(0.9),
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                color: Colors.white.withOpacity(0.4),
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
                                                            color: TweenSequence<
                                                                Color?>([
                                                              TweenSequenceItem(
                                                                weight: 1.0,
                                                                tween:
                                                                    ColorTween(
                                                                  begin: Colors
                                                                      .grey,
                                                                  end: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      205,
                                                                      4,
                                                                      241),
                                                                ),
                                                              ),
                                                              TweenSequenceItem(
                                                                weight: 1.0,
                                                                tween:
                                                                    ColorTween(
                                                                  begin: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      213,
                                                                      4,
                                                                      250),
                                                                  end: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      6,
                                                                      82,
                                                                      157),
                                                                ),
                                                              ),
                                                              TweenSequenceItem(
                                                                weight: 1.0,
                                                                tween:
                                                                    ColorTween(
                                                                  begin: Colors
                                                                      .blue,
                                                                  end: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      160,
                                                                      243,
                                                                      7),
                                                                ),
                                                              ),
                                                              TweenSequenceItem(
                                                                weight: 1.0,
                                                                tween:
                                                                    ColorTween(
                                                                  begin: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      247,
                                                                      1,
                                                                      112),
                                                                  end: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      241,
                                                                      2,
                                                                      2),
                                                                ),
                                                              ),
                                                            ]).evaluate(
                                                                AlwaysStoppedAnimation(
                                                                    value)),
                                                            size: 20,
                                                          )
                                                        ],
                                                      )
                                                      // icon: Stack(
                                                      //   alignment:
                                                      //       Alignment.center,
                                                      //   children: [
                                                      //     if (cartController
                                                      //         .isFavourite(
                                                      //             productModel.id
                                                      //                 .toString()))
                                                      //       ...List.generate(
                                                      //         5, // Increased number of layers for more rainbow effect
                                                      //         (index) =>
                                                      //             AnimatedOpacity(
                                                      //           duration: Duration(
                                                      //               milliseconds:
                                                      //                   100),
                                                      //           opacity: value,
                                                      //           child: Transform
                                                      //               .scale(
                                                      //             scale: 1 +
                                                      //                 (index *
                                                      //                         0.2) *
                                                      //                     value,
                                                      //             child: Transform
                                                      //                 .rotate(
                                                      //               angle: (index *
                                                      //                       0.0) *
                                                      //                   value *
                                                      //                   .10, // Adds rotation
                                                      //               child: Icon(
                                                      //                 Icons
                                                      //                     .favorite,
                                                      //                 color: HSLColor
                                                      //                     .fromAHSL(
                                                      //                   1.0,
                                                      //                   (index *
                                                      //                           10.0 *
                                                      //                           value) %
                                                      //                       20, // Rainbow hue rotation
                                                      //                   0.8,
                                                      //                   0.5 +
                                                      //                       (value *
                                                      //                           0.3),
                                                      //                 ).toColor().withOpacity(1 -
                                                      //                     (index *
                                                      //                         0.15)),
                                                      //                 size: 20,
                                                      //               ),
                                                      //             ),
                                                      //           ),
                                                      //         ),
                                                      //       ).toList(),
                                                      //     Icon(
                                                      //       Icons.favorite,
                                                      //       color: TweenSequence<
                                                      //           Color?>([
                                                      //         TweenSequenceItem(
                                                      //           weight: 1.0,
                                                      //           tween: ColorTween(
                                                      //             begin:
                                                      //                 Colors.grey,
                                                      //             end: Colors
                                                      //                 .purple,
                                                      //           ),
                                                      //         ),
                                                      //         TweenSequenceItem(
                                                      //           weight: 1.0,
                                                      //           tween: ColorTween(
                                                      //             begin: const Color
                                                      //                 .fromARGB(
                                                      //                 255,
                                                      //                 200,
                                                      //                 16,
                                                      //                 233),
                                                      //             end: const Color
                                                      //                 .fromARGB(
                                                      //                 255,
                                                      //                 6,
                                                      //                 82,
                                                      //                 157),
                                                      //           ),
                                                      //         ),
                                                      //         TweenSequenceItem(
                                                      //           weight: 1.0,
                                                      //           tween: ColorTween(
                                                      //             begin:
                                                      //                 Colors.blue,
                                                      //             end: const Color
                                                      //                 .fromARGB(
                                                      //                 255,
                                                      //                 21,
                                                      //                 232,
                                                      //                 45),
                                                      //           ),
                                                      //         ),
                                                      //         TweenSequenceItem(
                                                      //           weight: 1.0,
                                                      //           tween: ColorTween(
                                                      //             begin: const Color
                                                      //                 .fromARGB(
                                                      //                 255,
                                                      //                 233,
                                                      //                 13,
                                                      //                 112),
                                                      //             end: const Color
                                                      //                 .fromARGB(
                                                      //                 255,
                                                      //                 241,
                                                      //                 218,
                                                      //                 8),
                                                      //           ),
                                                      //         ),
                                                      //         TweenSequenceItem(
                                                      //           weight: 1.0,
                                                      //           tween: ColorTween(
                                                      //             begin: const Color
                                                      //                 .fromARGB(
                                                      //                 255,
                                                      //                 6,
                                                      //                 6,
                                                      //                 230),
                                                      //             end: const Color
                                                      //                 .fromARGB(
                                                      //                 255,
                                                      //                 241,
                                                      //                 149,
                                                      //                 10),
                                                      //           ),
                                                      //         ),
                                                      //         TweenSequenceItem(
                                                      //           weight: 1.0,
                                                      //           tween: ColorTween(
                                                      //             begin: const Color
                                                      //                 .fromARGB(
                                                      //                 255,
                                                      //                 186,
                                                      //                 14,
                                                      //                 228),
                                                      //             end: const Color
                                                      //                 .fromARGB(
                                                      //                 255,
                                                      //                 230,
                                                      //                 33,
                                                      //                 11),
                                                      //           ),
                                                      //         ),
                                                      //         TweenSequenceItem(
                                                      //           weight: 1.0,
                                                      //           tween: ColorTween(
                                                      //             begin: const Color
                                                      //                 .fromARGB(
                                                      //                 255,
                                                      //                 228,
                                                      //                 8,
                                                      //                 8),
                                                      //             end: const Color
                                                      //                 .fromARGB(
                                                      //                 255,
                                                      //                 214,
                                                      //                 10,
                                                      //                 91),
                                                      //           ),
                                                      //         ),
                                                      //         TweenSequenceItem(
                                                      //           weight: 1.0,
                                                      //           tween: ColorTween(
                                                      //             begin: const Color
                                                      //                 .fromARGB(
                                                      //                 255,
                                                      //                 229,
                                                      //                 231,
                                                      //                 222),
                                                      //             end: const Color
                                                      //                 .fromARGB(
                                                      //                 255,
                                                      //                 238,
                                                      //                 230,
                                                      //                 239),
                                                      //           ),
                                                      //         ),
                                                      //         TweenSequenceItem(
                                                      //           weight: 1.0,
                                                      //           tween: ColorTween(
                                                      //             begin: const Color
                                                      //                 .fromARGB(
                                                      //                 255,
                                                      //                 40,
                                                      //                 15,
                                                      //                 233),
                                                      //             end: const Color
                                                      //                 .fromARGB(
                                                      //                 255,
                                                      //                 13,
                                                      //                 210,
                                                      //                 13),
                                                      //           ),
                                                      //         ),
                                                      //         TweenSequenceItem(
                                                      //           weight: 1.0,
                                                      //           tween: ColorTween(
                                                      //             begin: const Color
                                                      //                 .fromARGB(
                                                      //                 255,
                                                      //                 60,
                                                      //                 5,
                                                      //                 227),
                                                      //             end: const Color
                                                      //                 .fromARGB(
                                                      //                 255,
                                                      //                 243,
                                                      //                 3,
                                                      //                 3),
                                                      //           ),
                                                      //         ),
                                                      //       ]).evaluate(
                                                      //           AlwaysStoppedAnimation(
                                                      //               value)),
                                                      //       size: 20,
                                                      //     ),
                                                      //   ],
                                                      // ),
                                                      );
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 1), // Reduced padding
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "₹ ${productModel.price.toString()}",
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 243, 6, 176),
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
                                            productModel.location.toString(),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                          productModel.posted_at != null
                                              ? DateFormat(
                                                      'dd MMM yyyy, hh:mm a')
                                                  .format(DateTime.parse(
                                                      productModel.posted_at!))
                                              : 'No date',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromARGB(255, 12, 0, 0),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ));
                      }),
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
                          style: TextStyle(color: Colors.red),
                        ),
                ),
              )
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollController.removeListener(_scrollListener);

    super.dispose();
  }
}
