// ignore_for_file: use_build_context_synchronously, deprecated_member_use, unnecessary_to_list_in_spreads, library_private_types_in_public_api

import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/controllers/cart_controller.dart';
import 'package:flutter_poc_v3/models/product_model.dart';
import 'package:flutter_poc_v3/protected_screen.dart/animated_back_button_appbar.dart';
import 'package:flutter_poc_v3/public_screen.dart/login_screen.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_poc_v3/protected_screen.dart/contact_seller_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/user_chat_screen.dart';
import 'package:get/get.dart'; // Make sure this import is correct
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ProductDetails extends StatefulWidget {
  final ProductModel productModel;

  const ProductDetails({super.key, required this.productModel});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final CartController cartController = Get.find<CartController>();
final ScrollController _scrollController = ScrollController();
  Future<void> _initiateChat() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

   // Check if token exists
//     if (token == null) {
//       // Navigator.pushAndRemoveUntil(
//       //       context,
//       //       MaterialPageRoute(builder: (context) => const LoginScreen()),
//       //       (route) => false,
//       //     );
//       Navigator.push(
//   context,
//   MaterialPageRoute(builder: (context) => LoginScreen()),
// );
//     }
    if (token == null) {
        // Check if context is still valid
        if (!context.mounted) return;

        Get.snackbar(
          'Login Required',
          'Please login to continue',
          snackStyle: SnackStyle.FLOATING,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor:
              const Color.fromARGB(255, 232, 235, 239).withOpacity(0.8),
          colorText: const Color.fromARGB(255, 12, 65, 0),
          margin: const EdgeInsets.all(10),
          duration: const Duration(seconds: 2),
        );

        // Use Get.to instead of Navigator
        Get.to(() => const LoginScreen());
        return;
      }
      
      final adPostId = widget.productModel.id?.replaceAll('"', '').trim() ?? '';

      // First check conversations to see if one exists
      final conversationsResponse = await http.get(
        Uri.parse('http://13.200.179.78/chat/conversations'),
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
            Uri.parse('http://13.200.179.78/chat/initiate'),
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
            Uri.parse('http://13.200.179.78/chat/messages'),
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
        throw Exception('Failed to check existing conversations navigate to login');
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

 String _formatMileage(dynamic mileage) {
  if (mileage != null) {
    if (mileage is int) {
      return '$mileage km';
    } else if (mileage is String) {
      final parsedMileage = int.tryParse(mileage);
      if (parsedMileage != null) {
        return '$parsedMileage km';
      }
    }
  }
  return 'N/A';
}


  Widget _buildProductSpecificDetails() {
    // Switch case to return different details based on category
    switch (widget.productModel.category?.toLowerCase()) {
      case 'cars':
        return _buildCarDetails();
      case 'properties':
        return _buildPropertiesDetails();
      case 'services':
        return _buildServicesForm();

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
            const Color.fromARGB(255, 193, 191, 193),
            const Color.fromARGB(255, 184, 181, 181),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 3, 1, 15)
                .withAlpha((0.9 * 255).round()),
            spreadRadius: 2,
            blurRadius: 4,
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
            _buildInfoRow('State', widget.productModel.state),
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
            // _buildInfoRow('Mileage', '${widget.productModel.mileage} km'),
           
// _buildInfoRow('Mileage', (widget.productModel.mileage.toString().isNotEmpty) ? _formatMileage(widget.productModel.mileage) : 'N/A'),
                  //  _buildInfoRow('Mileage', _formatMileage(widget.productModel.mileage)),
            _buildInfoRow('Transmission', widget.productModel.transmission),
               _buildInfoRow(
                'ownerType', widget.productModel.ownerType.toString()),
          ]),
          const SizedBox(height: 20),
          _buildSectionHeader('Additional Information'),
          _buildInfoCard([
            _buildInfoRow('Condition', widget.productModel.condition),
         
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
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(221, 4, 4, 248),
              overflow: TextOverflow.ellipsis,

            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(
          255,
          249,
          248,
          247,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 251, 252, 251)
                .withAlpha((0.9 * 255).round()),
            spreadRadius: 1,
            blurRadius: 2,
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
                    color: const Color.fromARGB(255, 5, 1, 17)
                        .withAlpha((0.9 * 255).round()),
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
        color: const Color.fromARGB(255, 233, 232, 216),
        border: Border(
          left: BorderSide(
            color: const Color.fromARGB(255, 2, 10, 0),
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
                color: const Color.fromARGB(179, 13, 2, 2),
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
                color: Color.fromARGB(179, 1, 1, 9),
                fontWeight: FontWeight.bold,
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

  // Widget _buildPropertiesDetails() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       _buildInfoRow('id', widget.productModel.id.toString()),
  //       _buildInfoRow('City', widget.productModel.city),
  //       _buildInfoRow('Category', widget.productModel.category),
  //       _buildInfoRow('Condition', widget.productModel.condition),
  //       _buildInfoRow('Price', widget.productModel.price.toString()),
  //       _buildInfoRow('Condition', widget.productModel.condition),
  //       _buildInfoRow('Title', widget.productModel.title.toString()),
  //       _buildInfoRow('Property Type', widget.productModel.propertyType),
  //       _buildInfoRow('Bedrooms', widget.productModel.bedrooms?.toString()),
  //       _buildInfoRow('Bathrooms', widget.productModel.bathrooms?.toString()),
  //       _buildInfoRow('Furnished', widget.productModel.furnishing.toString()),
  //       _buildInfoRow('Area', '${widget.productModel.area} sq. ft.'),
  //       _buildInfoRow('Condition', widget.productModel.condition),
  //       _buildInfoRow('OwnerType', widget.productModel.ownerType.toString()),
  //       _buildInfoRow(
  //           'FloorNumber', widget.productModel.floorNumber.toString()),
  //       _buildInfoRow(
  //           'TotalFloors', widget.productModel.totalFloors.toString()),
  //     ],
  //   );
  // }

  Widget _buildPropertiesDetails() {
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
            color: const Color.fromARGB(255, 147, 133, 230)
                .withAlpha((0.9 * 255).round()),
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Property Information'),
          _buildInfoCard([
            _buildInfoRow('ID', widget.productModel.id.toString()),
            _buildInfoRow('State', widget.productModel.state),
            _buildInfoRow('City', widget.productModel.city),
            _buildInfoRow('Category', widget.productModel.category),
          ]),
          const SizedBox(height: 20),
          _buildSectionHeader('Technical Details'),
          _buildInfoCard([
            _buildInfoRow('Property type', widget.productModel.type),
            _buildInfoRow('Berdrooms', widget.productModel.bedrooms),
            _buildInfoRow('BathRooms', widget.productModel.bathrooms),
            _buildInfoRow('Furnished', widget.productModel.furnishing),
            _buildInfoRow('Area', widget.productModel.area),
            _buildInfoRow('Total Floors', widget.productModel.totalFloors),
          ]),
          const SizedBox(height: 20),
          _buildSectionHeader('Additional Information'),
          _buildInfoCard([
            _buildInfoRow('Floor Number', widget.productModel.floorNumber),
            _buildInfoRow(
                'OwnerType', widget.productModel.ownerType),
          ]),
        ],
      ),
    );
  }

  // Widget _buildElectronicsDetails() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       _buildInfoRow('id', widget.productModel.id.toString()),
  //       _buildInfoRow('City', widget.productModel.city),
  //       _buildInfoRow('Category', widget.productModel.category),
  //       _buildInfoRow('Brand', widget.productModel.brand),
  //       _buildInfoRow('Model', widget.productModel.model),
  //       _buildInfoRow('Condition', widget.productModel.condition),
  //       _buildInfoRow('Warranty', widget.productModel.warranty),
  //     ],
  //   );
  // }

  Widget _buildElectronicsAppliancesDetails() {
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
            color: const Color.fromARGB(255, 147, 133, 230)
                .withAlpha((0.9 * 255).round()),
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Electronics Information'),
          _buildInfoCard([
            _buildInfoRow('ID', widget.productModel.id.toString()),
            _buildInfoRow('State', widget.productModel.state),
            _buildInfoRow('City', widget.productModel.city),
            _buildInfoRow('Category', widget.productModel.category),
            _buildInfoRow('Electronics category',
                widget.productModel.electronics_category),
          ]),
          const SizedBox(height: 20),
          _buildSectionHeader('Technical Details'),
          _buildInfoCard([
            _buildInfoRow('Brand', widget.productModel.brand),
            _buildInfoRow('Condition', widget.productModel.condition),
            _buildInfoRow('Product', widget.productModel.product ?? 'N/A'),
          ]),
          const SizedBox(height: 20),
          _buildSectionHeader('Additional Information'),
          _buildInfoCard([
            _buildInfoRow('Warranty', widget.productModel.warranty),
          ]),
        ],
      ),
    );
  }

  // Widget _buildMobilesDetails() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       _buildInfoRow('id', widget.productModel.id.toString()),
  //       _buildInfoRow('City', widget.productModel.city),
  //       _buildInfoRow('Category', widget.productModel.category),
  //       _buildInfoRow('Title', widget.productModel.title),
  //       _buildInfoRow('Price', widget.productModel.price.toString()),
  //       _buildInfoRow('Storage', widget.productModel.storage),
  //       _buildInfoRow('Operating System', widget.productModel.operatingSystem),
  //       _buildInfoRow('Screen Size', widget.productModel.screenSize),
  //       _buildInfoRow('Color', widget.productModel.color),
  //       _buildInfoRow('Camera', widget.productModel.camera),
  //       _buildInfoRow('Battery', widget.productModel.battery),
  //       _buildInfoRow('Brand', widget.productModel.brand),
  //       _buildInfoRow('Model', widget.productModel.model),
  //       _buildInfoRow('Condition', widget.productModel.condition),
  //       _buildInfoRow('Warranty', widget.productModel.warranty),
  //     ],
  //   );
  // }

  Widget _buildMobilesDetails() {
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
            color: const Color.fromARGB(255, 147, 133, 230)
                .withAlpha((0.9 * 255).round()),
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Mobiles Information'),
          _buildInfoCard([
            _buildInfoRow('ID', widget.productModel.id.toString()),
            _buildInfoRow('State', widget.productModel.state),
            _buildInfoRow('City', widget.productModel.city),
            _buildInfoRow('Category', widget.productModel.category),
           
          ]),
          const SizedBox(height: 20),
          _buildSectionHeader('Technical Details'),
          _buildInfoCard([
            _buildInfoRow('Brand', widget.productModel.brand),
            _buildInfoRow('Model', widget.productModel.model),
            _buildInfoRow('Condition', widget.productModel.condition),
            _buildInfoRow('Storage', widget.productModel.storage?.toString() ?? 'N/A'),
            _buildInfoRow('Operating System',
                widget.productModel.operatingSystem?.toString() ?? 'N/A'),
            _buildInfoRow(
                'Screen Size', widget.productModel.screenSize?.toString() ?? 'N/A'),
            _buildInfoRow('Camera', widget.productModel.camera?.toString() ?? 'N/A'),
            _buildInfoRow('Battery', widget.productModel.battery?.toString() ?? 'N/A'),
            _buildInfoRow('Color', widget.productModel.color?.toString() ?? 'N/A'),
          ]),
          const SizedBox(height: 20),
          _buildSectionHeader('Additional Information'),
          _buildInfoCard([
            _buildInfoRow('Warranty', widget.productModel.warranty?.toString() ?? 'N/A'),
          ]),
        ],
      ),
    );
  }

  // Widget _buildJobDetails() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       _buildInfoRow('id', widget.productModel.id.toString()),
  //       _buildInfoRow('City', widget.productModel.city),
  //       _buildInfoRow('Category', widget.productModel.category),
  //       _buildInfoRow('Title', widget.productModel.title),
  //       _buildInfoRow('Job Type', widget.productModel.jobType),
  //       _buildInfoRow('Experience', widget.productModel.experienceLevel),
  //       _buildInfoRow('Qualification', widget.productModel.qualifications),
  //       _buildInfoRow('Salary', widget.productModel.salary),
  //       _buildInfoRow('Position', widget.productModel.position),
  //       _buildInfoRow('Company', widget.productModel.company),
  //     ],
  //   );
  // }

  Widget _buildJobDetails() {
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
            color: const Color.fromARGB(255, 147, 133, 230)
                .withAlpha((0.9 * 255).round()),
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Jobs Information'),
          _buildInfoCard([
            _buildInfoRow('ID', widget.productModel.id.toString()),
            _buildInfoRow('State', widget.productModel.state),
            _buildInfoRow('City', widget.productModel.city),
            _buildInfoRow('Category', widget.productModel.category),
          ]),
          const SizedBox(height: 20),
          _buildSectionHeader('Technical Details'),
          _buildInfoCard([
            _buildInfoRow('Company', widget.productModel.company),
            _buildInfoRow('Industry', widget.productModel.industry),
            _buildInfoRow('Position', widget.productModel.position),
            _buildInfoRow('Salary', widget.productModel.salary?.toString() ?? 'N/A'),
         
            _buildInfoRow('Job Type', widget.productModel.jobType ?? 'N/A'),
            _buildInfoRow('Experiance Level',
                widget.productModel.experienceLevel ?? 'N/A'),
            _buildInfoRow(
                'Qualifications', widget.productModel.qualifications ?? 'N/A'),
          ]),
          const SizedBox(height: 20),
          _buildSectionHeader('Additional Information'),
          _buildInfoCard([
            _buildInfoRow(
                'Contact Info', widget.productModel.contact_info ?? 'N/A'),
          ]),
        ],
      ),
    );
  }

  // Widget _buildFashionDetails() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       _buildInfoRow('id', widget.productModel.id.toString()),
  //       _buildInfoRow('City', widget.productModel.city),
  //       _buildInfoRow('location', widget.productModel.location),
  //       _buildInfoRow('Product', widget.productModel.product),
  //       _buildInfoRow('Fachion Category', widget.productModel.fashion_category),
  //       _buildInfoRow('Size', widget.productModel.size),
  //       _buildInfoRow('Color', widget.productModel.color),
  //       _buildInfoRow('City', widget.productModel.city),
  //       _buildInfoRow('Category', widget.productModel.category),
  //       _buildInfoRow('Title', widget.productModel.title),
  //       _buildInfoRow('Price', widget.productModel.price.toString()),
  //       _buildInfoRow('Brand', widget.productModel.brand),
  //       _buildInfoRow('Model', widget.productModel.model),
  //       _buildInfoRow('Condition', widget.productModel.condition),
  //       _buildInfoRow('Warranty', widget.productModel.warranty),
  //     ],
  //   );
  // }

  Widget _buildFashionDetails() {
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
            color: const Color.fromARGB(255, 147, 133, 230)
                .withAlpha((0.9 * 255).round()),
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Fashion Information'),
          _buildInfoCard([
            _buildInfoRow('ID', widget.productModel.id.toString()),
            _buildInfoRow('State', widget.productModel.state),
            _buildInfoRow('City', widget.productModel.city),
            _buildInfoRow('Category', widget.productModel.category),
            _buildInfoRow('Condition', widget.productModel.condition),
          ]),
          const SizedBox(height: 20),
          _buildSectionHeader('Technical Details'),
          _buildInfoCard([
            _buildInfoRow('Product', widget.productModel.product),
            _buildInfoRow(
                'Fashion Category', widget.productModel.fashion_category),
            _buildInfoRow('Size', widget.productModel.size),
        
          ]),
          const SizedBox(height: 20),
          _buildSectionHeader('Additional Information'),
          _buildInfoCard([
              _buildInfoRow('Brand', widget.productModel.brand ?? 'N/A'),
          ]),
        ],
      ),
    );
  }

  // Widget _buildBooksSportsHobbiesDetails() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       _buildInfoRow('id', widget.productModel.id.toString()),
  //       _buildInfoRow('City', widget.productModel.city),
  //       _buildInfoRow('Category', widget.productModel.category),
  //       _buildInfoRow('Title', widget.productModel.title),
  //       _buildInfoRow('Price', widget.productModel.price.toString()),
  //       _buildInfoRow('hobby_category', widget.productModel.hobby_category),
  //       _buildInfoRow('Product', widget.productModel.product),
  //       _buildInfoRow('Condition', widget.productModel.condition),
  //     ],
  //   );
  // }

  Widget _buildBooksSportsHobbiesDetails() {
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
            color: const Color.fromARGB(255, 147, 133, 230)
                .withAlpha((0.9 * 255).round()),
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Books,Sports&Hobbies Information'
          ),
          _buildInfoCard([
            _buildInfoRow('ID', widget.productModel.id.toString()),
            _buildInfoRow('State', widget.productModel.state),
            _buildInfoRow('City', widget.productModel.city),
            _buildInfoRow('Category', widget.productModel.category),
            _buildInfoRow('Hobby category', widget.productModel.hobby_category),
          ]),
          const SizedBox(height: 20),
          _buildSectionHeader('Technical Details'),
          _buildInfoCard([
            _buildInfoRow('Product', widget.productModel.product ?? 'N/A'),
        
          ]),
          const SizedBox(height: 20),
          _buildSectionHeader('Additional Information'),
          _buildInfoCard([
            _buildInfoRow('Condition', widget.productModel.condition),
          ]),
        ],
      ),
    );
  }

  // Widget _buildBikesDetails() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       _buildInfoRow('id', widget.productModel.id.toString()),
  //       _buildInfoRow('City', widget.productModel.city),
  //       _buildInfoRow('Category', widget.productModel.category),
  //       _buildInfoRow('Title', widget.productModel.title),
  //       _buildInfoRow('Price', widget.productModel.price.toString()),
  //       _buildInfoRow('Brand', widget.productModel.brand),
  //       _buildInfoRow('Model', widget.productModel.model),
  //       _buildInfoRow('Condition', widget.productModel.condition),
  //       _buildInfoRow('Warranty', widget.productModel.warranty),
  //       _buildInfoRow('Mileage', '${widget.productModel.mileage} km'),
  //       _buildInfoRow('Transmission', widget.productModel.transmission),
  //       _buildInfoRow('OwnerType', widget.productModel.ownerType.toString()),
  //       _buildInfoRow('Color', widget.productModel.color),
  //       _buildInfoRow('Year', widget.productModel.year.toString()),
  //     ],
  //   );
  // }

  Widget _buildBikesDetails() {
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
            color: const Color.fromARGB(255, 147, 133, 230)
                .withAlpha((0.9 * 255).round()),
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Bikes Information'),
          _buildInfoCard([
            _buildInfoRow('ID', widget.productModel.id.toString()),
            _buildInfoRow('State', widget.productModel.state),
            _buildInfoRow('City', widget.productModel.city),
            _buildInfoRow('Category', widget.productModel.category),
            _buildInfoRow('Brand', widget.productModel.brand),
          ]),
          const SizedBox(height: 20),
          _buildSectionHeader('Technical Details'),
          _buildInfoCard([
            _buildInfoRow('Model', widget.productModel.model),
            _buildInfoRow('Year', widget.productModel.year.toString()),
            // _buildInfoRow('Mileage', widget.productModel.mileage.toString()),
  //             _buildInfoRow('Mileage', 
  //             widget.productModel.mileage != null 
  //     ? '${widget.productModel.mileage.toString()} km'
  //     : 'N/A'
  // ),

// _buildInfoRow('Mileage', _formatMileage(widget.productModel.mileage)),
            _buildInfoRow('Condition', widget.productModel.condition ?? 'N/A'),
          
          ]),
          const SizedBox(height: 20),
          _buildSectionHeader('Additional Information'),
          _buildInfoCard([
             _buildInfoRow(
                'ownerType', widget.productModel.ownerType.toString()),
          ]),
        ],
      ),
    );
  }

  // Widget _buildFurnitureDetails() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       _buildInfoRow('id', widget.productModel.id.toString()),
  //       _buildInfoRow('City', widget.productModel.city),
  //       _buildInfoRow('Category', widget.productModel.category),
  //       _buildInfoRow('Title', widget.productModel.title),
  //       _buildInfoRow('Price', widget.productModel.price.toString()),
  //       _buildInfoRow('Product', widget.productModel.product),
  //       _buildInfoRow('Condition', widget.productModel.condition),
  //       _buildInfoRow('Material', widget.productModel.material),
  //       _buildInfoRow('Dimensions', widget.productModel.dimensions.toString()),
  //     ],
  //   );
  // }

  Widget _buildFurnitureDetails() {
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
            color: const Color.fromARGB(255, 147, 133, 230)
                .withAlpha((0.9 * 255).round()),
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Furniture Information'),
          _buildInfoCard([
            _buildInfoRow('ID', widget.productModel.id.toString()),
            _buildInfoRow('State', widget.productModel.state),
            _buildInfoRow('City', widget.productModel.city),
            _buildInfoRow('Category', widget.productModel.category),
            _buildInfoRow('Product', widget.productModel.product),
            _buildInfoRow('Year', widget.productModel.year.toString()),
          ]),
          const SizedBox(height: 20),
          _buildSectionHeader('Technical Details'),
          _buildInfoCard([
            _buildInfoRow('Material', widget.productModel.material),
            _buildInfoRow('Condition', widget.productModel.condition),
         

         
          ]),
          const SizedBox(height: 20),
          _buildSectionHeader('Additional Information'),
          _buildInfoCard([
               _buildInfoRow(
                'Dimensions', widget.productModel.dimensions.toString()),
            

              
          ]),
        ],
      ),
    );
  }

  // Widget _buildPetsDetails() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       _buildInfoRow('id', widget.productModel.id.toString()),
  //       _buildInfoRow('City', widget.productModel.city),
  //       _buildInfoRow('Category', widget.productModel.category),
  //       _buildInfoRow('Title', widget.productModel.title),
  //       _buildInfoRow('Price', widget.productModel.price.toString()),
  //       _buildInfoRow('Breed', widget.productModel.breed),
  //       _buildInfoRow('Condition', widget.productModel.condition),
  //       _buildInfoRow('Vaccination Type', widget.productModel.vaccinationType),
  //       _buildInfoRow('Pet Category', widget.productModel.vaccinationType),
  //     ],
  //   );
  // }

  Widget _buildPetsDetails() {
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
            color: const Color.fromARGB(255, 147, 133, 230)
                .withAlpha((0.9 * 255).round()),
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Pets Information'),
          _buildInfoCard([
            _buildInfoRow('ID', widget.productModel.id.toString()),
            _buildInfoRow('State', widget.productModel.state),
            _buildInfoRow('City', widget.productModel.city),
            _buildInfoRow('Category', widget.productModel.category),
            _buildInfoRow('Pet category', widget.productModel.pet_category),
          ]),
          const SizedBox(height: 20),
          _buildSectionHeader('Technical Details'),
          _buildInfoCard([
           
            _buildInfoRow('Condition', widget.productModel.condition),
            _buildInfoRow(
                'VaccinationType', widget.productModel.vaccinationType),
          ]),
          const SizedBox(height: 20),
          _buildSectionHeader('Additional Information'),
          _buildInfoCard([
            _buildInfoRow('Breed', widget.productModel.breed),
          ]),
        ],
      ),
    );
  }

  // Widget _buildCommercialVehiclesSparesDetails() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       _buildInfoRow('id', widget.productModel.id.toString()),
  //       _buildInfoRow('City', widget.productModel.city),
  //       _buildInfoRow('Category', widget.productModel.category),
  //       _buildInfoRow('Title', widget.productModel.title),
  //       _buildInfoRow('Price', widget.productModel.price.toString()),
  //       _buildInfoRow('Brand', widget.productModel.brand),
  //       _buildInfoRow('Product', widget.productModel.product),
  //       _buildInfoRow('Condition', widget.productModel.condition),
  //       _buildInfoRow('Warranty', widget.productModel.warranty),
  //       _buildInfoRow('Mileage', '${widget.productModel.mileage} km'),
  //       _buildInfoRow('Transmission', widget.productModel.transmission),
  //       _buildInfoRow('OwnerType', widget.productModel.ownerType.toString()),
  //       _buildInfoRow('Color', widget.productModel.color),
  //       _buildInfoRow('Year', widget.productModel.year.toString()),
  //       _buildInfoRow('Model', widget.productModel.model),
  //     ],
  //   );
  // }

  Widget _buildCommercialVehiclesSparesDetails() {
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
            color: const Color.fromARGB(255, 147, 133, 230)
                .withAlpha((0.9 * 255).round()),
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Commercial Vehicles and Spares Information'),
          _buildInfoCard([
            _buildInfoRow('ID', widget.productModel.id.toString()),
            _buildInfoRow('State', widget.productModel.state),
            _buildInfoRow('City', widget.productModel.city),
            _buildInfoRow('Category', widget.productModel.category),
        

          ]),
          const SizedBox(height: 20),
          _buildSectionHeader('Technical Details'),
          _buildInfoCard([
            _buildInfoRow('Model', widget.productModel.model),
            _buildInfoRow('Brand', widget.productModel.brand),
            _buildInfoRow('Warranty', widget.productModel.warranty),
            _buildInfoRow(
                'Transmission Type', widget.productModel.transmission ?? 'N/A'),
            _buildInfoRow('Color', widget.productModel.color ?? 'N/A'),
            _buildInfoRow('Year', widget.productModel.year.toString()),
          ]),
          const SizedBox(height: 20),
          _buildSectionHeader('Additional Information'),
          _buildInfoCard([
            _buildInfoRow(
                'Condition', widget.productModel.condition ?? 'N/A'),
          ]),
        ],
      ),
    );
  }

  Widget _buildServicesForm() {
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
            color: const Color.fromARGB(255, 147, 133, 230)
                .withAlpha((0.9 * 255).round()),
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Services Information'),
          _buildInfoCard([
            _buildInfoRow('ID', widget.productModel.id.toString()),
            _buildInfoRow('State', widget.productModel.state),
            _buildInfoRow('City', widget.productModel.city),
            _buildInfoRow('Category', widget.productModel.category),
          ]),
          const SizedBox(height: 20),
          _buildSectionHeader('Technical Details'),
          _buildInfoCard([
            _buildInfoRow('Type', widget.productModel.type),
          ]),
          const SizedBox(height: 20),
          _buildSectionHeader('Additional Information'),
          _buildInfoCard([
            _buildInfoRow(
                'Condition', widget.productModel.condition ?? 'N/A'),
          ]),
        ],
      ),
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
       appBar: AnimatedBackButtonAppBar(
    title:widget.productModel.title,
    onBackButtonPressed: () {
      Navigator.of(context).pop();
    },
  ),
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back),
      //     onPressed: () {
      //       Navigator.of(context).pop();
      //     },
      //   ),
      //   title: Column(
      //     children: [
      //       Text(widget.productModel.title ?? 'Product Details'),
      //     ],
      //   ),
      // ),
      body: Container(
 decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFE8CBC0), // Soft pink
          Color(0xFF636FA4), // Muted blue
        ],
      ),
    ),


        child: SingleChildScrollView(
          
          child: Column(
            
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             
              // Container(
              //   margin: const EdgeInsets.all(30.0),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(10),
              //     boxShadow: [
              //       BoxShadow(
              //         color:
              //             const Color.fromARGB(255, 188, 177, 177).withValues(),
              //         spreadRadius: 0,
              //         blurRadius: 0,
              //         offset: const Offset(0, 3),
              //       ),
              //     ],
              //   ),
              //   child: ClipRRect(
              //     borderRadius: BorderRadius.circular(12),
              //     child: SizedBox(
              //       height: 270,
              //       width: double.infinity,
                   
              //       child: widget.productModel.assets != null &&
              //               widget.productModel.assets!
              //                   .where((asset) =>
              //                       asset['type'].toString().startsWith('image/'))
              //                   .isNotEmpty
              //           ? ListView.builder(
              //               scrollDirection: Axis.horizontal,
              //               itemCount: widget.productModel.assets!
              //                   .where((asset) =>
              //                       asset['type'].toString().startsWith('image/'))
              //                   .length,
              //               itemBuilder: (context, index) {
              //                 final imageAssets = widget.productModel.assets!
              //                     .where((asset) => asset['type']
              //                         .toString()
              //                         .startsWith('image/'))
              //                     .toList();
              //                 final asset = imageAssets[index];
              //                 return SizedBox(
              //                   width: MediaQuery.of(context).size.width - 60,
              //                   child: Image.network(
              //                     'http://13.200.179.78/${asset['url']}',
              //                     fit: BoxFit.fill,
              //                     loadingBuilder:
              //                         (context, child, loadingProgress) {
              //                       if (loadingProgress == null) return child;
              //                       return Center(
              //                         child: CircularProgressIndicator(
              //                           value:
              //                               loadingProgress.expectedTotalBytes !=
              //                                       null
              //                                   ? loadingProgress
              //                                           .cumulativeBytesLoaded /
              //                                       loadingProgress
              //                                           .expectedTotalBytes!
              //                                   : null,
              //                         ),
              //                       );
              //                     },
              //                   ),
              //                 );
              //               },
              //             )
                     
              //           : Container(
              //               color: Colors.grey[200],
              //               child: Column(
              //                   mainAxisAlignment:
              //                                             MainAxisAlignment
              //                                                 .center,
              //                 children: [
              //                   Icon(
              //                     Icons.image_not_supported_outlined,
              //                     size: 50,
              //                     color: Color.fromARGB(255, 123, 74, 74),
              //                   ),
              //                   SizedBox(height: 8),
              //                   Text(
              //                     'Image not available',
              //                     style: TextStyle(
              //                       color: Color.fromARGB(255, 123, 74, 74),
              //                       fontSize: 12,
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //     ),
              //   ),
              // ),
        
        
              Container(
             
          margin: const EdgeInsets.all(30.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
        
            boxShadow: [
        BoxShadow(
          color: const Color.fromARGB(255, 222, 122, 122),
          spreadRadius: 0,
          blurRadius: 0,
          offset: const Offset(0, 3),
        ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(70),
            
            child: SizedBox(
        height: 270,
        width: double.infinity,
        child: widget.productModel.assets != null &&
                widget.productModel.assets!
                    .where((asset) =>
                        asset['type'].toString().startsWith('image/'))
                    .isNotEmpty
            ? Stack(
                children: [
                  ListView.builder(
                    controller: _scrollController, // Add ScrollController
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.productModel.assets!
                        .where((asset) =>
                            asset['type'].toString().startsWith('image/'))
                        .length,
                    itemBuilder: (context, index) {
                      final imageAssets = widget.productModel.assets!
                          .where((asset) =>
                              asset['type'].toString().startsWith('image/'))
                          .toList();
                      final asset = imageAssets[index];
                      return SizedBox(
                        width: MediaQuery.of(context).size.width - 60,
                        child: Image.network(
                          'http://13.200.179.78/${asset['url']}',
                          fit: BoxFit.fill,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  // Only show navigation buttons if there are multiple images
                  if (widget.productModel.assets!
                          .where((asset) =>
                              asset['type'].toString().startsWith('image/'))
                          .length >
                      1) ...[
                    // Left Arrow
                    Positioned(
                      left: 10,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              _scrollController.animateTo(
                                _scrollController.offset -
                                    (MediaQuery.of(context).size.width - 60),
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    // Right Arrow
                    Positioned(
                      right: 10,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              _scrollController.animateTo(
                                _scrollController.offset +
                                    (MediaQuery.of(context).size.width - 60),
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              )
            : Container(
                color: Colors.grey[200],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_not_supported_outlined,
                      size: 50,
                      color: Color.fromARGB(255, 123, 74, 74),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Image not available',
                      style: TextStyle(
                        color: Color.fromARGB(255, 123, 74, 74),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
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
        
                    // Text(
                    //   '₹ ${widget.productModel.price?.toString() ?? 'N/A'}',
                    //   style: const TextStyle(
                    //     fontSize: 24,
                    //     fontWeight: FontWeight.bold,
                    //     color: Color.fromARGB(255, 243, 6, 176),
                    //   ),
                    // ),

                                                     Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 8),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          // Color(0xFF046368),
                                           Color.fromARGB(255, 97, 76, 181),
                                               Color.fromARGB(255, 97, 76, 181),
                                        ], // Stylish gradient
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          12), // Smooth rounded edges
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(
                                              0.15), // Soft shadow effect
                                          blurRadius: 6,
                                          offset: Offset(2, 4),
                                        ),
                                      ],
                                    ),
                                    child:
                                    //  Text(
                                    //   "₹ ${productModel.price.toString()}",
                                    //   style: const TextStyle(
                                    //     color: Colors
                                    //         .white, // White text for contrast
                                    //     fontSize: 15,
                                    //     fontWeight: FontWeight.bold,
                                    //     fontFamily: 'Poppins',
                                    //     fontStyle: FontStyle.normal,
                                    //     letterSpacing:
                                    //         0.8, // Slight spacing for elegance
                                    //   ),
                                    //   overflow: TextOverflow.ellipsis,
                                    // ),

                                     Text(
  widget.productModel.price != null
      ? '₹${NumberFormat('#,##0', 'en_IN').format(widget.productModel.price)}' 
      : 'N/A',
  style: const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w900,
    color: Colors.white,
    letterSpacing: 1.2,
    fontFamily: 'Poppins',
                                         fontStyle: FontStyle.normal,
  ),
  overflow: TextOverflow.ellipsis,
)
                                  ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Location', widget.productModel.location),
                    const Divider(height: 32),
                    _buildProductSpecificDetails(),
                    const Divider(height: 22),
        
                    if (widget.productModel.assets != null) ...[
                      ...widget.productModel.assets!
                          .where((asset) =>
                              asset['type'].toString().startsWith('video/'))
                          .map((videoAsset) {
                        final videoUrl = Uri.encodeFull(
                            'http://13.200.179.78/${videoAsset['url']}');
                        developer.log('Processing video URL: $videoUrl');
                        return VideoPlayerWidget(
                          videoUrl: videoUrl,
                        );
                      }).toList(),
                      const SizedBox(height: 16),
                    ],
        
                    const Divider(height: 32),
                    Column(
                      
                      children: [
                        ...widget.productModel
                            .getAllImageIds()
                            .asMap()
                            .entries
                            .map(
                              (entry) => Container(
                                margin: const EdgeInsets.only(right: 8, bottom: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Text(
                                  'Image${entry.key + 1}: ${entry.value}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                        ...widget.productModel
                            .getAllVideoIds()
                            .asMap()
                            .entries
                            .map(
                              (entry) => Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Text(
                                  'Video${entry.key + 1}: ${entry.value}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                      ],
                    ),
        
                    Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(221, 49, 6, 242),
                      ),
                    ),
        
                    if (widget.productModel.description != null)
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color.fromARGB(255, 193, 177, 177),
                              const Color.fromARGB(255, 206, 190, 190),
                            ],
                          ),
                        ),
                        child: Card(
                          // color: const Color.fromARGB(255, 155, 152, 156),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: const Color.fromARGB(255, 19, 6, 6)
                                  .withAlpha((0.9 * 255).round()),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              widget.productModel.description!,
                              style: const TextStyle(
                                fontSize: 18,
                                height: 1.6,
                                color: Color.fromARGB(221, 14, 1, 1),
                                letterSpacing: 0.3,
                                fontWeight: FontWeight.w400,
                              ),
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

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
  });

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  String? _errorMessage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _downloadAndPlayVideo() async {
    try {
      // Show loading state
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Download video
      final response = await http.get(Uri.parse(widget.videoUrl));

      if (response.statusCode != 200) {
        throw Exception('Failed to download video: ${response.statusCode}');
      }

      // Get temporary directory
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/temp_video.mp4';

      // Save video file
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      // Initialize video player with local file
      _videoPlayerController = VideoPlayerController.file(
        file,
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
          allowBackgroundPlayback: false,
        ),
      );

      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        autoPlay: false,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        placeholder: Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      );

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      developer.log('Error in video initialization: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Error loading video. Please try again.';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _initializePlayer() async {
    try {
      await _downloadAndPlayVideo();
    } catch (e) {
      developer.log('Error in _initializePlayer: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to initialize video player';
          _isLoading = false;
        });
      }
    }
  }

  void _retryInitialization() {
    setState(() {
      _isInitialized = false;
      _errorMessage = null;
      _isLoading = true;
    });
    _initializePlayer();
  }

  @override
  void dispose() {
    // Remove the disposal of _scrollController as it is not defined in this class
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color.fromARGB(255, 193, 177, 177),
            const Color.fromARGB(255, 206, 190, 190),
          ],
        ),
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: const Color.fromARGB(255, 19, 6, 6)
                .withAlpha((0.9 * 255).round()),
          ),
        ),
        child: Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _buildVideoWidget(),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoWidget() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(
              onPressed: _retryInitialization,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_isInitialized && _chewieController != null) {
      return Chewie(controller: _chewieController!);
    }

    return const Center(
      child: CircularProgressIndicator(color: Colors.white),
    );
  }
}
