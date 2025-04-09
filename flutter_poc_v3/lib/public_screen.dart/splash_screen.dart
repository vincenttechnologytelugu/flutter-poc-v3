// // ignore_for_file: use_build_context_synchronously

// import 'dart:async';
// import 'dart:developer';

// // import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';


// import 'package:flutter_poc_v3/protected_screen.dart/home_screen.dart';

// import 'package:flutter_poc_v3/public_screen.dart/login_screen.dart';


// import 'package:flutter_poc_v3/services/auth_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     checkAuthAndNavigate();
//     super.initState();
//   }

  // Future<void> checkAuthAndNavigate() async {
  //   try {
  //     // Add a minimum delay for splash screen
  //     await Future.delayed(const Duration(seconds: 1));

  //     final prefs = await SharedPreferences.getInstance();
  //     final token = prefs.getString('token');

  //     if (token != null) {
  //       // Validate token and get user details
  //       final authService = AuthService();
  //       final isValid = await authService.validateAndUpdateAuthUser(token);

  //       if (mounted) {
  //         if (isValid) {
  //           // The auth user object is already saved in SharedPreferences by validateAndUpdateAuthUser
  //           Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(builder: (context) => const HomeScreen()),
  //           );
  //         }
 
  //          else {
  //           // Clear invalid token
  //           await prefs.remove('token');
  //           await prefs.remove('user_data');
            

  //           Navigator.pushReplacement(
            
  //             context,
  //             MaterialPageRoute(builder: (context) => const LoginScreen()),
  //           );
  //         }
  //       }
  //     } else {
  //       if (mounted) {
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(builder: (context) => const LoginScreen()),
  //         );
  //       }
  //     }
  //   } catch (e) {
  //     // Handle any errors
  //     log('Error in checkAuthAndNavigate: $e');
  //     if (mounted) {
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => const LoginScreen()),
  //       );
  //     }
  //   }
  // }

//   @override
//   Widget build(BuildContext context) {
//     MediaQuery.of(context).size.height * 0.2;// 20% of screen height
// MediaQuery.of(context).size.width * 0.4;   // 40% of screen width

//   return Scaffold(
    
//     backgroundColor: const Color.fromARGB(255, 108, 70, 169),
//     body: Stack(
//       children: [
//         // Animated background gradient
//         // AnimatedContainer(
//         //   duration: const Duration(seconds: 10),
//         //   decoration: BoxDecoration(
//         //     gradient: LinearGradient(
//         //       colors: [const Color.fromARGB(255, 249, 3, 151), const Color.fromARGB(255, 252, 251, 251)],
//         //       begin: Alignment.topLeft,
//         //       end: Alignment.bottomRight,
//         //     ),
//         //   ),
//         // ),
        
//         Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Animated logo with shadow
//               AnimatedContainer(
//                 duration: const Duration(seconds: 10),
//                 curve: Curves.easeInOut,
//                 height: 150,
//                 width: 150,
//                 decoration: BoxDecoration(
//                   boxShadow: [
//                     BoxShadow(
//                       // ignore: deprecated_member_use
//                       color: Colors.black.withOpacity(0.2),
//                       blurRadius: 20,
//                       spreadRadius: 5,
//                     )
//                   ],
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(40),
//                   child: Container(
//                      constraints: BoxConstraints(
//                   maxWidth: MediaQuery.of(context).size.width * 0.3, // 30% of screen width
//                   maxHeight: 40,
//                 ),
//                     child: Image.asset(
//                     "assets/images/homelogo.jpg",
//                     fit: BoxFit.contain,
//                                     ),
//                   ),
//                   // child: CachedNetworkImage(
//                   //   // imageUrl: "https://cdn.grabon.in/gograbon/images/merchant/1620713761906/olx-logo.jpg",
//                   //     imageUrl: "https://mkdigitalmare.com/images/logo/Untitled%20design%20(3).png",
//                   //   fadeInDuration: const Duration(seconds: 5),
//                   //   fit: BoxFit.contain,
//                   // ),
//                 ),
//               ),
              
//               const SizedBox(height: 40),
              
//               // Animated text with gradient
//               ShaderMask(
//                 shaderCallback: (bounds) => LinearGradient(
//                   colors: [Colors.white, Colors.teal.shade100],
//                 ).createShader(bounds),
//                 child: AnimatedOpacity(
//                   duration: const Duration(seconds: 1),
//                   opacity: 1,
//                   // child: const Text(
//                   //   "Welcome to App",
//                   //   style: TextStyle(
//                   //     fontSize: 28,
//                   //     fontWeight: FontWeight.bold,
//                   //     letterSpacing: 1.2,
//                   //   ),
//                   // ),
//                 ),
//               ),
              
//               // Pulsating dot animation
//               const SizedBox(height: 30),
//               AnimatedContainer(
//                 duration: const Duration(milliseconds: 1000),
//                 curve: Curves.fastOutSlowIn,
//                 height: 12,
//                 width: 12,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }
  
// }












import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_poc_v3/protected_screen.dart/home_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to home screen after 3 seconds
    Timer(const Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) =>  HomeScreen()),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 254, 254),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add your splash screen logo or content here
            Image.asset(
               "assets/images/homelogo.jpg",
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 20),
            // const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
