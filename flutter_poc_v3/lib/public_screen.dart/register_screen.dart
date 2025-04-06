// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/controllers/location_controller.dart';
import 'package:flutter_poc_v3/controllers/products_controller.dart';
import 'package:flutter_poc_v3/protected_screen.dart/home_screen.dart';

import 'package:flutter_poc_v3/protected_screen.dart/responsive_products_screen.dart';

import 'package:flutter_poc_v3/public_screen.dart/login_screen.dart';
import 'package:flutter_poc_v3/public_screen.dart/splash_screen.dart';
import 'package:flutter_poc_v3/services/api_services.dart';
import 'package:flutter_poc_v3/services/auth_service.dart';
import 'package:flutter_poc_v3/utils/auth_navigation_helper.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>   {
  final _formKey = GlobalKey<FormState>();
  SizedBox textFieldDefaultGap = const SizedBox(height: 10);
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final locationController = Get.find<LocationController>();

  bool vissiblePassword = true;
  bool sanitizeAndCheckEmailAndPassword(String email, String password) {
    // Email validation
    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);

    // Password validation
    bool passwordValid =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
            .hasMatch(password);

    return emailValid && passwordValid;
  }


 Future<void> checkAuthAndNavigate() async {
    try {
      // Add a minimum delay for splash screen
      await Future.delayed(const Duration(seconds: 1));

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token != null) {
        // Validate token and get user details
        final authService = AuthService();
        final isValid = await authService.validateAndUpdateAuthUser(token);

        if (mounted) {
          if (isValid) {
            // The auth user object is already saved in SharedPreferences by validateAndUpdateAuthUser
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()
              ),
              (Route<dynamic> route) => false,
            );
              
            
          }
 
           else {
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
      log('Error in checkAuthAndNavigate: $e');
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }



  // In your auth controller or registration handler
// In your register_screen.dart file
  Future<void> handleRegistrationSuccess() async {
    try {
      if (!mounted) return;

      Position position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String city = place.locality ?? '';
        String state = place.administrativeArea ?? '';

        // Save location to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('city', place.locality ?? '');
        await prefs.setString('state', place.administrativeArea ?? '');

        // Update LocationController
        final locationController = Get.find<LocationController>();
        locationController.updateLocation(city: city, state: state
            // city: place.locality ?? '',
            // state: place.administrativeArea ?? '',
            );

        // Fetch products with new location
        await _fetchProductsWithLocation(
            place.locality ?? '', place.administrativeArea ?? '');
      }
    } catch (e) {
      log('Error in handleRegistrationSuccess: $e');
    }
  }

  Future<void> _fetchProductsWithLocation(String city, String state) async {
    try {
      final response = await http.get(
        Uri.parse('http://13.200.179.78/adposts?city=$city&state=$state'),
      );

      if (response.statusCode == 200) {
        final productsController = Get.find<ProductsController>();
        productsController.updateProducts(response.body);
      }
    } catch (e) {
      log('Error fetching products: $e');
    }
  }

  

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
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high,
      );
      return position;
    } catch (e) {
      log('Error getting location: $e');
      return null;
    }
  }

  bool isLoading = false;
// function to register to user
//   Future<void> registerUser(
//       String firstName, String lastName, String email, String password) async {
//     try {
//       if (!mounted) return; // Add this check
//       if (!sanitizeAndCheckEmailAndPassword(email, password)) {
//         throw Exception('Invalid email or password format');
//       }
//       if (!mounted) return;
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return const Center(child: CircularProgressIndicator());
//         },
//       );

//       final response = await http.post(
//         Uri.parse("http://13.200.179.78/authentication/register"),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode(<String, String>{
//           'first_name': firstName,
//           'last_name': lastName,
//           'email': email,
//           'password': password,
//         }),
//       );

//       // Add these debug logs
//       log('Response Status Code: ${response.statusCode}');
//       log('Response Body: ${response.body}');
//       log('Response Headers: ${response.headers}');

//       // Hide loading indicator
//       if (context.mounted) {
//         if (!mounted) return;
//         Navigator.pop(context);
//       }

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final responseData = jsonDecode(response.body);

//         // Initialize prefs before using it
//         final SharedPreferences prefs = await SharedPreferences.getInstance();
//         // Add this call after saving user data
//         _onRegistrationSuccess(); // Call the new method he
// // Before navigating to home screen, check location permission
//         final hasPermission = await handleLocationPermission(context);
//         if (!hasPermission) {
//           Fluttertoast.showToast(
//             msg: "Location permission is required to continue",
//             backgroundColor: Colors.red,
//           );
//           return;
//         }

//         // Get current location
//         final position = await getCurrentLocation();
//         if (position == null) {
//           Fluttertoast.showToast(
//             msg: "Failed to get location. Please try again.",
//             backgroundColor: Colors.red,
//           );
//           return;
//         }
// // After successful registration/login
//         await Get.find<LocationController>().updateToCurrentLocation();

//         // Save location to SharedPreferences
//         // final prefs = await SharedPreferences.getInstance();
//         await prefs.setDouble('latitude', position.latitude);
//         await prefs.setDouble('longitude', position.longitude);

//         // Save user data immediately after successful registration
//         await prefs.setString('first_name', firstNameController.text.trim());
//         await prefs.setString('last_name', lastNameController.text.trim());
//         await prefs.setString('email', emailController.text.trim());

//         // Debug log to verify data is saved
//         log('User data saved after registration:');
//         log('first_name: ${prefs.getString('first_name')}');
//         log('last_name: ${prefs.getString('last_name')}');
//         log('email: ${prefs.getString('email')}');

//         // Changed from 'token' to 'session'
//         final token = responseData['session'];
//         if (token != null && token.toString().isNotEmpty) {
//           // Save token and user data
//           final prefs = await SharedPreferences.getInstance();
//           await prefs.setString('token', token);
//           // In registration
//           log('Saved user data: ${firstNameController.text}, ${lastNameController.text}, ${emailController.text}');

// // In profile loading
//           log('Loaded user data: $firstName, $lastName, $email');

//           // Save user data - Add these lines
//           await prefs.setString('first_name', firstName);
//           await prefs.setString('last_name', lastName);
//           await prefs.setString('email', email);

// // Debug log after saving
//           log('Verification - Saved data:');
//           log('first_name: ${prefs.getString('first_name')}');
//           log('last_name: ${prefs.getString('last_name')}');
//           log('email: ${prefs.getString('email')}');
//           // Save user data from the 'data' object
//           if (responseData['data'] != null) {
//             await prefs.setString(
//                 'first_name', responseData['data']['first_name']);
//             await prefs.setString(
//                 'last_name', responseData['data']['last_name']);
//             await prefs.setString('email', responseData['data']['email']);
//           }
//           // Add after saving data
//           log('Saved user data - First Name: ${prefs.getString('first_name')}');
//           log('Saved user data - Last Name: ${prefs.getString('last_name')}');
//           log('Saved user data - Email: ${prefs.getString('email')}');

//           // Show success message
//           Fluttertoast.showToast(
//             msg: responseData['message'] ?? "Registration successful!",
//             toastLength: Toast.LENGTH_LONG,
//             gravity: ToastGravity.BOTTOM,
//             backgroundColor: Colors.green,
//           );

//           // Navigate to home screen
//           if (context.mounted) {
//             if (!mounted) return;
//             Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(builder: (context) => const SplashScreen()),
//               (route) => false, // This removes all previous routes
//             );
//           }
//         } else {
//           throw Exception('Session token not received from server');
//         }
//       } else {
//         final errorData = jsonDecode(response.body);
//         throw Exception(errorData['message'] ?? 'Registration failed');
//       }
//     } catch (e) {
//       // Hide loading indicator if it's still showing
//       if (context.mounted) {
//         if (!mounted) return;
//         Navigator.pop(context);
//         // Show error message
//         Fluttertoast.showToast(
//           msg: "Error during registration: $e",
//           toastLength: Toast.LENGTH_LONG,
//           gravity: ToastGravity.BOTTOM,
//           backgroundColor: Colors.red,
//         );
//       }

//       log('Error during registration: $e');
//     }
//   }

Future<void> registerUser(
    String firstName, String lastName, String email, String password) async {
  try {
    if (!mounted) return;
    if (!sanitizeAndCheckEmailAndPassword(email, password)) {
      throw Exception('Invalid email or password format');
    }
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    final response = await http.post(
      Uri.parse("http://13.200.179.78/authentication/register"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
      }),
    );

    // Debug logs
    log('Response Status Code: ${response.statusCode}');
    log('Response Body: ${response.body}');
    log('Response Headers: ${response.headers}');

    // Hide loading indicator
    if (context.mounted) {
      if (!mounted) return;
      Navigator.pop(context);
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);

      // Initialize SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      
      // Save user data immediately after successful registration
      await prefs.setString('first_name', firstName);
      await prefs.setString('last_name', lastName);
      await prefs.setString('email', email);

      // Save token from response
      final token = responseData['session'];
      if (token != null && token.toString().isNotEmpty) {
        await prefs.setString('token', token);
      }

      // Get and save location data
      try {
        // Check location permission
        final hasPermission = await handleLocationPermission(context);
        if (hasPermission) {
          final position = await getCurrentLocation();
          if (position != null) {
            // Save location coordinates
            await prefs.setDouble('latitude', position.latitude);
            await prefs.setDouble('longitude', position.longitude);

            // Get city and state
            List<Placemark> placemarks = await placemarkFromCoordinates(
              position.latitude,
              position.longitude,
            );

            if (placemarks.isNotEmpty) {
              Placemark place = placemarks[0];
              await prefs.setString('city', place.locality ?? '');
              await prefs.setString('state', place.administrativeArea ?? '');
            }

            // Update location controller
            await Get.find<LocationController>().updateToCurrentLocation();
          }
        }
      } catch (e) {
        log('Error saving location data: $e');
      }

      // Debug verification logs
      log('Saved user data verification:');
      log('First Name: ${prefs.getString('first_name')}');
      log('Last Name: ${prefs.getString('last_name')}');
      log('Email: ${prefs.getString('email')}');
      log('Token: ${prefs.getString('token')}');
      log('City: ${prefs.getString('city')}');
      log('State: ${prefs.getString('state')}');
      log('Latitude: ${prefs.getDouble('latitude')}');
      log('Longitude: ${prefs.getDouble('longitude')}');

      // Call registration success callback
      _onRegistrationSuccess();

      // Show success message
      Fluttertoast.showToast(
        msg: responseData['message'] ?? "Registration successful!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
      );

      // Navigate to splash screen
      if (context.mounted) {
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          // MaterialPageRoute(builder: (context) => const SplashScreen()),
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      }
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Registration failed');
    }
  } catch (e) {
    if (context.mounted) {
      if (!mounted) return;
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: "Error during registration: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
      );
    }
    log('Error during registration: $e');
  }
}






  // Future<void> handleRegistration() async {

  //   try {
  //     if (_formKey.currentState!.validate()) {
  //       final firstName = firstNameController.text.trim();
  //       final lastName = lastNameController.text.trim();
  //       final email = emailController.text.trim();
  //       final password = passwordController.text;

  //       // First register the user
  //       await registerUser(firstName, lastName, email, password);

  //       // Then handle location and products
  //       if (mounted) {
  //         await handleRegistrationSuccess();

  //         // Navigate to products screen
  //         Navigator.pushAndRemoveUntil(
  //           context,
  //           MaterialPageRoute(builder: (context) => ResponsiveProductsScreen()),
  //           (route) => false,
  //         );
  //       }
  //     }
  //   } catch (e) {
  //     log('Registration error: $e');
  //     if (mounted) {
  //       Fluttertoast.showToast(
  //         msg: "Error during registration: $e",
  //         backgroundColor: Colors.red,
  //       );
  //     }
  //   }
  // }




  // Future<void> handleRegistration() async {
  //   if (!mounted) return; // Add this check at the start

  //   try {
  //     if (_formKey.currentState!.validate()) {
  //       final firstName = firstNameController.text.trim();
  //       final lastName = lastNameController.text.trim();
  //       final email = emailController.text.trim();
  //       final password = passwordController.text;

  //       // First register the user
  //       await registerUser(firstName, lastName, email, password);

  //       // Check mounted state before continuing
  //       if (!mounted) return;

  //       // Then handle location and products
  //       await handleRegistrationSuccess();

  //       // Final mounted check before navigation
  //       if (!mounted) return;

  //       // Navigate to products screen
  //       Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(builder: (context) => ResponsiveProductsScreen()),
  //         (route) => false,
  //       );
  //     }
  //   } catch (e) {
  //     log('Registration error: $e');
  //     // Check mounted state before showing toast
  //     if (mounted) {
  //       Fluttertoast.showToast(
  //         msg: "Error during registration: $e",
  //         backgroundColor: Colors.red,
  //       );
  //     }
  //   }
  // }


  Future<void> handleRegistration() async {
  try {
    setState(() {
      isLoading = true;
    });

    final response = await ApiService.register(
      firstNameController.text,
      lastNameController.text,
      emailController.text,
      passwordController.text,
    );

    if (!mounted) return;

    if (response['token'] != null) {
      // Save the token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', response['token']);

      // // Show success message
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('Registration successful!'),
      //     backgroundColor: Colors.green,
      //     duration: Duration(seconds: 1), // Short duration
      //   ),
      // );
            Get.snackbar(
        'Success',
        'Registration successful!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 1),
      );

         // Call the mixin method with context
      await checkAuthAndNavigate();
    }
  } catch (e) {
    if (!mounted) return;
 Get.snackbar(
      'Error',
      e.toString(),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }
}


  Future<void> requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      // Permission granted, proceed with location functionality
    } else if (status.isDenied) {
      // Handle denied permission
    }
  }

  void _onRegistrationSuccess() async {
    final locationController = Get.find<LocationController>();
    final productsController = Get.find<ProductsController>();

    try {
      final response = await http.get(
        Uri.parse(
            'http://13.200.179.78/adposts?city=${locationController.city.value}&state=${locationController.state.value}'),
      );

      if (response.statusCode == 200) {
        // ignore: unused_local_variable
        final jsonResponse = json.decode(response.body);
        productsController.updateProducts(response.body);

        // Navigate to splash screen (as per your existing code)
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            //  MaterialPageRoute(builder: (context) => SplashScreen()),
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
          );
        }
      }
    } catch (e) {
      log('Error fetching initial ads: $e');
    }
  }

  // Future<void> checkAuthAndNavigate() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('token');

  //   if (token != null && token.isNotEmpty) {
  //     Navigator.pushAndRemoveUntil(
  //       context,
  //       MaterialPageRoute(builder: (context) => const HomeScreen()),
  //       (route) => false,
  //     );
  //   } else {
  //     Fluttertoast.showToast(
  //       msg: "Authentication failed. Please try again.",
  //       backgroundColor: Colors.red,
  //     );
  //   }
  // }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 223, 223),
      body: Stack(
        children: [
          // Background image
          // Container(
          //   decoration: const BoxDecoration(
          //     image: DecorationImage(
          //       image: AssetImage("assets/images/bg1.png"),
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 60, left: 20),
                      child: Text("Welcome\nCreate your Account",
                          style: TextStyle(
                              fontSize: 30,
                              color: const Color.fromARGB(255, 16, 6, 6))),
                    ),
                    textFieldDefaultGap,
                    textFieldDefaultGap,
                    TextFormField(
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () {
                        FocusScope.of(context).nextFocus();
                      },
                      controller: firstNameController,
                      onChanged: (value) {
                        log("value:$value");
                        _formKey.currentState!.validate();
                      },
                      maxLength: 100,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter your first name";
                        } else if (value.length < 2) {
                          return 'First name must be at least 2 characters';
                        }

                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: "First_name",
                        hintStyle:
                            TextStyle(color: Color.fromARGB(255, 23, 11, 11)),
                        labelStyle:
                            TextStyle(color: Color.fromARGB(255, 23, 11, 11)),
                        label: Text(
                          "First_name",
                          style:
                              TextStyle(color: Color.fromARGB(255, 23, 11, 11)),
                        ),
                        prefixIcon: Icon(
                          Icons.person_2_outlined,
                          color: Color.fromARGB(255, 53, 6, 240),
                        ),
                        counterText: "",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 23, 11, 11), width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 23, 11, 11)),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 23, 11, 11), width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        errorBorder: OutlineInputBorder(
                            // Add this for error state
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 23, 11, 11),
                                width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        focusedErrorBorder: OutlineInputBorder(
                          // Add this for focused error state
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 23, 11, 11),
                              width: 2.0),
                        ),
                      ),
                      style: TextStyle(color: Color.fromARGB(255, 23, 11, 11)),
                      cursorColor: const Color.fromARGB(255, 21, 12, 12),
                      cursorHeight: 20,
                      cursorWidth: 2,
                      cursorRadius: Radius.circular(10),
                    ),
                    textFieldDefaultGap,
                    TextFormField(
                      style: TextStyle(color: Color.fromARGB(255, 23, 11, 11)),
                      cursorColor: const Color.fromARGB(255, 12, 7, 7),
                      cursorHeight: 20,
                      cursorWidth: 2,
                      cursorRadius: Radius.circular(10),
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () {
                        FocusScope.of(context).nextFocus();
                      },
                      controller: lastNameController,
                      onChanged: (value) {
                        log("value:$value");
                        _formKey.currentState!.validate();
                      },
                      maxLength: 100,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter your last name";
                        } else if (value.length < 2) {
                          return 'Last name must be at least 2 characters';
                        }

                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: "Last_name",
                        label: Text(
                          "Last_name",
                          style:
                              TextStyle(color: Color.fromARGB(255, 23, 11, 11)),
                        ),
                        prefixIcon: Icon(
                          Icons.person_2_outlined,
                          color: Color.fromARGB(255, 53, 6, 240),
                        ),
                        counterText: "",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 23, 11, 11), width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 23, 11, 11), width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 23, 11, 11),
                                width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        errorBorder: OutlineInputBorder(
                            // Add this for error state
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 23, 11, 11),
                                width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        focusedErrorBorder: OutlineInputBorder(
                          // Add this for focused error state
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 23, 11, 11),
                              width: 2.0),
                        ),
                      ),
                    ),
                    textFieldDefaultGap,
                    TextFormField(
                      style: TextStyle(color: Color.fromARGB(255, 23, 11, 11)),
                      cursorColor: const Color.fromARGB(255, 8, 3, 3),
                      cursorHeight: 20,
                      cursorWidth: 2,
                      cursorRadius: Radius.circular(10),
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () {
                        FocusScope.of(context).nextFocus();
                      },
                      controller: emailController,
                      onChanged: (value) {
                        log("value:$value");
                        _formKey.currentState!.validate();
                      },
                      maxLength: 100,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        final bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value ?? "");
                        log("emailValid $emailValid");
                        if (value == null || value.isEmpty) {
                          return "Please enter email address";
                        } else if (!emailValid) {
                          return "Please enter valid email address";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: "Enter Email",
                        hintStyle:
                            TextStyle(color: Color.fromARGB(255, 23, 11, 11)),
                        labelStyle:
                            TextStyle(color: Color.fromARGB(255, 23, 11, 11)),
                        label: Text(
                          "Email",
                          style:
                              TextStyle(color: Color.fromARGB(255, 23, 11, 11)),
                        ),
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Color.fromARGB(255, 53, 6, 240),
                        ),
                        counterText: "",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 23, 11, 11)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 23, 11, 11), width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 23, 11, 11),
                                width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        errorBorder: OutlineInputBorder(
                            // Add this for error state
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 23, 11, 11),
                                width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        focusedErrorBorder: OutlineInputBorder(
                          // Add this for focused error state
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 23, 11, 11),
                              width: 2.0),
                        ),
                        // errorStyle: TextStyle(
                        //     color: Color.fromARGB(255, 255, 255, 255)
                        //     ),
                      ),
                    ),
                    textFieldDefaultGap,
                    TextFormField(
                      style: TextStyle(color: Color.fromARGB(255, 23, 11, 11)),
                      cursorColor: const Color.fromARGB(255, 19, 9, 9),
                      cursorHeight: 20,
                      cursorWidth: 2,
                      cursorRadius: Radius.circular(10),
                      textInputAction: TextInputAction.done,
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                      },
                      controller: passwordController,
                      onChanged: (value) {
                        log("value:$value");
                        _formKey.currentState!.validate();
                      },
                      validator: (value) {
                        bool validateStructure(String value) {
                          String pattern =
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                          RegExp regExp = RegExp(pattern);
                          return regExp.hasMatch(value);
                        }

                        if (value == null || value.isEmpty) {
                          return "Please enter password";
                        } else if (value.length < 8) {
                          return "Password must be at least 8 characters";
                        } else if (!validateStructure(value)) {
                          return """Password must contain:
                        • At least one uppercase letter
                        • At least one lowercase letter  
                        • At least one number
                        • At least one special character (!@#\$&*~)
                        • Minimum 8 characters""";
                        }
                        return null;
                      },
                      maxLength: 100,
                      keyboardType: TextInputType.text,
                      obscureText: vissiblePassword,
                      decoration: InputDecoration(
                        hintText: "Enter Password",
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 23, 11, 11),
                        ),
                        label: const Text(
                          "Password",
                          style:
                              TextStyle(color: Color.fromARGB(255, 23, 11, 11)),
                        ),
                        labelStyle:
                            TextStyle(color: Color.fromARGB(255, 23, 11, 11)),
                        prefixIcon: const Icon(
                          Icons.password_outlined,
                          color: Color.fromARGB(255, 53, 6, 240),
                        ),
                        suffixIcon: GestureDetector(
                            onTap: () {
                              vissiblePassword = !vissiblePassword;
                              setState(() {});
                            },
                            child: Icon(
                              vissiblePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Color.fromARGB(255, 23, 11, 11),
                            )),
                        counterText: "",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 23, 11, 11)),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 23, 11, 11),
                                width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 23, 11, 11),
                                width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 23, 11, 11),
                                width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 23, 11, 11),
                                width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                      ),
                    ),
                    textFieldDefaultGap,

                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => const LoginScreen()));
                          },
                          child: const Text(
                            "Already have an Account",
                            style: TextStyle(
                                color: Color.fromARGB(255, 8, 19, 238)),
                          )),
                    ),
                    textFieldDefaultGap,

                    //                   ElevatedButton(
                    //                     style: ElevatedButton.styleFrom(
                    //                         backgroundColor:
                    //                             const Color.fromARGB(255, 219, 9, 205),
                    //                         shape: RoundedRectangleBorder(
                    //                             borderRadius: BorderRadius.circular(15))),
                    //                     onPressed: () {
                    //                       // Comment out your API call logic
                    //                       /*
                    // Your existing API call code here
                    // */

                    //                       // Call dummy register instead
                    //                       handleDummyRegister();
                    //                     },
                    //                     child: const Text("Register"),
                    //                   ),

                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 219, 9, 205),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                        onPressed: handleRegistration, // Just change this line

                        child: const Text(
                          "Register",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )),
                  ],
                ),
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
                        // ignore: deprecated_member_use
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
        ],
      ),
    );
  }
}
