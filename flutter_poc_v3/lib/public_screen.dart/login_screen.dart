// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/controllers/location_controller.dart';
import 'package:flutter_poc_v3/controllers/products_controller.dart';
import 'package:flutter_poc_v3/models/product_model.dart';
import 'package:flutter_poc_v3/models/profile_details.dart';
import 'package:flutter_poc_v3/protected_screen.dart/dashboard/chat_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/dashboard/my_adds.dart';
import 'package:flutter_poc_v3/protected_screen.dart/dashboard/profile_screen.dart';

//import 'package:flutter_poc_v3/main.dart';
import 'package:flutter_poc_v3/protected_screen.dart/home_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/product_details.dart';
import 'package:flutter_poc_v3/protected_screen.dart/sell_subcategory_details_form_screen';

import 'package:flutter_poc_v3/public_screen.dart/ProfileResponseModel.dart';

import 'package:flutter_poc_v3/public_screen.dart/register_screen.dart';
import 'package:flutter_poc_v3/public_screen.dart/splash_screen.dart';

import 'package:flutter_poc_v3/services/auth_service.dart';
import 'package:flutter_poc_v3/services/my_ads_sevice.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

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
  final MyAdsService myAdsService = MyAdsService(); // Define myAdsService
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

//  Future<void> checkAuthAndNavigate() async {
//     try {
//       // Add a minimum delay for splash screen
//       await Future.delayed(const Duration(seconds: 1));

//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('token');

//       if (token != null) {
//         // Validate token and get user details
//         final authService = AuthService();
//         final isValid = await authService.validateAndUpdateAuthUser(token);

//         if (mounted) {
//           if (isValid) {
//             // The auth user object is already saved in SharedPreferences by validateAndUpdateAuthUser
//             Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(builder: (context) => const HomeScreen()
//               ),
//               (Route<dynamic> route) => false,
//             );

//           }

//            else {
//             // Clear invalid token
//             await prefs.remove('token');
//             await prefs.remove('user_data');

//             Navigator.pushReplacement(

//               context,
//               MaterialPageRoute(builder: (context) => const LoginScreen()),
//             );
//           }
//         }
//       } else {
//         if (mounted) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const LoginScreen()),
//           );
//         }
//       }
//     } catch (e) {
//       // Handle any errors
//       log('Error in checkAuthAndNavigate: $e');
//       if (mounted) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const LoginScreen()),
//         );
//       }
//     }
//   }

  Future<void> checkAuthAndNavigate() async {
    try {
      // Add a minimum delay for splash screen
      await Future.delayed(const Duration(seconds: 1));

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      // Get the previous route name from SharedPreferences
      final previousRoute = prefs.getString('previous_route') ?? '';

      if (token != null) {
        // Validate token and get user details
        final authService = AuthService();
        final isValid = await authService.validateAndUpdateAuthUser(token);

        if (mounted) {
          if (isValid) {
            // Navigate based on previous route
            if (previousRoute.isNotEmpty) {
              switch (previousRoute) {
                case 'chat_screen':
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChatScreen(),
                    ),
                    (route) => false,
                  );
                  break;
                case 'sell_subcategory_details_form_screen':
                  final savedCategory = prefs.getString('saved_category') ?? '';
                  final savedSubcategory =
                      prefs.getString('saved_subcategory') ?? '';
                  // Convert hex string back to Color
                  final savedColorString =
                      prefs.getString('saved_color') ?? 'FF000000';
                  final savedColor =
                      Color(int.parse(savedColorString, radix: 16));

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SellSubcategoryDetailsFormScreen(
                        category: savedCategory,
                        subcategory: savedSubcategory,
                        categoryColor: savedColor,
                      ),
                    ),
                  
                  );

                  //  Navigator.pop(context); // Go back to product details
                  break;
                case 'my_adds':
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyAdds(),
                    ),
                    (route) => false,
                  );
                  //  Navigator.pop(context); // Go back to product details
                  break;
                case 'profile_screen':
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                    (route) => false,
                  );
                  //  Navigator.pop(context); // Go back to product details

                  break;
                case 'product_details':
                  Navigator.pop(context); // Go back to product details
                  break;
                case 'sub_category_posts_screen':
                  Navigator.pop(context); // Go back to sub category posts
                  break;
                case 'category_based_posts_screen':
                  Navigator.pop(context); // Go back to category details
                  break;

                default:
                  Navigator.pop(context); // Go back to location screen
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
                  );
              }
              // Clear the previous route after navigation
              await prefs.remove('previous_route');
            } else {
              // Default navigation if no previous route
              Navigator.pop(context); // Go back to location screen
              // Navigator.pushAndRemoveUntil(
              //   context,
              //   MaterialPageRoute(builder: (context) => const HomeScreen()),
              //   (route) => false,
              // );
            }
          } else {
            // Clear invalid token
            await prefs.remove('token');
            await prefs.remove('user_data');
            await prefs.remove('previous_route');

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

  Future<void> refreshUserDataFromApi() async {
    setState(() => isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      // if (token == null) {
      //   log('No token found');
      //   return;
      // }
//         if (token == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Token Not Found")),
//         );

// //
// Navigator.push(
//   context,
//   MaterialPageRoute(builder: (context) => LoginScreen()),
// );
//         return;
//       }

      // Make API call to get user details
      final response = await http.get(
        Uri.parse('http://13.200.179.78/authentication/auth_user'),
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
        // if (mounted) {
        //   Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(builder: (context) => const HomeScreen()),
        //     (route) => false, // This removes all previous routes
        //   );
        // }
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

  static const String baseUrl = 'http://13.200.179.78';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Map<String, String> _getHeaders(String token) {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<List<dynamic>> getMyAds(BuildContext context) async {
    try {
      final token = await _getToken();
      // if (token == null) throw Exception('No token found');
      if (token == null) {
        //  handleUnauthorized(context);
        throw Exception('');
      }

      log("Token for My Ads: $token"); // Add this to debug
      final response = await http.get(
        Uri.parse('$baseUrl/adposts/my_ads'),
        headers: _getHeaders(token),
      );
      log('MyAds Response Status: ${response.statusCode}'); // Add this log
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        log('MyAds Data: ${data['data']}'); // Add this log
        return data['data'] ?? [];
      }
      throw Exception('Failed to load my ads');
    } catch (e) {
      throw Exception('Error getting my ads: $e');
    }
  }

  Future<void> loginUser(String email, String password) async {
    setState(() {
      isLoading = true;
      loginMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('http://13.200.179.78/authentication/login'),
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

          // Save user location from login response
          await prefs.setString('user_city', responseData['city'] ?? '');
          await prefs.setString('user_state', responseData['state'] ?? '');

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
// After successful registration/login
          await Get.find<LocationController>().updateToCurrentLocation();

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
          await getMyAds(context);
          // Call the mixin method with context
          await checkAuthAndNavigate();
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

  // In login_screen.dart or register_screen.dart
  // Future<void> handleLoginSuccess() async {
  //   // or handleRegistrationSuccess
  //   try {
  //     final locationController = Get.find<LocationController>();
  //     await locationController.updateToCurrentLocation();

  //     // Navigate to home screen
  //     // Get.offAll(() => const HomeScreen());
  //   } catch (e) {
  //     log('Error handling login success: $e');
  //   }
  // }

  Future<void> handleLoginSuccess(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);

    // Get previous route
    final previousRoute = prefs.getString('previous_route');

    if (mounted) {
      if (previousRoute != null) {
        // Clear previous route
        await prefs.remove('previous_route');

        // Navigate based on previous route
        switch (previousRoute) {
          case 'chat_screen':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatScreen()),
            );
            break;
          case 'my_adds':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyAdds(),
              ),
            );
            break;
          case 'profile_screen':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
              ),
            );
            break;
          default:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
        }
      } else {
        // No previous route, go to HomeScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    }
  }

  // In your login success handler
  void onLoginSuccess(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();

    if (userData['active_subscription_rules'] != null) {
      await prefs.setString('active_subscription_rules',
          json.encode(userData['active_subscription_rules']));
      log('Saved subscription rules: ${userData['active_subscription_rules']}');
    }
  }

  Future<void> handleAuthSuccess() async {
    final LocationController locationController =
        Get.find<LocationController>();
    final ProductsController productsController =
        Get.find<ProductsController>();

    final prefs = await SharedPreferences.getInstance();
    final savedCity = prefs.getString('city');
    final savedState = prefs.getString('state');

    if (savedCity == null || savedState == null) {
      try {
        Position position = await Geolocator.getCurrentPosition();
        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);

        if (placemarks.isNotEmpty) {
          String city = placemarks[0].locality ?? '';
          String state = placemarks[0].administrativeArea ?? '';

          // Save location
          await locationController.saveLocation(city, state, isManual: false);

          // Fetch products for current location
          final response = await http.get(Uri.parse(
              'http://13.200.179.78/adposts?city=$city&state=$state'));

          if (response.statusCode == 200) {
            final List<dynamic> data = json.decode(response.body);
            productsController.productModelList.clear();
            for (var item in data) {
              productsController.productModelList
                  .add(ProductModel.fromJson(item));
            }
            productsController.update();
          }
        }
      } catch (e) {
        log('Error setting initial location: $e');
      }
    }

    // Get.offAll(() => const HomeScreen());
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
        backgroundColor: Colors.transparent, // Make AppBar transparent
        elevation: 0, // Remove shadow
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Color.fromARGB(
                255, 43, 33, 33), // Match your existing text color
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(
                context); // This will navigate back to previous screen
          },
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 234, 223, 223),
        // Background: Solid magenta as per the image description
        //  color: const Color(0xFFFF00FF), // Vibrant magenta (#FF00FF)
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //     colors: [
        //       Color.fromARGB(255, 136, 132, 219), // Vibrant magenta (#E040FB)
        //       Color.fromARGB(255, 153, 181, 112),
        //       Color.fromARGB(255, 153, 4, 4), // Vibrant magenta (#D500F9)
        //     ],
        //   ),
        // ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Header: LOGO placeholder
                  const Text(
                    "LOGIN",
                    style: TextStyle(
                      color: Color.fromARGB(255, 43, 33, 33), // White (#FFFFFF)
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Color.fromARGB(
                              255, 43, 33, 33), // White (#FFFFFF)

                          blurRadius: 2,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Profile Icon: Circular with white silhouette
                  Container(
                    width: 200,
                    height: 200,

                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: const Color.fromARGB(
                          255, 180, 169, 173), // Slightly darker magenta
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    // child: Image.asset(
                    //   "assets/images/sales1.jpg",
                    //   width: 80,
                    //   height: 80,
                    //   fit: BoxFit.fill,
                    // ),
                    child: const Icon(
                      Icons.person,
                      size: 100,
                      color: Colors.white, // White (#FFFFFF)
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Title: Welcome Back!
                  const Text(
                    "Welcome Back!",
                    style: TextStyle(
                      color: Color.fromARGB(255, 53, 6, 240),
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  // Login Message (if any)
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
                  const SizedBox(height: 16),
                  // User ID Input Field
                  TextFormField(
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: Color.fromARGB(
                          255, 25, 11, 11), // Light gray (#D3D3D3)
                      fontSize: 23.0,
                    ),
                    controller: _emailController,
                    keyboardType:
                        TextInputType.text, // Specify appropriate keyboard type
                    textInputAction: TextInputAction.next, // Add this
                    autofocus: false,

                    onEditingComplete: () {
                      FocusScope.of(context).nextFocus();
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white, // White (#FFFFFF)
                      hintText: 'Email',
                      hintStyle: const TextStyle(
                          color: Color(0xFFD3D3D3)), // Light gray (#D3D3D3)
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Color.fromARGB(255, 53, 6, 240),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xFFD81B60), // Slightly darker magenta
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 91, 90, 93),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 91, 90, 93),
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Password Input Field
                  TextFormField(
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: Color.fromARGB(
                          255, 25, 11, 11), // Light gray (#D3D3D3)
                      fontSize: 23.0,
                    ),
                    controller: _passwordController,
                    obscureText: !visiblePassword,
                    keyboardType:
                        TextInputType.text, // Specify appropriate keyboard type

                    autofocus: false,
                    textInputAction: TextInputAction.done,
                    onEditingComplete: () {
                      FocusScope.of(context).unfocus();
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white, // White (#FFFFFF)
                      hintText: 'Password',
                      hintStyle: const TextStyle(
                          color: Color(0xFFD3D3D3)), // Light gray (#D3D3D3)
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Color.fromARGB(255, 53, 6, 240),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          visiblePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: const Color.fromARGB(
                              255, 19, 5, 10), // Slightly darker magenta
                        ),
                        onPressed: () {
                          setState(() {
                            visiblePassword = !visiblePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 91, 90, 93),
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 91, 90, 93),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 91, 90, 93),
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Login Button
                  SizedBox(
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 219, 9, 205),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        minimumSize: const Size(100, 50),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Color.fromARGB(255, 244, 244, 249))
                          : const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Create Account Link
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Create an account",
                      style: TextStyle(
                        color: Color.fromARGB(255, 8, 19, 238),
                        fontSize: 20,
                        decorationColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
