// lib/utils/auth_navigation_helper.dart
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_poc_v3/services/auth_service.dart';
import 'package:flutter_poc_v3/protected_screen.dart/home_screen.dart';
import 'package:flutter_poc_v3/public_screen.dart/login_screen.dart';

mixin AuthNavigationHelper {
  Future<void> checkAuthAndNavigate(BuildContext context) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500)); // Reduced delay

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token != null) {
        final authService = AuthService();
        final isValid = await authService.validateAndUpdateAuthUser(token);

        if (!context.mounted) return;

        if (isValid) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          await prefs.remove('token');
          await prefs.remove('user_data');
          
          if (!context.mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      } else {
        if (!context.mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      log('Error in checkAuthAndNavigate: $e');
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }
}
