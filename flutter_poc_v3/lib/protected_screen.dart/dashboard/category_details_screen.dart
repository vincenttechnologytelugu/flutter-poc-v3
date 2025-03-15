import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/controllers/location_controller.dart';
import 'package:flutter_poc_v3/protected_screen.dart/dashboard/category_based_posts_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/homeappbar_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/location_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_poc_v3/models/product_model.dart';

class CategoryDetailsScreen extends StatefulWidget {
  final ProductModel productModel;
  const CategoryDetailsScreen({super.key, required this.productModel});

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen>
    with SingleTickerProviderStateMixin {
  final LocationController locationController = Get.find<LocationController>();
  TabController? _tabController;
  String location = "Select Location"; // Add this line

  // Car specific data
  final List<Map<String, dynamic>> budgetRanges = [
    {'title': 'Below 1 Lac', 'start': '0', 'end': '100000'},
    {'title': '1 Lac - 2 Lac', 'start': '100000', 'end': '200000'},
    {'title': '2 Lac - 3 Lac', 'start': '200000', 'end': '300000'},
    {'title': '3 Lac and above', 'start': '300000', 'end': '10000000'},
  ];

  final List<Map<String, dynamic>> yearRanges = [
    {'title': '2025-2024', 'year': '2024,2025'},
    {'title': '2023-2022', 'year': '2022,2023'},
    {'title': '2021-2020', 'year': '2020,2021'},
    {'title': '2019-2018', 'year': '2018,2019'},
    {'title': '2017-2016', 'year': '2016,2017'},
    {'title': '2015-2012', 'year': '2012,2013,2014,2015'},
  ];

  final List<Map<String, dynamic>> carBrands = [
    {
      'name': 'Maruti Suzuki',
      'icon': Icons.directions_car,
      'findkey': 'maruti'
    },
    {'name': 'Hyundai', 'icon': Icons.directions_car, 'findkey': 'hyundai'},
    {'name': 'Mahindra', 'icon': Icons.directions_car, 'findkey': 'mahindra'},
    {'name': 'Toyota', 'icon': Icons.directions_car, 'findkey': 'toyota'},
    {'name': 'TATA', 'icon': Icons.directions_car, 'findkey': 'tata'},
    {'name': 'Honda', 'icon': Icons.directions_car, 'findkey': 'honda'},
  ];

  // // Category subcategories map
  // final Map<String, List<Map<String, dynamic>>> categorySubcategories = {
  //   'Mobiles': [
  //     {
  //       'title': 'Mobile Phones',
  //       'icon': Icons.phone_android,
  //       'findkey': 'mobiles'
  //     },
  //     {'title': 'Tablets', 'icon': Icons.tablet, 'findkey': 'tablets'},
  //     {'title': 'Accessories', 'icon': Icons.headset, 'findkey': 'accessories'},
  //     {
  //       'title': 'Smart Watches',
  //       'icon': Icons.watch,
  //       'findkey': 'smart_watches'
  //     },
  //   ],
  //   'Jobs': [
  //     {
  //       'title': 'Data Entry',
  //       'icon': Icons.edit_document,
  //       'findkey': 'data_entry'
  //     },
  //     {'title': 'Sales', 'icon': Icons.trending_up, 'findkey': 'sales'},
  //     {'title': 'BPO', 'icon': Icons.support_agent, 'findkey': 'bpo'},
  //     {'title': 'Driver', 'icon': Icons.drive_eta, 'findkey': 'driver'},
  //   ],
  //   'Properties': [
  //     {
  //       'title': 'For Sale: Houses',
  //       'icon': Icons.house,
  //       'findkey': 'house_sale'
  //     },
  //     {
  //       'title': 'For Rent: Houses',
  //       'icon': Icons.home,
  //       'findkey': 'house_rent'
  //     },
  //     {'title': 'Lands & Plots', 'icon': Icons.landscape, 'findkey': 'lands'},
  //     {
  //       'title': 'PG & Guest Houses',
  //       'icon': Icons.hotel,
  //       'findkey': 'pg_guest'
  //     },
  //   ],
  //   'Fashion': [
  //     {'title': 'Men', 'icon': Icons.man, 'findkey': 'men'},
  //     {'title': 'Women', 'icon': Icons.woman, 'findkey': 'women'},
  //     {'title': 'Kids', 'icon': Icons.child_care, 'findkey': 'kids'},
  //     {'title': 'Footwear', 'icon': Icons.hiking, 'findkey': 'footwear'},
  //   ],
  //   'Bikes': [
  //     {
  //       'title': 'Motorcycles',
  //       'icon': Icons.motorcycle,
  //       'findkey': 'motorcycles'
  //     },
  //     {'title': 'Scooters', 'icon': Icons.two_wheeler, 'findkey': 'scooters'},
  //     {'title': 'Spare Parts', 'icon': Icons.build, 'findkey': 'spare_parts'},
  //     {'title': 'Bicycles', 'icon': Icons.pedal_bike, 'findkey': 'bicycles'},
  //   ],
  //   'Furniture': [
  //     {'title': 'Sofa & Dining', 'icon': Icons.chair, 'findkey': 'sofa_dining'},
  //     {'title': 'Beds', 'icon': Icons.bed, 'findkey': 'beds'},
  //     {
  //       'title': 'Wardrobes',
  //       'icon': Icons.door_sliding,
  //       'findkey': 'wardrobes'
  //     },
  //     {'title': 'Home Decor', 'icon': Icons.home, 'findkey': 'home_decor'},
  //     {'title': ' furniture', 'icon': Icons.more_horiz, 'findkey': 'furniture'},
  //   ],
  //   'Commercial Vehicles & Spares': [
  //     {
  //       'title': 'Commercial Vehicles',
  //       'icon': Icons.local_shipping,
  //       'findkey': 'commercial_vehicles'
  //     },
  //     {'title': 'Spare Parts', 'icon': Icons.build, 'findkey': 'vehicle_parts'},
  //     {
  //       'title': 'Other Vehicles',
  //       'icon': Icons.more_horiz,
  //       'findkey': 'other_vehicles'
  //     },
  //   ],
  //   'Electronics & Appliances': [
  //     {'title': 'TVs', 'icon': Icons.tv, 'findkey': 'tvs'},
  //     {'title': 'Laptops', 'icon': Icons.laptop, 'findkey': 'laptops'},
  //     {
  //       'title': 'Kitchen Appliances',
  //       'icon': Icons.kitchen,
  //       'findkey': 'kitchen'
  //     },
  //     {'title': 'ACs', 'icon': Icons.ac_unit, 'findkey': 'acs'},
  //     {'title': 'Computer', 'icon': Icons.computer, 'findkey': 'computer'},
  //       {'title': 'electronics & appliances', 'icon': Icons.computer, 'findkey': 'electronics_appliances'},
  //     {'title': 'Computer', 'icon': Icons.computer, 'findkey': 'computer'},
  //   ],
  //   'Pets': [
  //     {'title': 'Pets', 'icon': Icons.pets, 'findkey': 'pets'},
  //     {'title': 'Cats', 'icon': Icons.pets, 'findkey': 'cats'},
  //     {'title': 'Fish & Aquarium', 'icon': Icons.water, 'findkey': 'fish'},
  //     {'title': 'Pet Food', 'icon': Icons.set_meal, 'findkey': 'pet_food'},
  //   ],
  //   'Services': [
  //     {
  //       'title': 'Electronics Repair',
  //       'icon': Icons.build,
  //       'findkey': 'electronics_repair'
  //     },
  //     {'title': 'Education', 'icon': Icons.school, 'findkey': 'education'},
  //     {
  //       'title': 'Home Services',
  //       'icon': Icons.home_repair_service,
  //       'findkey': 'home_services'
  //     },
  //     {'title': 'Insurance', 'icon': Icons.security, 'findkey': 'insurance'},
  //   ],
  //   'Cars': [
  //     {
  //       'title': 'Used Cars',
  //       'icon': Icons.directions_car,
  //       'findkey': 'used_cars'
  //     },
  //     {
  //       'title': 'New Cars',
  //       'icon': Icons.directions_car_filled,
  //       'findkey': 'new_cars'
  //     },
  //     {'title': 'Spare Parts', 'icon': Icons.build, 'findkey': 'car_parts'},
  //   ],
  //   'Books, Sports & Hobbies': [
  //     {'title': 'Books', 'icon': Icons.book, 'findkey': 'books'},
  //     {'title': 'Sports', 'icon': Icons.sports, 'findkey': 'sports'},
  //     {'title': 'Music', 'icon': Icons.music_note, 'findkey': 'music'},
  //     {'title': 'Gym', 'icon': Icons.fitness_center, 'findkey': 'fitness'},
  //   ],
  //   'Others': [
  //     {'title': 'Antiques', 'icon': Icons.vpn_key, 'findkey': 'antiques'},
  //     {
  //       'title': 'Other Products',
  //       'icon': Icons.category,
  //       'findkey': 'other_products'
  //     },
  //   ],
  // };

  @override
  void initState() {
    super.initState();
    if (widget.productModel.category?.toLowerCase() == 'cars') {
      _tabController = TabController(length: 2, vsync: this);
    }
  }

  void navigateToCategoryPosts(
      {String? findkey, String? priceStart, String? priceEnd, String? year}) {
    String baseUrl = 'http://13.200.179.78/adposts';
    String category = Uri.encodeComponent(widget.productModel.category ?? '');
    String url;

    if (priceStart != null && priceEnd != null) {
      url =
          '$baseUrl?category=$category&price_start=$priceStart&price_end=$priceEnd';
    } else if (year != null) {
      // Split the years and create a comma-separated string
      List<String> yearList = year.split(',');
      String yearQuery = yearList.join(',');
      url = '$baseUrl?category=$category&year=$yearQuery';

      // Create a title based on the year range
      String yearTitle = yearList.length > 2
          ? '${yearList.last}-${yearList.first}'
          : yearList.join('-');

      Get.to(() => CategoryBasedPostsScreen(
            apiUrl: url,
            title: 'Cars $yearTitle',
          ));
      return;
    } else if (findkey != null) {
      url = '$baseUrl?category=$category&findkey=$findkey';
    } else {
      url = '$baseUrl?category=$category';
    }

    log('API URL: $url');

    Get.to(() => CategoryBasedPostsScreen(
          apiUrl: url,
          title: findkey ?? widget.productModel.category ?? '',
        ));
  }

  Widget _buildCarCategoryContent() {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(130),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Added this to minimize height
              children: [
                HomeappbarScreen(
                  location: location,
                  onLocationTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LocationScreen(),
                      ),
                    );
                    if (result != null) {
                      setState(() {
                        location = result;
                      });
                    }

                    // Handle location tap if needed
                  },
                ),
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(
                        icon: Icon(Icons.currency_rupee),
                        text: 'Budget & Brand'),
                    Tab(icon: Icon(Icons.calendar_today), text: 'Year'),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color.fromARGB(255, 184, 52, 12)
                    .withAlpha((0.9 * 255).round()),
                Colors.white,
              ],
            ),
          ),
          child: TabBarView(
            controller: _tabController,
            children: [
              // Budget & Brands Tab Content
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Search by Budget',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2.5,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: budgetRanges.length,
                      itemBuilder: (context, index) {
                        final budget = budgetRanges[index];
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color.fromARGB(255, 227, 229, 241),
                                const Color(0xFF1A237E),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    Colors.black.withAlpha((0.9 * 255).round()),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () => navigateToCategoryPosts(
                              priceStart: budget['start'],
                              priceEnd: budget['end'],
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              budget['title'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => navigateToCategoryPosts(),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          'View All ${widget.productModel.category}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Popular Brands',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: carBrands.length,
                      itemBuilder: (context, index) {
                        final brand = carBrands[index];
                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: InkWell(
                            onTap: () => navigateToCategoryPosts(
                                findkey: brand['findkey']),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white,
                                    Colors.grey.shade50,
                                  ],
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1A237E)
                                          .withAlpha((0.3 * 255).round()),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      brand['icon'],
                                      size: 32,
                                      color: Colors.white70,
                                      // color: const Color(0xFF1A237E),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    brand['name'],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1A237E),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => navigateToCategoryPosts(),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          'View All ${widget.productModel.category}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Year Tab Content
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Search by Year',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2.5,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: yearRanges.length,
                      itemBuilder: (context, index) {
                        final year = yearRanges[index];
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color.fromARGB(255, 195, 198, 211),
                                const Color(0xFF1A237E),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    Colors.black.withAlpha((0.9 * 255).round()),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () => navigateToCategoryPosts(
                              year: year['year'],
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              year['title'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => navigateToCategoryPosts(),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          'View All ${widget.productModel.category}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check if it's the Cars category
    if (widget.productModel.category?.toLowerCase() == 'cars') {
      return _buildCarCategoryContent();
    }
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 129, 127, 126),
    );

    // // Original CategoryDetailsScreen content for other categories
    // final subcategories =
    //     categorySubcategories[widget.productModel.category] ?? [];

//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 129, 127, 126),
//       appBar: PreferredSize(
//   preferredSize: const Size.fromHeight(130), // Adjust height as needed
//   child: SafeArea(
//     child: Column(
//       mainAxisSize: MainAxisSize.min, // Added this to minimize height
//       children: [
//          HomeappbarScreen(
//            location: location,
//           onLocationTap: ()async {

//           },
//         ), // Add HomeAppBar here
//         AppBar(
//            centerTitle: true,
//            automaticallyImplyLeading: false,  // Add this line to remove b
//           title: Text(widget.productModel.category ?? ''.toUpperCase(),style: TextStyle(color: Colors.white),),
//           elevation: 0,
//           backgroundColor: Colors.transparent, // Make it transparent to avoid double background
//         ),
//       ],
//     ),
//   ),
// ),

//       // appBar: AppBar(
//       //   title: Text(widget.productModel.category ?? ''),
//       //   elevation: 0,
//       // ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Theme.of(context).primaryColor.withAlpha(51),
//               const Color.fromARGB(255, 243, 8, 8),
//             ],
//           ),
//         ),
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Text(
//                 //   'Explore ${widget.productModel.category}',
//                 //   style: const TextStyle(
//                 //       fontSize: 24,
//                 //       fontWeight: FontWeight.bold,
//                 //       color: Colors.white70),
//                 // ),
//                 const SizedBox(height: 20),

//                 AnimationLimiter(
//                   child: GridView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       childAspectRatio: 1.5,
//                       crossAxisSpacing: 15,
//                       mainAxisSpacing: 15,
//                     ),
//                     // itemCount: subcategories.length,
//                     itemBuilder: (context, index) {
//                       // Stunning gradient color combinations
//                       final List<List<Color>> cardGradients = [
//                         [
//                           const Color.fromARGB(255, 169, 169, 184),
//                           const Color.fromARGB(255, 223, 15, 36),
//                           const Color.fromARGB(255, 167, 5, 217),
//                         ],
//                         [
//                           const Color.fromARGB(255, 191, 6, 114),
//                           const Color.fromARGB(255, 3, 223, 197),
//                         ],
//                         [
//                           const Color.fromARGB(255, 162, 5, 229),
//                           const Color.fromARGB(255, 249, 9, 9),
//                         ],
//                         [
//                           const Color(0xFFFA8BFF),
//                           const Color(0xFF2BD2FF),
//                           const Color.fromARGB(255, 3, 228, 101),
//                         ],
//                         [
//                           const Color(0xFFFF3CAC),
//                           const Color(0xFF784BA0),
//                           const Color(0xFF2B86C5),
//                         ],
//                         [
//                           const Color(0xFFFBDA61),
//                           const Color(0xFFFF5ACD),
//                         ],
//                         [
//                           const Color(0xFF08AEEA),
//                           const Color.fromARGB(255, 227, 95, 7),
//                         ],
//                         [
//                           const Color(0xFFD9AFD9),
//                           const Color(0xFF97D9E1),
//                         ],
//                         [
//                           const Color(0xFFFF9A9E),
//                           const Color(0xFFFAD0C4),
//                           const Color(0xFFFAD0C4),
//                         ],
//                         [
//                           const Color.fromARGB(255, 207, 6, 229),
//                           const Color(0xFFFFBBEC),
//                         ],
//                         [
//                           const Color(0xFF21D4FD),
//                           const Color(0xFFB721FF),
//                         ],
//                         [
//                           const Color.fromARGB(255, 54, 23, 230),
//                           const Color.fromARGB(255, 63, 10, 197),
//                         ],
//                       ];

//                       final gradientColors =
//                           cardGradients[index % cardGradients.length];
//                       final subcategory = subcategories[index];

//                       return AnimationConfiguration.staggeredGrid(
//                         position: index,
//                         duration: const Duration(milliseconds: 500),
//                         columnCount: 2,
//                         child: ScaleAnimation(
//                           scale: 0.8,
//                           child: FadeInAnimation(
//                             child: Card(
//                               elevation: 8,
//                               shadowColor: gradientColors[0]
//                                   .withAlpha((0.3 * 255).round()),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               child: InkWell(
//                                 onTap: () {
//                                   HapticFeedback.mediumImpact();
//                                   navigateToCategoryPosts(
//                                     findkey: subcategory['findkey'],
//                                   );
//                                 },
//                                 borderRadius: BorderRadius.circular(20),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(20),
//                                     gradient: LinearGradient(
//                                       begin: Alignment.topLeft,
//                                       end: Alignment.bottomRight,
//                                       colors: [
//                                         gradientColors[0]
//                                             .withAlpha((0.3 * 255).round()),
//                                         gradientColors[
//                                                 gradientColors.length - 1]
//                                             .withAlpha((0.3 * 255).round()),
//                                       ],
//                                     ),
//                                   ),
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Container(
//                                         padding: const EdgeInsets.all(16),
//                                         decoration: BoxDecoration(
//                                           gradient: LinearGradient(
//                                             begin: Alignment.topLeft,
//                                             end: Alignment.bottomRight,
//                                             colors: gradientColors
//                                                 .map(
//                                                   (color) => color.withAlpha(
//                                                       (0.3 * 255).round()),
//                                                 )
//                                                 .toList(),
//                                           ),
//                                           shape: BoxShape.circle,
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color: gradientColors[0]
//                                                   .withAlpha(
//                                                       (0.3 * 255).round()),
//                                               blurRadius: 12,
//                                               spreadRadius: 2,
//                                             ),
//                                           ],
//                                         ),
//                                         child: Icon(
//                                           subcategory['icon'],
//                                           color: gradientColors[0],
//                                           size: 30,
//                                         ),
//                                       )
//                                           .animate(
//                                               onPlay: (controller) =>
//                                                   controller.repeat())
//                                           .shimmer(
//                                             duration: 2000.ms,
//                                             color: gradientColors[
//                                                     gradientColors.length - 1]
//                                                 .withAlpha((0.3 * 255).round()),
//                                           )
//                                           .then()
//                                           .scale(
//                                             duration: 900.ms,
//                                             begin: const Offset(1, 1),
//                                             end: const Offset(1.1, 1.1),
//                                           )
//                                           .then()
//                                           .scale(
//                                             duration: 900.ms,
//                                             begin: const Offset(1.1, 1.1),
//                                             end: const Offset(1, 1),
//                                           ),
//                                       const SizedBox(height: 10),
//                                       Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 10),
//                                         child: Text(
//                                           subcategory['title'],
//                                           textAlign: TextAlign.center,
//                                           style: TextStyle(
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.w600,
//                                             letterSpacing: 0.3,
//                                             foreground: Paint()
//                                               ..shader = LinearGradient(
//                                                 colors: gradientColors,
//                                               ).createShader(
//                                                 const Rect.fromLTWH(
//                                                     0.0, 0.0, 100.0, 0.0),
//                                               ),
//                                           ),
//                                           maxLines: 2,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                       )
//                                           .animate()
//                                           .fadeIn(duration: 600.ms)
//                                           .moveY(
//                                             begin: 10,
//                                             end: 0,
//                                             curve: Curves.easeOutQuad,
//                                           ),
//                                       const SizedBox(height: 6),
//                                       Container(
//                                         width: 40,
//                                         height: 3,
//                                         decoration: BoxDecoration(
//                                           gradient: LinearGradient(
//                                             colors: [
//                                               gradientColors[0].withAlpha(
//                                                   (0.3 * 255).round()),
//                                               ...gradientColors,
//                                               gradientColors[0].withAlpha(
//                                                   (0.3 * 255).round()),
//                                             ],
//                                           ),
//                                           borderRadius:
//                                               BorderRadius.circular(2),
//                                         ),
//                                       )
//                                           .animate(
//                                             onPlay: (controller) =>
//                                                 controller.repeat(),
//                                           )
//                                           .shimmer(
//                                             duration: 2000.ms,
//                                             color: gradientColors[
//                                                 gradientColors.length - 1],
//                                           )
//                                           .fadeIn(duration: 400.ms)
//                                           .scale(
//                                             duration: 400.ms,
//                                             curve: Curves.easeInOutQuad,
//                                           ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             )
//                                 .animate()
//                                 .scale(
//                                   duration: 400.ms,
//                                   curve: Curves.linearToEaseOut,
//                                   begin: const Offset(0.8, 0.8),
//                                   end: const Offset(1, 1),
//                                 )
//                                 .then()
//                                 .shimmer(
//                                   duration: 1200.ms,
//                                   color: gradientColors[0]
//                                       .withAlpha((0.6 * 255).round()),
//                                 ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),

//                 const SizedBox(height: 24),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () => navigateToCategoryPosts(),
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       elevation: 2,
//                     ),
//                     child: Text(
//                       'View All ${widget.productModel.category}',
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}
