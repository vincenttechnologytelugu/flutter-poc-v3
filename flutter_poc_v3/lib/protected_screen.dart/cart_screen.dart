import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/protected_screen.dart/product_details.dart';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:flutter_poc_v3/controllers/cart_controller.dart';


import 'package:flutter_poc_v3/models/product_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (cartController) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("My Favourites"),
          // backgroundColor: Colors.purple,
        ),
        body: cartController.cartList.isEmpty
            ? Center(child: Text("No Favourites"))
            : ListView.builder(
                itemCount: cartController.cartList.length,
                itemBuilder: (context, index) {
                  // CartModel cartModel =
                  //            productsController.productModelList[index];
                  ProductModel cartModel = cartController.cartList[index];
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetails(productModel: cartModel),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.all(10),
                      color: const Color.fromARGB(255, 129, 112, 112),
                      shadowColor: const Color.fromARGB(255, 217, 6, 232),
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
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
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                    child: Image.network(
                                      cartModel.thumb.toString(),
                                      width: 210,
                                      height: 140,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                      },
                                      errorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace? stackTrace) {
                                        return const Center(
                                          child: Icon(
                                            Icons
                                                .image_not_supported_outlined, // You can change this icon
                                            size: 80, // Adjust size as needed
                                            color: Color.fromARGB(255, 226, 24, 85), // Adjust color as needed
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
                                        color: Colors.yellow,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          // cartController.addToCart(
                                          //     context, cartModel);
                                        },
                                        icon: const Icon(
                                          Icons.favorite_border_outlined,
                                          // Icons
                                          //     .add_shopping_cart_outlined,
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Text(cartModel.id.toString()),
                          Text(
                            cartModel.title.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            '₹${cartModel.price.toString()}',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),

                          IconButton(
                              onPressed: () {
                                cartController.removeFromCart(
                                    context, cartModel);
                              },
                              icon: Icon(
                                Icons.delete,
                                size: 30,
                                color: const Color.fromARGB(255, 57, 47, 62),
                              ))
                          // TextButton(
                          //     onPressed: () {
                          //       cartController.removeFromCart(
                          //           context, cartModel);
                          //     },
                          //     child:const Text(
                          //       "Remove from Favourite",
                          //       style: TextStyle(color: Colors.red),
                          //     ))
                        ],
                      ),
                    ),
                  );
                }),
      );
    });
  }
}
