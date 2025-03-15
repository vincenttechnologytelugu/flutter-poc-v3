import 'package:flutter_poc_v3/controllers/location_controller.dart';
// import 'package:flutter_poc_v3/protected_screen.dart/responsive_products_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_poc_v3/models/product_model.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductsController extends GetxController {
  var adPosts = <dynamic>[].obs;
  RxList<ProductModel> products = <ProductModel>[].obs;
  RxBool isLoading = false.obs;
  final LocationController locationController = Get.find<LocationController>();
  String currentCity = '';
  String currentState = '';
  bool isCurrentLocation = false;

  List<ProductModel> productModelList = [];
  List<String> categoriesList = [];
  List<ProductModel> cartItems = [];
  bool isLoadingOne = false;
  bool isLoadingMore = false;
  bool hasMoreData = true;
  int currentPage = 0;
  final int pageSize = 10;
  int totalPages = 0; // Add this to track total pages
  // var products = <ProductModel>[].obs;

  void updateAdPosts(List<dynamic> newAdPosts) {
    adPosts.clear(); // Clear existing posts
    adPosts.addAll(newAdPosts); // Add new posts
  }

  void clearAdPosts() {
    adPosts.clear();
  }

  @override
  void onInit() {
    super.onInit();
    loadInitialLocation();
  }

  void addProducts(List<ProductModel> products) {
    productModelList.addAll(products);
    update(); // Notify listeners
  }

  void clearProducts() {
    productModelList.clear();
    update(); // Notify listeners
  }

  Future<void> loadInitialLocation() async {
    final prefs = await SharedPreferences.getInstance();
    currentCity = prefs.getString('city') ?? '';
    currentState = prefs.getString('state') ?? '';
    isCurrentLocation = prefs.getBool('isCurrentLocation') ?? false;
    if (currentCity.isNotEmpty && currentState.isNotEmpty) {
      await refreshProducts(
          newCity: currentCity,
          newState: currentState,
          isCurrentLocation: isCurrentLocation);
    }
  }

  Future<void> refreshProducts(
      {required String newCity,
      required String newState,
      required bool isCurrentLocation}) async {
    if (!isCurrentLocation &&
        newCity == currentCity &&
        newState == currentState) {
      return;
    }

    isLoading.value = true;
    try {
      // Update current location
      currentCity = newCity;
      currentState = newState;
      this.isCurrentLocation = isCurrentLocation;

      // Save current state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('city', newCity);
      await prefs.setString('state', newState);
      await prefs.setBool('isCurrentLocation', isCurrentLocation);

      // Fetch products based on location
      await fetchProductsByLocation(newCity, newState);
    } catch (e) {
      log('Error refreshing products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  //  Future<List<ProductModel>?> fetchProductsByLocation(String city, String state) async {
  //   try {
  //     // Your existing API call to fetch products
  //     // Make sure to include city and state in the query
  //     final response = await http.get(
  //       Uri.parse("http://13.200.179.78/adposts?city=$city&state=$state"),
  //     );

  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = json.decode(response.body);
  //       return data.map((json) => ProductModel.fromJson(json)).toList();
  //     }
  //     return null;
  //   } catch (e) {
  //     log('Error fetching products: $e');
  //     return null;
  //   }
  // }

  Future<void> fetchProductsByLocation(String city, String state) async {
    try {
      final response = await http.get(
          Uri.parse('http://13.200.179.78/adposts?city=$city&state=$state'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        productModelList.clear();
        for (var item in data) {
          productModelList.add(ProductModel.fromJson(item));
        }
        update();
      }
    } catch (e) {
      log('Error fetching products: $e');
    }
  }

  void updateProducts(String jsonResponse) {
    try {
      final Map<String, dynamic> responseData = json.decode(jsonResponse);
      final List<dynamic> productsJson = responseData['data'] ?? [];

      productModelList.clear(); // Clear existing products

      // Convert JSON to ProductModel objects
      productModelList.addAll(
          productsJson.map((json) => ProductModel.fromJson(json)).toList());

      update(); // Notify listeners
    } catch (e) {
      log('Error parsing products: $e');
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

  // Future<void> _tryFetchWithParams(Map<String, String> queryParams) async {
  //   var uri = Uri.parse('http://13.200.179.78/adposts')
  //       .replace(queryParameters: queryParams);

  //   log('Trying URL: ${uri.toString()}');

  //   try {
  //     var response = await http.get(uri);

  //     if (response.statusCode == 200) {
  //       var jsonData = jsonDecode(response.body);

  //       if (productModelList.isEmpty) {
  //         if (jsonData is Map<String, dynamic> &&
  //             jsonData.containsKey('data')) {
  //           var productsData = jsonData['data'];
  //           if (productsData is List) {
  //             for (var item in productsData) {
  //               productModelList.add(ProductModel.fromJson(item));
  //             }
  //           }
  //         } else if (jsonData is List) {
  //           for (var item in jsonData) {
  //             productModelList.add(ProductModel.fromJson(item));
  //           }
  //         }

  //         log('Found ${productModelList.length} products with params: $queryParams');
  //       }
  //     } else {
  //       log('Request failed with status: ${response.statusCode}');
  //       log('Response body: ${response.body}');
  //     }
  //   } catch (e) {
  //     log('Error in _tryFetchWithParams: $e');
  //   }
  // }
  Future<void> _tryFetchWithParams(Map<String, String> queryParams) async {
    // Return early if no location parameters are provided
    if (queryParams.isEmpty) {
      return;
    }

    var uri = Uri.parse('http://13.200.179.78/adposts')
        .replace(queryParameters: queryParams);

    log('Trying URL: ${uri.toString()}');

    try {
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        productModelList.clear(); // Clear existing list first

        // Extract the products data
        List<dynamic> productsToProcess = [];
        if (jsonData is Map<String, dynamic> && jsonData.containsKey('data')) {
          productsToProcess = jsonData['data'] as List;
        } else if (jsonData is List) {
          productsToProcess = jsonData;
        }

        // Filter and add only exact location matches
        for (var item in productsToProcess) {
          bool cityMatch = true;
          bool stateMatch = true;

          // Check city match if city parameter is provided
          if (queryParams.containsKey('city')) {
            cityMatch = item['city']?.toString().toLowerCase() ==
                queryParams['city']!.toLowerCase();
          }

          // Check state match if state parameter is provided
          if (queryParams.containsKey('state')) {
            stateMatch = item['state']?.toString().toLowerCase() ==
                queryParams['state']!.toLowerCase();
          }

          // Only add if both city and state match (when provided)
          if (cityMatch && stateMatch) {
            productModelList.add(ProductModel.fromJson(item));
          }
        }

        log('Found ${productModelList.length} exact location matches for: $queryParams');
      } else {
        log('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      log('Error in _tryFetchWithParams: $e');
    }

    // If no matching products found, clear the list
    if (productModelList.isEmpty) {
      log('No products found matching location criteria');
    }

    update();
  }

// Helper method to check if product location matches query params
  bool _isLocationMatch(dynamic item, Map<String, String> queryParams) {
    bool matches = true;

    if (queryParams.containsKey('city') && item['city'] != null) {
      matches = matches &&
          item['city'].toString().toLowerCase() ==
              queryParams['city']!.toLowerCase();
    }

    if (queryParams.containsKey('state') && item['state'] != null) {
      matches = matches &&
          item['state'].toString().toLowerCase() ==
              queryParams['state']!.toLowerCase();
    }

    return matches;
  }

  // bool isLoading = false;

  getProductsByCategory(String categories) async {
    try {
      bool isLoading = true;

      update();
      productModelList.clear();

      // Updated URL to fetch all categories
      http.Response response = await http
          .get(Uri.parse("http://13.200.179.78/adposts/category/$categories"));

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
      bool isLoading = false;
      update();
    }
  }

  Future<void> getAllCategories() async {
    try {
      final response =
          await http.get(Uri.parse("http://13.200.179.78/categories"));

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
