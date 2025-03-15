// posts_controller.dart
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class PostsController extends GetxController {
  final RxList posts = [].obs;
  final RxBool isLoading = false.obs;
 final Dio dio = Dio();
  Future<void> fetchPosts({
    required String categoryId,
    String? subCategory,
    Map<String, dynamic>? filters,
    required String city,
    required String state,
  }) async {
    try {
      isLoading.value = true;
      
      // Construct query parameters
      final queryParams = {
        'category': categoryId,
        if (subCategory != null) 'subCategory': subCategory,
        'city': city,
        'state': state,
        if (filters != null) ...filters,
      };

      // Make API call
      final response = await dio.get(
        '/api/posts',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        posts.value = response.data['posts'];
      }
    } catch (e) {
      log('Error fetching posts: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
