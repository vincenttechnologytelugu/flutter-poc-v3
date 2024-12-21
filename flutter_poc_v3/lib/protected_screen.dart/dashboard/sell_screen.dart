import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/protected_screen.dart/detail_screen.dart';

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
    {"icon": Icons.book, "caption": "Books & Sports", "color": Colors.teal},
    {"icon": Icons.motorcycle, "caption": "Bike", "color": Colors.red},
    {"icon": Icons.devices_other, "caption": "Electronics", "color": Colors.indigo},
    {"icon": Icons.local_shipping, "caption": "Commercial Vehicle", "color": Colors.brown},
    {"icon": Icons.chair, "caption": "Furniture", "color": Colors.amber},
    {"icon": Icons.pets, "caption": "Pets", "color": Colors.cyan},
    {"icon": Icons.miscellaneous_services, "caption": "Services", "color": Colors.deepOrange},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sell Items'),
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(item: items[index]),
                ),
              );
            },
            child: Card(
              elevation: 2, // Reduced elevation
              child: Padding(
                padding: const EdgeInsets.all(4.0), // Added padding inside the card
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
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold), // Smaller font
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

// class DetailScreen extends StatelessWidget {
//   final Map<String, dynamic> item;

//   const DetailScreen({Key? key, required this.item}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(item["caption"]),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               item["icon"],
//               size: 100,
//               color: item["color"],
//             ),
//             SizedBox(height: 20),
//             Text(
//               "Details for ${item["caption"]}",
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             // Add more details or form fields here for the specific item category
//           ],
//         ),
//       ),
//     );
//   }
// }
