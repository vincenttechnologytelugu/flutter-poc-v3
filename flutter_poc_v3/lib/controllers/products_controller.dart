// import 'package:get/get_state_manager/get_state_manager.dart';
// // import 'package:flutter_poc_v3/models/post_model.dart';
// import 'package:flutter_poc_v3/models/product_model.dart';
// import 'dart:convert';
// import 'dart:developer';
// import 'package:http/http.dart' as http;

// class ProductsController extends GetxController {
//   List<ProductModel> productModelList = [];
//   List<ProductModel> cartModelList = [];
//   List categoriesList = [];
//   // List<PostModel>postModelList=[];

// // bool isLoading = false;
// //  getPost() async{
 
// //     isLoading=true;
// //      update();
// //    http.Response response = 
// //    await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
// // var post=jsonDecode(response.body);

// // for(var item in post){
// // postModelList.add(PostModel.fromJson(item));
// // }
// // log(postModelList.length.toString());

// //   isLoading=false;
// //   update();

// //   }


//   bool isLoadingOne = false;
//  getData() async {
//   isLoadingOne = true;
//   update();
//   try {
//     http.Response response = await http.get(Uri.parse("http://172.26.0.1:8080/adposts"));
//     log('Response body: ${response.body}'); // Add this line to see the response
    
//     var data = jsonDecode(response.body);
    
//     // If the response is a single object
//     if (data is Map<String, dynamic>) {
//       productModelList.add(ProductModel.fromJson(data));
//     }
//     // If the response is an array
//     else if (data is List) {
//       for (var item in data) {
//         productModelList.add(ProductModel.fromJson(item));
//       }
//     }
    
//     log('Number of products: ${productModelList.length}');
//   } catch (e) {
//     log('Error: $e');
//   } finally {
//     isLoadingOne = false;
//     update();
//   }
// }

  
//   bool isLoading = false;

//   getProductsByCategory(String category) async {
//     isLoading = true;
//     update();
//     productModelList.clear();
//     http.Response response = await http
//         .get(Uri.parse("http://172.26.0.1:8080/category/$category"));
//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body);
//       for (var item in data) {
//         productModelList.add(ProductModel.fromJson(item));
//       }
//     }
//     isLoading = false;
//     update();
//   }

//   // createNewPost() async {
//   //   http.Response response = await http.post(
//   //       Uri.parse("https://dummyjson.com/posts/add"),
//   //       headers: {'Content-Type': 'application/json'},
//   //       body: jsonEncode({"title": "Sai gpo", "userId": 5}));
//   //   if (response.statusCode == 201) {
//   //     log("response ${response.statusCode}");
//   //     log("response ${response.body}");
//   //   } else {
//   //     // api failed
//   //   }
//   }
  

//   // deletPost() async {
//   //   http.Response response = await http.delete(
//   //       Uri.parse("https://dummyjson.com/posts/add"),
//   //       headers: {'Content-Type': 'application/json'},
//   //       body: jsonEncode({"title": "Sai gpo", "userId": 5}));
//   //   if (response.statusCode == 201) {
//   //     log("response ${response.statusCode}");
//   //     log("response ${response.body}");
//   //   } else {
//   //     // api failed
//   //   }
//   // }

//   // editPost() async {
//   //   http.Response response = await http.patch(
//   //       Uri.parse("https://dummyjson.com/posts/add"),
//   //       headers: {'Content-Type': 'application/json'},
//   //       body: jsonEncode({"title": "Sai gpo", "userId": 5}));
//   //   if (response.statusCode == 201) {
//   //     log("response ${response.statusCode}");
//   //     log("response ${response.body}");
//   //   } else {
//   //     // api failed
//   //   }
//   // }
// // }



import 'package:get/get.dart';
import 'package:flutter_poc_v3/models/product_model.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;


// lib/controllers/products_controller.dart

class ProductsController extends GetxController {
  List<ProductModel> productModelList = [];
  List<String> categoriesList = [];
  bool isLoadingOne = false;
  bool isLoadingMore = false;
  bool hasMoreData = true;
  int currentPage = 0;
  final int pageSize = 10;
  int totalPages = 0;  // Add this to track total pages

  // Future<void> getData({bool loadMore = false}) async {
  //   try {
  //     // Don't proceed if already loading or no more data
  //     if (loadMore && (!hasMoreData || isLoadingMore)) {
  //       return;
  //     }

  //     // Set loading states
  //     if (loadMore) {
  //       isLoadingMore = true;
  //     } else {
  //       isLoadingOne = true;
  //       currentPage = 0;  // Reset page only for fresh load
  //       productModelList.clear();
  //     }
  //     update();

  //     // Log the current request
  //     log('Fetching data for page: $currentPage');

  //     final response = await http.get(
  //       Uri.parse("http://172.26.0.1:8080/adposts?page=$currentPage&psize=$pageSize"),
  //     );

  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> responseData = json.decode(response.body);
  //       final List<dynamic> products = responseData['data'];
  //       final pagination = responseData['pagination'];

  //       // Update total pages
  //       totalPages = pagination['totalPages'] ?? 0;
        
  //       final newProducts = products
  //           .map((product) => ProductModel.fromJson(product))
  //           .toList();

  //       // Add new products to the list
  //       if (loadMore) {
  //         productModelList.addAll(newProducts);
  //       } else {
  //         productModelList = newProducts;
  //       }

  //       // Important: Update currentPage and hasMoreData
  //       // Increment the page number for the next request
  //       if (newProducts.isNotEmpty) {
  //         currentPage++;  // Increment for next page
  //         hasMoreData = currentPage < totalPages;
  //       } else {
  //         hasMoreData = false;
  //       }

  //       // Log pagination status
  //       log('Current Page: $currentPage, Total Pages: $totalPages, Has More: $hasMoreData');

  //       // Update categories if needed
  //       Set<String> uniqueCategories = {};
  //       for (var product in productModelList) {
  //         if (product.category != null) {
  //           uniqueCategories.add(product.category!);
  //         }
  //       }
  //       categoriesList = uniqueCategories.toList();
  //     }
  //   } catch (e) {
  //     log('Error fetching data: $e');
  //     hasMoreData = false;  // Set to false on error
  //   } finally {
  //     isLoadingOne = false;
  //     isLoadingMore = false;
  //     update();
  //   }
  // }


  

 getData() async {
  try {
    isLoadingOne = true;
    update();
    
    http.Response response = await http.get(Uri.parse("http://172.26.0.1:8080/adposts"));
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
  //       .get(Uri.parse("http://172.26.0.1:8080/categories/$categories"));
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
             Uri.parse("http://172.26.0.1:8080/adposts/category/$categories")
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
        Uri.parse("http://172.26.0.1:8080/categories")
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
