

// // ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/models/product_model.dart';
// import 'package:flutter_poc_v3/models/product_model.dart';
import 'package:flutter_poc_v3/protected_screen.dart/all_categories_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/dashboard/category_details_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/leven_category_details_screen.dart';
// import 'package:flutter_poc_v3/protected_screen.dart/video_widget.dart';
import 'package:get/get.dart';
import 'package:flutter_poc_v3/controllers/category_controller.dart';

// // Import the new AllCategoriesScreen (we'll define it later)
// import 'all_categories_screen.dart'; // Make sure to create this file

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  final double _leftPosition = 3; // Start position for the left side
  final double _rightPosition = 200; // Start position for the right side

  // Scaling factor for the button when it is pressed or hovered
  double _scale = 1.0;
  Color _buttonColor = const Color.fromARGB(255, 238, 97, 3);
  final CategoryController categoryController = Get.put(CategoryController());
  late AnimationController animationController;
  int currentIconIndex = 0;
  final int displayDuration =
      4000; // Duration each icon is displayed in milliseconds





// Add this method to your class
Widget _buildCategoryCard(ProductModel product, bool isFirst) {
  return GestureDetector(
    onTap: () {
      if (product.category?.toLowerCase() != 'cars') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LevenCategoryDetailsScreen(
              productModel: product,
            ),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryDetailsScreen(
              productModel: product,
            ),
          ),
        );
      }
    },
    child: AnimatedContainer(
      duration: Duration(milliseconds: 500),
      padding: EdgeInsets.all(10),
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        color: isFirst 
            ? const Color.fromARGB(255, 125, 1, 187).withOpacity(0.8)
            : const Color.fromARGB(255, 125, 1, 187).withOpacity(0.9),
        borderRadius: BorderRadius.circular(0),
        boxShadow: [
          // BoxShadow(
          //   color: isFirst 
          //       ? const Color.fromARGB(255, 124, 0, 146).withOpacity(0.2)
          //       : const Color.fromARGB(255, 194, 143, 1).withOpacity(0.2),
          //   spreadRadius: 2,
          //   blurRadius: 10,
          //   offset: Offset(0, 4),
          // ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isFirst 
              ? [
                  Color.fromARGB(255, 255, 116, 2).withOpacity(0.8),
                  Color.fromARGB(255, 255, 116, 2).withOpacity(0.9),
                ]
              : [
                  Color.fromARGB(255, 255, 116, 2).withOpacity(0.9),
                  Color.fromARGB(255, 255, 116, 2).withOpacity(1.0),
                ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(0),
            width: 120,
            height: 120,
            child: ClipOval(
              child: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Colors.white.withOpacity(0.9),
                  ],
                ).createShader(bounds),
                child: Image.network(
                  product.icon,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.category,
                      size: 40,
                      color: Colors.purple.shade300,
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 2),
          Text(
            product.category ?? 'Category',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 252, 252, 252),
              // shadows: [
              //   Shadow(
              //     color: Colors.white.withOpacity(0.5),
              //     offset: Offset(0, 1),
              //     blurRadius: 0,
              //   ),
              // ],
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );
}








  @override
  void initState() {
    super.initState();
    categoryController.getData();

    // Initialize animation controller
    animationController = AnimationController(
      vsync: this,
      duration: Duration(
          milliseconds: 4000), // Total animation duration for each icon
    );

    // Start the icon animation sequence
    startIconAnimation();
  }

void startIconAnimation() {
  Future.delayed(Duration(milliseconds: 3000), () {
    if (mounted) {
      setState(() {
        currentIconIndex = (currentIconIndex + 2) % 
            categoryController.productModelList.length;
        animationController.forward(from: 0.0);
      });
      startIconAnimation();
    }
  });
}

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (categoryController) {
      if (categoryController.isLoadingOne) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color.fromARGB(255, 187, 9, 218),
          ),
        );
      }

      return Scaffold(





body: Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        const Color.fromARGB(255, 255, 255, 255),
        const Color.fromARGB(255, 251, 251, 251),
      ],
    ),
  ),
  child: Stack(
    fit: StackFit.expand,
    children: [
      // Rotating Categories
      if (currentIconIndex < categoryController.productModelList.length)
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // First Category
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: Duration(milliseconds: 1000),
                builder: (context, double value, child) {
                  return Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(value * pi * 2 * _scale),
                    alignment: Alignment.center,
                    child: _buildCategoryCard(
                      categoryController.productModelList[currentIconIndex],
                      true,
                    ),
                  );
                },
              ),
              SizedBox(width: 20),
              // Second Category
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: Duration(milliseconds: 1000),
                builder: (context, double value, child) {
                  return Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(-value * pi * 2 * _scale),
                    alignment: Alignment.center,
                    child: _buildCategoryCard(
                      categoryController.productModelList[
                          (currentIconIndex + 1) % categoryController.productModelList.length],
                      false,
                    ),
                  );
                },
              ),
            ],
          ),
        ),

      // View All Button (unchanged)
           AnimatedPositioned(
                duration:
                    Duration(seconds: 1), // Duration of the swipe animation
                bottom: 2,
                right: 5,


                // left: _leftPosition,
                // right: _rightPosition,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AllCategoriesScreen(),
                      ),
                    );
                  },
                  onTapDown: (_) {
                    setState(() {
                      _scale = 0.95; // Scale down when the button is pressed
                      _buttonColor = const Color.fromARGB(
                          255, 9, 249, 69); // Darken color when pressed
                    });
                  },
                  onTapUp: (_) {
                    setState(() {
                      _scale = 1.0; // Scale back when the press is released
                      _buttonColor = const Color.fromARGB(
                          255, 248, 186, 2); // Revert to original color
                    });
                  },
                  onTapCancel: () {
                    setState(() {
                      _scale = 1.0; // Scale back if the tap is canceled
                      _buttonColor = Color.fromARGB(
                          255, 240, 107, 31); // Revert color if tap canceled
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(
                        milliseconds: 800), // Smooth transition duration
                    transform: Matrix4.identity()
                      ..scale(_scale), // Scale effect on tap
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(40), // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 2,
                          offset: Offset(0, 4), // Shadow position
                        ),
                      ],
                      color:
                          _buttonColor, // Button color with smooth transition
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5), // Button padding
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Text(
                        'View All',
                        style: TextStyle(
                          fontSize: 15,
                          color: const Color.fromARGB(255, 252, 247, 247),
                          fontWeight: FontWeight
                              .w900, // Bold text for a modern look
                        ),
                      ),
                    ),
                    
                  ),
                ),
              ),
    ],
  ),
)













        // body: Container(
        //   decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //       begin: Alignment.topLeft,
        //       end: Alignment.bottomRight,
        //       colors: [
        //         const Color.fromARGB(255, 252, 249, 252),
        //         Colors.purple.shade50,
        //       ],
        //     ),
        //   ),
        //   child: Stack(
        //     fit: StackFit.expand, // This ensures the stack fills the container
        //     children: [
        //       // Background Tree Image
        //       // Center(
        //       //   child: Image.asset(
        //       //     'assets/images/leaf.jpg',
        //       //     width: 420,
        //       //     height: 420,
        //       //     fit: BoxFit.fill,
        //       //   ),
        //       // ),

        //       // Centered Animated Icons with Name
        //       if (currentIconIndex < categoryController.productModelList.length)
        //         Center(
        //           // This centers the content in the stack
        //           child: AnimatedOpacity(
        //             duration: Duration(milliseconds: 2000),
        //             opacity: 1.0,
        //             child: FadeTransition(
        //               opacity: Tween<double>(
        //                 begin: 0.0,
        //                 end: 1.0,
        //               ).animate(CurvedAnimation(
        //                 parent: animationController,
        //                 curve: Interval(0.0, 0.5, curve: Curves.easeIn),
        //               )),
        //               child: GestureDetector(
                 

        //                 onTap: () {
        //                   final currentProduct = categoryController
        //                       .productModelList[currentIconIndex];

        //                   // Check if the category is NOT 'cars' (case insensitive)
        //                   if (currentProduct.category?.toLowerCase() !=
        //                       'cars') {
        //                     // For all categories except 'cars', navigate to LevenCategoryDetailsScreen
        //                     Navigator.push(
        //                       context,
        //                       MaterialPageRoute(
        //                         builder: (context) =>
        //                             LevenCategoryDetailsScreen(
        //                           productModel: currentProduct,
        //                         ),
        //                       ),
        //                     );
        //                   } else {
        //                     // For 'cars' category, keep the original navigation
        //                     Navigator.push(
        //                       context,
        //                       MaterialPageRoute(
        //                         builder: (context) => CategoryDetailsScreen(
        //                           productModel: currentProduct,
        //                         ),
        //                       ),
        //                     );
        //                   }
        //                 },

        //                 child: Container(
        //                   padding: EdgeInsets.all(10),
        //                   width: 200,
        //                   height: 200,
        //                   decoration: BoxDecoration(
        //                     color: const Color.fromARGB(255, 182, 187, 199).withOpacity(0.8),
        //                     shape: BoxShape.rectangle,
        //                     borderRadius: BorderRadius.circular(20),
        //                     boxShadow: [
        //                       BoxShadow(
        //                         color: const Color.fromARGB(255, 254, 252, 254),
        //                         spreadRadius: 2,
        //                         blurRadius: 1,
        //                       ),
        //                     ],
        //                   ),
        //                   child: Column(
        //                     mainAxisAlignment: MainAxisAlignment.center,
        //                     children: [
        //                       Container(
        //                         padding: EdgeInsets.all(0),
        //                         width: 150,
        //                         height: 150,
        //                         child: ClipOval(
        //                           child: Image.network(
        //                             categoryController
        //                                 .productModelList[currentIconIndex]
        //                                 .icon,
        //                             fit: BoxFit.contain,
        //                             errorBuilder: (context, error, stackTrace) {
        //                               return Icon(
        //                                 Icons.category,
        //                                 size: 40,
        //                                 color: Colors.purple.shade300,
        //                               );
        //                             },
        //                           ),
        //                         ),
        //                       ),
        //                       SizedBox(height: 10),
        //                       Text(
        //                         categoryController
        //                                 .productModelList[currentIconIndex]
        //                                 .category ??
        //                             'Category',
        //                         style: TextStyle(
        //                           fontSize: 14,
        //                           fontWeight: FontWeight.bold,
        //                           color: const Color.fromARGB(255, 4, 4, 7),
        //                         ),
        //                         textAlign: TextAlign.center,
        //                         maxLines: 1,
        //                         overflow: TextOverflow.ellipsis,
        //                       ),
        //                     ],
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ),

        //       AnimatedPositioned(
        //         duration:
        //             Duration(seconds: 1), // Duration of the swipe animation
        //         bottom: 20,
        //         right: 5,


        //         // left: _leftPosition,
        //         // right: _rightPosition,
        //         child: GestureDetector(
        //           onTap: () {
        //             Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                 builder: (context) => const AllCategoriesScreen(),
        //               ),
        //             );
        //           },
        //           onTapDown: (_) {
        //             setState(() {
        //               _scale = 0.95; // Scale down when the button is pressed
        //               _buttonColor = const Color.fromARGB(
        //                   255, 9, 249, 69); // Darken color when pressed
        //             });
        //           },
        //           onTapUp: (_) {
        //             setState(() {
        //               _scale = 1.0; // Scale back when the press is released
        //               _buttonColor = const Color.fromARGB(
        //                   255, 248, 186, 2); // Revert to original color
        //             });
        //           },
        //           onTapCancel: () {
        //             setState(() {
        //               _scale = 1.0; // Scale back if the tap is canceled
        //               _buttonColor = Color.fromARGB(
        //                   255, 240, 107, 31); // Revert color if tap canceled
        //             });
        //           },
        //           child: AnimatedContainer(
        //             duration: Duration(
        //                 milliseconds: 800), // Smooth transition duration
        //             transform: Matrix4.identity()
        //               ..scale(_scale), // Scale effect on tap
        //             decoration: BoxDecoration(
        //               borderRadius:
        //                   BorderRadius.circular(40), // Rounded corners
        //               boxShadow: [
        //                 BoxShadow(
        //                   color: Colors.black26,
        //                   blurRadius: 2,
        //                   offset: Offset(0, 4), // Shadow position
        //                 ),
        //               ],
        //               color:
        //                   _buttonColor, // Button color with smooth transition
        //             ),
        //             child: Container(
        //               padding: EdgeInsets.symmetric(
        //                   horizontal: 15, vertical: 10), // Button padding
        //               decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(40),
        //               ),
        //               child: Text(
        //                 'View All',
        //                 style: TextStyle(
        //                   fontSize: 15,
        //                   color: const Color.fromARGB(255, 252, 247, 247),
        //                   fontWeight: FontWeight
        //                       .w900, // Bold text for a modern look
        //                 ),
        //               ),
        //             ),
                    
        //           ),
        //         ),
        //       ),
            
        //     ],
        //   ),
        // ),
      );
    });
  }
}


