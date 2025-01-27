// category_based_posts_controller.dart
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product_model.dart';

class CategoryBasedPostsController extends GetxController {
  List<ProductModel> posts = [];
   List<String> categoriesList = [];
   List<ProductModel> productModelList = [];
  bool isLoading = false;
  bool hasMoreData = true;
  int currentPage = 1;
  final String category;
  
  CategoryBasedPostsController({required this.category});

  

  Future<void> getPosts({bool isLoadMore = false}) async {
    if (!isLoadMore) {
      currentPage = 1;
      posts.clear();
    }

    if (!hasMoreData || isLoading) return;

    try {
      isLoading = true;
      update();

      final encodedCategory = Uri.encodeComponent(category);
      final response = await http.get(
         Uri.parse('http://172.21.208.1:8080/adposts?category=$encodedCategory&page=$currentPage'),
       //   Uri.parse('https://jsonplaceholder.typicode.com/posts?category=$encodedCategory&page=$currentPage'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['data'] != null) {
          final List<ProductModel> newPosts = (data['data'] as List)
              .map((item) => ProductModel.fromJson(item))
              .toList();

          posts.addAll(newPosts);
          
          if (newPosts.isEmpty) {
            hasMoreData = false;
          } else {
            currentPage++;
          }
        }
      }
    } catch (e) {
      log('Error fetching posts: $e');
    } finally {
      isLoading = false;
      update();
    }
  }



  


getProductsByCategory(String categories) async {
    try {
      isLoading = true;
      update();
      productModelList.clear();
      
      // Updated URL to fetch all categories
      http.Response response = await http
          .get(
             Uri.parse("http://172.21.208.1:8080/adposts/category/$categories")
            //  Uri.parse("https://jsonplaceholder.typicode.com/posts/category/$categories")
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
}
