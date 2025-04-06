import 'package:flutter_poc_v3/models/product_model.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
// import 'package:flutter_poc_v3/models/post_model.dart';

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class CategoryController extends GetxController {
  // List<CategoryModel> categoryModelList = [];
  List<ProductModel> productModelList = [];
  // List<CategoryModel> cartModelList = [];
  List categoriesList = [];
  // List<PostModel>postModelList=[];



  bool isLoadingOne = false;
  bool _hasInitialized = false;
  getData() async {
    if (_hasInitialized) {
      return;
    }
    _hasInitialized = true;
    isLoadingOne = true;
    update();
    http.Response response =
        // await http.get(Uri.parse("https://fakestoreapi.com/products"));
        await http.get(Uri.parse("http://13.200.179.78/categories"));
    var data = jsonDecode(response.body);
    // parsing
    for (var item in data) {
      productModelList.add(ProductModel.fromJson(item));
    }

    log(productModelList.length.toString());
    // log(data.toString());
    isLoadingOne = false;
    update();
  }

  
}
