import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_poc_v3/protected_screen.dart/home_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/responsive_products_screen.dart';
import 'package:flutter_poc_v3/public_screen.dart/login_screen.dart';
import 'package:flutter_poc_v3/public_screen.dart/register_screen.dart';
import 'package:flutter_poc_v3/services/api_services.dart';
import 'package:flutter_poc_v3/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    checkAuthAndNavigate();
    super.initState();
  }

  Future<void> checkAuthAndNavigate() async {
    try {
      // Add a minimum delay for splash screen
      await Future.delayed(const Duration(seconds: 2));

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token != null) {
        // Validate token and get user details
        final authService = AuthService();
        final isValid = await authService.validateAndUpdateAuthUser(token);

        if (mounted) {
          if (isValid) {
            // The auth user object is already saved in SharedPreferences by validateAndUpdateAuthUser
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else {
            // Clear invalid token
            await prefs.remove('token');
            await prefs.remove('user_data');

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          }
        }
      } else {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      }
    } catch (e) {
      // Handle any errors
      print('Error in checkAuthAndNavigate: $e');
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.teal,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              // child: CachedNetworkImage(
              //     height: 150,
              //     imageUrl:
              //         "https://cdn.grabon.in/gograbon/images/merchant/1620713761906/olx-logo.jpg"
              //         ),
            ),
            Text(
              "Welcome to App",
              style: TextStyle(fontSize: 25, color: Colors.white),
            )
          ],
        ));
  }
}
