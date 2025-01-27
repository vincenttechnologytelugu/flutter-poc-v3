import 'package:flutter/material.dart';

class PackageCategoryScreen extends StatefulWidget {
  final Function(String) onCategorySelected;

  const PackageCategoryScreen({
    super.key,
    required this.onCategorySelected,
  });

  @override
  State<PackageCategoryScreen> createState() => _PackageCategoryScreenState();
}

class _PackageCategoryScreenState extends State<PackageCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    // List of categories with their icons
    final categories = [
      {'name': 'Cars', 'icon': Icons.directions_car},
      {'name': 'Real Estate', 'icon': Icons.home},
      {'name': 'Mobile Phones', 'icon': Icons.phone_android},
      {'name': 'Electronics', 'icon': Icons.devices},
      {'name': 'Furniture', 'icon': Icons.chair},
      {'name': 'Fashion', 'icon': Icons.shopping_bag},
      {'name': 'Books', 'icon': Icons.book},
      {'name': 'Sports', 'icon': Icons.sports_soccer},
      {'name': 'Toys', 'icon': Icons.toys},
      {'name': 'Jewelry', 'icon': Icons.diamond},
      
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Select Category'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Icon(categories[index]['icon'] as IconData, color: Colors.blue),
              title: Text(categories[index]['name'] as String),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                widget.onCategorySelected(categories[index]['name'] as String);
                Navigator.pop(context);
              },
            ),
          );
        },
      ),
    );
  }
}
