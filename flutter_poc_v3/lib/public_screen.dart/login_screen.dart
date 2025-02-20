import 'dart:convert';
import 'package:flutter/material.dart';

//import 'package:flutter_poc_v3/main.dart';
import 'package:flutter_poc_v3/protected_screen.dart/home_screen.dart';

import 'package:flutter_poc_v3/public_screen.dart/ProfileResponseModel.dart';

import 'package:flutter_poc_v3/public_screen.dart/register_screen.dart';
import 'package:flutter_poc_v3/public_screen.dart/splash_screen.dart';

import 'package:flutter_poc_v3/services/auth_service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:http/http.dart' as http;

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
  // In your login_screen.dart or auth_controller.dart

  // void handleDummyLogin() {
  //   // Dummy credentials
  //   const String dummyEmail = "test@example.com";
  //   const String dummyPassword = "password123";

  //   if (_emailController.text == dummyEmail &&
  //       _passwordController.text == dummyPassword) {
  //     // Show success message
  //     setState(() {
  //       loginMessage = "Login successful!";
  //     });

  //     // Navigate to home screen
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => const HomeScreen()),
  //     );
  //   } else {
  //     // Show error message
  //     setState(() {
  //       loginMessage =
  //           "Invalid credentials. Use test@example.com / password123";
  //     });
  //   }
  // }

  Future<bool> handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are permanently denied')));
      return false;
    }

    return true;
  }

  Future<Position?> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return position;
    } catch (e) {
      log('Error getting location: $e');
      return null;
    }
  }

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
        Uri.parse('http://192.168.0.167:8080/authentication/auth_user'),
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
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SplashScreen()),
            (route) => false, // This removes all previous routes
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
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const SplashScreen()),
              (route) => false, // This removes all previous routes
            );
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (context) => const HomeScreen()),
            // );
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
        Uri.parse('http://192.168.0.167:8080/authentication/login'),
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
        final token = responseData['session'];

        if (token != null && token.toString().isNotEmpty) {
          // Store the token
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);

          setState(() {
            loginMessage = 'Login successful! Checking location permissions...';
            isLoading = false;
          });

          // Request location permission
          bool hasLocationPermission = await handleLocationPermission(context);
          if (!hasLocationPermission) {
            setState(() {
              loginMessage = 'Location permission is required to continue';
            });
            return;
          }

          // Get initial location and save it
          Position? position = await getCurrentLocation();
          if (position == null) {
            setState(() {
              loginMessage = 'Unable to get location. Please try again.';
            });
            return;
          }

          // Save initial location
          await prefs.setDouble('latitude', position.latitude);
          await prefs.setDouble('longitude', position.longitude);

          // Get address from coordinates
          try {
            List<Placemark> placemarks = await placemarkFromCoordinates(
              position.latitude,
              position.longitude,
            );
            if (placemarks.isNotEmpty) {
              Placemark place = placemarks[0];
              String currentLocation =
                  "${place.locality}, ${place.administrativeArea}";
              await prefs.setString('pickedLocation', currentLocation);
            }
          } catch (e) {
            log('Error getting address: $e');
          }

          // Now proceed with user data refresh and navigation
          await refreshUserDataFromApi();
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

//   Future<void> loginUser(String email, String password) async {
//     setState(() {
//       isLoading = true;
//       loginMessage = null;
//     });

//     try {
//       final response = await http.post(
//         Uri.parse('http://192.168.0.167:8080/authentication/login'),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode(<String, String>{
//           'email': email,
//           'password': password,
//         }),
//       );

//       log('Response Status Code: ${response.statusCode}');
//       log('Response Body: ${response.body}');

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final responseData = jsonDecode(response.body);

//         // Get session token from response
//         final token = responseData['session'];
//         if (token != null && token.toString().isNotEmpty) {
//           // Store login data in SharedPreferences
//           final prefs = await SharedPreferences.getInstance();
//           // Store the token
//           await prefs.setString('token', token);

//           setState(() {
//             loginMessage = 'Login successful! Redirecting to home...';
//             isLoading = false;
//           });
//           // Replace Fluttertoast with SnackBar
//           void showMessage(String message, bool isError) {
//             if (mounted) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text("login success"),
//                   backgroundColor: isError ? Colors.red : Colors.green,
//                   duration: const Duration(seconds: 3),
//                 ),
//               );
//             }
//           }

// // Then update your login method to use this:
//           try {
//             // ... login logic ...
//             showMessage('Login successful! Redirecting to home...', false);
//           } catch (e) {
//             showMessage(e.toString(), true);
//           }

//           refreshUserDataFromApi();
//         } else {
//           throw Exception('Session token not received from server');
//         }
//       } else {
//         final errorData = jsonDecode(response.body);
//         throw Exception(errorData['message'] ?? 'Login failed');
//       }
//     } catch (e) {
//       setState(() {
//         loginMessage = 'Error: ${e.toString()}';
//         isLoading = false;
//       });

//       Fluttertoast.showToast(
//         msg: e.toString(),
//         toastLength: Toast.LENGTH_LONG,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//       );
//     }
//   }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg1.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Image.asset("assets/images/bg1.png",
          //     fit: BoxFit.cover,
          //     width: double.infinity,
          //     height: double.infinity

          // ),
          SingleChildScrollView(
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
                  Padding(
                    padding: const EdgeInsets.only(top: 60, left: 20),
                    child: Text("Welcome Back\nPlease Login",
                        style: TextStyle(fontSize: 30, color: Colors.white)),
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
                    onEditingComplete: () {
                      FocusScope.of(context).nextFocus();
                    },
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white),
                      hintText: 'Enter your email',
                      helperStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 250, 248, 248),
                              width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 245, 242, 242),
                              width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                    ),
                  ),
                  textFieldDefaultGap,
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !visiblePassword,
                    textInputAction: TextInputAction.done,
                    onEditingComplete: () {
                      FocusScope.of(context).unfocus();
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.white),
                      hintText: 'Enter your password',
                      helperStyle: TextStyle(color: Colors.white),
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.white,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          visiblePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            visiblePassword = !visiblePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: const Color.fromARGB(255, 250, 248, 248),
                              width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: const Color.fromARGB(255, 245, 242, 242),
                              width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      // color: Colors.pink,
                      width: 50,
                      margin: EdgeInsets.only(left: 90, right: 90),
                      child:
                          //               ElevatedButton(
                          //                 onPressed: isLoading
                          //                     ? null
                          //                     : () {
                          //                         final email = _emailController.text.trim();
                          //                         final password = _passwordController.text;

                          //                         // Comment out your API call logic
                          //                         /*
                          // Your existing API call code here
                          // */

                          //                         // Call dummy login instead
                          //                         handleDummyLogin();
                          //                       },
                          //                 child: Text("Login"),
                          //               ),

                          ElevatedButton(
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
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.blue),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      // Navigate to registration screen
                      // Navigator.pushNamed(context, '/register');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => const RegisterScreen()));
                    },
                    child: const Text("New User? Creat Account",
                        style: TextStyle(
                            color: Color.fromARGB(255, 235, 230, 231),
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 630),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40)),
                color: Colors.white70,
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 246, 241, 242)
                        .withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              height: double.infinity,
              width: double.infinity,
            ),
          ),
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   height: MediaQuery.of(context).size.height *
          //       0.3, // 15% of screen height
          //   child: Container(
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.only(
          //           topRight: Radius.circular(40),
          //           topLeft: Radius.circular(40)),
          //       color: Colors.white,
          //     ),
          //   ),
          // ),

          // Padding(
          //   padding: const EdgeInsets.only(top: 580),
          //   child: Container(
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.only(
          //           topRight: Radius.circular(40),
          //           topLeft: Radius.circular(40)),
          //       color: Colors.white,
          //     ),
          //     height: double.infinity,
          //     width: double.infinity,
          //   ),
          // ),
        ],
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
