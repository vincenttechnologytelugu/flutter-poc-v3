// import 'package:flutter/material.dart';

// import 'package:flutter_poc_v3/protected_screen.dart/sub_categories_screen.dart';

// class SellScreen extends StatefulWidget {
//   const SellScreen({super.key});

//   @override
//   State<SellScreen> createState() => _SellScreenState();
// }

// class _SellScreenState extends State<SellScreen> {
//   final List<Map<String, dynamic>> items = [
//     {"icon": Icons.directions_car, "caption": "Cars", "color": Colors.blue},
//     {"icon": Icons.home, "caption": "Property", "color": Colors.green},
//     {"icon": Icons.phone_android, "caption": "Mobiles", "color": Colors.orange},
//     {"icon": Icons.work, "caption": "Jobs", "color": Colors.purple},
//     {"icon": Icons.shopping_bag, "caption": "Fashion", "color": Colors.pink},
//     {
//       "icon": Icons.book,
//       "caption": "Books, Sports & Hobbies",
//       "color": Colors.teal
//     },
//     {"icon": Icons.motorcycle, "caption": "Bikes", "color": Colors.red},
//     {
//       "icon": Icons.devices_other,
//       "caption": "Electronics & Appliances",
//       "color": Colors.indigo
//     },
//     {
//       "icon": Icons.local_shipping,
//       "caption": "Commercial Vehicles & Spares",
//       "color": Colors.brown
//     },
//     {"icon": Icons.chair, "caption": "Furniture", "color": Colors.amber},
//     {"icon": Icons.pets, "caption": "Pets", "color": Colors.cyan},
//     {
//       "icon": Icons.miscellaneous_services,
//       "caption": "Services",
//       "color": Colors.deepOrange
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('What are you offering'),
//       ),
//       body: GridView.builder(
//         itemCount: items.length,
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2, // Increased to 4 columns
//           childAspectRatio: 2, // Adjusted for smaller, more square-like cards
//           crossAxisSpacing: 6, // Reduced spacing
//           mainAxisSpacing: 6, // Reduced spacing
//         ),
//         padding: EdgeInsets.all(6), // Reduced padding
//         itemBuilder: (ctx, index) {
//           return InkWell(
//             // In your SellScreen's onTap method, replace the existing navigation with:
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => SubcategoriesScreen(
//                     category: items[index]["caption"],
//                     categoryColor: items[index]["color"],
//                   ),
//                 ),
//               );
//             },

//             // onTap: () {
//             //   Navigator.push(
//             //     context,
//             //     MaterialPageRoute(
//             //       builder: (context) => DetailScreen(item: items[index]),
//             //     ),
//             //   );
//             // },
//             child: Card(
//               elevation: 2, // Reduced elevation
//               child: Padding(
//                 padding:
//                     const EdgeInsets.all(4.0), // Added padding inside the card
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       items[index]["icon"],
//                       size: 40, // Reduced icon size
//                       color: items[index]["color"],
//                     ),
//                     SizedBox(height: 2), // Reduced space between icon and text
//                     Text(
//                       items[index]["caption"],
//                       style: TextStyle(
//                           fontSize: 10,
//                           fontWeight: FontWeight.bold), // Smaller font
//                       textAlign: TextAlign.center,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_poc_v3/protected_screen.dart/sub_categories_screen.dart';

// class SellScreen extends StatefulWidget {
//   const SellScreen({super.key});

//   @override
//   State<SellScreen> createState() => _SellScreenState();
// }

// class _SellScreenState extends State<SellScreen> {
//     final List<Map<String, dynamic>> items = [
//     {"icon": Icons.directions_car, "caption": "Cars", "color": Colors.blue},
//     {"icon": Icons.home, "caption": "Property", "color": Colors.green},
//     {"icon": Icons.phone_android, "caption": "Mobiles", "color": Colors.orange},
//     {"icon": Icons.work, "caption": "Jobs", "color": Colors.purple},
//     {"icon": Icons.shopping_bag, "caption": "Fashion", "color": Colors.pink},
//     {
//       "icon": Icons.book,
//       "caption": "Books, Sports & Hobbies",
//       "color": Colors.teal
//     },
//     {"icon": Icons.motorcycle, "caption": "Bikes", "color": Colors.red},
//     {
//       "icon": Icons.devices_other,
//       "caption": "Electronics & Appliances",
//       "color": Colors.indigo
//     },
//     {
//       "icon": Icons.local_shipping,
//       "caption": "Commercial Vehicles & Spares",
//       "color": Colors.brown
//     },
//     {"icon": Icons.chair, "caption": "Furniture", "color": Colors.amber},
//     {"icon": Icons.pets, "caption": "Pets", "color": Colors.cyan},
//     {
//       "icon": Icons.miscellaneous_services,
//       "caption": "Services",
//       "color": Colors.deepOrange
//     },
//    ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('What are you offering',
//             style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontSize: 18,
//                 color: Colors.white)),
//         centerTitle: true,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF6A1B9A), Color(0xFF9C27B0)],
//               begin: Alignment.centerLeft,
//               end: Alignment.centerRight,
//             ),
//           ),
//         ),
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Color(0xFFF5F5F5), Color(0xFFE0E0E0)],
//           ),
//         ),
//         child: GridView.builder(
//           itemCount: items.length,
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             childAspectRatio: 1.2,
//             crossAxisSpacing: 12,
//             mainAxisSpacing: 12,
//           ),
//           padding: const EdgeInsets.all(16),
//           itemBuilder: (ctx, index) {
//             return InkWell(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => SubcategoriesScreen(
//                       category: items[index]["caption"],
//                       categoryColor: items[index]["color"],
//                     ),
//                   ),
//                 );
//               },
//               borderRadius: BorderRadius.circular(20),
//               child: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       items[index]["color"].withOpacity(0.8),
//                       items[index]["color"].withOpacity(0.4),
//                     ],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 8,
//                       spreadRadius: 2,
//                       offset: const Offset(0, 4),
//                       blurStyle: BlurStyle.normal,
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.2),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(
//                         items[index]["icon"],
//                         size: 32,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                       child: Text(
//                         items[index]["caption"],
//                         style: const TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                         ),
//                         textAlign: TextAlign.center,
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_poc_v3/protected_screen.dart/sub_categories_screen.dart';

// class SellScreen extends StatefulWidget {
//   const SellScreen({super.key});

//   @override
//   State<SellScreen> createState() => _SellScreenState();
// }

// class _SellScreenState extends State<SellScreen> {
//  final List<Map<String, dynamic>> items = [
//     {"icon": Icons.directions_car, "caption": "Cars", "color": Colors.blue},
//     {"icon": Icons.home, "caption": "Property", "color": Colors.green},
//     {"icon": Icons.phone_android, "caption": "Mobiles", "color": Colors.orange},
//     {"icon": Icons.work, "caption": "Jobs", "color": Colors.purple},
//     {"icon": Icons.shopping_bag, "caption": "Fashion", "color": Colors.pink},
//     {
//       "icon": Icons.book,
//       "caption": "Books, Sports & Hobbies",
//       "color": Colors.teal
//     },
//     {"icon": Icons.motorcycle, "caption": "Bikes", "color": Colors.red},
//     {
//       "icon": Icons.devices_other,
//       "caption": "Electronics & Appliances",
//       "color": Colors.indigo
//     },
//     {
//       "icon": Icons.local_shipping,
//       "caption": "Commercial Vehicles & Spares",
//       "color": Colors.brown
//     },
//     {"icon": Icons.chair, "caption": "Furniture", "color": Colors.amber},
//     {"icon": Icons.pets, "caption": "Pets", "color": Colors.cyan},
//     {
//       "icon": Icons.miscellaneous_services,
//       "caption": "Services",
//       "color": Colors.deepOrange
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('What are you offering?',
//             style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w700,
//                 letterSpacing: 0.5,
//                 color: Colors.white)),
//         centerTitle: true,
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.deepPurple.shade500, Colors.blueAccent.shade700],
//               stops: const [0.2, 0.8],
//             ),
//           ),
//         ),
//         elevation: 8,
//         shadowColor: Colors.deepPurple.withOpacity(0.3),
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
//       ),
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [Color(0xFFF8F9FA), Color(0xFFE9ECEF)],
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
//               return AnimatedScale(
//                 duration: const Duration(milliseconds: 200),
//                 scale: 1,
//                 child: Material(
//                   color: Colors.transparent,
//                   child: InkWell(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => SubcategoriesScreen(
//                             category: items[index]["caption"],
//                             categoryColor: items[index]["color"],
//                           ),
//                         ),
//                       );
//                     },
//                     borderRadius: BorderRadius.circular(24),
//                     splashColor: items[index]["color"].withOpacity(0.2),
//                     highlightColor: items[index]["color"].withOpacity(0.1),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(24),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.1),
//                             blurRadius: 20,
//                             spreadRadius: 2,
//                             offset: const Offset(0, 4),
//                           ),
//                         ],
//                         border: Border.all(
//                           color: Colors.grey.withOpacity(0.1),
//                           width: 1,
//                         ),
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               gradient: LinearGradient(
//                                 colors: [
//                                   items[index]["color"].withOpacity(0.9),
//                                   items[index]["color"].withOpacity(0.7),
//                                 ],
//                                 begin: Alignment.topLeft,
//                                 end: Alignment.bottomRight,
//                               ),
//                             ),
//                             child: Icon(
//                               items[index]["icon"],
//                               size: 32,
//                               color: Colors.white,
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 12),
//                             child: Text(
//                               items[index]["caption"],
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.grey.shade800,
//                                 letterSpacing: 0.3,
//                               ),
//                               textAlign: TextAlign.center,
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/protected_screen.dart/category_item.dart';
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
