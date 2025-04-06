// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_poc_v3/models/product_model.dart';
// import 'package:flutter_poc_v3/protected_screen.dart/dashboard/category_details_screen.dart';
// import 'package:get/get.dart';
// import 'package:flutter_poc_v3/controllers/category_controller.dart';

// class CategoryScreen extends StatefulWidget {
//   const CategoryScreen({super.key});

//   @override
//   State<CategoryScreen> createState() => _CategoryScreenState();
// }

// class _CategoryScreenState extends State<CategoryScreen> {
//   CategoryController categoryController = Get.put(CategoryController());
//   late PageController _pageController;
//   int _currentPage = 0;
//   Timer? _timer;

//   @override
//   void initState() {
//     super.initState();
//     categoryController.getData();
//     _pageController = PageController(
//       viewportFraction: 0.85,
//       initialPage: 0,
//     );
//     _startAutoSlide();
//   }

//   void _startAutoSlide() {
//     _timer = Timer.periodic(const Duration(seconds: 6), (timer) {
//       if (_currentPage < categoryController.productModelList.length - 1) {
//         _currentPage++;
//       } else {
//         _currentPage = 0;
//       }

//       if (_pageController.hasClients) {
//         _pageController.animateToPage(
//           _currentPage,
//           duration: const Duration(milliseconds: 800),
//           curve: Curves.easeInOutCubic,
//         );
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<CategoryController>(builder: (categoryController) {
//       return Scaffold(
//         body: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 // Colors.purple.shade100,
//                 // Colors.purple.shade50,
//                 const Color.fromARGB(255, 202, 4, 241),
//                 const Color.fromARGB(255, 250, 62, 5),
//               ],
//             ),
//           ),
//           child: categoryController.isLoadingOne
//               ? const Center(
//                   child: CircularProgressIndicator(
//                     color: Color.fromARGB(255, 187, 9, 218),
//                   ),
//                 )
//               : Column(
//                   children: [
//                     const SizedBox(height: 10),
//                     Expanded(
//                       child: PageView.builder(
//                         controller: _pageController,
//                         onPageChanged: (index) {
//                           setState(() => _currentPage = index);
//                         },
//                         itemCount: categoryController.productModelList.length,
//                         itemBuilder: (context, index) {
//                           ProductModel product =
//                               categoryController.productModelList[index];
//                           double scale = _currentPage == index ? 1.0 : 0.9;
//                           return TweenAnimationBuilder(
//                             duration: const Duration(milliseconds: 350),
//                             tween: Tween(begin: scale, end: scale),
//                             curve: Curves.ease,
//                             builder: (context, double value, child) {
//                               return Transform.scale(
//                                 scale: value,
//                                 child: child,
//                               );
//                             },
//                             child: GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => CategoryDetailsScreen(
//                                       productModel: product,
//                                     ),
//                                   ),
//                                 );
//                               },

//                                 child: Card(
//                                   elevation: 6,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(20),
//                                   ),
//                                   child: Container(
//                                     padding: const EdgeInsets.all(10),
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(30),
//                                       gradient: LinearGradient(
//                                         begin: Alignment.topLeft,
//                                         end: Alignment.bottomRight,
//                                         colors: [
//                                           const Color.fromARGB(255, 233, 233, 239),
//                                           const Color.fromARGB(255, 233, 224, 231),
//                                         ],
//                                       ),
//                                     ),
//                                     child: Column(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [

//                                         Container(
//                                           padding: const EdgeInsets.all(0),
//                                           decoration: BoxDecoration(
//                                             color: Colors.white,
//                                             shape: BoxShape.circle,
//                                             boxShadow: [
//                                               BoxShadow(
//                                                 color: const Color.fromARGB(255, 179, 160, 182).withAlpha(100),
//                                                 spreadRadius: 1,
//                                                 blurRadius: 1,
//                                               ),
//                                             ],
//                                           ),
//                                           child: Image.network(
//                                             product.icon,
//                                             height: 55,
//                                             width: 55,
//                                             fit: BoxFit.contain,
//                                             errorBuilder: (context, error, stackTrace) {
//                                               return Icon(
//                                                 Icons.category,
//                                                 size: 40,
//                                                 color: Colors.purple.shade300,
//                                               );
//                                             },
//                                           ),
//                                         ),
//                                         const SizedBox(height: 10),
//                                         Text(
//                                           product.category.toString(),
//                                           style: TextStyle(
//                                             fontSize: 20,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.purple.shade700,
//                                           ),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                         const SizedBox(height: 10),
//                                         ElevatedButton(
//                                           onPressed: () {
//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (context) =>
//                                                     CategoryDetailsScreen(
//                                                       productModel: product,
//                                                     ),
//                                               ),
//                                             );
//                                           },
//                                           style: ElevatedButton.styleFrom(
//                                             backgroundColor: Colors.purple.shade400,
//                                             padding: const EdgeInsets.symmetric(
//                                               horizontal: 15,
//                                               vertical: 5,
//                                             ),
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius: BorderRadius.circular(30),
//                                             ),
//                                           ),
//                                           child: const Text(
//                                             'View Details',
//                                             style: TextStyle(
//                                               fontSize: 15,
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),

//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 10, top: 2),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: List.generate(
//                           categoryController.productModelList.length,
//                           (index) => AnimatedContainer(
//                             duration: const Duration(milliseconds: 300),
//                             height: 8,
//                             width: _currentPage == index ? 20 : 6,
//                             margin: const EdgeInsets.symmetric(horizontal: 2),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(4),
//                               color: _currentPage == index
//                                   ? Colors.white
//                                   : Colors.purple.withAlpha((0.9 * 255).round()),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//         ),
//       );
//     });
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_poc_v3/models/product_model.dart';
// import 'package:flutter_poc_v3/protected_screen.dart/dashboard/category_details_screen.dart';
// import 'package:get/get.dart';
// import 'package:flutter_poc_v3/controllers/category_controller.dart';

// class CategoryScreen extends StatefulWidget {

//   const CategoryScreen({super.key});

//   @override
//   State<CategoryScreen> createState() => _CategoryScreenState();
// }

// class _CategoryScreenState extends State<CategoryScreen> {
//   CategoryController categoryController = Get.put(CategoryController());

//   @override
//   void initState() {
//     categoryController.getData();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<CategoryController>(builder: (categoryController) {
//       return Scaffold(
//         body: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 Colors.purple.shade100,
//                 Colors.purple.shade50,
//               ],
//             ),
//           ),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [

//               Container(
//                 width: MediaQuery.of(context).size.width *0 , // 20% of screen width
//                 height: 0,
//                 margin: const EdgeInsets.symmetric(horizontal: 3),
//                 child: ListView.builder(
//                   itemCount: categoryController.categoriesList.length,
//                   scrollDirection: Axis.vertical,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.only(right: 4.0),
//                       child: FilterChip(
//                         label: Text(
//                           categoryController.categoriesList[index],
//                           style: TextStyle(
//                             color: Colors.white,
//                           ),
//                         ),
//                         selected: false,
//                         onSelected: (bool selected) {
//                           final selectedCategory =
//                               categoryController.categoriesList[index];
//                           final productModel = categoryController.productModelList
//                               .firstWhere(
//                                   (element) =>
//                                       element.category == selectedCategory,
//                                   orElse: () => ProductModel(
//                                       category: selectedCategory, icon: ''));

//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => CategoryDetailsScreen(
//                                 productModel: productModel,
//                               ),
//                             ),
//                           );
//                         },
//                         backgroundColor: Colors.purple.shade300,
//                         selectedColor: Colors.purple.shade700,
//                         elevation: 2,
//                       ),
//                     );
//                   },
//                 ),
//               ),

//               const SizedBox(height: 10),

//               // Grid View
//               Expanded(
//                 child: categoryController.isLoadingOne
//                     ? const Center(
//                         child: CircularProgressIndicator(
//                           color: Color.fromARGB(255, 187, 9, 218),
//                         ),
//                       )
//                     : Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 5),
//                         child: GridView.builder(
//                           gridDelegate:
//                               const SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 5,
//                             childAspectRatio: .8,
//                             crossAxisSpacing: 5,
//                             mainAxisSpacing: 5,
//                           ),
//                           itemCount: categoryController.productModelList.length,
//                           itemBuilder: (context, index) {
//                             ProductModel productModel =
//                                 categoryController.productModelList[index];
//                             return InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => CategoryDetailsScreen(
//                                       productModel: productModel,
//                                     ),
//                                   ),
//                                 );
//                               },
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(15),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.purple.withOpacity(0.1),
//                                       spreadRadius: 1,
//                                       blurRadius: 10,
//                                       offset: const Offset(0, 3),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Container(
//                                       padding: const EdgeInsets.all(8),
//                                       decoration: BoxDecoration(
//                                         color: Colors.purple.shade50,
//                                         shape: BoxShape.circle,
//                                       ),
//                                       child: Image.network(
//                                         productModel.icon,
//                                         height: 50,
//                                         width: 50,
//                                         fit: BoxFit.cover,
//                                         errorBuilder:
//                                             (context, error, stackTrace) {
//                                           return Icon(
//                                             Icons.category,
//                                             size: 50,
//                                             color: Colors.purple.shade300,
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                     const SizedBox(height: 5),
//                                     Text(
//                                       productModel.category.toString(),
//                                       maxLines: 1,
//                                       textAlign: TextAlign.center,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.w600,
//                                         color: const Color.fromARGB(255, 95, 1, 211),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_poc_v3/protected_screen.dart/dashboard/category_details_screen.dart';
// import 'package:get/get.dart';

// import 'package:flutter_poc_v3/controllers/category_controller.dart';
// import 'package:flutter_poc_v3/models/category_model.dart';

// class CategoryScreen extends StatefulWidget {
//   const CategoryScreen({super.key});

//   @override
//   State<CategoryScreen> createState() => _CategoryScreenState();
// }

// class _CategoryScreenState extends State<CategoryScreen> {
//   CategoryController categoryController = Get.put(CategoryController());

//   @override
//   void initState() {
//     categoryController.getData();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<CategoryController>(builder: (categoryController) {
//       return Scaffold(
//         backgroundColor: const Color.fromARGB(255, 202, 164, 222),
//         body: Column(

//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               margin: EdgeInsets.all(0),
//               height: 10,
//               child: ListView.builder(
//                   itemCount: categoryController.categoriesList.length,
//                   shrinkWrap: true,
//                   scrollDirection: Axis.horizontal,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                       child: InkWell(
//                         onTap: () {
//                           final selectedCategory =
//                               categoryController.categoriesList[index];
//                           final categoryModel = categoryController.categoryModelList
//                               .firstWhere(
//                                   (element) =>
//                                       element.category == selectedCategory,
//                                   orElse: () => CategoryModel(
//                                       category: selectedCategory, icon: ''));

//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => CategoryDetailsScreen(
//                                 categoryModel: categoryModel,
//                               ),
//                             ),
//                           );
//                         },
//                         child: Card(
//                             elevation: 1,
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(
//                                 categoryController.categoriesList[index],
//                                 style: TextStyle(
//                                     fontSize: 16, fontWeight: FontWeight.w500),
//                               ),
//                             )),
//                       ),
//                     );
//                   }),
//             ),
//             Expanded(
//               child: categoryController.isLoadingOne
//                   ? const Center(child: CircularProgressIndicator())
//                   : GridView.builder(
//                       padding: EdgeInsets.all(0  ),
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 5,
//                               childAspectRatio: 0.9,
//                               crossAxisSpacing: 10,
//                               mainAxisSpacing: 5),
//                       itemCount: categoryController.categoryModelList.length,
//                       itemBuilder: (context, index) {
//                         CategoryModel categoryModel =
//                             categoryController.categoryModelList[index];
//                         return InkWell(
//                           onTap: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => CategoryDetailsScreen(
//                                           categoryModel: categoryModel,
//                                         )));
//                           },
//                           child: Card(
//                             elevation: 3,
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Image.network(
//                                   categoryModel.icon,
//                                   height: 40,
//                                   width: 40,
//                                   fit: BoxFit.cover,
//                                   errorBuilder: (context, error, stackTrace) {
//                                     return const Icon(Icons.error, size: 40);
//                                   },
//                                 ),
//                                 SizedBox(height: 10),
//                                 Text(
//                                   categoryModel.category,
//                                   maxLines: 1,
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       }),
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
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
    Future.delayed(Duration(milliseconds: displayDuration), () {
      if (mounted) {
        setState(() {
          currentIconIndex = (currentIconIndex + 1) %
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
                Colors.purple.shade100,
                Colors.purple.shade50,
              ],
            ),
          ),
          child: Stack(
            fit: StackFit.expand, // This ensures the stack fills the container
            children: [
              // Background Tree Image
              Center(
                child: Image.asset(
                  'assets/images/leaf.jpg',
                  width: 420,
                  height: 420,
                  fit: BoxFit.fill,
                ),
              ),

              // Centered Animated Icons with Name
              if (currentIconIndex < categoryController.productModelList.length)
                Center(
                  // This centers the content in the stack
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 2000),
                    opacity: 1.0,
                    child: FadeTransition(
                      opacity: Tween<double>(
                        begin: 0.0,
                        end: 1.0,
                      ).animate(CurvedAnimation(
                        parent: animationController,
                        curve: Interval(0.0, 0.5, curve: Curves.easeIn),
                      )),
                      child: GestureDetector(
                        // onTap: () {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => CategoryDetailsScreen(
                        //         productModel: categoryController
                        //             .productModelList[currentIconIndex],
                        //       ),
                        //     ),
                        //   );
                        // },

                        onTap: () {
                          final currentProduct = categoryController
                              .productModelList[currentIconIndex];

                          // Check if the category is NOT 'cars' (case insensitive)
                          if (currentProduct.category?.toLowerCase() !=
                              'cars') {
                            // For all categories except 'cars', navigate to LevenCategoryDetailsScreen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    LevenCategoryDetailsScreen(
                                  productModel: currentProduct,
                                ),
                              ),
                            );
                          } else {
                            // For 'cars' category, keep the original navigation
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryDetailsScreen(
                                  productModel: currentProduct,
                                ),
                              ),
                            );
                          }
                        },

                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 1,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(0),
                                width: 55,
                                height: 55,
                                child: ClipOval(
                                  child: Image.network(
                                    categoryController
                                        .productModelList[currentIconIndex]
                                        .icon,
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
                              SizedBox(height: 10),
                              Text(
                                categoryController
                                        .productModelList[currentIconIndex]
                                        .category ??
                                    'Category',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple.shade700,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              AnimatedPositioned(
                duration:
                    Duration(seconds: 20), // Duration of the swipe animation
                bottom: 0,
                left: _leftPosition,
                right: _rightPosition,
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
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16), // Adjust padding for text
                      child: Column(
                        children: [
                          Text(
                            'View All',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight
                                  .w600, // Bold text for a modern look
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // View All Button
              // Positioned(
              //   bottom: 0,
              //   left: 3,
              //   right: 200,
              //   child: ElevatedButton(
              //     onPressed: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => const AllCategoriesScreen(),
              //         ),
              //       );
              //     },
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.purple.shade400,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(20),
              //       ),
              //     ),
              //     child: Text(
              //       'View All',
              //       style: TextStyle(
              //         fontSize: 16,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      );
    });
  }
}


// class _CategoryScreenState extends State<CategoryScreen>
//     with SingleTickerProviderStateMixin {
//   final CategoryController categoryController = Get.put(CategoryController());
//   late AnimationController animationController;
//   int currentSetIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     // Fetch category data
//     categoryController.getData();

//     // Initialize animation controller for 10-second cycles
//     animationController = AnimationController(
//       duration: const Duration(seconds: 10),
//       vsync: this,
//     )..repeat();

//     // Listen for animation completion to update the category set
//     animationController.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         setState(() {
//           int totalCategories = categoryController.productModelList.length;
//           int totalSets = (totalCategories / 5).ceil();
//           currentSetIndex = (currentSetIndex + 1) % totalSets;
//         });
//         animationController.forward(from: 0.0);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     animationController.dispose();
//     super.dispose();
//   }

//   /// Calculates opacity for each leaf based on animation progress
//   /// Leaves fade in sequentially and fade out together
//   double getOpacity(int i) {
//     double start = i / 10.0; // Start time for leaf i
//     double end = start + 0.1; // End time for fade-in
//     double fadeOutStart = 0.9; // Start time for fade-out
//     double fadeOutEnd = 1.0; // End time for fade-out
//     double value = animationController.value;

//     if (value < start) {
//       return 0.0; // Not visible yet
//     } else if (value < end) {
//       return (value - start) / 0.1; // Fade in
//     } else if (value < fadeOutStart) {
//       return 1.0; // Fully visible
//     } else if (value < fadeOutEnd) {
//       return 1.0 - (value - fadeOutStart) / 0.1; // Fade out
//     } else {
//       return 0.0; // Not visible
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<CategoryController>(builder: (categoryController) {
//       if (categoryController.isLoadingOne) {
//         return const Center(
//           child: CircularProgressIndicator(
//             color: Color.fromARGB(255, 187, 9, 218),
//           ),
//         );
//       }

//       // Compute current categories based on set index
//       int totalCategories = categoryController.productModelList.length;
//       int totalSets = (totalCategories / 5).ceil();
//       int start = (currentSetIndex % totalSets) * 5;
//       int end = start + 5;
//       if (end > totalCategories) {
//         end = totalCategories;
//       }
//       List<ProductModel> currentCategories =
//           categoryController.productModelList.sublist(start, end);

//       // Define leaf positions (adjust based on your tree image)
//       List<Offset> leafPositions = [
//         const Offset(100, 200),
//         const Offset(150, 150),
//         const Offset(200, 250),
//         const Offset(250, 180),
//         const Offset(300, 220),
//       ];

//       return Scaffold(
//         body: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 Colors.purple.shade100,
//                 Colors.purple.shade50,
//               ],
//             ),
//           ),
//           child: Stack(
//             children: [
//               // Tree image (centered)
//               // Center(
//               //   child: VideoWidget(),
//               // ),

//               Center(
//                 child: Image.asset(
//                   // 'assets/tree.png', // Replace with your tree image
//                   'assets/images/leaf1.jpg',
//                   width: 420,
//                   height: 420,

//                   fit: BoxFit.fill,
//                 ),
//               ),
//               // Leaves with category icons
//               for (int i = 0; i < 5; i++)
//                 if (i < currentCategories.length)
//                   Positioned(
//                     left: leafPositions[i].dx,
//                     top: leafPositions[i].dy,
                 
//                     child: Opacity(
//                       opacity: getOpacity(i),
//                       child: GestureDetector(
//                         onTap: () {
//                           // Navigate to category details
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => CategoryDetailsScreen(
//                                 productModel: currentCategories[i],
//                               ),
//                             ),
//                           );
//                         },
//                         child: Container(
//                           width: 50,
//                           height: 50,
//                           decoration: BoxDecoration(
//                               // image: DecorationImage(
//                               //   image: const AssetImage('assets/images/mklogo.jpg'), // Replace with your leaf image
//                               //   fit: BoxFit.cover,
//                               // ),
//                               ),
//                           child: Center(
//                             child: Image.network(
//                               currentCategories[i].icon,
//                               width: 100,
//                               height: 100,
//                               fit: BoxFit.cover,
//                               errorBuilder: (context, error, stackTrace) {
//                                 return Icon(
//                                   Icons.category,
//                                   size: 30,
//                                   color: Colors.purple.shade300,
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//               // View All button
//               Positioned(
//                 bottom: 20,
//                 left: 0,
//                 right: 0,
//                 child: Center(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       // Navigate to AllCategoriesScreen
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const AllCategoriesScreen(),
//                         ),
//                       );
//                     },
//                     child: const Text('View All'),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }
