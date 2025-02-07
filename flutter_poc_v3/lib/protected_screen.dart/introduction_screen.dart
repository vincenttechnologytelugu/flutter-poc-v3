import 'package:flutter/material.dart';
import 'package:animated_introduction/animated_introduction.dart';
import 'package:flutter_poc_v3/protected_screen.dart/notifications_screen.dart';
class IntroductionScreen extends StatefulWidget {
   IntroductionScreen({super.key});
  
  /// List of pages to be shown in the introduction
///
final List<SingleIntroScreen> pages = [
  const SingleIntroScreen(
    title: 'Welcome to the Event Management App !',
    
    description: 'You plans your Events, We\'ll do the rest and will be the best! Guaranteed!  ',
    imageNetwork: "https://media.istockphoto.com/id/621856364/photo/certified-tick-icon.jpg?s=2048x2048&w=is&k=20&c=9lLsW0dnMZq3KXViK2RnfOThjEk-pYwvp49D6STK4q0=",

    // imageAsset: 'assets/images/allevents.png',
  ),
  const SingleIntroScreen(
    title: 'Book tickets to cricket matches and events',
    description: 'Tickets to the latest movies, crickets matches, concerts, comedy shows, plus lots more !',
    imageNetwork: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS1fQ_bZkowoTHogTcoZIMEfJ8MakI-08PSaA&s",
    // imageAsset: 'assets/images/cricket.png',
  ),
  const SingleIntroScreen(
    title: 'Grabs all events now only in your hands',
    description: 'All events are now in your hands, just a click away ! ',
    imageNetwork: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTYgFL8YKGFw-g41tSuGfBa5ttbuOG9OTev8Q&s",
    // imageAsset: 'assets/images/events.png',
  ),
    const SingleIntroScreen(
    title: 'Grabs all events now only in your hands',
    description: 'All events are now in your hands, just a click away ! ',
    imageNetwork: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTEqesCYqHmjBw5QqNjc7hJPLx-LESdYftEEw&s",
    // imageAsset: 'assets/images/events.png',
  ),
];

/// Example page

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  
 @override
  Widget build(BuildContext context) {
    return AnimatedIntroduction(
    
      skipText: 'Skip',
      nextText: 'Next',
      doneText: 'Done',
 

      slides: widget.pages,

      // slides: pages,
      indicatorType: IndicatorType.circle,


      onDone: () {
      Navigator.pushReplacement(
            
              context,
              MaterialPageRoute(builder: (context) => const NotificationsScreen()),
            );
        /// TODO: Go to desire page like login or home
      },
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
