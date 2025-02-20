import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/models/product_model.dart';
import 'package:flutter_poc_v3/protected_screen.dart/dashboard/category_details_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_poc_v3/controllers/category_controller.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  CategoryController categoryController = Get.put(CategoryController());
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    categoryController.getData();
    _pageController = PageController(
      viewportFraction: 0.85,
      initialPage: 0,
    );
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (_currentPage < categoryController.productModelList.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (categoryController) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                // Colors.purple.shade100,
                // Colors.purple.shade50,
                const Color.fromARGB(255, 202, 4, 241),
                const Color.fromARGB(255, 250, 62, 5),
              ],
            ),
          ),
          child: categoryController.isLoadingOne
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 187, 9, 218),
                  ),
                )
              : Column(
                  children: [
                    const SizedBox(height: 10),
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() => _currentPage = index);
                        },
                        itemCount: categoryController.productModelList.length,
                        itemBuilder: (context, index) {
                          ProductModel product =
                              categoryController.productModelList[index];
                          double scale = _currentPage == index ? 1.0 : 0.9;
                          return TweenAnimationBuilder(
                            duration: const Duration(milliseconds: 350),
                            tween: Tween(begin: scale, end: scale),
                            curve: Curves.ease,
                            builder: (context, double value, child) {
                              return Transform.scale(
                                scale: value,
                                child: child,
                              );
                            },
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CategoryDetailsScreen(
                                      productModel: product,
                                    ),
                                  ),
                                );
                              },
                              child: Hero(
                                tag: 'category_${product.category}',
                                child: Card(
                                  elevation: 6,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Stack(
                                    children: [
                                      
                                      // Background Image
                                      ClipRRect(

                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.network(
                                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRwVLs8BDLx5ndhLuTZAq4uMSMkEHO24xdfgw&s',
                                          // product.icon,
                                          height: double.infinity,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              color: Colors.purple.shade50,
                                              child: Icon(
                                                Icons.category,
                                                size: 40,
                                                color: const Color.fromARGB(255, 239, 236, 240),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      // Gradient Overlay
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              const Color.fromARGB(0, 245, 226, 235),
                                              const Color.fromARGB(255, 11, 11, 11).withAlpha((0.9 * 255).round()),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // Content
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              product.category.toString(),
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(255, 250, 249, 252),
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 10),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CategoryDetailsScreen(
                                                      productModel: product,
                                                    ),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.purple.shade400,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 15,
                                                  vertical: 5,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                              ),
                                              child: const Text(
                                                'View Details',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // child: Card(
                                //   elevation: 6,
                                //   shape: RoundedRectangleBorder(
                                //     borderRadius: BorderRadius.circular(20),
                                //   ),
                                //   child: Container(
                                //     padding: const EdgeInsets.all(10),
                                //     decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.circular(30),
                                //       gradient: LinearGradient(
                                //         begin: Alignment.topLeft,
                                //         end: Alignment.bottomRight,
                                //         colors: [
                                //           const Color.fromARGB(255, 233, 233, 239),
                                //           const Color.fromARGB(255, 233, 224, 231),
                                //         ],
                                //       ),
                                //     ),
                                //     child: Column(
                                //       mainAxisAlignment: MainAxisAlignment.center,
                                //       children: [

                                //         Container(
                                //           padding: const EdgeInsets.all(0),
                                //           decoration: BoxDecoration(
                                //             color: Colors.white,
                                //             shape: BoxShape.circle,
                                //             boxShadow: [
                                //               BoxShadow(
                                //                 color: const Color.fromARGB(255, 179, 160, 182).withAlpha(100),
                                //                 spreadRadius: 1,
                                //                 blurRadius: 1,
                                //               ),
                                //             ],
                                //           ),
                                //           child: Image.network(
                                //             product.icon,
                                //             height: 55,
                                //             width: 55,
                                //             fit: BoxFit.contain,
                                //             errorBuilder: (context, error, stackTrace) {
                                //               return Icon(
                                //                 Icons.category,
                                //                 size: 40,
                                //                 color: Colors.purple.shade300,
                                //               );
                                //             },
                                //           ),
                                //         ),
                                //         const SizedBox(height: 10),
                                //         Text(
                                //           product.category.toString(),
                                //           style: TextStyle(
                                //             fontSize: 20,
                                //             fontWeight: FontWeight.bold,
                                //             color: Colors.purple.shade700,
                                //           ),
                                //           textAlign: TextAlign.center,
                                //         ),
                                //         const SizedBox(height: 10),
                                //         ElevatedButton(
                                //           onPressed: () {
                                //             Navigator.push(
                                //               context,
                                //               MaterialPageRoute(
                                //                 builder: (context) =>
                                //                     CategoryDetailsScreen(
                                //                       productModel: product,
                                //                     ),
                                //               ),
                                //             );
                                //           },
                                //           style: ElevatedButton.styleFrom(
                                //             backgroundColor: Colors.purple.shade400,
                                //             padding: const EdgeInsets.symmetric(
                                //               horizontal: 15,
                                //               vertical: 5,
                                //             ),
                                //             shape: RoundedRectangleBorder(
                                //               borderRadius: BorderRadius.circular(30),
                                //             ),
                                //           ),
                                //           child: const Text(
                                //             'View Details',
                                //             style: TextStyle(
                                //               fontSize: 15,
                                //               color: Colors.white,
                                //             ),
                                //           ),
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          categoryController.productModelList.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: 8,
                            width: _currentPage == index ? 20 : 6,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: _currentPage == index
                                  ? Colors.white
                                  : Colors.purple.withAlpha((0.9 * 255).round()),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      );
    });
  }
}





















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



