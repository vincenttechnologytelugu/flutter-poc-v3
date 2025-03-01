import 'package:flutter/material.dart';

import 'package:flutter_poc_v3/protected_screen.dart/sub_categories_screen.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  final List<Map<String, dynamic>> items = [
    {"icon": Icons.directions_car, "caption": "Cars", "color": Colors.blue},
    {"icon": Icons.home, "caption": "Property", "color": Colors.green},
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
        title: Text('What are you offering'),
      ),
      body: GridView.builder(
        itemCount: items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Increased to 4 columns
          childAspectRatio: 2, // Adjusted for smaller, more square-like cards
          crossAxisSpacing: 6, // Reduced spacing
          mainAxisSpacing: 6, // Reduced spacing
        ),
        padding: EdgeInsets.all(6), // Reduced padding
        itemBuilder: (ctx, index) {
          return InkWell(
            // In your SellScreen's onTap method, replace the existing navigation with:
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubcategoriesScreen(
                    category: items[index]["caption"],
                    categoryColor: items[index]["color"],
                  ),
                ),
              );
            },

            // onTap: () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => DetailScreen(item: items[index]),
            //     ),
            //   );
            // },
            child: Card(
              elevation: 2, // Reduced elevation
              child: Padding(
                padding:
                    const EdgeInsets.all(4.0), // Added padding inside the card
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      items[index]["icon"],
                      size: 40, // Reduced icon size
                      color: items[index]["color"],
                    ),
                    SizedBox(height: 2), // Reduced space between icon and text
                    Text(
                      items[index]["caption"],
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold), // Smaller font
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
