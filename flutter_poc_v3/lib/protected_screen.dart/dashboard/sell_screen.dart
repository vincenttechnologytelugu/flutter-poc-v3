

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/protected_screen.dart/category_item.dart';
import 'package:flutter_poc_v3/protected_screen.dart/dashboard/custom_bottom_nav_bar.dart';
import 'package:flutter_poc_v3/protected_screen.dart/delay_animation.dart';
import 'package:flutter_poc_v3/protected_screen.dart/sub_categories_screen.dart'; // Adjust import as needed

class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  final List<Map<String, dynamic>> items = [
    {"icon": Icons.directions_car, "caption": "Cars", "color": Colors.blue},
    {"icon": Icons.home, "caption": "properties", "color": Colors.green},
    {"icon": Icons.phone_android, "caption": "Mobiles", "color": Colors.orange},
    {"icon": Icons.work, "caption": "Jobs", "color": Colors.purple},
    {"icon": Icons.shopping_bag, "caption": "Fashion", "color": Colors.pink},
    {
      "icon": Icons.book,
      "caption": "Books, Sports & Hobbies",
      "color": Colors.teal
    },
    {"icon": Icons.motorcycle, "caption": "Bikes", "color": Colors.red},
    {
      "icon": Icons.devices_other,
      "caption": "Electronics & Appliances",
      "color": Colors.indigo
    },
    {
      "icon": Icons.local_shipping,
      "caption": "Commercial Vehicles & Spares",
      "color": Colors.brown
    },
    {"icon": Icons.chair, "caption": "Furniture", "color": Colors.amber},
    {"icon": Icons.pets, "caption": "Pets", "color": Colors.cyan},
    {
      "icon": Icons.miscellaneous_services,
      "caption": "Services",
      "color": Colors.deepOrange
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'What are you offering?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade500, Colors.blueAccent.shade700],
              stops: const [0.2, 0.8],
            ),
          ),
        ),
        elevation: 8,
        shadowColor: Colors.deepPurple.withOpacity(0.3),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.purple.shade50
            ], // Stylish background
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: GridView.builder(
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
            ),
            itemBuilder: (ctx, index) {
              return DelayedAnimation(
                delay: index * 150, // Staggered delay
                child: CategoryItem(
                  item: items[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            SubcategoriesScreen(
                          category: items[index]["caption"],
                          categoryColor: items[index]["color"],
                        ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
           bottomNavigationBar: CustomBottomNavBar(currentIndex: 2),
    );
  }
}
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Colors.blue.shade50,
//               Colors.purple.shade50
//             ], // Stylish background
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: GridView.builder(
//             itemCount: items.length,
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               childAspectRatio: 1.0,
//               mainAxisSpacing: 20,
//               crossAxisSpacing: 20,
//             ),
//             itemBuilder: (ctx, index) {
//               return DelayedAnimation(
//                 delay: index * 150, // Staggered delay
//                 child: CategoryItem(
//                   item: items[index],
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       PageRouteBuilder(
//                         pageBuilder: (context, animation, secondaryAnimation) =>
//                             SubcategoriesScreen(
//                           category: items[index]["caption"],
//                           categoryColor: items[index]["color"],
//                         ),
//                         transitionsBuilder:
//                             (context, animation, secondaryAnimation, child) {
//                           return FadeTransition(
//                             opacity: animation,
//                             child: child,
//                           );
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
