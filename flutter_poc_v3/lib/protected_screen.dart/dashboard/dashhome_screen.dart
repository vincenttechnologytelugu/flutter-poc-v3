

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/protected_screen.dart/dashboard/category_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/dashboard/search_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/introduction_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/responsive_products_screen.dart';

class DashhomeScreen extends StatefulWidget {
  const DashhomeScreen({super.key});

  @override
  State<DashhomeScreen> createState() => _DashhomeScreenState();
}

class _DashhomeScreenState extends State<DashhomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<String> searchTexts = [
    'Cars',
    'Bikes',
    'Properties',
    'Mobiles',
    'Jobs',
    'Furniture',
    'Electronics',
    'Fashion',
    'Services',
    'Pets',
    'Books'

  ];
  int currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startAnimation();
  }

  void startAnimation() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          currentIndex = (currentIndex + 1) % searchTexts.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Clean up timer to prevent memory leaks
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
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.grey),
                          const SizedBox(width: 10),
                          const Text(
                            'Find ',
                            style: TextStyle(
                              color: Color.fromARGB(255, 33, 4, 221),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            transitionBuilder: (Widget child, Animation<double> animation) {
                              final offsetAnimation = Tween<Offset>(
                                begin: const Offset(0.0, -1.0), // Slide from top
                                end: Offset.zero,
                              ).animate(animation);
                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                            child: Text(
                              searchTexts[currentIndex],
                              key: ValueKey<int>(currentIndex),
                              style: const TextStyle(
                                color: Color.fromARGB(255, 33, 4, 221),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Text(
                            '...',
                            style: TextStyle(
                              color: Color.fromARGB(255, 33, 4, 221),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(
                    Icons.notifications_outlined,
                    size: 25,
                    color: Color.fromARGB(255, 240, 6, 232),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IntroductionScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 0),
                    height: 210, // Adjust this height as needed
                    child: const CategoryScreen(),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.only(top: 0),
                    height: MediaQuery.of(context).size.height - 212, // Adjust based on needs
                    child:  ResponsiveProductsScreen(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}