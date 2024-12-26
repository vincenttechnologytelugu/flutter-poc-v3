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

  Future<void> getData({bool loadMore = false}) async {
    try {
      // Don't proceed if already loading or no more data
      if (loadMore && (!hasMoreData || isLoadingMore)) {
        return;
      }

      // Set loading states
      if (loadMore) {
        isLoadingMore = true;
      } else {
        isLoadingOne = true;
        currentPage = 0;  // Reset page only for fresh load
        productModelList.clear();
      }
      update();

      // Log the current request
      log('Fetching data for page: $currentPage');

      final response = await http.get(
        Uri.parse("http://172.26.0.1:8080/adposts?page=$currentPage&psize=$pageSize"),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> products = responseData['data'];
        final pagination = responseData['pagination'];

        // Update total pages
        totalPages = pagination['totalPages'] ?? 0;
        
        final newProducts = products
            .map((product) => ProductModel.fromJson(product))
            .toList();

        // Add new products to the list
        if (loadMore) {
          productModelList.addAll(newProducts);
        } else {
          productModelList = newProducts;
        }

        // Important: Update currentPage and hasMoreData
        // Increment the page number for the next request
        if (newProducts.isNotEmpty) {
          currentPage++;  // Increment for next page
          hasMoreData = currentPage < totalPages;
        } else {
          hasMoreData = false;
        }

        // Log pagination status
        log('Current Page: $currentPage, Total Pages: $totalPages, Has More: $hasMoreData');

        // Update categories if needed
        Set<String> uniqueCategories = {};
        for (var product in productModelList) {
          if (product.category != null) {
            uniqueCategories.add(product.category!);
          }
        }
        categoriesList = uniqueCategories.toList();
      }
    } catch (e) {
      log('Error fetching data: $e');
      hasMoreData = false;  // Set to false on error
    } finally {
      isLoadingOne = false;
      isLoadingMore = false;
      update();
    }
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
