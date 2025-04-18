// lib/services/auth_service.dart
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://13.200.179.78';
  static Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token != null && token.isNotEmpty;
  }

  static Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Only remove authentication-related data
    await prefs.remove('token');
    // Do not remove user profile data (first_name, last_name, email)

    // Debug log to verify profile data remains
    log('Profile data after logout:');
    log('first_name: ${prefs.getString('first_name')}');
    log('last_name: ${prefs.getString('last_name')}');
    log('email: ${prefs.getString('email')}');
  }

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('first_name', userData['firstName'] ?? '');
    await prefs.setString('last_name', userData['lastName'] ?? '');
    await prefs.setString('email', userData['email'] ?? '');
     await prefs.setString('userId', userData['_id'] ?? ''); // Add this line
      // Save active subscription rules
  if (userData['active_subscription_rules'] != null) {
    await prefs.setString('active_subscription_rules', json.encode(userData['active_subscription_rules']));
    log('Saved active subscription rules: ${userData['active_subscription_rules']}');
  }
  }

  Future<bool> validateAndUpdateAuthUser(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/authentication/auth_user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();

        // Save user details in SharedPreferences
        await prefs.setString('user_data', jsonEncode(responseData));
          await prefs.setString('userId', responseData['_id'] ?? ''); // Add this line
        // In your login success handler


        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  
}
