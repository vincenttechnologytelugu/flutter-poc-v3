import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/protected_screen.dart/cart_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_poc_v3/controllers/cart_controller.dart';
import 'package:flutter_poc_v3/controllers/products_controller.dart';
import 'package:flutter_poc_v3/models/product_model.dart';

import 'package:http/http.dart' as http;

// import 'package:flutter_poc_v3/protected_screen.dart/products_screen.dart';

import 'product_details.dart';

class ResponsiveProductsScreen extends StatefulWidget {
  const ResponsiveProductsScreen({super.key});

  @override
  State<ResponsiveProductsScreen> createState() =>
      _ResponsiveProductsScreenState();
}

class _ResponsiveProductsScreenState extends State<ResponsiveProductsScreen> {
  ProductsController productsController = Get.put(ProductsController());

  CartController cartController = Get.put(CartController());
  final ScrollController _scrollController = ScrollController();

  bool isLoadingMore = false;
  int currentPage = 0;
  final int pageSize = 50; // Adjust page size as needed
  bool hasMoreData = true;

  @override
  void initState() {
    productsController.getData();
    _loadInitialData();
    //productsController.createNewOnePost();
    // productsController.createNewPost();
    // Add scroll listener
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  // Add scroll listener method
  void _scrollListener() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    // Load more when user reaches 80% of the list
    if (currentScroll >= maxScroll * 0.8) {
      loadMoreData();
    }
  }

  Future<void> _loadInitialData() async {
    await productsController.getData(); // Load initial data
  }

// Modify your loadMoreData function
  Future<void> loadMoreData() async {
    if (!isLoadingMore && hasMoreData) {
      setState(() {
        isLoadingMore = true;
      });

      try {
        final response = await http.get(
          Uri.parse(
              "http://172.26.0.1:8080/adposts?page=$currentPage&psize=$pageSize"),
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          final List<dynamic> newProducts = responseData['data'];
          final pagination = responseData['pagination'];

          // Check if we have more pages
          hasMoreData = currentPage < (pagination['totalPages'] - 1);

          if (newProducts.isNotEmpty) {
            setState(() {
              // Add new products to the list
              for (var item in newProducts) {
                productsController.productModelList
                    .add(ProductModel.fromJson(item));
              }
              // Increment page for next load
              currentPage++;
            });
          }
        }
      } catch (e) {
        log('Error loading more data: $e');
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
    log("buildsize width ${size.width}");
    log("buildsize height ${size.height}");
    return GetBuilder<ProductsController>(builder: (productsController) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(8),
            
            child: const Text("Fresh Recomendations")),
          actions: [
            GetBuilder<CartController>(builder: (cartController) {
              return Stack(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (builder) => const CartScreen()));
                      },
                      icon: const Icon(Icons.add_shopping_cart_rounded)),
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.amber,
                    child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(2),
                        child: Text("${cartController.cartList.length}")),
                  )
                ],
              );
            })
          ],
        ),
        body: Column(
          children: [
//             const Text(
//                 """Flutter is a popular mobile app development framework that allows developers to build high-quality and dynamic apps for both iOS and Android platforms.
// It offers a wide range of widgets that developers can use to create user interfaces, but sometimes it can be challenging to create a responsive UI that can adapt to different screen sizes. To solve this problem, Flutter provides the LayoutBuilder widget that helps developers to build responsive UIs.
// In this article, we will discuss what is LayoutBuilder in Flutter, how it works, and how to use it to create responsive UIs."""),
            SizedBox(
              height: 45,
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
                      controller: _scrollController,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: size.width > 1368
                              ? 6
                              : size.width > 767 && size.width < 1368
                                  ? 4
                                  : 2,
                          childAspectRatio: size.width > 1368
                              ? 1.45
                              : size.width > 767 && size.width < 1368
                                  ? 1.0
                                  : 0.9),
                      itemCount: productsController.productModelList.length,
                      itemBuilder: (context, index) {
                        ProductModel productModel =
                            productsController.productModelList[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => ProductDetails(
                                          productModel: productModel,
                                        )));
                          },
                          child: Card(
                            child: Column(
                              children: [
                                Image.network(
                                  productModel.thumb.toString(),
                                  height: 100,
                                  width: double.infinity,
                                  fit: BoxFit.fill,
                                ),
                                Text(
                                  productModel.title.toString(),
                                  maxLines: 1,
                                ),
                                Text(
                                  productModel.category.toString(),
                                  maxLines: 1,
                                ),
                        
                                Text("\$${productModel.price.toString()}"),
                                IconButton(
                                    onPressed: () {
                                      cartController.addToCart(
                                          context, productModel);
                                    },
                                    icon: const Icon(
                                        Icons.add_shopping_cart_outlined))
                              ],
                            ),
                          ),
                        );
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
                      : const Text('Load More',style: TextStyle(color:Colors.red),),
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





