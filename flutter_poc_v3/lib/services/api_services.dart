// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.96.1:8080'; // Update with your server URL
// For real android device
//static const String baseUrl = 'http://192.168.96.1:8080'; // Update with your server URL
  // Get authenticated user details
  static Future<Map<String, dynamic>> getAuthenticatedUser(String token) async {
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
         return responseData;
      }
      return {'error': 'Failed to get user data'};
    } catch (e) {
   return {'error': e.toString()};
    }

  }

  // Login method
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/authentication/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final token = responseData['session'];

        if (token != null) {
          // Save token
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);

          // Get user details
          final userData = await getAuthenticatedUser(token);
          
          // Save user data
          await prefs.setString('user_data', jsonEncode(userData));

          return {
            'token': token,
            'user': userData,
          };
        } else {
          throw Exception('Token not received from server');
        }
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Login failed');
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Register method
  static Future<Map<String, dynamic>> register(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/authentication/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final token = responseData['session'];

        if (token != null) {
          // Save token
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);

          // Get user details
          final userData = await getAuthenticatedUser(token);
          
          // Save user data
          await prefs.setString('user_data', jsonEncode(userData));

          return {
            'token': token,
            'user': userData,
          };
        } else {
          throw Exception('Token not received from server');
        }
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Registration failed');
      }
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  // Validate auth user
  static Future<Map<String, dynamic>> validateAuthUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('No token found');
      }

      final userData = await getAuthenticatedUser(token);
      return {
        'success': true,
        'data': userData,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  // Logout method
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user_data');
  }
}
