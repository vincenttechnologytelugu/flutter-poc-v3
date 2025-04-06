



// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/protected_screen.dart/sell_subcategory_details_form_screen';
import '../utils/category_data.dart';
import 'package:google_fonts/google_fonts.dart';


class SubcategoriesScreen extends StatefulWidget {
  final String category;
  final Color categoryColor;

  const SubcategoriesScreen({
    super.key,
    required this.category,
    required this.categoryColor,
  });

  @override
  State<SubcategoriesScreen> createState() => _SubcategoriesScreenState();
}

class _SubcategoriesScreenState extends State<SubcategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    final subcategories = CategoryData.categorySubcategories[widget.category] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select ${widget.category} Category',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.amber.shade700,
        elevation: 4,
      ),
      backgroundColor: Colors.amber[50], // Soft yellow background
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: subcategories.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                shadowColor: Colors.amberAccent.withOpacity(0.4),
                color: Colors.white,
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  leading: CircleAvatar(
                    backgroundColor: Colors.amber.shade600,
                    child: Icon(
                      Icons.category,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    subcategories[index],
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.amber[800],
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.amber[700],
                  ),
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
              ),
            );
          },
        ),
      ),
    );
  }
}

