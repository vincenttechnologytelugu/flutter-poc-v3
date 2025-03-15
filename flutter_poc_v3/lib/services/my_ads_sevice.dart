// lib/services/my_ads_service.dart
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyAdsService {
  static const String baseUrl = 'http://13.200.179.78';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Map<String, String> _getHeaders(String token) {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<List<dynamic>> getMyAds() async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('No token found');

      final response = await http.get(
        Uri.parse('$baseUrl/adposts/my_ads'),
        headers: _getHeaders(token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'] ?? [];
      }
      throw Exception('Failed to load my ads');
    } catch (e) {
      throw Exception('Error getting my ads: $e');
    }
  }

  Future<bool> removeAd(String adpostId) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('No token found');

      final response = await http.post(
        Uri.parse('$baseUrl/adposts/remove'),
        headers: _getHeaders(token),
        body: jsonEncode({'adpostId': adpostId}),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error removing ad: $e');
    }
  }

  Future<Map<String, dynamic>> markAsInactive(String adId) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('No token found');

      final response = await http.post(
        Uri.parse('$baseUrl/adposts/mark_as_inactive'),
        headers: _getHeaders(token),
        body: jsonEncode({'adpostId': adId}),
      );

      log("API Response: ${response.body}"); // Add this to debug

      if (response.statusCode == 200) {
        // Since we need the ad data for the DeactivateScreen, let's fetch it
        final getResponse = await http.get(
          Uri.parse('$baseUrl/adposts/my_ads'),
          headers: _getHeaders(token),
        );

        if (getResponse.statusCode == 200) {
          final data = jsonDecode(getResponse.body);
          final adData = (data['data'] as List).firstWhere(
            (ad) => ad['_id'] == adId,
            orElse: () => null,
          );
          return adData;
        }
        throw Exception('Failed to get updated ad data');
      }
      throw Exception('Failed to mark as inactive');
    } catch (e) {
      throw Exception('Error marking as inactive: $e');
    }
  }

  // Future<Map<String, dynamic>> markAsInactive(String adpostId) async {
  //   try {
  //     final token = await _getToken();
  //     if (token == null) throw Exception('No token found');

  //     final response = await http.post(
  //       Uri.parse('$baseUrl/adposts/mark_as_inactive'),
  //       headers: _getHeaders(token),
  //       body: jsonEncode({'adpostId': adpostId}),
  //     );

  //     if (response.statusCode == 200) {
  //       return jsonDecode(response.body);

  //     }
  //     throw Exception('Failed to mark as inactive');
  //   } catch (e) {
  //     throw Exception('Error marking as inactive: $e');
  //   }
  // }

  Future<Map<String, dynamic>> publishAd(String adpostId) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('No token found');

      final response = await http.post(
        Uri.parse('$baseUrl/adposts/publish'),
        headers: _getHeaders(token),
        body: jsonEncode({'adpostId': adpostId}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      throw Exception('Failed to publish ad');
    } catch (e) {
      throw Exception('Error publishing ad: $e');
    }
  }

  Future<Map<String, dynamic>> markAsSold(String adpostId) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('No token found');

      final response = await http.post(
        Uri.parse('$baseUrl/adposts/mark_as_sold'),
        headers: _getHeaders(token),
        body: jsonEncode({'adpostId': adpostId}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      throw Exception('Failed to mark as sold');
    } catch (e) {
      throw Exception('Error marking as sold: $e');
    }
  }

  Future<Map<String, dynamic>> updateAd(
      String adpostId, Map<String, dynamic> updates) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('No token found');

      final response = await http.post(
        Uri.parse('$baseUrl/adposts/update'),
        headers: _getHeaders(token),
        body: jsonEncode({
          'adpost': {
            '_id': adpostId,
            ...updates,
          },
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      throw Exception('Failed to update ad');
    } catch (e) {
      throw Exception('Error updating ad: $e');
    }
  }

  // In my_ads_service.dart
  Future<bool> makeFeatured(String adId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.post(
        Uri.parse('http://13.200.179.78/adposts/make_featured'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'adpostId': adId}),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to make featured: $e');
    }
  }
}
