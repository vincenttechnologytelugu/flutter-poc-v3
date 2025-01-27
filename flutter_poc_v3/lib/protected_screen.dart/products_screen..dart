
import 'package:flutter/material.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Products Screen"),
      ),
    );
  }
}




// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_poc_v3/protected_screen.dart/product_listview.dart';
// import 'package:get/get.dart';
// //import 'package:flutter_poc_v3/controllers/cart_controller.dart';
// import 'package:flutter_poc_v3/controllers/products_controller.dart';
// import 'package:flutter_poc_v3/models/product_model.dart';
// //import 'package:flutter_poc_v3/screens/cart_screen.dart';

// import 'product_details.dart';

// class ProductsScreen extends StatefulWidget {
//   const ProductsScreen({super.key});

//   @override
//   State<ProductsScreen> createState() => _ProductsScreenState();
// }

// class _ProductsScreenState extends State<ProductsScreen> {
//   ProductsController productsController = Get.put(ProductsController());

//   //CartController cartController = Get.put(CartController());

//   @override
//   void initState() {
//     productsController.getData();
//     //productsController.createNewOnePost();
//     //productsController.createNewPost();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<ProductsController>(builder: (productsController) {
//       return Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           title: const Text("Products List"),
//           // actions: [
//           //   GetBuilder<CartController>(builder: (cartController) {
//           //     return Stack(
//           //       children: [
//           //         IconButton(
//           //             onPressed: () {
//           //               Navigator.of(context).push(MaterialPageRoute(
//           //                   builder: (builder) => const CartScreen()));
//           //             },
//           //             icon: const Icon(Icons.add_shopping_cart_rounded)),
//           //         CircleAvatar(
//           //           radius: 10,
//           //           backgroundColor: Colors.amber,
//           //           child: Container(
//           //               alignment: Alignment.center,
//           //               padding:const EdgeInsets.all(2),
//           //               child: Text("${cartController.cartList.length}")),
//           //         )
//           //       ],
//           //     );
//           //   })
//           // ],
//         ),
//         body:
//         Column(
//           children: [
//             SizedBox(
//               height: 45,
//               child: ListView.builder(
//                   itemCount: productsController.categoriesList.length,
//                   scrollDirection: Axis.horizontal,
//                   itemBuilder: (context, index) {
//                     return InkWell(
//                       onTap: () {
//                         // productsController.getProductsByCategory(
//                         //     productsController.categoriesList[index]);
//                       },
//                       child: Card(
//                           child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(productsController.categoriesList[index]),
//                       )),
//                     );
//                   }),
//             ),
//             Expanded(
//               child: productsController.isLoadingOne
//                   ? const Center(child: CircularProgressIndicator())
//                   : GridView.builder(
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 2, childAspectRatio: 0.9),
//                       itemCount: productsController.productModelList.length,
//                       itemBuilder: (context, index) {
//                         ProductModel productModel =
//                             productsController.productModelList[index];
//                         return InkWell(
//                             onTap: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (builder) => ProductDetails(
//                                             productModel: productModel,
//                                           )));
//                             },
//                             child: Card(
//                               elevation: 4,
//                               margin: EdgeInsets.all(8),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   // Thumbnail Image
//                                   Container(
//                                     height: 200,
//                                     width: double.infinity,
//                                     child: productModel.thumb != null
//                                         ? Image.network(
//                                             productModel.thumb!,
//                                             fit: BoxFit.cover,
//                                             loadingBuilder: (context, child,
//                                                 loadingProgress) {
//                                               if (loadingProgress == null)
//                                                 return child;
//                                               return Center(
//                                                 child:
//                                                     CircularProgressIndicator(
//                                                   value: loadingProgress
//                                                               .expectedTotalBytes !=
//                                                           null
//                                                       ? loadingProgress
//                                                               .cumulativeBytesLoaded /
//                                                           loadingProgress
//                                                               .expectedTotalBytes!
//                                                       : null,
//                                                 ),
//                                               );
//                                             },
//                                             errorBuilder:
//                                                 (context, error, stackTrace) {
//                                               log(
//                                                   'Error loading image: $error');
//                                               return Container(
//                                                 color: Colors.grey[200],
//                                                 child: Center(
//                                                   child: Icon(
//                                                     Icons.image_not_supported,
//                                                     size: 40,
//                                                     color: Colors.grey[400],
//                                                   ),
//                                                 ),
//                                               );
//                                             },
//                                           )
//                                         : Container(
//                                             color: Colors.grey[200],
//                                             child: Center(
//                                               child: Icon(
//                                                 Icons.image_not_supported,
//                                                 size: 40,
//                                                 color: Colors.grey[400],
//                                               ),
//                                             ),
//                                           ),
//                                   ),

//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         // Price
//                                         Text(
//                                           '₹ ${productModel.price?.toString() ?? 'N/A'}',
//                                           style: TextStyle(
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.orange,
//                                           ),
//                                         ),
//                                         SizedBox(height: 4),
//                                         // Brand
//                                         Text(
//                                           productModel.brand ?? 'N/A',
//                                           style: TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                         SizedBox(height: 4),
//                                         // Year and Mileage
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Text(
//                                               '${productModel.year ?? 'N/A'}',
//                                               style: TextStyle(
//                                                   color: Colors.grey[600]),
//                                             ),
//                                             Text(
//                                               '${productModel.mileage ?? '0'} km',
//                                               style: TextStyle(
//                                                   color: Colors.grey[600]),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ));
//                       }),
//             ),
//             //  Expanded(
//             //   child: ProductListView()
//             //   ),
//           ],
//         ),
//       );
//     });
//   }
// }
