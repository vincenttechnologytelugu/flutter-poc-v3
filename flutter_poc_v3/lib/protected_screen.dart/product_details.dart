import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/models/product_model.dart';

import 'package:flutter_poc_v3/protected_screen.dart/contact_seller_screen.dart';  // Make sure this import is correct
class ProductDetails extends StatelessWidget {
  final ProductModel productModel;

  const ProductDetails({super.key, required this.productModel});
  // Add this method to handle chat button press
  void _handleChatPress(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ContactSellerScreen()),
    );
  }

  // Add this method to handle call button press
  void handleCallPress() {
  
    // Implement call functionality here
    // You can use url_launcher package to make phone calls
  }

  Widget _buildProductSpecificDetails() {
  //    // Get the category and subcategory from the product model
  // final category = productModel.category?.toLowerCase() ?? '';
  // final Map<String, dynamic> details = {};

  //  // Add common details that are available
  // if (productModel.brand != null) details['Brand'] = productModel.brand;
  // if (productModel.condition != null) details['Condition'] = productModel.condition;
  // if (productModel.warranty != null) details['Warranty'] = productModel.warranty;
  // if (productModel.price != null) details['Price'] = '₹ ${productModel.price}';

  // // Add category-specific details
  // switch (category) {
  //   case 'House':
  //     if (productModel.bedrooms != null) details['Bedrooms'] = productModel.bedrooms;
  //     if (productModel.bathrooms != null) details['Bathrooms'] = productModel.bathrooms;
  //     if (productModel.area != null) details['Area'] = '${productModel.area} sq ft';
  //     if (productModel.furnishing != null) details['Furnishing'] = productModel.furnishing;
  //     break;

  //   case 'vehicles':
  //   case 'cars':
  //     if (productModel.year != null) details['Year'] = productModel.year;
  //     if (productModel.kilometers != null) details['Kilometers'] = '${productModel.kilometers} km';
  //     if (productModel.fuelType != null) details['Fuel Type'] = productModel.fuelType;
  //     if (productModel.transmission != null) details['Transmission'] = productModel.transmission;
  //     break;

  //   case 'mobile phones':
  //   case 'electronics':
  //     if (productModel.model != null) details['Model'] = productModel.model;
  //     if (productModel.storage != null) details['Storage'] = productModel.storage;
  //     if (productModel.ram != null) details['RAM'] = productModel.ram;
  //     break;

  //   case 'furniture':
  //     if (productModel.material != null) details['Material'] = productModel.material;
  //     if (productModel.dimensions != null) details['Dimensions'] = productModel.dimensions;
  //     break;

  //   // Add more categories as needed
  // }



    // Switch case to return different details based on category
    switch (productModel.category?.toLowerCase()) {
      case 'cars':
        return _buildCarDetails();
      case 'properties':
        return _buildPropertiesDetails();
      case 'electronics':
        return _buildElectronicsDetails();
      case 'mobiles':
        return _buildMobilesDetails();
      case 'jobs':
        return _buildJobDetails();
      case 'fashion':
        return _buildFashionDetails();
      case 'books, sports & hobbies':
        return _buildBooksSportsHobbiesDetails();
      case 'bikes':
        return _buildBikesDetails();
      case 'electronics & appliances':
        return _buildElectronicsAppliancesDetails();
      case 'furniture':
        return _buildFurnitureDetails();
      case 'pets':
        return _buildPetsDetails();
        case 'commercial vehicles & spares':
        return _buildCommercialVehiclesSparesDetails();
      default:
        return _buildDefaultDetails();
    }
  }

  Widget _buildCarDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('City', productModel.city),
        _buildInfoRow('Category', productModel.category),
        _buildInfoRow('Brand', productModel.brand),
        _buildInfoRow('Model', productModel.model),
        _buildInfoRow('Fuel', productModel.fuel),
        _buildInfoRow('Year', productModel.year?.toString()),
        _buildInfoRow('Mileage', '${productModel.mileage} km'),
        _buildInfoRow('Transmission', productModel.transmission),
        _buildInfoRow('Condition', productModel.condition),
        _buildInfoRow('OwnerType', productModel.ownerType.toString()),
      ],
    );
  }

  Widget _buildPropertiesDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('City', productModel.city),
        _buildInfoRow('Category', productModel.category),
        _buildInfoRow('Condition', productModel.condition),
        _buildInfoRow('Price', productModel.price.toString()),
        _buildInfoRow('Condition', productModel.condition),
        _buildInfoRow('Title', productModel.title.toString()),
        _buildInfoRow('Property Type', productModel.propertyType),
        _buildInfoRow('Bedrooms', productModel.bedrooms?.toString()),
        _buildInfoRow('Bathrooms', productModel.bathrooms?.toString()),
        _buildInfoRow('Furnished', productModel.furnishing.toString()),
        _buildInfoRow('Area', '${productModel.area} sq. ft.'),
        _buildInfoRow('Condition', productModel.condition),
        _buildInfoRow('OwnerType', productModel.ownerType.toString()),
        _buildInfoRow('FloorNumber', productModel.floorNumber.toString()),
        _buildInfoRow('TotalFloors', productModel.totalFloors.toString()),
      ],
    );
  }

  Widget _buildElectronicsDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('City', productModel.city),
        _buildInfoRow('Category', productModel.category),
        _buildInfoRow('Brand', productModel.brand),
        _buildInfoRow('Model', productModel.model),
        _buildInfoRow('Condition', productModel.condition),
        _buildInfoRow('Warranty', productModel.warranty),
      ],
    );
  }

  Widget _buildMobilesDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('City', productModel.city),
        _buildInfoRow('Category', productModel.category),
        _buildInfoRow('Title', productModel.title),
        _buildInfoRow('Price', productModel.price.toString()),
        _buildInfoRow('Storage', productModel.storage),
        _buildInfoRow('Operating System', productModel.operatingSystem),
        _buildInfoRow('Screen Size', productModel.screenSize),
        _buildInfoRow('Color', productModel.color),
        _buildInfoRow('Camera', productModel.camera),
        _buildInfoRow('Battery', productModel.battery),
        _buildInfoRow('Brand', productModel.brand),
        _buildInfoRow('Model', productModel.model),
        _buildInfoRow('Condition', productModel.condition),
        _buildInfoRow('Warranty', productModel.warranty),
      ],
    );
  }

  Widget _buildJobDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('City', productModel.city),
        _buildInfoRow('Category', productModel.category),
        _buildInfoRow('Title', productModel.title),
        _buildInfoRow('Job Type', productModel.jobType),
        _buildInfoRow('Experience', productModel.experienceLevel),
        _buildInfoRow('Qualification', productModel.qualifications),
        _buildInfoRow('Salary', productModel.salary),
        _buildInfoRow('Position', productModel.position),
        _buildInfoRow('Company', productModel.company),
      ],
    );
  }

  Widget _buildFashionDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('City', productModel.city),
        _buildInfoRow('location', productModel.location),
        _buildInfoRow('Product', productModel.product),
        _buildInfoRow('Fachion Category', productModel.fashion_category),
        _buildInfoRow('Size', productModel.size),
        _buildInfoRow('Color', productModel.color),
        _buildInfoRow('City', productModel.city),
        _buildInfoRow('Category', productModel.category),
        _buildInfoRow('Title', productModel.title),
        _buildInfoRow('Price', productModel.price.toString()),
        _buildInfoRow('Brand', productModel.brand),
        _buildInfoRow('Model', productModel.model),
        _buildInfoRow('Condition', productModel.condition),
        _buildInfoRow('Warranty', productModel.warranty),
      ],
    );
  }

  Widget _buildBooksSportsHobbiesDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('City', productModel.city),
        _buildInfoRow('Category', productModel.category),
        _buildInfoRow('Title', productModel.title),
        _buildInfoRow('Price', productModel.price.toString()),
        _buildInfoRow('hobby_category', productModel.hobby_category),
        _buildInfoRow('Product', productModel.product),
        _buildInfoRow('Condition', productModel.condition),
      ],
    );
  }

  Widget _buildBikesDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('City', productModel.city),
        _buildInfoRow('Category', productModel.category),
        _buildInfoRow('Title', productModel.title),
        _buildInfoRow('Price', productModel.price.toString()),
        _buildInfoRow('Brand', productModel.brand),
        _buildInfoRow('Model', productModel.model),
        _buildInfoRow('Condition', productModel.condition),
        _buildInfoRow('Warranty', productModel.warranty),
        _buildInfoRow('Mileage', '${productModel.mileage} km'),
        _buildInfoRow('Transmission', productModel.transmission),
        _buildInfoRow('OwnerType', productModel.ownerType.toString()),
        _buildInfoRow('Color', productModel.color),
        _buildInfoRow('Year', productModel.year.toString()),
      ],
    );
  }

  Widget _buildElectronicsAppliancesDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('City', productModel.city),
        _buildInfoRow('Category', productModel.category),
        _buildInfoRow('Title', productModel.title),
        _buildInfoRow('Price', productModel.price.toString()),
        _buildInfoRow('Brand', productModel.brand),
        _buildInfoRow('Product', productModel.product),
        _buildInfoRow('Condition', productModel.condition),
        _buildInfoRow('Warranty', productModel.warranty),
      ],
    );
  }

  Widget _buildFurnitureDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('City', productModel.city),
        _buildInfoRow('Category', productModel.category),
        _buildInfoRow('Title', productModel.title),
        _buildInfoRow('Price', productModel.price.toString()),
        _buildInfoRow('Product', productModel.product),
        _buildInfoRow('Condition', productModel.condition),
        _buildInfoRow('Material', productModel.material),
        _buildInfoRow('Dimensions', productModel.dimensions.toString()),
      ],
    );
  }

  Widget _buildPetsDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('City', productModel.city),
        _buildInfoRow('Category', productModel.category),
        _buildInfoRow('Title', productModel.title),
        _buildInfoRow('Price', productModel.price.toString()),
        _buildInfoRow('Breed', productModel.breed),
        _buildInfoRow('Condition', productModel.condition),
        _buildInfoRow('Vaccination Type', productModel.vaccinationType),
        _buildInfoRow('Pet Category', productModel.vaccinationType),
      ],
    );
  }
  Widget _buildCommercialVehiclesSparesDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('City', productModel.city),
        _buildInfoRow('Category', productModel.category),
        _buildInfoRow('Title', productModel.title),
        _buildInfoRow('Price', productModel.price.toString()),
        _buildInfoRow('Brand', productModel.brand),
        _buildInfoRow('Product', productModel.product),
        _buildInfoRow('Condition', productModel.condition),
        _buildInfoRow('Warranty', productModel.warranty),
        _buildInfoRow('Mileage', '${productModel.mileage} km'),
        _buildInfoRow('Transmission', productModel.transmission),
        _buildInfoRow('OwnerType', productModel.ownerType.toString()),
        _buildInfoRow('Color', productModel.color),
        _buildInfoRow('Year', productModel.year.toString()),
        _buildInfoRow('Model', productModel.model),

      ],
    );
  }

  Widget _buildDefaultDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Brand', productModel.brand),
        _buildInfoRow('Condition', productModel.condition),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(productModel.title ?? 'Product Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             
            // Image
            Container(
              margin: const EdgeInsets.all(30.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: 270,
                  width: double.infinity,
                  child: productModel.thumb != null
                      ? Image.network(
                          productModel.thumb!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.image_not_supported,size: 180,color: Colors.red,),
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                 
                  Text(
                    '₹ ${productModel.price?.toString() ?? 'N/A'}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 243, 6, 176),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('Location', productModel.location),
                  const Divider(height: 32),
                  _buildProductSpecificDetails(),
                  if (productModel.description != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        productModel.description!,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // In ProductDetails class
                        Expanded(
                          child: ElevatedButton(
                            // Update this line to pass the context
                            onPressed: () => _handleChatPress(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.chat, color: Colors.white),
                                const SizedBox(width: 8),
                                const Text(
                                  'Chat',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            // onPressed: () => _handleCallPress(),
                              onPressed: () => _handleChatPress(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.call, color: Colors.white),
                                const SizedBox(width: 8),
                                const Text(
                                  'Call',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
