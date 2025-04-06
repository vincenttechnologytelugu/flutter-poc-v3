// services/auth_user_service.dart
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/public_screen.dart/login_screen.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class AuthUserService {
  static Future<Map<String, dynamic>> getAuthUserDetails(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    log(token);
    // if (token.isEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Token not found. Please log in again.'),
    //     ),
    //   );
    //       Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => const LoginScreen(),
    //   ),
    //       );
     
    // }

    final response = await http.get(
      Uri.parse('http://13.200.179.78/adposts/authentication/auth_user'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load auth user details');
    }
  }
}
