
import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/models/category_model.dart';

class CategoryDetailsScreen extends StatelessWidget {
  final CategoryModel categoryModel;

  const CategoryDetailsScreen({Key? key, required this.categoryModel})
      : super(key: key);

  Widget _buildCategorySpecificDetails() {
    // Switch case to return different details based on category
    switch (categoryModel.category.toLowerCase()) {
      case 'cars':
        return _buildCarDetails();
      case 'property':
        return _buildPropertyDetails();
      case 'electronics':
        return _buildElectronicsDetails();
      case 'furniture':
        return _buildFurnitureDetails();
      default:
        return _buildDefaultDetails();
    }
  }

  Widget _buildCarDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailHeader('Car Specifications'),
          _buildDetailItem(Icons.directions_car, 'Type', 'Vehicles'),
          _buildDetailItem(Icons.speed, 'Features', 'New/Used Cars'),
          _buildDetailItem(Icons.build, 'Services', 'Maintenance, Repair'),
          _buildDetailItem(Icons.category, 'Subcategories', 'Sedan, SUV, Sports'),
        ],
      ),
    );
  }

  Widget _buildPropertyDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailHeader('Property Information'),
          _buildDetailItem(Icons.home, 'Type', 'Real Estate'),
          _buildDetailItem(Icons.apartment, 'Options', 'Rent/Buy'),
          _buildDetailItem(Icons.location_city, 'Properties', 'Apartment, House, Land'),
          _buildDetailItem(Icons.business, 'Commercial', 'Office Space, Retail'),
        ],
      ),
    );
  }

  Widget _buildElectronicsDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailHeader('Electronics Information'),
          _buildDetailItem(Icons.devices, 'Devices', 'Smartphones, Laptops'),
          _buildDetailItem(Icons.cable, 'Accessories', 'Chargers, Cases'),
          _buildDetailItem(Icons.memory, 'Components', 'Hardware parts'),
          _buildDetailItem(Icons.headphones, 'Audio', 'Headphones, Speakers'),
        ],
      ),
    );
  }

  Widget _buildFurnitureDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailHeader('Furniture Collection'),
          _buildDetailItem(Icons.chair, 'Living Room', 'Sofas, Tables'),
          _buildDetailItem(Icons.bed, 'Bedroom', 'Beds, Wardrobes'),
          _buildDetailItem(Icons.kitchen, 'Kitchen', 'Cabinets, Dining Sets'),
          _buildDetailItem(Icons.work, 'Office', 'Desks, Office Chairs'),
        ],
      ),
    );
  }

  Widget _buildDefaultDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailHeader('Category Information'),
          _buildDetailItem(Icons.category, 'Category Type', categoryModel.category),
          _buildDetailItem(Icons.info, 'General Information', 'Standard Category'),
        ],
      ),
    );
  }

  Widget _buildDetailHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryModel.category),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: Image.network(
                categoryModel.icon,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Icon(Icons.error, size: 50));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    categoryModel.category,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCategorySpecificDetails(),
                  const SizedBox(height: 20),
                  const Text(
                    'Products in this Category',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 200,
                    child: const Center(
                      child: Text(
                        'Products will be displayed here',
                        style: TextStyle(
                          color: Colors.grey,
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
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_poc_v3/models/category_model.dart';

// class CategoryDetailsScreen extends StatelessWidget {
//   final CategoryModel categoryModel;

//   const CategoryDetailsScreen({Key? key, required this.categoryModel})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(categoryModel.category),
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: double.infinity,
//               height: 200,
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//               ),
//               child: Image.network(
//                 categoryModel.icon,
//                 fit: BoxFit.contain,
//                 errorBuilder: (context, error, stackTrace) {
//                   return const Center(child: Icon(Icons.error, size: 50));
//                 },
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     categoryModel.category,
//                     style: const TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   // Category Description Section
//                   Container(
//                     padding: EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[100],
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Category Details',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                         // Add more category details here
//                         ListTile(
//                           leading: Icon(Icons.category),
//                           title: Text('Category Type'),
//                           subtitle: Text(categoryModel.category),
//                         ),
//                         // Add more ListTiles for additional details
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   // Products Section (You can add a grid or list of products here)
//                   Text(
//                     'Products in this Category',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   // Add a GridView or ListView for products
//                   Container(
//                     height: 200,
//                     child: Center(
//                       child: Text(
//                         'Products will be displayed here',
//                         style: TextStyle(
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
