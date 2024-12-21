import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_poc_v3/public_screen.dart/login_screen.dart';

class HomeappbarScreen extends StatefulWidget {
  const HomeappbarScreen({super.key});

  @override
  State<HomeappbarScreen> createState() => _HomeappbarScreenState();
}

class _HomeappbarScreenState extends State<HomeappbarScreen> {
  String? userName;
  // Add this method to check storage
  void checkStorageData() {
    // if (kIsWeb) {
    //   // For Web
    //   html.window.localStorage.forEach((key, value) {
    //     log('Local Storage - $key: $value');
    //   });
    // } else {
    //   // For Mobile
    checkSharedPreferences();
    // }
  }

// Check SharedPreferences
  Future<void> checkSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stored Data'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var key in allKeys)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text('$key: ${prefs.getString(key)}'),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('first_name') ?? 'User';
    });
  }

  Future<void> logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout ?? false) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        Fluttertoast.showToast(
          msg: "Logged out successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
        );

        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Logout failed: $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: const Color.fromARGB(255, 173, 171, 171),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(padding: EdgeInsets.only(top: 10)),
              const Text(
                "Olx",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
              ),

              const Spacer(),
              // Add debug button
              // if (kDebugMode) // Only show in debug mode
              //   IconButton(
              //     icon: const Icon(Icons.storage),
              //     onPressed: checkStorageData,
              //     tooltip: 'Check Storage',
              //   ),

              const Spacer(),
              const Icon(
                Icons.location_on_outlined,
                size: 30,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // Your location tap logic here
                  },
                  child: Text(
                    userName ?? 'User',
                    style: const TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              // Add logout icon button
              IconButton(
                icon: const Icon(
                  Icons.logout,
                  color: Colors.black87,
                  size: 24,
                ),
                onPressed: logout,
                tooltip: 'Logout',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class HomeappbarScreen extends StatelessWidget {
//   const HomeappbarScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       elevation: 0.0,
//       backgroundColor: const Color.fromARGB(255, 173, 171, 171),
//       title: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               const Padding(padding: EdgeInsets.only(top: 10)),
//               const Text(
//                 "Olx",
//                 style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
//               ),
//               const SizedBox(width: 160),
//               const Icon(
//                 Icons.location_on_outlined,
//                 size: 30,
//               ),
//               const SizedBox(width: 5),
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () {
//                     // Navigator.push(
//                     //     context,
//                     //     MaterialPageRoute(
//                     //         builder: (ctx) => const Location()));
//                   },
//                   child: const Text(
//                     'Miyapur, Hyderabad',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
