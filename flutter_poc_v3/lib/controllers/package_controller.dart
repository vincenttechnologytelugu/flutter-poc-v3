// lib/controllers/package_controller.dart

import 'package:get/get.dart';
import 'package:flutter_poc_v3/models/product_model.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class PackageController extends GetxController {
  List<ProductModel> packages = [];
  bool isLoading = false;
  String? error;
   ProductModel? selectedPackage;

  @override
  void onInit() {
    super.onInit();
    getPackages();
  }

  Future<void> getPackages() async {
    try {
      isLoading = true;
      update();

      // Get the token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        error = 'No authentication token found';
        return;
      }

      final response = await http.get(
        Uri.parse('http://172.21.208.1:8080/packages'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        packages.clear();
        
        if (data is List) {
          for (var item in data) {
            packages.add(ProductModel.fromJson(item));
          }
        } else if (data is Map && data.containsKey('data')) {
          final packagesData = data['data'] as List;
          for (var item in packagesData) {
            packages.add(ProductModel.fromJson(item));
          }
        }
        
        log('Packages loaded: ${packages.length}');
      } else {
        error = 'Failed to load packages: ${response.statusCode}';
        log(error!);
      }
    } catch (e) {
      error = 'Error loading packages: $e';
      log(error!);
    } finally {
      isLoading = false;
      update();
    }
  }
  
}
