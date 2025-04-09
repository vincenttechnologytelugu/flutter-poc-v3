// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_poc_v3/protected_screen.dart/sub_category_posts_screen.dart';
import 'package:google_fonts/google_fonts.dart';

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
    'Cars': [
      'Maruti',
      'Mahindra',
      'Hyundai',
      'Tata',
      'Honda',
      'Toyota',
      'Honda',
      'BMW',
      'Mercedes',
      'Toyota',
      'Ford',
      'Chevrolet',
      'Nissan',
      'Volkswagen',
      'Mazda',
      'Subaru',
      'Audi',
      'Ferrari',
      'Lamborghini',
      'Bugatti',
      'Rolls-Royce',
      'Land Rover',
      'Jaguar',
      'Porsche',
      'Tesla',
      'Kia',
      'Acura',
      'Maserati',
      'Lexus',
      'Infiniti',
      'Mclaren',
      'Aston Martin',
      'Jaguar',
      'McLaren',
      'Aston Martin',
      'Bentley',
      'Chrysler',
      'Fiat',
      'Peugeot',

    ],
    'Bikes': [
      'Honda',
      'Yamaha',
      'Suzuki',
      'KTM',
      'Royal Enfield',
      'Hero',
      'TVS',
      'Bajaj',
      'Hero',
      'Royal Enfield',
      'activa 6G',
      'activa 5G',
      'activa 3G',
      'activa 2G',
      'activa 1G',
    ],
    'Properties': [
      'House',
      'rent',
      'Apartment',
      'Plot',
      'Commercial',
      'PG Guest',
      'Farm House',
      'Villa',
      'Independent House',
      'Duplex House',
      'Flat',
      'Condo',
      'Bungalow',
      'Cottage',
      'Townhouse',
      'Penthouse',
      'Studio Apartment',
      'Serviced Apartment',
      'Office Space',
    ],
    'Mobiles': [
      'iPhone',
      'Samsung',
      'Xiaomi',
      'OnePlus',
      'Oppo',
      'Vivo',
      'Realme',
      'Nokia',
      'Motorola',
      'HTC',
      'LG',
      'Sony',
      'Asus',
      'Lenovo',
      'Google',
      'Honor',
    ],
    'electronics & appliances': [
      'TV',
      'Laptop',
      'Camera',
      'Headphones',
      'Speakers',
      'prestige',
      'LG',
      'Samsung',
      'Sony',
      'Whirlpool',
      'Godrej',
      'IFB',
      'Bosch',
      'Haier',
      'Voltas',
      'Blue Star',
      'Carrier',
      'Daikin',
      'Hitachi',
      'Lloyd',
      'Mitsubishi',
      'O General',
      'Onida',
      'Panasonic',
      'Sansui',
      'Sharp',
      'Toshiba',
      'Videocon',
      'Vu',
      'Akai',
      'AOC',
      'BPL',
      'CloudWalker',
      'Haier',
      'Hisense',
      'Intex',
      'Kodak',
      'Lloyd',
      'Micromax',
      'Mitashi',
      'Noble Skiodo',
      'Onida',
      'Panasonic',
      'Philips',
      'Polaroid',
      'Sansui',
      'Sanyo',
      'Sharp',
      'Shinco',
      'TCL',
      'Thomson',
      'Toshiba',
      'Truvison',
      'Vu',
      'Weston',
      'Wybor',
      'Xiaomi',
      'YU',
      'Zync',
      'Acer',
      'Apple',
      'Asus',
      'Dell',
      'HP',
      'Lenovo',
      'Microsoft',
      'MSI',
      'Razer',
      'Samsung',
      'Sony',
      'Toshiba',
      'Canon',
      'Nikon',
      'Sony',
      'Panasonic',
      'Fujifilm',
      'Olympus',
      'Pentax',
      'Leica',
      'Samsung',
      'JBL',
      'Sony',
      'Bose',
      'Philips',
      'Sennheiser',
      'Skullcandy',
      'Beats',
      'Harman Kardon',
      'AC',
      'Refrigerator',
      'Washing Machine',
      'Microwave',
      'Oven',
      'Iron',
      'Blender',
      'Mixer',
      'Grinder',
      'Toaster',
      'Kettle',
      'Water Purifier',
      'Air Purifier',
      'Fan',
      'Geyser',
      'Inverter',
      'Generator',
      'Water Heater',
      'Water Dispenser',
      'Air Conditioner',
      'Refrigerator',
      'Washing Machine',
      'Microwave',
      'Oven',
      'Iron',
      'Blender',
      'Mixer',
      'Grinder',
      'Toaster',
      'Kettle',
      'Water Purifier',
      'Air Purifier',
      'Fan',
      'Geyser',
    ],
    'Jobs': [

      'IT',
      'Sales',
      'Security',
      'Marketing',
      'Finance',
      'Healthcare',
      'driver',
      'Teaching',
      'Engineering',
      'Customer Service',
      'Human Resources',
      'Legal',
      'Education',
      'Hospitality',
      'Manufacturing',
      'Real Estate',
      'Retail',
      'Transportation',
      'Travel & Tourism',
      'Writing & Editing',
      'Graphic Design',
      'Video Editing',
      'Photography',
      'Music',
      'Art',
      'Fashion',
      'Architecture',
      'Interior Design',
      'Event Planning',
      'Fitness',
      'Personal Training',
      'Nutrition',
      'Yoga',
      'Meditation',
      'Cooking',
      'Baking',
      'Gardening',
      'Crafts',
      'Painting',
      'Sculpting',
      'Dance',
      'Theater',
      'Film',
      'Television',
      'Radio',
      'Podcasting',
      'Voice Acting',
      'Public Speaking',
    ],
    'Services': [
      'Cleaning',
      'Plumbing',
      'Electrical',
      'Education',
      'Beauty',
      'Health',
      'Fitness',
      'Legal',
    ],
    'Pets': [
      'Dogs',
      'Cats',
      'Birds',
      'Fish',
      'Reptiles',
      'Small Animals',
      'Horses',
      'Farm Animals', 

      'Accessories',
      'pets',
      'Pet Food',
      'Pet Supplies',
      'Pet Grooming',
      'Pet Training',
      'Pet Sitting',
      'Pet Walking',
      'Pet Boarding',
      'Pet Adoption',
      'Pet Breeding',
      'Pet Insurance',
      'Pet Photography',
      'Pet Services',
      'Pet Care',
      'Pet Training Classes',
      'Pet Training Equipment',
      'Pet Training Supplies',
      'Pet Training Services',
      'Pet Training Programs',
      'Pet Training Courses',
      'Pet Training Workshops',
      'Pet Training Seminars',
      'Pet Training Webinars',
      'Pet Training Videos',
      'Pet Training Books',
      'Pet Training Articles',
      'Pet Training Blogs',
      'Pet Training Podcasts',
      'Pet Training Forums',
      'Pet Training Communities',
      'Pet Training Groups',
      'Pet Training Organizations',
      'Pet Training Associations',
      'Pet Training Clubs',
      'Pet Training Schools',
      'Pet Training Colleges',
      'Pet Training Universities',
      'Pet Training Institutes',
      'Pet Training Centers',
      'Pet Training Facilities',
      'Pet Training Studios',
      'Pet Training Spaces',
      'First Stage Vaccinated',
      'Second Stage Vaccinated',
      'Third Stage Vaccinated',
      'Fourth Stage Vaccinated',
  
    ],

    'Furniture': [
      'Home Appliances',
      'Sofa',
      'Bed',
      'Table',
      'Chair',
      'Wardrobe',
      'stool'
          'Desk',
      'Cabinet',
      'Shelf',
      'Dresser',
      'Couch',
      'Recliner',
      'Ottoman',
      'Futon',
      'Sectional Sofa',
      'Loveseat',
      'Dining Table',
      'Coffee Table',
      'End Table',
      'Nightstand',
      'Bookcase',
      'Entertainment Center',
      'TV Stand',
      'Buffet Table',
      'Sideboard',
      'Console Table',
      'Hall Tree',
      'Storage Bench',
      'Shoe Rack',
      'Coat Rack',
      'Hat Rack',
      'Umbrella Stand',
      'Magazine Rack',
      'Wine Rack',
      'Bar Cart',
      'Kitchen Island',
      'Breakfast Nook',
      'Patio Furniture',
      'Outdoor Furniture',
      'Garden Furniture',
      'Lawn Furniture',
      'Deck Furniture',
      'Porch Furniture',
      'Balcony Furniture',
      'Poolside Furniture',
      'Beach Furniture',
      'Camping Furniture',
      'Picnic Furniture',
      'Tailgating Furniture',
      'Travel Furniture',
      'Portable Furniture',
      'Foldable Furniture',
      'Stackable Furniture',
      'Expandable Furniture',
      'Adjustable Furniture',
      'Convertible Furniture',
      'Multi-Functional Furniture',
      'Space-Saving Furniture',
      'Compact Furniture',
      'Modular Furniture',
      'Custom Furniture',
      'Bespoke Furniture',
      'Handmade Furniture',
      'Artisan Furniture',
      'Vintage Furniture',
      'Antique Furniture',
      'Retro Furniture',
      'Mid-Century Modern Furniture',
      'Industrial Furniture',
      'Scandinavian Furniture',
      'Contemporary Furniture',
      'Modern Furniture',
      'Traditional Furniture',
      'Classic Furniture',
      'Rustic Furniture',
      'Farmhouse Furniture',
      'Shabby Chic Furniture',
      'Bohemian Furniture',
      'Eclectic Furniture',
      'Minimalist Furniture',
      'Maximalist Furniture',
      'Luxury Furniture',
      'High-End Furniture',
      'Designer Furniture',
      'Brand Name Furniture',
      'Affordable Furniture',
      'Budget Furniture',
      'Cheap Furniture',
      'Discounted Furniture',
      'Sale Furniture',
      'Clearance Furniture',
    ],

    'Fashion': [
      'Men',
      'Women',
      'Kids',
      'Accessories',
      'Footwear',
      'Clothing',
      'Jewelry',
      'Bags',
      'Watches',
      'Sunglasses',
      'Hats',
      'Belts',
      'Scarves',
      'Gloves',
      'Socks',
      'Ties',
      'Wallets',
      'Handbags',
      'Backpacks',
      'Luggage',
      'Travel Bags',
      'Diaper Bags',
      'Gym Bags',
      'Laptop Bags',
      'Messenger Bags',
      'Crossbody Bags',
      'Clutches',
      'Evening Bags',
      'Shoulder Bags',
    ],
    // 'Books': ['Fiction', 'Non-Fiction', 'Educational', 'Comics', 'Magazines'],
    // 'Sports': ['Cricket', 'Football', 'Basketball', 'Fitness', 'Equipment'],
    'books, sports & hobbies': [
      'Music',
      'Fiction',
      'Non-Fiction',
      'Educational',
      'Comics',
      'Magazines'
          'Cricket',
      'Football',
      'Basketball',
      'Fitness',
      'Equipment'
    ],
    'commercial vehicles & spares': [
      'Maruti',
      'Buses',
      'tata',
      'HONDA',
      'ASHOK LEYLAND',
      'TATA MOTORS',
      'MARUTI SUZUKI',
      'MAHINDRA',
      'HYUNDAI',
      'RENAULT',
      'TOYOTA',
      'FORD',
      'CHEVROLET',
      'BMW',
      'MERCEDES-BENZ',
      'AUDI',
      'VOLKSWAGEN',
      'NISSAN',
      'JAGUAR',
      'LAND ROVER',
      'PORSCHE',
      'TESLA',
      'KIA',
      'SUBARU',
      'MAZDA',
      'ISUZU',
      'SUZUKI',
      'DAEWOO',
      'SKODA',
      'VOLVO',
      'MITSUBISHI',
      'HONDA',
      'YAMAHA',
      'SUZUKI',
      'KTM',
      'ROYAL ENFIELD',
      'HERO',
      'TVS',
      'BAJAJ',
      'HERO',
      'ROYAL ENFIELD',
      'ACTIVA 6G',
      'ACTIVA 5G',
      'ACTIVA 3G',
      'ACTIVA 2G',
      'ACTIVA 1G',
      'AC',
      'Refrigerator',
      'Washing Machine',
      'Microwave',
      'Oven',
      'Iron',
      'Blender',
      'Mixer',
      'Grinder',
      'Toaster',
      'Kettle',
      'Water Purifier',
      'Air Purifier',
      'Fan',
      'Geyser',
      'Inverter',
      'Generator',
      'Water Heater',
      'Water Dispenser',
      'Air Conditioner',
      'Refrigerator',
      'Washing Machine',
      'Microwave',
      'Oven',
      'Iron',
      'Blender',
      'Mixer',
      'Grinder',
      'Toaster',
      'Kettle',
      'Water Purifier',
      'Air Purifier',
      'Fan',
      'Geyser',
      'Inverter',
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
      backgroundColor: const Color.fromARGB(255, 246, 245, 244),
      appBar: AppBar(
        title: Text('Search Categories'),
      ),
      // body:

      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 1, 85, 108),
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
                        icon: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue[400],
                          
                          ),
                          child: const Icon(Icons.clear)),
                        color: const Color.fromARGB(255, 14, 2, 2),
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
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
            ),
          ),
          Expanded(
            child: isSearching
                ? ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filteredCategories.length,
                    itemBuilder: (context, index) {
                      final category = filteredCategories[index];
                   

                      return Card(
                        elevation: 4, // Slightly increased elevation for depth
                        shadowColor: Colors.blueAccent.withOpacity(0.2),
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(18), // Rounded corners
                            child: ExpansionTile(
                              backgroundColor:
                                  Colors.white, // Prevents color leaks
                              tilePadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              iconColor: Colors.blueAccent,
                              collapsedIconColor: Colors.blueGrey,
                              leading: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue.shade300,
                                      Colors.blueAccent.shade200
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue.withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  _getCategoryIcon(category.key),
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              title: Text(
                                category.key,
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blueGrey[900],
                                ),
                              ),
                              children: category.value.map((subCategory) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  child: InkWell(
                                    onTap: () => navigateToSubCategoryPosts(
                                        category.key, subCategory),
                                    borderRadius: BorderRadius.circular(10),
                                    splashColor: Colors.blue.withOpacity(0.2),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 6),
                                      leading: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade50,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          Icons
                                              .subdirectory_arrow_right_rounded,
                                          color: Colors.blueAccent,
                                          size: 24,
                                        ),
                                      ),
                                      title: Text(
                                        subCategory,
                                        style: GoogleFonts.abel(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                          color: const Color.fromARGB(255, 45, 39, 39),
                                        ),
                                      ),
                                      trailing: Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Colors.blueAccent,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
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
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.1,
                          ),
                          itemCount: categoryMap.length,
                          itemBuilder: (context, index) {
                            final category =
                                categoryMap.entries.elementAt(index);
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
                                      _getCategoryColor(category.key)
                                          .withAlpha((0.9 * 255).round()),
                                      _getCategoryColor(category.key),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _getCategoryColor(category.key)
                                          .withAlpha((0.9 * 255).round()),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withAlpha(
                                                  (0.9 * 255).round()),
                                              borderRadius:
                                                  BorderRadius.circular(12),
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
