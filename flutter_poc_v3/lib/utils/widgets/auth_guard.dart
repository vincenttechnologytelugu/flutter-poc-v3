// // lib/widgets/auth_guard.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_poc_v3/public_screen.dart/login_screen.dart';
// import 'package:flutter_poc_v3/services/auth_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AuthGuard extends StatelessWidget {
//   final Widget child;

//   const AuthGuard({super.key, required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<bool>(
//       future: _checkAuthentication(context),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
        
//         if (snapshot.data == true) {
//           return child;
//         }
        
//         return const LoginScreen();
//       },
//     );
//   }

//   Future<bool> _checkAuthentication(BuildContext context) async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
    
//     if (token == null) return false;
    
//     final authService = AuthService();
//     final isValid = await authService.validateAndUpdateAuthUser(token);
//     return isValid;
//   }
// }
// lib/utils/widgets/auth_guard.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_poc_v3/public_screen.dart/login_screen.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({Key? key, required this.child}) : super(key: key);

  Future<bool> _checkAuth(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return false;
      }

      final response = await http.get(
        Uri.parse('http://13.200.179.78/authentication/auth_user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkAuth(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data == true) {
          return child;
        }

        // Navigate to login if not authenticated
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        });

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
