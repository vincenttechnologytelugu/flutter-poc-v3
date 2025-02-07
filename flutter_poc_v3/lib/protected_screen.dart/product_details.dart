import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/controllers/cart_controller.dart';
import 'package:flutter_poc_v3/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_poc_v3/protected_screen.dart/contact_seller_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/user_chat_screen.dart';
import 'package:get/get.dart'; // Make sure this import is correct
import 'package:http/http.dart' as http;

class ProductDetails extends StatefulWidget {
  final ProductModel productModel;

  const ProductDetails({super.key, required this.productModel});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final CartController cartController = Get.find<CartController>();

  Future<void> _initiateChat() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final adPostId = widget.productModel.id?.replaceAll('"', '').trim() ?? '';

      // First check conversations to see if one exists
      final conversationsResponse = await http.get(
        Uri.parse('http://192.168.0.170:8080/chat/conversations'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (conversationsResponse.statusCode == 200) {
        final List conversations = json.decode(conversationsResponse.body);
        final existingConversation = conversations.firstWhere(
          (conv) => conv['adPostId'] == adPostId,
          orElse: () => null,
        );

        String? conversationId;
        String? title;
        String? thumb;

        if (existingConversation != null) {
          // Use existing conversation
          conversationId = existingConversation['_id'];
          title = existingConversation['title'];
          thumb = existingConversation['thumb'];
        } else {
          // Initiate new chat
          final initiateResponse = await http.post(
            Uri.parse('http://192.168.0.170:8080/chat/initiate'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: json.encode({
              'adPostId': adPostId,
            }),
          );

          if (initiateResponse.statusCode == 201 ||
              initiateResponse.statusCode == 200) {
            final data = json.decode(initiateResponse.body);
            conversationId = data['conversationId'];
            title = data['title'];
            thumb = data['thumb'];
          } else {
            throw Exception('Failed to initiate chat');
          }
        }

        // Load messages for the conversation
        if (conversationId != null) {
          final messagesResponse = await http.post(
            Uri.parse('http://192.168.0.170:8080/chat/messages'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: json.encode({
              'conversationId': conversationId,
            }),
          );

          if (messagesResponse.statusCode == 200) {
            final messagesList = json.decode(messagesResponse.body);

            if (!mounted) return;

            // Navigate to chat screen with all required data
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserChatScreen(
                  conversationId: conversationId!,
                  thumb: thumb ?? widget.productModel.thumb ?? '',
                  title: title ?? widget.productModel.title ?? '',
                  price: widget.productModel.price ?? 0.0,
                  initialMessages: messagesList,
                  product: widget.productModel,
                ),
              ),
            );
          } else {
            throw Exception('Failed to load messages');
          }
        }
      } else {
        throw Exception('Failed to check existing conversations');
      }
    } catch (e) {
      log('Error in _initiateChat: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  // Add this method to handle call button press
  void handleCallPress() {
    // Implement call functionality here
    // You can use url_launcher package to make phone calls
  }

  Widget _buildProductSpecificDetails() {
    // Switch case to return different details based on category
    switch (widget.productModel.category?.toLowerCase()) {
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color.fromARGB(255, 129, 115, 115),
            const Color.fromARGB(255, 159, 142, 142),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 147, 133, 230).withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Vehicle Information'),
          _buildInfoCard([
            _buildInfoRow('ID', widget.productModel.id.toString()),
            _buildInfoRow('City', widget.productModel.city),
            _buildInfoRow('Category', widget.productModel.category),
          ]),
          const SizedBox(height: 20),
          _buildSectionHeader('Technical Details'),
          _buildInfoCard([
            _buildInfoRow('Brand', widget.productModel.brand),
            _buildInfoRow('Model', widget.productModel.model),
            _buildInfoRow('Fuel Type', widget.productModel.fuelType),
            _buildInfoRow(
                'Year', widget.productModel.year?.toString() ?? 'N/A'),
            _buildInfoRow('Mileage', '${widget.productModel.mileage} km'),
            _buildInfoRow('Transmission', widget.productModel.transmission),
          ]),
          const SizedBox(height: 20),
          _buildSectionHeader('Additional Information'),
          _buildInfoCard([
            _buildInfoRow('Condition', widget.productModel.condition),
            _buildInfoRow(
                'Owner Type', widget.productModel.ownerType.toString()),
          ]),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 24, 1, 230),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 247, 245, 250),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 251, 252, 251).withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: children.map((child) {
            final index = children.indexOf(child);
            return Column(
              children: [
                child,
                if (index != children.length - 1)
                  Divider(
                    height: 1,
                    color: Colors.grey.withOpacity(0.1),
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 237, 187, 6),
        border: Border(
          left: BorderSide(
            color: const Color.fromARGB(255, 231, 236, 230),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 18,
                color: const Color.fromARGB(179, 25, 8, 8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildCarDetails() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //         _buildInfoRow('id', widget.productModel.id.toString()),
  //       _buildInfoRow('City', widget.productModel.city),
  //       _buildInfoRow('Category', widget.productModel.category),
  //       _buildInfoRow('Brand', widget.productModel.brand),
  //       _buildInfoRow('Model', widget.productModel.model),
  //       _buildInfoRow('Fuel', widget.productModel.fuelType),
  //       _buildInfoRow('Year', widget.productModel.year?.toString()),
  //       _buildInfoRow('Mileage', '${widget.productModel.mileage} km'),
  //       _buildInfoRow('Transmission', widget.productModel.transmission),
  //       _buildInfoRow('Condition', widget.productModel.condition),
  //       _buildInfoRow('OwnerType', widget.productModel.ownerType.toString()),
  //     ],
  //   );
  // }

  Widget _buildPropertiesDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('id', widget.productModel.id.toString()),
        _buildInfoRow('City', widget.productModel.city),
        _buildInfoRow('Category', widget.productModel.category),
        _buildInfoRow('Condition', widget.productModel.condition),
        _buildInfoRow('Price', widget.productModel.price.toString()),
        _buildInfoRow('Condition', widget.productModel.condition),
        _buildInfoRow('Title', widget.productModel.title.toString()),
        _buildInfoRow('Property Type', widget.productModel.propertyType),
        _buildInfoRow('Bedrooms', widget.productModel.bedrooms?.toString()),
        _buildInfoRow('Bathrooms', widget.productModel.bathrooms?.toString()),
        _buildInfoRow('Furnished', widget.productModel.furnishing.toString()),
        _buildInfoRow('Area', '${widget.productModel.area} sq. ft.'),
        _buildInfoRow('Condition', widget.productModel.condition),
        _buildInfoRow('OwnerType', widget.productModel.ownerType.toString()),
        _buildInfoRow(
            'FloorNumber', widget.productModel.floorNumber.toString()),
        _buildInfoRow(
            'TotalFloors', widget.productModel.totalFloors.toString()),
      ],
    );
  }

  Widget _buildElectronicsDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('id', widget.productModel.id.toString()),
        _buildInfoRow('City', widget.productModel.city),
        _buildInfoRow('Category', widget.productModel.category),
        _buildInfoRow('Brand', widget.productModel.brand),
        _buildInfoRow('Model', widget.productModel.model),
        _buildInfoRow('Condition', widget.productModel.condition),
        _buildInfoRow('Warranty', widget.productModel.warranty),
      ],
    );
  }

  Widget _buildMobilesDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('id', widget.productModel.id.toString()),
        _buildInfoRow('City', widget.productModel.city),
        _buildInfoRow('Category', widget.productModel.category),
        _buildInfoRow('Title', widget.productModel.title),
        _buildInfoRow('Price', widget.productModel.price.toString()),
        _buildInfoRow('Storage', widget.productModel.storage),
        _buildInfoRow('Operating System', widget.productModel.operatingSystem),
        _buildInfoRow('Screen Size', widget.productModel.screenSize),
        _buildInfoRow('Color', widget.productModel.color),
        _buildInfoRow('Camera', widget.productModel.camera),
        _buildInfoRow('Battery', widget.productModel.battery),
        _buildInfoRow('Brand', widget.productModel.brand),
        _buildInfoRow('Model', widget.productModel.model),
        _buildInfoRow('Condition', widget.productModel.condition),
        _buildInfoRow('Warranty', widget.productModel.warranty),
      ],
    );
  }

  Widget _buildJobDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('id', widget.productModel.id.toString()),
        _buildInfoRow('City', widget.productModel.city),
        _buildInfoRow('Category', widget.productModel.category),
        _buildInfoRow('Title', widget.productModel.title),
        _buildInfoRow('Job Type', widget.productModel.jobType),
        _buildInfoRow('Experience', widget.productModel.experienceLevel),
        _buildInfoRow('Qualification', widget.productModel.qualifications),
        _buildInfoRow('Salary', widget.productModel.salary),
        _buildInfoRow('Position', widget.productModel.position),
        _buildInfoRow('Company', widget.productModel.company),
      ],
    );
  }

  Widget _buildFashionDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('id', widget.productModel.id.toString()),
        _buildInfoRow('City', widget.productModel.city),
        _buildInfoRow('location', widget.productModel.location),
        _buildInfoRow('Product', widget.productModel.product),
        _buildInfoRow('Fachion Category', widget.productModel.fashion_category),
        _buildInfoRow('Size', widget.productModel.size),
        _buildInfoRow('Color', widget.productModel.color),
        _buildInfoRow('City', widget.productModel.city),
        _buildInfoRow('Category', widget.productModel.category),
        _buildInfoRow('Title', widget.productModel.title),
        _buildInfoRow('Price', widget.productModel.price.toString()),
        _buildInfoRow('Brand', widget.productModel.brand),
        _buildInfoRow('Model', widget.productModel.model),
        _buildInfoRow('Condition', widget.productModel.condition),
        _buildInfoRow('Warranty', widget.productModel.warranty),
      ],
    );
  }

  Widget _buildBooksSportsHobbiesDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('id', widget.productModel.id.toString()),
        _buildInfoRow('City', widget.productModel.city),
        _buildInfoRow('Category', widget.productModel.category),
        _buildInfoRow('Title', widget.productModel.title),
        _buildInfoRow('Price', widget.productModel.price.toString()),
        _buildInfoRow('hobby_category', widget.productModel.hobby_category),
        _buildInfoRow('Product', widget.productModel.product),
        _buildInfoRow('Condition', widget.productModel.condition),
      ],
    );
  }

  Widget _buildBikesDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('id', widget.productModel.id.toString()),
        _buildInfoRow('City', widget.productModel.city),
        _buildInfoRow('Category', widget.productModel.category),
        _buildInfoRow('Title', widget.productModel.title),
        _buildInfoRow('Price', widget.productModel.price.toString()),
        _buildInfoRow('Brand', widget.productModel.brand),
        _buildInfoRow('Model', widget.productModel.model),
        _buildInfoRow('Condition', widget.productModel.condition),
        _buildInfoRow('Warranty', widget.productModel.warranty),
        _buildInfoRow('Mileage', '${widget.productModel.mileage} km'),
        _buildInfoRow('Transmission', widget.productModel.transmission),
        _buildInfoRow('OwnerType', widget.productModel.ownerType.toString()),
        _buildInfoRow('Color', widget.productModel.color),
        _buildInfoRow('Year', widget.productModel.year.toString()),
      ],
    );
  }

  Widget _buildElectronicsAppliancesDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('id', widget.productModel.id.toString()),
        _buildInfoRow('City', widget.productModel.city),
        _buildInfoRow('Category', widget.productModel.category),
        _buildInfoRow('Title', widget.productModel.title),
        _buildInfoRow('Price', widget.productModel.price.toString()),
        _buildInfoRow('Brand', widget.productModel.brand),
        _buildInfoRow('Product', widget.productModel.product),
        _buildInfoRow('Condition', widget.productModel.condition),
        _buildInfoRow('Warranty', widget.productModel.warranty),
      ],
    );
  }

  Widget _buildFurnitureDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('id', widget.productModel.id.toString()),
        _buildInfoRow('City', widget.productModel.city),
        _buildInfoRow('Category', widget.productModel.category),
        _buildInfoRow('Title', widget.productModel.title),
        _buildInfoRow('Price', widget.productModel.price.toString()),
        _buildInfoRow('Product', widget.productModel.product),
        _buildInfoRow('Condition', widget.productModel.condition),
        _buildInfoRow('Material', widget.productModel.material),
        _buildInfoRow('Dimensions', widget.productModel.dimensions.toString()),
      ],
    );
  }

  Widget _buildPetsDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('id', widget.productModel.id.toString()),
        _buildInfoRow('City', widget.productModel.city),
        _buildInfoRow('Category', widget.productModel.category),
        _buildInfoRow('Title', widget.productModel.title),
        _buildInfoRow('Price', widget.productModel.price.toString()),
        _buildInfoRow('Breed', widget.productModel.breed),
        _buildInfoRow('Condition', widget.productModel.condition),
        _buildInfoRow('Vaccination Type', widget.productModel.vaccinationType),
        _buildInfoRow('Pet Category', widget.productModel.vaccinationType),
      ],
    );
  }

  Widget _buildCommercialVehiclesSparesDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('id', widget.productModel.id.toString()),
        _buildInfoRow('City', widget.productModel.city),
        _buildInfoRow('Category', widget.productModel.category),
        _buildInfoRow('Title', widget.productModel.title),
        _buildInfoRow('Price', widget.productModel.price.toString()),
        _buildInfoRow('Brand', widget.productModel.brand),
        _buildInfoRow('Product', widget.productModel.product),
        _buildInfoRow('Condition', widget.productModel.condition),
        _buildInfoRow('Warranty', widget.productModel.warranty),
        _buildInfoRow('Mileage', '${widget.productModel.mileage} km'),
        _buildInfoRow('Transmission', widget.productModel.transmission),
        _buildInfoRow('OwnerType', widget.productModel.ownerType.toString()),
        _buildInfoRow('Color', widget.productModel.color),
        _buildInfoRow('Year', widget.productModel.year.toString()),
        _buildInfoRow('Model', widget.productModel.model),
      ],
    );
  }

  Widget _buildDefaultDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('id', widget.productModel.id.toString()),
        _buildInfoRow('City', widget.productModel.city),
        _buildInfoRow('Category', widget.productModel.category),
        _buildInfoRow('Brand', widget.productModel.brand),
        _buildInfoRow('Condition', widget.productModel.condition),
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
        title: Column(
          children: [
            Text(widget.productModel.title ?? 'Product Details'),
          ],
        ),
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
                  child: widget.productModel.thumb != null
                      ? Image.network(
                          widget.productModel.thumb!,
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
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 180,
                            color: Colors.red,
                          ),
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   widget.productModel.id.toString(),
                  //   style: const TextStyle(
                  //     fontSize: 24,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),

                  Text(
                    '₹ ${widget.productModel.price?.toString() ?? 'N/A'}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 243, 6, 176),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('Location', widget.productModel.location),
                  const Divider(height: 32),
                  _buildProductSpecificDetails(),
                  if (widget.productModel.description != null)
                    Card(
                          color: const Color.fromARGB(255, 237, 187, 6),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: const Color.fromARGB(255, 248, 4, 4).withOpacity(0.2),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          widget.productModel.description!,
                          style: const TextStyle(
                            fontSize: 18,
                            height: 1.6,
                            color: Color.fromARGB(179, 14, 4, 4),
                            letterSpacing: 0.3,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),

                  // Padding(
                  //   padding: const EdgeInsets.only(top: 16),
                  //   child: Text(
                  //     widget.productModel.description!,
                  //     style: const TextStyle(fontSize: 14),
                  //   ),
                  // ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // In ProductDetails class
                        Expanded(
                          child: ElevatedButton(
                            // Update this line to pass the context
                            onPressed: _initiateChat,
                            // onPressed: () => _handleChatPress(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 243, 33, 156),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: const BorderSide(
                                    color: Color.fromARGB(255, 218, 72, 10)),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.chat,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Chat',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            // onPressed: () => _handleCallPress(),
                            // onPressed: () => _handleChatPress(context),
                            onPressed: _initiateChat,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.call,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Call',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
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

  // Widget _buildInfoRow(String label, String? value) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 4),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         SizedBox(
  //           width: 100,
  //           child: Text(
  //             label,
  //             style: TextStyle(
  //               color: Colors.grey[600],
  //               fontSize: 14,
  //             ),
  //           ),
  //         ),
  //         Expanded(
  //           child: Text(
  //             value ?? 'N/A',
  //             style: const TextStyle(
  //               fontSize: 14,
  //               fontWeight: FontWeight.w500,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
