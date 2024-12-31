

import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/protected_screen.dart/dashboard/category_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/dashboard/search_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/responsive_products_screen.dart';

class DashhomeScreen extends StatefulWidget {
  const DashhomeScreen({super.key});

  @override
  State<DashhomeScreen> createState() => _DashhomeScreenState();
}

class _DashhomeScreenState extends State<DashhomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Search and Notification Row
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 8.0,
              bottom: 0.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      height: 45,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey),
                          SizedBox(width: 10),
                          Text(
                            'Find Cars, Mobile and More...',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.notifications_outlined),
                  onPressed: () {
                    // Handle notification tap
                  },
                ),
              ],
            ),
          ),  
          // Container for CategoryScreen with fixed height
          Expanded(

            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  Container(
                    height: 210, // Adjust this height as needed
                    child: CategoryScreen(
                      
                    ),
                  ),
                  SizedBox(height: 20),
                   Container(
                    margin: EdgeInsets.only(top: 0),
                height: MediaQuery.of(context).size.height - 200, // Adjust this value based on your needs
                child: ResponsiveProductsScreen(),
              ),
                ],
              ),
            ),
          ),
          
          // Container for ResponsiveProductsScreen
          // Container(
          //   height: MediaQuery.of(context).size.height - 200, // Adjust this value based on your needs
          //   child: ResponsiveProductsScreen(),
          // ),
        ],
      ),
    );
  }
}


