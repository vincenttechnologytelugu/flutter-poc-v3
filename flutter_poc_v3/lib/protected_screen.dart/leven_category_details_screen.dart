

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/models/product_model.dart';
import 'package:flutter_poc_v3/protected_screen.dart/dashboard/category_based_posts_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/homeappbar_screen.dart';
import 'package:flutter_poc_v3/services/ad_post_service.dart';
import 'package:get/get.dart';
import 'package:flutter_poc_v3/controllers/location_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class LevenCategoryDetailsScreen extends StatefulWidget {
  final ProductModel productModel;

  const LevenCategoryDetailsScreen({super.key, required this.productModel});

  @override
  State<LevenCategoryDetailsScreen> createState() =>
      _LevenCategoryDetailsScreen();
}

class _LevenCategoryDetailsScreen extends State<LevenCategoryDetailsScreen> {
  final LocationController locationController = Get.find<LocationController>();
  final AdPostService _adPostService = AdPostService();
  String location = "Select Location";


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
    if (city.isNotEmpty) {
      url += '&city=$city';
    }
    if (state.isNotEmpty) {
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
       backgroundColor: const Color.fromARGB(255, 247, 212, 224),
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
              // AppBar(
              //   centerTitle: true,

              //   automaticallyImplyLeading: false, // Add this line to remove b
              //   title: Text(widget.productModel.category ?? 'Category Details'),
              //   elevation: 0,

              //   backgroundColor: Colors
              //       .transparent, // Make it transparent to avoid double background
              // ),

              AppBar(
  centerTitle: true,
  automaticallyImplyLeading: false,
  title: Text(
    widget.productModel.category ?? 'Category Details',
    style: TextStyle(
      color: Color.fromARGB(255, 249, 249, 250), // Use primary color from body gradient
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    ),
  ),
  elevation: 0,
 
  backgroundColor: const Color.fromARGB(255, 147, 119, 119).withOpacity(0.96), // Semi-transparent white

  shadowColor: Color(0xFF6366F1).withOpacity(0.1), // Coordinated shadow
  surfaceTintColor: const Color.fromARGB(0, 255, 254, 254),
  flexibleSpace: Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(16),
        bottomRight: Radius.circular(16),
      ),
      boxShadow: [
        BoxShadow(
        
          color: Color(0xFF4F46E5).withOpacity(0.08),
          blurRadius: 12,
          spreadRadius: 1,
          offset: Offset(0, 2),
        ),
      ],
    ),
  ),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(16),
      bottomRight: Radius.circular(16),
    ),
  ),
  toolbarHeight: 60, // Slightly taller for modern look
)
            ],
          ),
        ),
      ),
     
      // body: ListView(
      //   children: _buildSubcategoryList(),

      // ),
      body: Container(
       
        margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration:BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromARGB(255, 255, 253, 255),
           const Color.fromARGB(255, 255, 253, 255),
            ],
          ),
        ),
        // color: const Color.fromARGB(255, 245, 115, 227), // Light modern background
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          children: _buildSubcategoryList().map((widget) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(16),
        //   boxShadow: [
        //     BoxShadow(
        //       color: Colors.blueGrey.withOpacity(0.1),
        //       blurRadius: 12,
        //       spreadRadius: 2,
        //       offset: const Offset(0, 4),
        //     ),
        //   ],
        //   gradient: const LinearGradient(
        //     colors: [Color.fromARGB(255, 235, 181, 245), Color.fromARGB(255, 2, 49, 103)], // Indigo gradient
        //     begin: Alignment.centerLeft,
        //     end: Alignment.centerRight,
        //   ),
        // ),
        decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(20), // Slightly larger for a modern feel
  boxShadow: [
    BoxShadow(
      color: const Color.fromARGB(255, 236, 235, 237).withOpacity(0.15), // Subtle shadow
      blurRadius: 16, // Increased for a smoother look
      spreadRadius: 3, 
      offset: const Offset(0, 6), // More depth
    ),
  ],
  gradient: const LinearGradient(
    colors: [
      Color(0xFF023167),// Soft pastel violet
      Color(0xFF023167), // Deep indigo for contrast
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
),

        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            splashColor: Colors.white.withOpacity(0.2),
            onTap: () {}, // Add your onTap functionality here
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      child: widget,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
          }).toList(),
        ),
      )
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
        {'name': 'Fitness', 'findkey': 'Fitness'},
        {'name':"Horror", 'findkey':"Horror"},
        {'name': 'Action', 'findkey': 'Action'},
        {'name': 'Adventure', 'findkey': 'Adventure'},
        {'name': 'Romance', 'findkey': 'Romance'},
        {'name': 'Science Fiction', 'findkey': 'Science Fiction'},
        {'name': 'Fantasy', 'findkey': 'Fantasy'},
        {'name': 'Mystery', 'findkey': 'Mystery'},
        {'name': 'Thriller', 'findkey': 'Thriller'},
        {'name': 'Biography', 'findkey': 'Biography'},
        {'name': 'Self-Help', 'findkey': 'Self-Help'},
        {'name': 'Cookbooks', 'findkey': 'Cookbooks'},
        {'name': 'Travel Guides', 'findkey': 'Travel Guides'},
        {'name': 'Children\'s Books', 'findkey': 'Children\'s Books'},
        {'name': 'Young Adult', 'findkey': 'Young Adult'},
        {'name': 'Graphic Novels', 'findkey': 'Graphic Novels'},
        {'name': 'Comics', 'findkey': 'Comics'},
        {'name': 'Textbooks', 'findkey': 'Textbooks'},
        {'name': 'Academic Books', 'findkey': 'Academic Books'},
        {'name': 'Poetry', 'findkey': 'Poetry'},
        {'name': 'Short Stories', 'findkey': 'Short Stories'},
        {'name': 'Essays', 'findkey': 'Essays'},
        {'name': 'Plays', 'findkey': 'Plays'},
        {'name': 'Anthologies', 'findkey': 'Anthologies'},
        {'name': 'Cookbooks', 'findkey': 'Cookbooks'},
        {'name': 'Graphic Novels', 'findkey': 'Graphic Novels'},
        {'name': 'Comics', 'findkey': 'Comics'},
        {'name': 'Textbooks', 'findkey': 'Textbooks'},
        {'name': 'Academic Books', 'findkey': 'Academic Books'},
        {'name': 'Poetry', 'findkey': 'Poetry'},
        {'name': 'Short Stories', 'findkey': 'Short Stories'},
        {'name': 'Essays', 'findkey': 'Essays'},
        {'name': 'Plays', 'findkey': 'Plays'},
        {'name': 'Anthologies', 'findkey': 'Anthologies'},
        {'name': 'Gym & Fitness', 'findkey': 'Gym & Fitness'},
        {'name': 'Sports Equipment', 'findkey': 'Sports Equipment'},
        {'name': 'Other Hobbies', 'findkey': 'Other Hobbies'},
      ],
      'Jobs': [
        {
          'name': 'Data Entry',
          'findkey': 'Data Entry',
       
        },
            {
          'name': 'Security',
          'findkey': 'Security',
       
        },
        {
          'name': 'Sales',
          'findkey': 'Sales',
        
        },
        {
          'name': 'BPO',
          'findkey': 'BPO',
        
        },
        {
          'name': 'Driver',
          'findkey': 'Driver',
        
        },
        {
          'name': 'Cook',
          'findkey': 'Cook',
         
        },
        {
          'name': 'Delivery Boy',
          'findkey': 'Delivery Boy',
         
        },
        {
          'name': 'Electrician',
          'findkey': 'Electrician',
        
        },
        {
          'name': 'Plumber',
          'findkey': 'Plumber',
        
        },
        {
          'name': 'Housekeeping',
          'findkey': 'Housekeeping',
         
        },
        {
          'name': 'Security Guard',
          'findkey': 'Security Guard',
        
        },
        {
          'name': 'Office Assistant',
          'findkey': 'Office Assistant',
        
        },
        {
          'name': 'Marketing',
          'findkey': 'Marketing',
        
        },
        {
          'name': 'Teaching',
          'findkey': 'Teaching',
         
        },
        {
          'name': 'Customer Service',
          'findkey': 'Customer Service',
          'salary_start': '12000',
          'salary_end': '30000'
        },
        {
          'name': 'IT Support',
          'findkey': 'IT Support',
        
        },
         {
          'name': 'IT',
          'findkey': 'IT',
        
        },
        {
          'name': 'HR',
          'findkey': 'HR',
        
        },
        {
          'name': 'Finance',
          'findkey': 'Finance',
       
        },
        {
          'name': 'Engineering',
          'findkey': 'Engineering',
      
        },
        {
          'name': 'Healthcare',
          'findkey': 'Healthcare',
    
        },
        {
          'name': 'Hospitality',
          'findkey': 'Hospitality',
       
        },
        {
          'name': 'Construction',
          'findkey': 'Construction',
        
        },
        {
          'name': 'Manufacturing',
          'findkey': 'Manufacturing',
        
        },
        {
          'name': 'Logistics',
          'findkey': 'Logistics',
         
        },
        {
          'name': 'Telecom',
          'findkey': 'Telecom',
     
        },
        {
          'name': 'Retail',
          'findkey': 'Retail',
          
        },
        {
          'name': 'Real Estate',
          'findkey': 'Real Estate',
       
        },
        {
          'name': 'Insurance',
          'findkey': 'Insurance',
       
        },
        {
          'name': 'Legal',
          'findkey': 'Legal',
         
        },
      ],
      'Properties': [
        {'name': 'House Sale', 'findkey': 'house'},
        {'name': 'Apartment Sale', 'findkey': 'apartment'},
        {'name': 'Land Sale', 'findkey': 'land'},
        {'name': 'House Rent', 'findkey': 'rent'},
        {'name': 'Apartment Rent', 'findkey': 'apartment_rent'},
        {'name': 'Land Rent', 'findkey': 'land_rent'},
        {'name': 'PG & Guest House', 'findkey': 'pg_guest'},
        {'name': 'Shops & Offices Sale', 'findkey': 'shops_offices_sale'},
        {'name': 'Shops & Offices Rent', 'findkey': 'shops_offices_rent'},
        {'name': 'Commercial Property Sale', 'findkey': 'commercial_property_sale'},
        {'name': 'Commercial Property Rent', 'findkey': 'commercial_property_rent'},
        {'name': 'Farmhouse Sale', 'findkey': 'farmhouse_sale'},
        {'name': 'Farmhouse Rent', 'findkey': 'farmhouse_rent'},


      
        {'name': 'Villas Sale', 'findkey': 'villas_sale'},
        {'name': 'Villas Rent', 'findkey': 'villas_rent'},
        {'name': 'Plots Sale', 'findkey': 'plots_sale'},
        {'name': 'Plots Rent', 'findkey': 'plots_rent'},
        {'name': 'Commercial Land Sale', 'findkey': 'commercial_land_sale'},
        {'name': 'Commercial Land Rent', 'findkey': 'commercial_land_rent'},
        {'name': 'Industrial Property Sale', 'findkey': 'industrial_property_sale'},
        {'name': 'Industrial Property Rent', 'findkey': 'industrial_property_rent'},
        {'name': 'Warehouse Sale', 'findkey': 'warehouse_sale'},
        {'name': 'Warehouse Rent', 'findkey': 'warehouse_rent'},
        {'name': 'Office Space Sale', 'findkey': 'office_space_sale'},
        {'name': 'Office Space Rent', 'findkey': 'office_space_rent'},
        {'name': 'Retail Space Sale', 'findkey': 'retail_space_sale'},
        {'name': 'Retail Space Rent', 'findkey': 'retail_space_rent'},
        {'name': 'Co-working Space Sale', 'findkey': 'co_working_space_sale'},
        {'name': 'Co-working Space Rent', 'findkey': 'co_working_space_rent'},
        {'name': 'Storage Space Sale', 'findkey': 'storage_space_sale'},
        {'name': 'Storage Space Rent', 'findkey': 'storage_space_rent'},
        {'name': 'Parking Space Sale', 'findkey': 'parking_space_sale'},
        {'name': 'Parking Space Rent', 'findkey': 'parking_space_rent'},
        {'name': 'Farm Land Sale', 'findkey': 'farm_land_sale'},
        {'name': 'Farm Land Rent', 'findkey': 'farm_land_rent'},
        {'name': 'Resort Sale', 'findkey': 'resort_sale'},
        {'name': 'Resort Rent', 'findkey': 'resort_rent'},
        {'name': 'Guest House Sale', 'findkey': 'guest_house_sale'},
        {'name': 'Guest House Rent', 'findkey': 'guest_house_rent'},


      ],
      'Electronics & Appliances': [
        {'name': 'Mobiles', 'findkey': 'mobiles'},
         {'name': 'Samsung', 'findkey': 'samsung'},
              {'name': 'Generators', 'findkey': 'generators'},
        {
          'name': 'Electronics & Appliances',
          'findkey': 'Electronics & Appliances'
        },
        {'name': 'Bicycle', 'findkey': 'Bicycle'},
        {'name': 'Computer & Laptop', 'findkey': 'Computer & Laptop'},
        {'name': 'Camera', 'findkey': 'camera'},
        {'name': 'Fridge', 'findkey': 'Fridge'},
        {'name': 'Washing Machine', 'findkey': 'Washing Machine'},
        {'name': 'AC', 'findkey': 'AC'},
        {'name': 'Cooler', 'findkey': 'Cooler'},
        {'name': 'TV', 'findkey': 'TV'},
        {'name': 'Kitchen Appliances', 'findkey': 'Kitchen Appliances'},
        {'name': 'Other Appliances', 'findkey': 'Other Appliances'},
      ],
      'Bikes': [
        {'name': "Honda SP 125",'findkey': "Honda SP 125"},
        {'name': 'Activa 6G', 'findkey': 'activa 6G'},
            {'name': 'Shine', 'findkey': 'shine'},
              {'name': 'TVS Apache RTR 180', 'findkey': 'TVS Apache RTR 180'},
               {'name': 'TVS Apache RTR 160 4V', 'findkey': 'TVS Apache RTR 160 4V'},
                {'name': 'TVS Apache RTR 16', 'findkey': 'TVS Apache RTR 160'},
                 {'name': 'TVS Ronin', 'findkey': 'TVS Ronin'},
 {'name': 'TVS Raider 125', 'findkey': 'TVS Raider 125'},
  {'name': 'TVS Radeon', 'findkey': 'TVS Radeon'},
   {'name': 'TVS Star City+', 'findkey': 'TVS Star City+'},
    {'name': 'TVS Apache RTR 310', 'findkey': 'TVS Apache RTR 310'},
     {'name': 'TVS Apache RR 310', 'findkey': 'TVS Apache RR 310'},
      {'name': 'TVS Apache RTR 200 4V', 'findkey': 'TVS Apache RTR 200 4V'},
       {'name': 'TVS', 'findkey': 'TVS'},
        {'name': 'TVS Apache RTR 200', 'findkey': 'TVS Apache RTR 200'},
          {'name': 'Glamour', 'findkey': 'glamour'},




        {'name': 'Trucks', 'findkey': 'Trucks'},
        {'name': 'Scooters', 'findkey': 'Scooters'},
      ],
  
      'Fashion': [
        {'name': 'Clothes', 'findkey': 'women'},
        {'name': 'Shoes', 'findkey': 'shoes'},
        {'name': 'Men', 'findkey': 'men'},
        {'name': 'Footwear', 'findkey': 'Footwear'},
        {'name': 'Bags', 'findkey': 'Bags'},
        {'name': 'Accessories', 'findkey': 'Accessories'},
        {'name': 'Watches', 'findkey': 'Watches'},
        {'name': 'Jewellery', 'findkey': 'Jewellery'},
        {'name': 'Sunglasses', 'findkey': 'Sunglasses'},
        {'name': 'Belts', 'findkey': 'Belts'},
        {'name': 'Wallets', 'findkey': 'Wallets'},
        {'name': 'Perfumes', 'findkey': 'Perfumes'},
 
     


      ],
      'Pets': [
        {'name': 'pets', 'findkey': 'pets'},
        {'name': 'Fish', 'findkey': 'fish'},
        {'name': 'Birds', 'findkey': 'Birds'},
        {'name': 'Cats', 'findkey': 'Cats'},
        {'name': 'dogs', 'findkey': 'dogs'},
        {'name': 'Dogs', 'findkey': 'Dogs'},
      
        {'name': 'Reptiles', 'findkey': 'Reptiles'},
        {'name': 'Turtles', 'findkey': 'Turtles'},
        {'name': 'Snakes', 'findkey': 'Snakes'},
        {'name': 'Lizards', 'findkey': 'Lizards'},
        {'name': 'Frogs', 'findkey': 'Frogs'},
        {'name': 'Hamsters', 'findkey': 'Hamsters'},
        {'name': 'Guinea Pigs', 'findkey': 'Guinea Pigs'},
        {'name': 'Gerbils', 'findkey': 'Gerbils'},
        {'name': 'Rabbits', 'findkey': 'Rabbits'},
      
        {'name': 'Ponds', 'findkey': 'Ponds'},
        {'name': 'Aquarium', 'findkey': 'Aquarium'},
        {'name': 'Pet Food', 'findkey': 'Pet Food'},
        {'name': 'Pet Accessories', 'findkey': 'Pet Accessories'},
        {'name': 'Pet Tools', 'findkey': 'Pet Tools'},
        {'name': 'Other Pets', 'findkey': 'Other Pets'},
        {'name': 'Pet Training', 'findkey': 'Pet Training'},
        {'name': 'Pet Grooming', 'findkey': 'Pet Grooming'},
        {'name': 'Pet Sitting', 'findkey': 'Pet Sitting'},
        {'name': 'Pet Walking', 'findkey': 'Pet Walking'},
        {'name': 'Pet Adoption', 'findkey': 'Pet Adoption'},
        {'name': 'Pet Breeding', 'findkey': 'Pet Breeding'},
        {'name': 'Pet Supplies', 'findkey': 'Pet Supplies'},
        {'name': 'Pet Insurance', 'findkey': 'Pet Insurance'},
        {'name': 'Pet Hospitals', 'findkey': 'Pet Hospitals'},
        {'name': 'Pet Stores', 'findkey': 'Pet Stores'},
        {'name': 'Pet Services', 'findkey': 'Pet Services'},
    
        {'name': 'Pet Shows', 'findkey': 'Pet Shows'},
        {'name': 'Pet Clubs', 'findkey': 'Pet Clubs'},
        {'name': 'Pet Forums', 'findkey': 'Pet Forums'},
        {'name': 'Pet Blogs', 'findkey': 'Pet Blogs'},
        {'name': 'Pet Magazines', 'findkey': 'Pet Magazines'},
        {'name': 'Pet News', 'findkey': 'Pet News'},
        {'name': 'Pet Videos', 'findkey': 'Pet Videos'},
        {'name': 'Pet Podcasts', 'findkey': 'Pet Podcasts'},
        {'name': 'Pet Apps', 'findkey': 'Pet Apps'},
        {'name': 'Pet Games', 'findkey': 'Pet Games'},
        {'name': 'Pet Toys', 'findkey': 'Pet Toys'},
        {'name': 'Pet Gifts', 'findkey': 'Pet Gifts'},
        {'name': 'Pet Clothing', 'findkey': 'Pet Clothing'},
        {'name': 'Pet Accessories', 'findkey': 'Pet Accessories'},
        {'name': 'Pet Furniture', 'findkey': 'Pet Furniture'},
        {'name': 'Pet Carriers', 'findkey': 'Pet Carriers'},
        {'name': 'Pet Beds', 'findkey': 'Pet Beds'},
        {'name': 'Pet Crates', 'findkey': 'Pet Crates'},
        {'name': 'Pet Gates', 'findkey': 'Pet Gates'},
        {'name': 'Pet Fences', 'findkey': 'Pet Fences'},
        {'name': 'Pet Houses', 'findkey': 'Pet Houses'},
        {'name': 'Pet Strollers', 'findkey': 'Pet Strollers'},
        {'name': 'Pet Car Seats', 'findkey': 'Pet Car Seats'},
        {'name': 'Pet Travel Accessories', 'findkey': 'Pet Travel Accessories'},
        {'name': 'Pet Training Supplies', 'findkey': 'Pet Training Supplies'},
        {'name': 'Pet Health Supplies', 'findkey': 'Pet Health Supplies'},
        {'name': 'Pet Grooming Supplies', 'findkey': 'Pet Grooming Supplies'},
        {'name': 'Pet Cleaning Supplies', 'findkey': 'Pet Cleaning Supplies'},
          {'name': 'First statge vaccination', 'findkey': 'First Stage Vaccinated'},


      ],
      'Mobiles': [
        {'name': 'IPhone', 'findkey': 'iPhone'},
         {'name': 'Samsung', 'findkey': 'samsung'},
          {'name': 'OnePlus', 'findkey': 'OnePlus'},
           {'name': 'Realme', 'findkey': 'Realme'},
            {'name': 'Vivo', 'findkey': 'Vivo'},
             {'name': 'Oppo', 'findkey': 'Oppo'},
              {'name': 'Motorola', 'findkey': 'Motorola'},
               {'name': 'Nokia', 'findkey': 'Nokia'},
                {'name': 'Honor', 'findkey': 'Honor'},
                 {'name': 'Xiaomi', 'findkey': 'Xiaomi'},
                  {'name': 'Poco', 'findkey': 'Poco'},
                   {'name': 'Asus', 'findkey': 'Asus'},
                    {'name': 'Lenovo', 'findkey': 'Lenovo'},
                     {'name': 'Micromax', 'findkey': 'Micromax'},

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
        {'name': 'Bedroom Appliances', 'findkey': 'Bedroom Appliances'},
        {'name': 'Living Room Appliances', 'findkey': 'Living Room Appliances'},
        {'name': 'Dining Room Appliances', 'findkey': 'Dining Room Appliances'},
        {'name': 'Garden Appliances', 'findkey': 'Garden Appliances'},
        {'name': 'Outdoor Appliances', 'findkey': 'Outdoor Appliances'},
        {'name': 'Indoor Appliances', 'findkey': 'Indoor Appliances'},

      ],
      'Services': [
        {'name': 'Education ', 'findkey': 'Education'},
        {'name': 'Cleaning', 'findkey': 'Cleaning'},
        {'name': 'Plumbing', 'findkey': 'Plumbing'},
        {'name': 'Electrician', 'findkey': 'Electrician'},
        {'name': 'Carpentry', 'findkey': 'Carpentry'},
        {'name': 'Gardener', 'findkey': 'Gardener'},
        {'name': 'Painting', 'findkey': 'Painting'},
        {'name': 'Pest Control', 'findkey': 'Pest Control'},
        {'name': 'Home Repair', 'findkey': 'Home Repair'},
        {'name': 'Beauty Services', 'findkey': 'Beauty Services'},
        {'name': 'Fitness Training', 'findkey': 'Fitness Training'},
        {'name': 'Tutoring', 'findkey': 'Tutoring'},
        {'name': 'Photography', 'findkey': 'Photography'},
        {'name': 'Event Management', 'findkey': 'Event Management'},
        {'name': 'Catering & Food', 'findkey': 'Catering & Food'},
        {'name': 'Transportation', 'findkey': 'Transportation'},
        {'name': 'Pet Services', 'findkey': 'Pet Services'},
        {'name': 'Personal Training', 'findkey': 'Personal Training'},
        {'name': 'Massage Therapy', 'findkey': 'Massage Therapy'},
        {'name': 'Yoga Classes', 'findkey': 'Yoga Classes'},
        {'name': 'Security', 'findkey': 'Security'},
        {'name': 'Music Lessons', 'findkey': 'Music Lessons'},
        {'name': 'Dance Classes', 'findkey': 'Dance Classes'},
        {'name': 'Art Classes', 'findkey': 'Art Classes'},
        {'name': 'Cooking Classes', 'findkey': 'Cooking Classes'},
        {'name': 'Photography & Videography', 'findkey': 'Photography & Videography'},
        {'name': 'Computer Classes', 'findkey': 'Computer Classes'},
        {'name': 'Driving Lessons', 'findkey': 'Driving Lessons'},
        {'name': 'Health & Wellness Coaching', 'findkey': 'Health & Wellness Coaching'},
        {'name': 'Financial Planning', 'findkey': 'Financial Planning'},
        {'name': 'Legal Services', 'findkey': 'Legal Services'},
        {'name': 'Consulting', 'findkey': 'Consulting'},
        {'name': 'Marketing Services', 'findkey': 'Marketing Services'},
        {'name': 'Web Development', 'findkey': 'Web Development'},
        {'name': 'Graphic Design', 'findkey': 'Graphic Design'},
        {'name': 'Social Media Management', 'findkey': 'Social Media Management'},
        {'name': 'SEO Services', 'findkey': 'SEO Services'},
        {'name': 'Content Writing', 'findkey': 'Content Writing'},
        {'name': 'Maid & Housekeeping', 'findkey': 'Maid & Housekeeping'},
        {'name': 'Data Entry', 'findkey': 'Data Entry'},
        {'name': 'Health & Beauty', 'findkey': 'Health & Beauty'},
        {'name': 'Cleaning & Housekeeping', 'findkey': 'Cleaning & Housekeeping'},
        {'name': 'Plumber', 'findkey': 'Plumber'},
        {'name': 'Legal Translation', 'findkey': 'Legal Translation'},
        {'name': 'Repair & Maintenance', 'findkey': 'Repair & Maintenance'},
        {'name': 'Carpenter', 'findkey': 'Carpenter'},
        {'name': 'Tutors & Training', 'findkey': 'Tutors & Training'},
        {'name': 'Business Writing', 'findkey': 'Business Writing'},
        {'name': 'Drivers & Taxi', 'findkey': 'Drivers & Taxi'},
        {'name': 'Home & Office Shifting', 'findkey': 'Home & Office Shifting'},
        {'name': 'Packing & Unpacking', 'findkey': 'Packing & Unpacking'},
        {'name': 'Interior Designer', 'findkey': 'Interior Designer'},
        {'name': 'Courier & Express Delivery', 'findkey': 'Courier & Express Delivery'},
        {'name': 'Packers & Movers', 'findkey': 'Packers & Movers'},
        {'name': 'Car Wash', 'findkey': 'Car Wash'},
        {'name': 'Vehicle Rental', 'findkey': 'Vehicle Rental'},
      
 
    
  
   
   
     
     
   
     
    
   
    
    
   
   
    
    


      

      ],
      'Commercial Vehicles & Spares': [
        {'name': 'Commercial Vehicles', 'findkey': 'Commercial Vehicles'},
        {'name': 'Spares', 'findkey': 'Spares'},
        {'name': 'Buses', 'findkey': 'Buses'},
        {'name': 'Trucks', 'findkey': 'TATA'},
        {'name': 'Scooters', 'findkey': 'Scooters'},
         {'name': 'TATA', 'findkey': 'tata'},
          {'name': 'Mahindra', 'findkey': 'mahindra'},
           {'name': 'Hyundai', 'findkey': 'Hyundai'},
            {'name': 'Eicher', 'findkey': 'Eicher'},
             {'name': 'Volvo', 'findkey': 'Volvo'},
              {'name': 'Ashok Leyland', 'findkey': 'Ashok Leyland'},
               {'name': 'Isuzu', 'findkey': 'Isuzu'},
                {'name': 'Nissan', 'findkey': 'Nissan'},
                 {'name': 'Mitsubishi', 'findkey': 'Mitsubishi'},
                  {'name': 'Honda', 'findkey': 'Honda'},
                   {'name': 'Suzuki', 'findkey': 'Suzuki'},
                    {'name': 'Honda', 'findkey': 'Honda'},
      ],

      // Add other categories...
    };

    List<Map<String, dynamic>> currentSubcategories =
        subcategories[widget.productModel.category] ?? [];

    return currentSubcategories.map((subcategory) {
      return ListTile(
        title: Text(subcategory['name'],
        
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: const Color.fromARGB(221, 246, 245, 245),
          fontFamily: GoogleFonts.sanchez().fontFamily,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          softWrap: true,
          textScaleFactor: 1.0, // Adjust text size 

        
        ),
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
