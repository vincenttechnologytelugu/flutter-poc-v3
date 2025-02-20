
import 'package:get/get.dart';
import 'package:flutter_poc_v3/models/product_model.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductsController extends GetxController {
  List<ProductModel> productModelList = [];
  List<String> categoriesList = [];
  List<ProductModel> cartItems = [];
  bool isLoadingOne = false;
  bool isLoadingMore = false;
  bool hasMoreData = true;
  int currentPage = 0;
  final int pageSize = 10;
  int totalPages = 0; // Add this to track total pages
  var products = <ProductModel>[].obs;





  void updateProducts(String responseBody) {
    try {
      final dynamic jsonData = json.decode(responseBody);
      products.clear(); // Clear existing products

      if (jsonData is List) {
        products.addAll(
          jsonData.map((data) => ProductModel.fromJson(data)).toList(),
        );
      } else if (jsonData is Map) {
        // If response is a map with a data field containing the list
        final List<dynamic> productsList = jsonData['data'] ?? [];
        products.addAll(
          productsList.map((data) => ProductModel.fromJson(data)).toList(),
        );
      }
      update();
    } catch (e) {
      log('Error updating products: $e');
    }
  }

  Future<void> getData() async {
    try {
      isLoadingOne = true;
      update();

      final prefs = await SharedPreferences.getInstance();
      String city = prefs.getString('city') ?? '';
      String state = prefs.getString('state') ?? '';

      log('Location details - City: $city, State: $state');

      // Try with city and state combination first
      if (city.isNotEmpty && state.isNotEmpty) {
        await _tryFetchWithParams({'city': city, 'state': state});
      }
      // If no results, try with state only
      else if (state.isNotEmpty && productModelList.isEmpty) {
        await _tryFetchWithParams({'state': state});
      }
      // If no results and have city, try with city only
      else if (city.isNotEmpty && productModelList.isEmpty) {
        await _tryFetchWithParams({'city': city});
      }
    } catch (e, stackTrace) {
      log('Error: $e');
      log('Stack trace: $stackTrace');
    } finally {
      isLoadingOne = false;
      update();
    }
  }

  Future<void> _tryFetchWithParams(Map<String, String> queryParams) async {
    var uri = Uri.parse('http://192.168.0.167:8080/adposts')
        .replace(queryParameters: queryParams);

    log('Trying URL: ${uri.toString()}');

    try {
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        if (productModelList.isEmpty) {
          if (jsonData is Map<String, dynamic> &&
              jsonData.containsKey('data')) {
            var productsData = jsonData['data'];
            if (productsData is List) {
              for (var item in productsData) {
                productModelList.add(ProductModel.fromJson(item));
              }
            }
          } else if (jsonData is List) {
            for (var item in jsonData) {
              productModelList.add(ProductModel.fromJson(item));
            }
          }

          log('Found ${productModelList.length} products with params: $queryParams');
        }
      } else {
        log('Request failed with status: ${response.statusCode}');
        log('Response body: ${response.body}');
      }
    } catch (e) {
      log('Error in _tryFetchWithParams: $e');
    }
  }

  // getData() async {
  //   try {
  //     isLoadingOne = true;
  //     update();

  //     http.Response response =
  //         await http.get(Uri.parse("http://192.168.0.167:8080/adposts"));
  //     //  http.Response response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
  //     var data = jsonDecode(response.body);

  //     productModelList.clear(); // Clear existing list before adding new items

  //     // Check if the response is a Map or List and handle accordingly
  //     if (data is Map<String, dynamic>) {
  //       // If the response is a paginated response with 'data' field
  //       if (data.containsKey('data')) {
  //         var products = data['data'];
  //         if (products is List) {
  //           for (var item in products) {
  //             productModelList.add(ProductModel.fromJson(item));
  //           }
  //         }
  //       } else {
  //         // If it's a single product
  //         productModelList.add(ProductModel.fromJson(data));
  //       }
  //     } else if (data is List) {
  //       // If the response is directly a list of products
  //       for (var item in data) {
  //         productModelList.add(ProductModel.fromJson(item));
  //       }
  //     }

  //     log('Number of products loaded: ${productModelList.length}');
  //   } catch (e) {
  //     log('Error fetching data: $e');
  //   } finally {
  //     isLoadingOne = false;
  //     update();
  //   }
  // }

  //   bool isLoading = false;

  // getProductsByCategory(String categories) async {
  //   isLoading = true;
  //   update();
  //   productModelList.clear();
  //   http.Response response = await http
  //       .get(Uri.parse("http://192.168.0.167:8080/categories/$categories"));
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
      http.Response response = await http.get(
          Uri.parse("http://192.168.0.167:8080/adposts/category/$categories"));

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
      final response =
          await http.get(Uri.parse("http://192.168.0.167:8080/categories"));

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
