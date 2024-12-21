// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_poc_v3/public_screen.dart/login_screen.dart'; // Make sure this import path is correct

// class ForgotPasswordScreen extends StatefulWidget {
//   @override
//   _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
// }

// class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _newPasswordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   bool _isLoading = false;

//   final RegExp _passwordRegex =
//       RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
//   bool _isNewPasswordVisible = false;
//   bool _isConfirmPasswordVisible = false;

//   @override
//   void dispose() {
//     _newPasswordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   Future<void> _updatePassword() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() => _isLoading = true);

//       try {
//         final prefs = await SharedPreferences.getInstance();
//         final token = prefs.getString('token');

//         if (token == null) {
//           throw Exception('No authentication token found');
//         }

//         final response = await http.post(
//           Uri.parse('http://192.168.96.1:8080/authentication/update_password'),
//           headers: {
//             'Content-Type': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//           body: jsonEncode({
//             'newPassword': _newPasswordController.text,
//           }),
//         );

//         if (response.statusCode == 200) {
//           // Show success message
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Password updated successfully')),
//           );

//           // Navigate to LoginScreen
//           Navigator.of(context).pushAndRemoveUntil(
//             MaterialPageRoute(builder: (context) => LoginScreen()),
//             (Route<dynamic> route) => false,
//           );
//         } else {
//           final errorData = jsonDecode(response.body);
//           throw Exception(errorData['error'] ?? 'Failed to update password');
//         }
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: ${e.toString()}')),
//         );
//       } finally {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Update Password'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               TextFormField(
//                 controller: _newPasswordController,
//                 decoration: InputDecoration(
//                   labelText: 'New Password',
//                   border: OutlineInputBorder(),
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _isNewPasswordVisible
//                           ? Icons.visibility
//                           : Icons.visibility_off,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _isNewPasswordVisible = !_isNewPasswordVisible;
//                       });
//                     },
//                   ),
//                 ),
//                 obscureText: !_isNewPasswordVisible,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a new password';
//                   }
//                   if (!_passwordRegex.hasMatch(value)) {
//                     return 'Password must be 6-12 characters long, contain uppercase and lowercase letters, numbers, and special characters';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 20),
//               TextFormField(
//                 controller: _confirmPasswordController,
//                 decoration: InputDecoration(
//                   labelText: 'Confirm New Password',
//                   border: OutlineInputBorder(),
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _isConfirmPasswordVisible
//                           ? Icons.visibility
//                           : Icons.visibility_off,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
//                       });
//                     },
//                   ),
//                 ),
//                 obscureText: !_isConfirmPasswordVisible,
//                 validator: (value) {
//                   if (value != _newPasswordController.text) {
//                     return 'Passwords do not match';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _isLoading ? null : _updatePassword,
//                 child: _isLoading
//                     ? CircularProgressIndicator()
//                     : Text('Save New Password'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
