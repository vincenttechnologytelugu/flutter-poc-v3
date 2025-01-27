



import 'package:get/get.dart';
import 'package:flutter_poc_v3/models/product_model.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;




class ProductsController extends GetxController {
  List<ProductModel> productModelList = [];
  List<String> categoriesList = [];
   List<ProductModel> cartItems = [];
  bool isLoadingOne = false;
  bool isLoadingMore = false;
  bool hasMoreData = true;
  int currentPage = 0;
  final int pageSize = 10;
  int totalPages = 0;  // Add this to track total pages

   
 
 
  

 getData() async {
  try {
    isLoadingOne = true;
    update();
    
     http.Response response = await http.get(Uri.parse("http://172.21.208.1:8080/adposts"));
   //  http.Response response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
    var data = jsonDecode(response.body);
    
    productModelList.clear(); // Clear existing list before adding new items
    
    // Check if the response is a Map or List and handle accordingly
    if (data is Map<String, dynamic>) {
      // If the response is a paginated response with 'data' field
      if (data.containsKey('data')) {
        var products = data['data'];
        if (products is List) {
          for (var item in products) {
            productModelList.add(ProductModel.fromJson(item));
          }
        }
      } else {
        // If it's a single product
        productModelList.add(ProductModel.fromJson(data));
      }
    } else if (data is List) {
      // If the response is directly a list of products
      for (var item in data) {
        productModelList.add(ProductModel.fromJson(item));
      }
    }

    log('Number of products loaded: ${productModelList.length}');
  } catch (e) {
    log('Error fetching data: $e');
  } finally {
    isLoadingOne = false;
    update();
  }
}

















 






  //   bool isLoading = false;

  // getProductsByCategory(String categories) async {
  //   isLoading = true;
  //   update();
  //   productModelList.clear();
  //   http.Response response = await http
  //       .get(Uri.parse("http://172.21.208.1:8080/categories/$categories"));
  //   if (response.statusCode == 200) {
  //     var data = jsonDecode(response.body);
  //     for (var item in data) {
  //       productModelList.add(ProductModel.fromJson(item));
  //     }
  //   }
  //   isLoading = false;
  //   update();
  // }


bool isLoading = false;

getProductsByCategory(String categories) async {
    try {
      isLoading = true;
      update();
      productModelList.clear();
      
      // Updated URL to fetch all categories
      http.Response response = await http
          .get(
             Uri.parse("http://172.21.208.1:8080/adposts/category/$categories")
            );
      
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        
        // If the response is paginated
        if (data is Map<String, dynamic> && data.containsKey('data')) {
          var products = data['data'];
          for (var item in products) {
            productModelList.add(ProductModel.fromJson(item));
          }
        } 
        // If the response is a direct array
        else if (data is List) {
          for (var item in data) {
            productModelList.add(ProductModel.fromJson(item));
          }
        }

        // Update categories list
        Set<String> uniqueCategories = {};
        for (var product in productModelList) {
          if (product.category != null && product.category!.isNotEmpty) {
            uniqueCategories.add(product.category!);
          }
        }
        categoriesList = uniqueCategories.toList();
        
        log('Categories found: ${categoriesList.length}');
        log('Categories: $categoriesList');
      }
    } catch (e) {
      log('Error fetching categories: $e');
    } finally {
      isLoading = false;
      update();
    }
}








Future<void> getAllCategories() async {
    try {
      final response = await http.get(
        Uri.parse("http://172.21.208.1:8080/categories")
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          categoriesList = List<String>.from(data);
        }
        log('All categories loaded: ${categoriesList.length}');
      }
    } catch (e) {
      log('Error loading categories: $e');
    }
    update();
  }








  

 





  // Helper method to reset the controller
  void reset() {
    currentPage = 0;
    hasMoreData = true;
    productModelList.clear();
    isLoadingOne = false;
    isLoadingMore = false;
    update();
  }
}
