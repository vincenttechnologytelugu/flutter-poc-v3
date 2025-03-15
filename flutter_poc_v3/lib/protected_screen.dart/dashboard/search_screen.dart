
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_poc_v3/protected_screen.dart/sub_category_posts_screen.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isSearching = false;

  // Define all categories and their subcategories
  final Map<String, List<String>> categoryMap = {
    'Cars': ['Maruti', 'Mahindra', 'Hyundai', 'Tata', 'Honda', 'Tyota', 'Honda', 'BMW', 'Mercedes',
    'Toyota', 'Ford', 'Chevrolet', 'Nissan', 'Volkswagen', 'Mazda', 'Subaru', 'Audi', 'Ferrari', 'Lamborghini', 'Bugatti', 'Rolls-Royce',
    'Land Rover', 'Jaguar',  'Porsche', 'Tesla', 'Kia', 'Acura', 'Maserati', 'Lexus', 'Infiniti', 'Mclaren', 'Aston Martin', 'Jaguar', 'McLaren', 'Aston Martin'

    
    ],
    'Bikes': ['Honda', 'Yamaha', 'Suzuki', 'KTM', 'Royal Enfield',
    'Hero', 'TVS', 'Bajaj', 'Hero', 'Royal Enfield',

    ],
    'Properties': ['House', 'Apartment', 'Plot', 'Commercial', 
    'PG Guest', 'Farm House', 'Villa', 'Penthouse', 'Studio Apartment', 'Serviced Apartment', 'Office Space',


    
    ],
    'Mobiles': ['iPhone', 'Samsung', 'Xiaomi', 'OnePlus', 'Oppo',
    
    ],
    'electronics & appliances': ['TV', 'Laptop', 'Camera', 'Headphones', 'Speakers','prestige'],
    'Jobs': ['IT', 'Sales', 'Marketing', 'Finance', 'Healthcare',

    
    ],
    'Services': ['Cleaning', 'Plumbing', 'Electrical', 'Education', 'Beauty',],
    'Pets': ['Dog', 'Cat', 'Birds', 'Fish', 'Accessories'],
    'Furniture': ['Sofa', 'Bed', 'Table', 'Chair', 'Wardrobe','stool'],
    'Fashion': ['Men', 'Women', 'Kids', 'Accessories', 'Footwear'],
    // 'Books': ['Fiction', 'Non-Fiction', 'Educational', 'Comics', 'Magazines'],
    // 'Sports': ['Cricket', 'Football', 'Basketball', 'Fitness', 'Equipment'],
    'books, sports & hobbies':['Fiction', 'Non-Fiction', 'Educational', 'Comics', 'Magazines'
    'Cricket', 'Football', 'Basketball', 'Fitness', 'Equipment'
    ],
    'commercial vehicles & spares':[

      'TATA','HONDA','ASHOK LEYLAND',
      
    
    ]
  };

  List<MapEntry<String, List<String>>> filteredCategories = [];

  @override
  void initState() {
    super.initState();
    filteredCategories = categoryMap.entries.toList();
  }

  void filterCategories(String query) {
    if (query.isEmpty) {
      setState(() {
        isSearching = false;
        filteredCategories = categoryMap.entries.toList();
      });
    } else {
      setState(() {
        isSearching = true;
        filteredCategories = categoryMap.entries
            .where((entry) =>
                entry.key.toLowerCase().contains(query.toLowerCase()) ||
                entry.value.any((subCategory) =>
                    subCategory.toLowerCase().contains(query.toLowerCase())))
            .toList();
      });
    }
  }

 void navigateToSubCategoryPosts(String category, String subCategory) {
  log('Navigating to: Category: $category, SubCategory: $subCategory'); // Debug log
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SubCategoryPostsScreen(
        category: category,
        subCategory: subCategory,
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Categories'),
      ),
      // body:

body: Column(
  children: [
    Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(51),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: filterCategories,
        decoration: InputDecoration(
          hintText: 'Search categories...',
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(Icons.search, color: Colors.blue[400]),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  color: Colors.grey[400],
                  onPressed: () {
                    _searchController.clear();
                    filterCategories('');
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    ),
    Expanded(
      child: isSearching
          ? ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: filteredCategories.length,
              itemBuilder: (context, index) {
                final category = filteredCategories[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.withAlpha(51),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          _getCategoryIcon(category.key),
                          color: Colors.blue[600],
                        ),
                      ),
                      title: Text(
                        category.key,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      children: category.value.map((subCategory) {
                        return ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.subdirectory_arrow_right,
                              color: Colors.grey[600],
                              size: 20,
                            ),
                          ),
                          title: Text(
                            subCategory,
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 15,
                            ),
                          ),
                          onTap: () {
                            navigateToSubCategoryPosts(category.key, subCategory);
                          },
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.category_rounded,
                        color: Colors.blue[600],
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Popular Categories',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: categoryMap.length,
                    itemBuilder: (context, index) {
                      final category = categoryMap.entries.elementAt(index);
                      return GestureDetector(
                        onTap: () {
                          _searchController.text = category.key;
                          filterCategories(category.key);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                _getCategoryColor(category.key).withAlpha((0.9 * 255).round()),
                                _getCategoryColor(category.key),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: _getCategoryColor(category.key).withAlpha((0.9 * 255).round()),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                right: -20,
                                bottom: -20,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withAlpha(51),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withAlpha((0.9 * 255).round()),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        _getCategoryIcon(category.key),
                                        size: 32,
                                        color: Colors.orange,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      category.key,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    ),
  ],
),






      //  Column(
      //   children: [
      //     Container(
      //       padding: EdgeInsets.all(16),
      //       child: TextField(
      //         controller: _searchController,
      //         onChanged: filterCategories,
      //         decoration: InputDecoration(
      //           hintText: 'Search categories...',
      //           prefixIcon: Icon(Icons.search, color: Colors.grey),
      //           filled: true,
      //           fillColor: Colors.grey[200],
      //           border: OutlineInputBorder(
      //             borderRadius: BorderRadius.circular(20),
      //             borderSide: BorderSide.none,
      //           ),
      //         ),
      //       ),
      //     ),
      //     Expanded(
      //       child: isSearching
      //           ? ListView.builder(
      //               itemCount: filteredCategories.length,
      //               itemBuilder: (context, index) {
      //                 final category = filteredCategories[index];
      //                 return ExpansionTile(
      //                   leading: Icon(Icons.category),
      //                   title: Text(category.key),
      //                   children: category.value.map((subCategory) {
      //                     return ListTile(
      //                       leading: Icon(Icons.subdirectory_arrow_right),
      //                       title: Text(subCategory),
      //                       onTap: () {
      //                         navigateToSubCategoryPosts(
      //                             category.key, subCategory);
      //                       },
                           
      //                     );
      //                   }).toList(),
      //                 );
      //               },
      //             )
      //           : Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 Padding(
      //                   padding: EdgeInsets.all(8),
      //                   child: Text(
      //                     'Popular Categories',
      //                     style: TextStyle(
      //                       fontSize: 20,
      //                       fontWeight: FontWeight.bold,
      //                     ),
      //                   ),
      //                 ),
      //                 Expanded(
      //                   child: GridView.builder(
      //                     padding: EdgeInsets.all(8),
      //                     gridDelegate:
      //                         SliverGridDelegateWithFixedCrossAxisCount(
      //                       crossAxisCount: 2,
      //                       crossAxisSpacing: 10,
      //                       mainAxisSpacing: 10,
      //                     ),
      //                     itemCount: categoryMap.length,
      //                     itemBuilder: (context, index) {
      //                       final category =
      //                           categoryMap.entries.elementAt(index);
      //                       return GestureDetector(
      //                         onTap: () {
      //                           _searchController.text = category.key;
      //                           filterCategories(category.key);
      //                         },
      //                         child: Container(
      //                           decoration: BoxDecoration(
      //                             color:
      //                                 const Color.fromARGB(255, 93, 97, 126),
      //                             borderRadius: BorderRadius.circular(10),
      //                           ),
      //                           child: Column(
      //                             mainAxisAlignment: MainAxisAlignment.center,
      //                             children: [
      //                               Icon(Icons.category, size: 40),
      //                               SizedBox(height: 8),
      //                               Text(
      //                                 category.key,
      //                                 style: TextStyle(fontSize: 16),
      //                                 selectionColor: Colors.white,
      //                               ),
      //                             ],
      //                           ),
      //                         ),
      //                       );
      //                     },
      //                   ),
      //                 ),
      //               ],
      //             ),
      //     ),
      //   ],
      // ),
    );
  }



  // Add these helper methods
IconData _getCategoryIcon(String category) {
  switch (category.toLowerCase()) {
    case 'cars':
      return Icons.directions_car;
    case 'bikes':
      return Icons.two_wheeler;
    case 'properties':
      return Icons.home;
    case 'mobiles':
      return Icons.phone_android;
    case 'electronics & appliances':
      return Icons.devices;
    case 'jobs':
      return Icons.work;
    case 'services':
      return Icons.miscellaneous_services;
    case 'pets':
      return Icons.pets;
    case 'furniture':
      return Icons.chair;
    case 'fashion':
      return Icons.shopping_bag;
    case 'books, sports & hobbies':
      return Icons.sports_soccer;
    case 'commercial vehicles & spares':
      return Icons.local_shipping;
    default:
      return Icons.category;
  }
}

Color _getCategoryColor(String category) {
  switch (category.toLowerCase()) {
    case 'cars':
      return Colors.blue;
    case 'bikes':
      return Colors.red;
    case 'properties':
      return Colors.green;
    case 'mobiles':
      return Colors.purple;
    case 'electronics & appliances':
      return Colors.orange;
    case 'jobs':
      return Colors.teal;
    case 'services':
      return Colors.indigo;
    case 'pets':
      return Colors.brown;
    case 'furniture':
      return Colors.amber;
    case 'fashion':
      return Colors.pink;
    case 'books, sports & hobbies':
      return Colors.deepOrange;
    case 'commercial vehicles & spares':
      return Colors.blueGrey;
    default:
      return Colors.blue;
  }
}

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
