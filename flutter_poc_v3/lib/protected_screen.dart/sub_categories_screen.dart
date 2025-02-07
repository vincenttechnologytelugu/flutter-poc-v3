// screens/subcategories_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/protected_screen.dart/sell_subcategory_details_form_screen';
import '../utils/category_data.dart';

class SubcategoriesScreen extends StatefulWidget {
  final String category;
  final Color categoryColor;

  const SubcategoriesScreen({
    Key? key,
    required this.category,
    required this.categoryColor,
  }) : super(key: key);

  @override
  State<SubcategoriesScreen> createState() => _SubcategoriesScreenState();
}

class _SubcategoriesScreenState extends State<SubcategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    final subcategories = CategoryData.categorySubcategories[widget.category] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Select ${widget.category} Category'),
      ),
      body: ListView.builder(
        itemCount: subcategories.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              title: Text(subcategories[index]),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SellSubcategoryDetailsFormScreen(
                      category: widget.category,
                      subcategory: subcategories[index],
                      categoryColor: widget.categoryColor,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
