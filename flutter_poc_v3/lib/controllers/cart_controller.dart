import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:flutter_poc_v3/models/product_model.dart';

class CartController extends GetxController {
  List<ProductModel> cartList = [];
  


  addToCart(BuildContext context, ProductModel productModel) {
    cartList.add(productModel);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Added to Favourite")));
    update();
  }
  

  removeFromCart(BuildContext context, ProductModel productModel) {
    // Find the index of the first matching item
    final index = cartList.indexWhere((e) => e.id == productModel.id);
    if (index != -1) {
      // Remove only one item at that index
      cartList.removeAt(index);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Removed from Favourite")));
      update();
      } else {
      // Handle the case where the item is not found in the cartList
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Item not found in cart")));
      update();
    }

}


  // removeFromCart(BuildContext context, ProductModel productModel) {
  //   cartList.removeWhere((e) => e.id == productModel.id);
  //   ScaffoldMessenger.of(context)
  //       .showSnackBar(const SnackBar(content: Text("Added to cart")));
  //   update();
  // }
}
