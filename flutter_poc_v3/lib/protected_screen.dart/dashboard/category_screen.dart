import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/protected_screen.dart/dashboard/category_details_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_poc_v3/controllers/cart_controller.dart';
import 'package:flutter_poc_v3/controllers/category_controller.dart';
import 'package:flutter_poc_v3/models/category_model.dart';


class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  CategoryController categoryController = Get.put(CategoryController());

  @override
  void initState() {
    categoryController.getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (categoryController) {
      return Scaffold(
        body: Column(
        
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 10,
              child: ListView.builder(
                  itemCount: categoryController.categoriesList.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: InkWell(
                        onTap: () {
                          final selectedCategory =
                              categoryController.categoriesList[index];
                          final categoryModel = categoryController.categoryModelList
                              .firstWhere(
                                  (element) =>
                                      element.category == selectedCategory,
                                  orElse: () => CategoryModel(
                                      category: selectedCategory, icon: ''));

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryDetailsScreen(
                                categoryModel: categoryModel,
                              ),
                            ),
                          );
                        },
                        child: Card(
                            elevation: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                categoryController.categoriesList[index],
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            )),
                      ),
                    );
                  }),
            ),
            Expanded(
              child: categoryController.isLoadingOne
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      padding: EdgeInsets.all(0  ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              childAspectRatio: 0.9,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 5),
                      itemCount: categoryController.categoryModelList.length,
                      itemBuilder: (context, index) {
                        CategoryModel categoryModel =
                            categoryController.categoryModelList[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CategoryDetailsScreen(
                                          categoryModel: categoryModel,
                                        )));
                          },
                          child: Card(
                            elevation: 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  categoryModel.icon,
                                  height: 40,
                                  width: 40,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.error, size: 40);
                                  },
                                ),
                                SizedBox(height: 10),
                                Text(
                                  categoryModel.category,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
            ),
          ],
        ),
      );
    });
  }
}


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_poc_v3/controllers/cart_controller.dart';
// import 'package:flutter_poc_v3/controllers/category_controller.dart';
// import 'package:flutter_poc_v3/models/category_model.dart';
// // import 'package:flutter_poc_v3/screens/cart_screen.dart';

// // import 'product_details.dart';

// class CategoryScreen extends StatefulWidget {
//   const CategoryScreen({super.key});

  

//   @override
//   State<CategoryScreen> createState() => _CategoryScreenState();
// }

// class _CategoryScreenState extends State<CategoryScreen> {
//   CategoryController categoryController = Get.put(CategoryController());

//   // CartController cartController = Get.put(CartController());

//   @override
//   void initState() {
//     categoryController.getData();
//     //productsController.createNewOnePost();
//     // productsController.createNewPost();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<CategoryController>(builder: (categoryController) {
//       return Scaffold(
//         // appBar: AppBar(
//         //   centerTitle: true,
//         //   title: const Text("Products List"),
//         //   // actions: [
//         //   //   GetBuilder<CartController>(builder: (cartController) {
//         //   //     return Stack(
//         //   //       children: [
//         //   //         IconButton(
//         //   //             onPressed: () {
//         //   //               Navigator.of(context).push(MaterialPageRoute(
//         //   //                   builder: (builder) => const CartScreen()));
//         //   //             },
//         //   //             icon: const Icon(Icons.add_shopping_cart_rounded)),
//         //   //         CircleAvatar(
//         //   //           radius: 10,
//         //   //           backgroundColor: Colors.amber,
//         //   //           child: Container(
//         //   //               alignment: Alignment.center,
//         //   //               padding:const EdgeInsets.all(2),
//         //   //               child: Text("${cartController.cartList.length}")),
//         //   //         )
//         //   //       ],
//         //   //     );
//         //   //   })
//         //   // ],
//         // ),
//         body: Column(
//           children: [
//             SizedBox(
//               height: 10,
//               child: ListView.builder(
//                   itemCount: categoryController.categoriesList.length,
//                   shrinkWrap: true,
//                    physics: NeverScrollableScrollPhysics(), // Disable independent scrolling

//                   // scrollDirection: Axis.horizontal,
//                   itemBuilder: (context, index) {
//                     return InkWell(
//                       // onTap: () {
//                       //   productsController.getProductsByCategory(
//                       //       productsController.categoriesList[index]);
//                       // },
//                       child: Card(
//                           child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(categoryController.categoriesList[index]),
//                       )),
//                     );
//                   }),
//             ),
//             Expanded(
//               child: categoryController.isLoadingOne
//                   ? const Center(child: CircularProgressIndicator())
//                   : GridView.builder(
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 5, childAspectRatio: 0.9),
//                       itemCount: categoryController.categoryModelList.length,
//                       itemBuilder: (context, index) {
//                         CategoryModel categoryModel =
//                             categoryController.categoryModelList[index];
//                         return InkWell(
//                           onTap: () {
//                             // Navigator.push(
//                             //     context,
//                             //     MaterialPageRoute(
//                             //         builder: (builder) => ProductDetails(
//                             //               productModel: productModel,
//                             //             )));
//                           },
//                           child: Card(
//                             child: Column(
//                               children: [
//                                 Image.network(
//                                   categoryModel.icon,
//                                   height: 50,
//                                   width: 50,
//                                   fit: BoxFit.fill,
//                                   errorBuilder: (context, error, stackTrace) {
//                                     return const Icon(Icons.error);
//                                   },
//                                 ),
//                                 // Text(
//                                 //   productModel.title,
//                                 //   maxLines: 1,
//                                 // ),
//                                 Text(
//                                   categoryModel.category,
//                                   maxLines: 1,
//                                 ),
//                                 // Text("\$${productModel.price.toString()}"),
//                                 // IconButton(
//                                 //     onPressed: () {
//                                 //       cartController.addToCart(
//                                 //           context, productModel);
//                                 //     },
//                                 //     icon: const Icon(
//                                 //         Icons.add_shopping_cart_outlined))
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
