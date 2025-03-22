// // all_category_details_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_poc_v3/models/product_model.dart';
// import 'package:flutter_poc_v3/protected_screen.dart/dashboard/category_based_posts_screen.dart';
// import 'package:flutter_poc_v3/protected_screen.dart/homeappbar_screen.dart';
// import 'package:get/get.dart';
// import 'package:flutter_poc_v3/controllers/location_controller.dart';

// class LevenCategoryDetailsScreen extends StatefulWidget {
//   final ProductModel productModel;

//   LevenCategoryDetailsScreen({Key? key, required this.productModel}) : super(key: key);

//   @override
//   State<LevenCategoryDetailsScreen> createState() => _LevenCategoryDetailsScreenState();
// }

// class _LevenCategoryDetailsScreenState extends State<LevenCategoryDetailsScreen> {
//   final LocationController locationController = Get.find<LocationController>();
//  String location = "Select Location"; // Add this line
//   void navigateToCategoryPosts({required String findkey}) {
//     String baseUrl = 'http://13.200.179.78/adposts';
//     String category = Uri.encodeComponent(widget.productModel.category ?? '');
//     String url;

//     String? city = locationController.selectedCity.value;
//     String? state = locationController.selectedState.value;

//     url = '$baseUrl?category=$category&findkey=$findkey';
//     if (city != null && state != null) {
//       url += '&city=$city&state=$state';
//     }

//     Get.to(() => CategoryBasedPostsScreen(
//           apiUrl: url,
//           title: findkey,
//         ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//        appBar: PreferredSize(
//   preferredSize: const Size.fromHeight(130), // Adjust height as needed
//   child: SafeArea(
//     child: Column(
//       mainAxisSize: MainAxisSize.min, // Added this to minimize height
//       children: [
//          HomeappbarScreen(
//            location: location,
//           onLocationTap: () async{

//             // Handle location tap if needed
//           },
//         ), // Add HomeAppBar here
//         AppBar(
//        centerTitle: true,

//            automaticallyImplyLeading: false,  // Add this line to remove b
//        title: Text(widget.productModel.category ?? 'Category Details'),
//           elevation: 0,

//           backgroundColor: Colors.transparent, // Make it transparent to avoid double background

//         ),
//       ],
//     ),
//   ),
// ),
//       // appBar: AppBar(
//       //   title: Text(widget.productModel.category ?? 'Category Details'),
//       // ),
//       body: ListView(
//         children: _buildSubcategoryList(),
//       ),
//     );
//   }

//   List<Widget> _buildSubcategoryList() {
//     // Define subcategories based on category
//     Map<String, List<String>> subcategories = {
//       'Books, Sports & Hobbies': ['Books', 'Sports', 'Music', 'Gym'],
//       'Jobs': ['Data Entry', 'Sales', 'BPO', 'Driver'],
//       'Properties': ['house_sale', 'house_rent', 'pg_guest'],
//       // Add other categories and their subcategories here
//     };

//     List<String> currentSubcategories =
//         subcategories[widget.productModel.category] ?? [];

//     return currentSubcategories.map((subcategory) {
//       return ListTile(
//         title: Text(subcategory),
//         onTap: () => navigateToCategoryPosts(findkey: subcategory),
//         trailing: Icon(Icons.arrow_forward_ios),
//       );
//     }).toList();
//   }
// }

// screens/all_category_details_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/models/product_model.dart';
import 'package:flutter_poc_v3/protected_screen.dart/dashboard/category_based_posts_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/homeappbar_screen.dart';
import 'package:flutter_poc_v3/services/ad_post_service.dart';
import 'package:get/get.dart';
import 'package:flutter_poc_v3/controllers/location_controller.dart';

class LevenCategoryDetailsScreen extends StatefulWidget {
  final ProductModel productModel;

  LevenCategoryDetailsScreen({Key? key, required this.productModel})
      : super(key: key);

  @override
  State<LevenCategoryDetailsScreen> createState() =>
      _LevenCategoryDetailsScreen();
}

class _LevenCategoryDetailsScreen extends State<LevenCategoryDetailsScreen> {
  final LocationController locationController = Get.find<LocationController>();
  final AdPostService _adPostService = AdPostService();
  String location = "Select Location";

  // leven_category_details_screen.dart
// void navigateToCategoryPosts({required String findkey}) {
//   String baseUrl = 'http://13.200.179.78/adposts';
//   String category = Uri.encodeComponent(widget.productModel.category ?? '');
//   String url;

//   String? city = locationController.selectedCity.value;
//   String? state = locationController.selectedState.value;

//   url = '$baseUrl?category=$category&findkey=$findkey';
//   if (city != null && state != null) {
//     url += '&city=$city&state=$state';
//   }

//   Get.to(() => CategoryBasedPostsScreen(
//     apiUrl: url, // Change this line to use apiUrl instead of adPosts
//     title: findkey,

//   ));
// }

// leven_category_details_screen.dart
  void navigateToCategoryPosts({required String findkey}) {
    String baseUrl = 'http://13.200.179.78/adposts';
    String category = Uri.encodeComponent(widget.productModel.category ?? '');

    // Get current location from LocationController
    String? city =
        locationController.currentCity.value; // Changed to currentCity
    String? state =
        locationController.currentState.value; // Changed to currentState

    // Build URL with parameters
    String url = '$baseUrl?category=$category&findkey=$findkey';
    if (city != null && city.isNotEmpty) {
      url += '&city=$city';
    }
    if (state != null && state.isNotEmpty) {
      url += '&state=$state';
    }

    Get.to(() => CategoryBasedPostsScreen(
          apiUrl: url,
          title: findkey,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(130), // Adjust height as needed
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Added this to minimize height
            children: [
              HomeappbarScreen(
                location: location,
                onLocationTap: () async {
                  // Handle location tap if needed
                },
              ), // Add HomeAppBar here
              AppBar(
                centerTitle: true,

                automaticallyImplyLeading: false, // Add this line to remove b
                title: Text(widget.productModel.category ?? 'Category Details'),
                elevation: 0,

                backgroundColor: Colors
                    .transparent, // Make it transparent to avoid double background
              ),
            ],
          ),
        ),
      ),
      // appBar: AppBar(
      //   title: Text(widget.productModel.category ?? 'Category Details'),
      // ),
      body: ListView(
        children: _buildSubcategoryList(),
      ),
    );
  }

  List<Widget> _buildSubcategoryList() {
    final Map<String, List<Map<String, dynamic>>> subcategories = {
      'Books, Sports & Hobbies': [
        {
          'name': 'Books',
          'findkey': 'books',
        },
        {'name': 'Sports', 'findkey': 'Sports'},
        {'name': 'Music', 'findkey': 'Music'},
        {'name': 'Gym', 'findkey': 'Gym'},
      ],
      'Jobs': [
        {
          'name': 'Data Entry',
          'findkey': 'Data Entry',
          'salary_start': '10000',
          'salary_end': '30000'
        },
        {
          'name': 'Sales',
          'findkey': 'Sales',
          'salary_start': '20000',
          'salary_end': '50000'
        },
        {
          'name': 'BPO',
          'findkey': 'BPO',
          'salary_start': '15000',
          'salary_end': '40000'
        },
        {
          'name': 'Driver',
          'findkey': 'Driver',
          'salary_start': '12000',
          'salary_end': '25000'
        },
      ],
      'Properties': [
        {'name': 'House Sale', 'findkey': 'house'},
        {'name': 'House Rent', 'findkey': 'house_rent'},
        {'name': 'PG Guest', 'findkey': 'pg_guest'},
      ],
      'Electronics & Appliances': [
        {'name': 'Mobiles', 'findkey': 'mobiles'},
        {
          'name': 'Electronics & Appliances',
          'findkey': 'Electronics & Appliances'
        },
        {'name': 'Bicycle', 'findkey': 'Bicycle'},
        {'name': 'Computer & Laptop', 'findkey': 'Computer & Laptop'},
      ],
      'Bikes': [
        {'name': 'bikes', 'findkey': 'Honda'},
        {'name': 'bikes', 'findkey': 'activa 6G'},
        {'name': 'Trucks', 'findkey': 'Trucks'},
        {'name': 'Scooters', 'findkey': 'Scooters'},
      ],
      'Furniture & Home Decor': [
        {'name': 'Furniture', 'findkey': 'Furniture'},
        {'name': 'Home Decor', 'findkey': 'Home Decor'},
      ],
      'Fashion': [
        {'name': 'Clothes', 'findkey': 'women'},
        {'name': 'Shoes', 'findkey': 'shoes'},
        {'name': 'Men', 'findkey': 'mens'},
        {'name': 'Footwear', 'findkey': 'Footwear'},
        {'name': 'Watches', 'findkey': 'Watches'},
        {'name': 'Jewellery', 'findkey': 'Jewellery'},
      ],
      'Pets': [
        {'name': 'pets', 'findkey': 'pets'},
        {'name': 'Fish', 'findkey': 'fish'},
        {'name': 'Birds', 'findkey': 'Birds'},
        {'name': 'Cats', 'findkey': 'Cats'},
        {'name': 'dogs', 'findkey': 'dogs'},
      ],
      'Mobiles': [
        {'name': 'Mobile Phones', 'findkey': 'iPhone'},
        {'name': 'Accessories', 'findkey': 'Accessories'},
        {'name': 'Tablets', 'findkey': 'Tablets'},
        {'name': 'Smart Phones', 'findkey': 'Smart Phones'},
      ],
      'Furniture': [
        {'name': 'Furniture', 'findkey': 'house'},
        {'name': 'Home Decor', 'findkey': 'Home Decor'},
        {'name': 'Home Appliances', 'findkey': 'Home Appliances'},
        {'name': 'Kitchen Appliances', 'findkey': 'Kitchen Appliances'},
        {'name': 'Office Appliances', 'findkey': 'Office Appliances'},
        {'name': 'Gym Appliances', 'findkey': 'Gym Appliances'},
        {'name': 'Bathroom Appliances', 'findkey': 'Bathroom Appliances'},
      ],
      'Services': [
        {'name': 'Services', 'findkey': 'Services'},
        {'name': 'Cleaning', 'findkey': 'Cleaning'},
        {'name': 'Plumbing', 'findkey': 'Plumbing'},
        {'name': 'Electrician', 'findkey': 'Electrician'},
      ],
      'Commercial Vehicles & Spares': [
        {'name': 'Commercial Vehicles', 'findkey': 'Commercial Vehicles'},
        {'name': 'Spares', 'findkey': 'Spares'},
        {'name': 'Buses', 'findkey': 'Buses'},
        {'name': 'Trucks', 'findkey': 'TATA'},
        {'name': 'Scooters', 'findkey': 'Scooters'},
      ],

      // Add other categories...
    };

    List<Map<String, dynamic>> currentSubcategories =
        subcategories[widget.productModel.category] ?? [];

    return currentSubcategories.map((subcategory) {
      return ListTile(
        title: Text(subcategory['name']),
        onTap: () => navigateToCategoryPosts(
          findkey: subcategory['findkey'],
          // salaryStart: subcategory['salary_start'],
          // salaryEnd: subcategory['salary_end'],
        ),
        trailing: Icon(Icons.arrow_forward_ios),
      );
    }).toList();
  }
}
