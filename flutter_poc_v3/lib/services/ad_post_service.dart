// services/ad_post_service.dart
import 'dart:convert';

import 'package:flutter_poc_v3/models/ad_post_model.dart';
import 'package:http/http.dart' as http;

class AdPostService {
  final String baseUrl = 'http://13.200.179.78/adposts';

  Future<AdPostResponse> getAdPosts({
    String? city,
    String? state,
    String? category,
    String? findkey,
    String? brand,
    String? year,
    String? model,
    String? priceStart,
    String? priceEnd,
    String? salaryStart,
    String? salaryEnd,
    int page = 0,
    int pageSize = 50,
  }) async {
    Map<String, String> queryParams = {
      'page': page.toString(),
      'psize': pageSize.toString(),
    };

    if (city != null) queryParams['city'] = city;
    if (state != null) queryParams['state'] = state;
    if (category != null) queryParams['category'] = category;
    if (findkey != null) queryParams['findkey'] = findkey;
    if (brand != null) queryParams['brand'] = brand;
    if (year != null) queryParams['year'] = year;
    if (model != null) queryParams['model'] = model;
    if (priceStart != null) queryParams['price_start'] = priceStart;
    if (priceEnd != null) queryParams['price_end'] = priceEnd;
    if (salaryStart != null) queryParams['salary_start'] = salaryStart;
    if (salaryEnd != null) queryParams['salary_end'] = salaryEnd;

    final Uri uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return AdPostResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load ad posts');
    }
  }
}
