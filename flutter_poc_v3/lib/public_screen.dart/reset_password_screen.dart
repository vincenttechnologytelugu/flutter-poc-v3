import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_poc_v3/public_screen.dart/login_screen.dart'; // Make sure this import path is correct

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ResetPasswordScreenState createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  bool validatePassword(String password) {
    // Updated regex to match backend requirements
    final RegExp passwordRegex = RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,12}$',
    );
    return passwordRegex.hasMatch(password);
  }

  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() => _isLoading = true);

        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');

//         if (token == null) {
// ScaffoldMessenger.of(context).showSnackBar(
//   const SnackBar(content: Text("Token Not Found navigate to login")),
// );
//             Navigator.push(
//   context,
//   MaterialPageRoute(builder: (context) => LoginScreen()),
// );
//           throw Exception('No authentication token found');
          
//         }

        log('Sending password update request...');

        final response = await http.post(
          Uri.parse('http://13.200.179.78/authentication/update_password'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            // 'currentPassword': _oldPasswordController.text,
            // 'newPassword': _newPasswordController.text,
            'password': _confirmPasswordController.text,
          }),
        );
        log('Response received: ${response.statusCode}');

        log('Request body: ${jsonEncode({
              'currentPassword': _oldPasswordController.text,
              'newPassword': _newPasswordController.text,
              'confirmPassword': _confirmPasswordController.text,
            })}');
        log('Response status code: ${response.statusCode}');
        log('Response body: ${response.body}');

        if (response.statusCode == 200) {
          if (!mounted) return;

          await prefs.setString('password', _newPasswordController.text);
          await prefs.setString(
              'confirmPassword', _confirmPasswordController.text);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password updated successfully'),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (Route<dynamic> route) => false,
          );
        } else {
          final errorData = jsonDecode(response.body);
          log('Error response: $errorData');
          throw Exception(errorData['error'] ?? 'Failed to update password');
        }
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Password'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Old Password Field
                TextFormField(
                  controller: _oldPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Current Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isOldPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isOldPasswordVisible = !_isOldPasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isOldPasswordVisible,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your current password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // New Password Field
                TextFormField(
                  controller: _newPasswordController,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    border: const OutlineInputBorder(),
                    helperText:
                        'Password must be 6-12 characters long, contain uppercase and lowercase letters, numbers, and special characters',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isNewPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isNewPasswordVisible = !_isNewPasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isNewPasswordVisible,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your new password';
                    }
                    if (!validatePassword(value)) {
                      return 'Password must be 6-12 characters long, contain uppercase and lowercase letters, numbers, and special characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Confirm Password Field
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm New Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isConfirmPasswordVisible,
                  validator: (value) {
                    if (value != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _updatePassword,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Save New Password'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_poc_v3/public_screen.dart/login_screen.dart'; // Make sure this import path is correct

// class ResetPasswordScreen extends StatefulWidget {
//   const ResetPasswordScreen({super.key});

//   @override
//   ResetPasswordScreenState createState() => ResetPasswordScreenState();
// }

// class ResetPasswordScreenState extends State<ResetPasswordScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _oldPasswordController = TextEditingController();
//   final _newPasswordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   bool _isLoading = false;

//   bool validatePassword(String password) {
//     // Regular expression for password validation
//     final RegExp passwordRegex = RegExp(
//       r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'
//       // r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,12}$',
//     );
//     return passwordRegex.hasMatch(password);
//   }

//   bool _isOldPasswordVisible = false;
//   bool _isNewPasswordVisible = false;
//   bool _isConfirmPasswordVisible = false;

//   @override
//   void dispose() {
//     _oldPasswordController.dispose();
//     _newPasswordController.dispose();
//     _confirmPasswordController.dispose();

//     super.dispose();
//   }

//   Future<void> _updatePassword() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         setState(() => _isLoading = true);

//         final prefs = await SharedPreferences.getInstance();
//         final token = prefs.getString('token');

//         if (token == null) {
//           throw Exception('No authentication token found');
//         }

//         // Print for debugging
//         log('Sending password update request...');

//         final response = await http.post(
//           Uri.parse('http://13.200.179.78/authentication/update_password'),
//           headers: {
//             'Content-Type': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//           body: jsonEncode({
//             'currentPassword': _oldPasswordController.text,
//             'newPassword': _newPasswordController.text,
//             'confirmPassword': _confirmPasswordController.text,
//           }),
//         );
//         log('Request body: ${jsonEncode({
//               'currentPassword': _oldPasswordController.text,
//               'newPassword': _newPasswordController.text,
//               'confirmPassword': _confirmPasswordController.text,
//             })}');

//         // Print response for debugging
//         log('Response status code: ${response.statusCode}');
//         log('Response body: ${response.body}');

//         if (response.statusCode == 200) {
//           if (!mounted) return;

//           // Save the new password in SharedPreferences
//           await prefs.setString('password', _newPasswordController.text);
//           await prefs.setString(
//               'confirmPassword', _confirmPasswordController.text);

//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Password updated successfully'),
//               backgroundColor: Colors.green,
//             ),
//           );

//           // Navigate back to login screen
//           Navigator.of(context).pushAndRemoveUntil(
//             MaterialPageRoute(builder: (context) => const LoginScreen()),
//             (Route<dynamic> route) => false,
//           );
//         } else {
//           final errorData = jsonDecode(response.body);
//           log('Error response: $errorData'); // Add this line
//           throw Exception(errorData['message'] ?? 'Failed to update password');
//         }
//       } catch (e) {
//         if (!mounted) return;

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error: ${e.toString()}'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       } finally {
//         if (mounted) {
//           setState(() => _isLoading = false);
//         }
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Update Password'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Old Password Field
//                 TextFormField(
//                   controller: _oldPasswordController,
//                   decoration: InputDecoration(
//                     labelText: 'Current Password',
//                     border: OutlineInputBorder(),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _isOldPasswordVisible
//                             ? Icons.visibility
//                             : Icons.visibility_off,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _isOldPasswordVisible = !_isOldPasswordVisible;
//                         });
//                       },
//                     ),
//                   ),
//                   obscureText: !_isOldPasswordVisible,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your current password';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 20),
//                 TextFormField(
//                   controller: _newPasswordController,
//                   decoration: InputDecoration(
//                     labelText: 'New Password',
//                     border: OutlineInputBorder(),
//                     helperText:
//                         'Password must be 6-12 characters long, contain uppercase and lowercase letters, numbers, and special characters',
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _isNewPasswordVisible
//                             ? Icons.visibility
//                             : Icons.visibility_off,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _isNewPasswordVisible = !_isNewPasswordVisible;
//                         });
//                       },
//                     ),
//                   ),
//                   obscureText: !_isNewPasswordVisible,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your new password';
//                     }
//                     if (!validatePassword(value)) {
//                       return 'Password must be 6-12 characters long, contain uppercase and lowercase letters, numbers, and special characters';
//                     }
//                     return null;
//                   },
//                 ),

//                 SizedBox(height: 20),
//                 TextFormField(
//                   controller: _confirmPasswordController,
//                   decoration: InputDecoration(
//                     labelText: 'Confirm New Password',
//                     border: OutlineInputBorder(),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _isConfirmPasswordVisible
//                             ? Icons.visibility
//                             : Icons.visibility_off,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _isConfirmPasswordVisible =
//                               !_isConfirmPasswordVisible;
//                         });
//                       },
//                     ),
//                   ),
//                   obscureText: !_isConfirmPasswordVisible,
//                   validator: (value) {
//                     if (value != _newPasswordController.text) {
//                       return 'Passwords do not match';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 20),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: _isLoading ? null : _updatePassword,
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 15),
//                     ),
//                     child: _isLoading
//                         ? const CircularProgressIndicator()
//                         : const Text('Save New Password'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
