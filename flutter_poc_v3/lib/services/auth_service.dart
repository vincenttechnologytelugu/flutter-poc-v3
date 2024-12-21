// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://192.168.96.1:8080';

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
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
