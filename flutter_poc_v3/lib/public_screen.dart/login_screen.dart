import 'dart:convert';
import 'package:flutter/material.dart';
//import 'package:flutter_poc_v3/main.dart';
import 'package:flutter_poc_v3/protected_screen.dart/home_screen.dart';
import 'package:flutter_poc_v3/public_screen.dart/ProfileResponseModel.dart';

import 'package:flutter_poc_v3/public_screen.dart/reset_password_screen.dart';
import 'package:flutter_poc_v3/public_screen.dart/register_screen.dart';
import 'package:flutter_poc_v3/services/api_services.dart';
import 'package:flutter_poc_v3/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:developer';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final SizedBox textFieldDefaultGap = const SizedBox(height: 16);
  bool visiblePassword = false;
  String? loginMessage;
  bool isLoading = false;
ProfileResponseModel profileData = ProfileResponseModel();

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  // Future<void>handleLogin(String email, String password) async {
  //   try {
  //     setState(() => isLoading = true);

  //     // First login request
  //     final response = await http.post(
  //       Uri.parse('${ApiService.baseUrl}/login'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({
  //         'email': email,
  //         'password': password,
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       final responseData = jsonDecode(response.body);
  //       final token = responseData['session'];

  //       // Save token first
  //       final prefs = await SharedPreferences.getInstance();
  //       await prefs.setString('token', token);

  //       // Then immediately fetch user details with the token
  //       final userResponse = await http.get(
  //         Uri.parse('${ApiService.baseUrl}/authentication/auth_user'),
  //         headers: {
  //           'Authorization': 'Bearer $token',
  //           'Content-Type': 'application/json',
  //         },
  //       );

  //       if (userResponse.statusCode == 200) {
  //         final userData = jsonDecode(userResponse.body);

  //         // Save user data with proper field names
  //         await prefs.setString('first_name', userData['firstName'] ?? '');
  //         await prefs.setString('last_name', userData['lastName'] ?? '');
  //         await prefs.setString('email', userData['email'] ?? '');

  //         // Debug logs to verify data is saved
  //         log('Saved user data:');
  //         log('Token: $token');
  //         log('First Name: ${prefs.getString('first_name')}');
  //         log('Last Name: ${prefs.getString('last_name')}');
  //         log('Email: ${prefs.getString('email')}');
           

  //          refreshUserDataFromApi();
          
  //       } else {
  //         throw Exception('Failed to fetch user details');
  //       }
  //     } else {
  //       throw Exception('Login failed');
  //     }
  //   } catch (e) {
  //     log('Login error: $e');
  //     setState(() => isLoading = false);
  //     Fluttertoast.showToast(
  //       msg: "An error occurred. Please try again.",
  //       backgroundColor: Colors.red,
  //     );
  //   } finally {
  //     setState(() => isLoading = false);
  //   }
  // }



 Future<void> refreshUserDataFromApi() async {
    setState(() => isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        log('No token found');
        return;
      }

      // Make API call to get user details
      final response = await http.get(
        Uri.parse('http://172.26.0.1:8080/authentication/auth_user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final userDetails = jsonDecode(response.body);
        log('User details: $userDetails');
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        profileData = ProfileResponseModel.fromJson(responseData);
        setState(() {
          isLoading = false;
        });
        log('User details: $userDetails');
        // Update SharedPreferences with latest data
        await prefs.setString('first_name', profileData.firstName ?? '');
        await prefs.setString('last_name', profileData.lastName ?? '');
        await prefs.setString('email', profileData.email ?? '');
        if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }
      }
    } catch (e) {
      log('Error refreshing user data: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }


  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      try {
        // Call the API to validate the token and get auth user
        final authService = AuthService();
        final isValid = await authService.validateAndUpdateAuthUser(token);

        if (isValid) {
          // Token is valid, navigate to HomeScreen
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }
        } else {
          // Token is invalid, clear it and stay on LoginScreen
          await prefs.remove('token');
          await prefs.remove('user_data');
        }
      } catch (e) {
        // Handle any errors
        log('Error validating token: $e');
        // Optionally show an error message to the user
      }
    }
    // If no token or invalid token, stay on LoginScreen
  }

  Future<void> loginUser(String email, String password) async {
    setState(() {
      isLoading = true;
      loginMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('http://172.26.0.1:8080/authentication/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      log('Response Status Code: ${response.statusCode}');
      log('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        // Get session token from response
        final token = responseData['session'];
        if (token != null && token.toString().isNotEmpty) {
          // Store login data in SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          // Store the token
          await prefs.setString('token', token);

          setState(() {
            loginMessage = 'Login successful! Redirecting to home...';
            isLoading = false;
          });

          // Show success toast
          Fluttertoast.showToast(
            msg: "Login successful!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
          );
refreshUserDataFromApi();
          // if (mounted) {
          //   Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(builder: (context) => const HomeScreen()),
          //   );
          // }
        } else {
          throw Exception('Session token not received from server');
        }
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Login failed');
      }
    } catch (e) {
      setState(() {
        loginMessage = 'Error: ${e.toString()}';
        isLoading = false;
      });

      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Login"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // CachedNetworkImage(
              //   height: 150,
              //   imageUrl:
              //       "https://static.vecteezy.com/ti/vetor-gratis/p1/15271968-design-de-icone-plano-de-homem-de-negocios-conceito-de-icone-de-recurso-humano-e-empresario-icone-de-homem-em-estilo-plano-da-moda-simbolo-para-o-design-do-seu-site-logotipo-app-vetor.jpg",
              //   placeholder: (context, url) =>
              //       const CircularProgressIndicator(),
              //   errorWidget: (context, url, error) => const Icon(Icons.error),
              // ),
              const SizedBox(height: 24),
              Text(
                "Welcome Back\nPlease Login to Your Account",
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              if (loginMessage != null)
                Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.only(bottom: 16.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: loginMessage!.contains('successful')
                        ? Colors.green.shade100
                        : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    loginMessage!,
                    style: TextStyle(
                      color: loginMessage!.contains('successful')
                          ? Colors.green.shade800
                          : Colors.red.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),
              textFieldDefaultGap,
              TextFormField(
                controller: _passwordController,
                obscureText: !visiblePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      visiblePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        visiblePassword = !visiblePassword;
                      });
                    },
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              //TextButton("Forgot Password",style: TextStyle(fontSize: 25,color: Colors.blue),),
              // TextButton(onPressed: (){
              //    Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (ctx) =>  ResetPasswordScreen()));
              // }, child: Text("Forgot Password",
              // style: TextStyle(fontSize: 20,color: Colors.blue),
              // )
              // ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: Container(
                  color: Colors.pink,
                  width: 50,
                  margin: EdgeInsets.only(left: 90, right: 90),
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            final email = _emailController.text.trim();
                            final password = _passwordController.text;
                            if (email.isNotEmpty && password.isNotEmpty) {
                              loginUser(email, password);
                            } else {
                              Fluttertoast.showToast(
                                msg: "Please fill in all fields",
                                backgroundColor: Colors.red,
                              );
                            }
                          },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Login',
                              style:
                                  TextStyle(fontSize: 25, color: Colors.blue),
                            ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(height: 100),
              TextButton(
                onPressed: () {
                  // Navigate to registration screen
                  // Navigator.pushNamed(context, '/register');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => const RegisterScreen()));
                },
                child: const Text(
                  "New User? Creat Account",
                  style: TextStyle(color: Colors.blue, fontSize: 25),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class User {
  final String id;
  final String email;
   final String firstName;
  final String lastName;
  // Add other relevant fields

  User({
    required this.id,
    required this.email,
      required this.firstName,
    required this.lastName,
    // Add other required fields
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
       firstName: json['firstName'],
      lastName: json['lastName'],
      // Map other fields
    );
  }
}
