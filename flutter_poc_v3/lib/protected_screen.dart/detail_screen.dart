import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  final Map<String, dynamic> item;

  const DetailScreen({super.key, required this.item});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final Map<String, TextEditingController> controllers = {};
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    initializeControllers();
  }

  @override
  void dispose() {
    controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void initializeControllers() {
    // Common fields for all categories
    controllers['title'] = TextEditingController();
    controllers['description'] = TextEditingController();
    controllers['price'] = TextEditingController();
    controllers['city'] = TextEditingController();
    controllers['category'] = TextEditingController();

    // Category specific controllers
    switch (widget.item["caption"]) {
      case "Cars":
        controllers['make'] = TextEditingController();
        controllers['model'] = TextEditingController();
        controllers['mfgYear'] = TextEditingController();
        controllers['odoReading'] = TextEditingController();
        controllers['inWarranty'] = TextEditingController();
        controllers['transmissionType'] = TextEditingController();
        controllers['fuelType'] = TextEditingController();
        break;
      case "Property":
        controllers['propertyType'] = TextEditingController();
        controllers['bedrooms'] = TextEditingController();
        controllers['bathrooms'] = TextEditingController();
        controllers['area'] = TextEditingController();
        break;
      case "Jobs":
        controllers['jobType'] = TextEditingController();
        controllers['company'] = TextEditingController();
        controllers['location'] = TextEditingController();
        // controllers['salary'] = TextEditingController();
        controllers['industry'] = TextEditingController();
        controllers['position'] = TextEditingController();
        controllers['experienceLevel'] = TextEditingController();
        controllers['qualifications'] = TextEditingController();
        controllers['contact_info'] = TextEditingController();
      case "Electronics":
        controllers['brand'] = TextEditingController();

        controllers['model'] = TextEditingController();
        controllers['condition'] = TextEditingController();
      case "Mobiles":
        controllers['brand'] = TextEditingController();
        controllers['model'] = TextEditingController();
        controllers['condition'] = TextEditingController();

        controllers['storage'] = TextEditingController();
      case "Bikes":
        controllers['make'] = TextEditingController();
        controllers['model'] = TextEditingController();
        controllers['year'] = TextEditingController();
        break;
      // Add other categories as needed
    }
  }

  Future<void> _postItem() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      Map<String, dynamic> formData = {
        'category': widget.item["caption"],
        ...collectFormData(),
      };

      final response = await http.post(
        Uri.parse('http://192.168.0.179:8080/adposts'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(formData),
      );
      log('Status Code: ${response.statusCode}');
      log('Response Headers: ${response.headers}');
      log('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Item posted successfully!')),
        );
        if (!mounted) return;
        Navigator.pop(context);
      } else if (response.statusCode == 204) {
        log("mo data found:${response.statusCode}");
      } else {
        throw Exception('Failed to post item: ${response.body}');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error posting item: $e')),
      );
    }
  }

  Map<String, dynamic> collectFormData() {
    Map<String, dynamic> data = {};
    controllers.forEach((key, controller) {
      data[key] = controller.text;
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post ${widget.item["caption"]}"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  widget.item["icon"],
                  size: 100,
                  color: widget.item["color"],
                ),
                SizedBox(height: 20),
                _buildCategorySpecificContent(),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _postItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 212, 33, 243), // Background color
                      shadowColor: Colors.white, // Text color
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5, // Add shadow
                    ),
                    child: Container(
                      padding: EdgeInsets.all(0),
                      child: Text(
                        'Post Item',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ),

                // ElevatedButton(
                //   onPressed: _postItem,
                //   child: Center(child: Container(
                //     padding: EdgeInsets.all(8),
                //     child: Text('Post Item',style: TextStyle(color: Colors.red,fontSize: 15,backgroundColor: Colors.grey),))),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySpecificContent() {
    switch (widget.item["caption"]) {
      case "Cars":
        return _buildCarForm();
      case "Property":
        return _buildPropertyForm();
      case "Jobs":
        return _buildJobForm();
      case 'Electronics':
        return _buildElectronicsForm();
      case 'Mobiles':
        return _buildMobilesDetails();

      case 'Fashion':
        return _buildFashionForm();
      case 'Books, Sports & Hobbies':
        return _buildBooksSportsHobbiesForm();
      case 'Bikes':
        return _buildBikesDetails();
      case 'electronics & appliances':
        return _buildElectronicsAppliancesForm();
      case 'Furniture':
        return _buildFurnitureForm();
      case 'Services':
        return _buildServicesForm();
      case 'Pets':
        return _buildPetsForm();
      case 'Commercial Vehicles & Spares':
        return _buildCommercialVehiclesSparesForm();

      // Add other cases
      default:
        return Text("Form for ${widget.item["caption"]} category");
    }
  }

  Widget _buildCarForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controllers['thumb'],
          decoration:
              InputDecoration(labelText: 'thumb', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['title'],
          decoration:
              InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['city'],
          decoration:
              InputDecoration(labelText: 'City', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['verifiedSeller'],
          decoration: InputDecoration(
              labelText: 'verifiedSeller', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['category'],
          decoration: InputDecoration(
              labelText: 'category', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['description'],
          decoration: InputDecoration(
              labelText: 'description', border: OutlineInputBorder()),
          maxLines: 3,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['price'],
          decoration:
              InputDecoration(labelText: 'Price', border: OutlineInputBorder()),
          keyboardType: TextInputType.number,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        // SizedBox(height: 20),
        // Text("Specifications",
        //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['make'],
          decoration:
              InputDecoration(labelText: 'Make', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['model'],
          decoration:
              InputDecoration(labelText: 'Model', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['mfgYear'],
          decoration: InputDecoration(
              labelText: 'Manufacturing Year', border: OutlineInputBorder()),
          keyboardType: TextInputType.number,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['odoReading'],
          decoration: InputDecoration(
              labelText: 'Odometer Reading', border: OutlineInputBorder()),
          keyboardType: TextInputType.number,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),

        TextFormField(
          controller: controllers['inWarranty'],
          decoration: InputDecoration(
              labelText: 'In Warranty', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        // SizedBox(height: 10),
        // TextFormField(
        //   controller: controllers['variant'],
        //   decoration: InputDecoration(labelText: 'variant',

        //    border: OutlineInputBorder()),
        //   validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        // ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['transmissionType'],
          decoration: InputDecoration(
              labelText: 'transmissionType', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['fuelType'],
          decoration: InputDecoration(
              labelText: 'Fuel Type', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['ownership'],
          decoration: InputDecoration(
              labelText: 'ownership', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
      ],
    );
  }

  Widget _buildPropertyForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controllers['title'],
          decoration:
              InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['city'],
          decoration:
              InputDecoration(labelText: 'City', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['location'],
          decoration: InputDecoration(
              labelText: 'Location', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['Category'],
          decoration: InputDecoration(
              labelText: 'Category', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['type'],
          decoration:
              InputDecoration(labelText: 'type', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['ownerType'],
          decoration: InputDecoration(
              labelText: 'Property Type', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['bedrooms'],
          decoration: InputDecoration(
              labelText: 'Bedrooms', border: OutlineInputBorder()),
          keyboardType: TextInputType.number,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['bathrooms'],
          decoration: InputDecoration(
              labelText: 'Bathrooms', border: OutlineInputBorder()),
          keyboardType: TextInputType.number,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['area'],
          decoration: InputDecoration(
              labelText: 'Area (sq ft)', border: OutlineInputBorder()),
          keyboardType: TextInputType.number,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['price'],
          decoration:
              InputDecoration(labelText: 'Price', border: OutlineInputBorder()),
          keyboardType: TextInputType.number,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['furnishing'],
          decoration: InputDecoration(
              labelText: 'furnishing', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['floorNumber'],
          decoration: InputDecoration(
              labelText: 'floorNumber', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['totalFloors'],
          decoration: InputDecoration(
              labelText: 'totalFloors', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['description'],
          decoration: InputDecoration(
              labelText: 'description', border: OutlineInputBorder()),
          maxLines: 3,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
      ],
    );
  }

  Widget _buildJobForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controllers['title'],
          decoration: InputDecoration(labelText: 'title',
          border: OutlineInputBorder()
          
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['company'],
          decoration: InputDecoration(labelText: 'Company',
          border: OutlineInputBorder()
          
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['jobType'],
          decoration: InputDecoration(labelText: 'Job Type',
          border: OutlineInputBorder()
          
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['location'],
          decoration: InputDecoration(labelText: 'Location',
          border: OutlineInputBorder()
          
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['salary'],
          decoration: InputDecoration(labelText: 'Salary',
          border: OutlineInputBorder()
          
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['city'],
          decoration: InputDecoration(labelText: 'city',
          border: OutlineInputBorder()
          
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['experienceLevel'],
          decoration: InputDecoration(labelText: 'Experience Level',
            border: OutlineInputBorder()
          
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['position'],
          decoration: InputDecoration(labelText: 'position',
            border: OutlineInputBorder()
          
          ),
          maxLines: 3,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['industry'],
          decoration: InputDecoration(labelText: 'industry',
            border: OutlineInputBorder()
          
          ),
          maxLines: 3,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['contact_info'],
          decoration: InputDecoration(labelText: 'Contact Information',
            border: OutlineInputBorder()
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
      ],
    );
  }

  Widget _buildMobilesDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controllers['title'],
          decoration:
              InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['brand'],
          decoration:
              InputDecoration(labelText: 'Brand', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['model'],
          decoration:
              InputDecoration(labelText: 'Model', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['storage'],
          decoration: InputDecoration(
              labelText: 'Storage', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['color'],
          decoration:
              InputDecoration(labelText: 'Color', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['ram'],
          decoration:
              InputDecoration(labelText: 'RAM', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['price'],
          decoration:
              InputDecoration(labelText: 'Price', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['description'],
          decoration: InputDecoration(
              labelText: 'Description', border: OutlineInputBorder()),
          maxLines: 3,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
      ],
    );
  }

  Widget _buildBikesDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controllers['title'],
          decoration:
              InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['bikeType'],
          decoration: InputDecoration(
              labelText: 'Bike Type', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['brand'],
          decoration:
              InputDecoration(labelText: 'Brand', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['model'],
          decoration:
              InputDecoration(labelText: 'Model', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['year'],
          decoration:
              InputDecoration(labelText: 'Year', border: OutlineInputBorder()),
          keyboardType: TextInputType.number,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['price'],
          decoration:
              InputDecoration(labelText: 'Price', border: OutlineInputBorder()),
          keyboardType: TextInputType.number,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['mileage'],
          decoration: InputDecoration(
              labelText: 'Mileage', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['condition'],
          decoration: InputDecoration(
              labelText: 'Condition', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['description'],
          decoration: InputDecoration(
              labelText: 'Description', border: OutlineInputBorder()),
          maxLines: 3,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
      ],
    );
  }

  Widget _buildElectronicsForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controllers['title'],
          decoration:
              InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['brand'],
          decoration:
              InputDecoration(labelText: 'Brand', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['model'],
          decoration:
              InputDecoration(labelText: 'Model', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['price'],
          decoration:
              InputDecoration(labelText: 'Price', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['description'],
          decoration: InputDecoration(
              labelText: 'Description', border: OutlineInputBorder()),
          maxLines: 3,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
      ],
    );
  }

  Widget _buildFurnitureForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controllers['title'],
          decoration:
              InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['condition'],
          decoration: InputDecoration(
              labelText: 'Condition', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['price'],
          decoration:
              InputDecoration(labelText: 'Price', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['description'],
          decoration: InputDecoration(
              labelText: 'Description', border: OutlineInputBorder()),
          maxLines: 3,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
      ],
    );
  }

  Widget _buildFashionForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controllers['title'],
          decoration:
              InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['brand'],
          decoration:
              InputDecoration(labelText: 'Brand', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['price'],
          decoration:
              InputDecoration(labelText: 'Price', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['description'],
          decoration: InputDecoration(
              labelText: 'Description', border: OutlineInputBorder()),
          maxLines: 3,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
      ],
    );
  }

  Widget _buildBooksSportsHobbiesForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controllers['title'],
          decoration:
              InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['category'],
          decoration: InputDecoration(
              labelText: 'Category', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['author'],
          decoration: InputDecoration(
              labelText: 'Author/Brand', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['condition'],
          decoration: InputDecoration(
              labelText: 'Condition', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['price'],
          decoration:
              InputDecoration(labelText: 'Price', border: OutlineInputBorder()),
          keyboardType: TextInputType.number,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['description'],
          decoration: InputDecoration(
              labelText: 'Description', border: OutlineInputBorder()),
          maxLines: 3,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
      ],
    );
  }

  Widget _buildPetsForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controllers['title'],
          decoration:
              InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['breed'],
          decoration:
              InputDecoration(labelText: 'Breed', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['price'],
          decoration:
              InputDecoration(labelText: 'Price', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['description'],
          decoration: InputDecoration(
              labelText: 'Description', border: OutlineInputBorder()),
          maxLines: 3,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
      ],
    );
  }

  Widget _buildServicesForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controllers['title'],
          decoration:
              InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['category'],
          decoration: InputDecoration(
              labelText: 'Category', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['price'],
          decoration:
              InputDecoration(labelText: 'Price', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['description'],
          decoration: InputDecoration(
              labelText: 'Description', border: OutlineInputBorder()),
          maxLines: 3,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
      ],
    );
  }

  Widget _buildElectronicsAppliancesForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controllers['title'],
          decoration:
              InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['brand'],
          decoration:
              InputDecoration(labelText: 'Brand', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['price'],
          decoration:
              InputDecoration(labelText: 'Price', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['description'],
          decoration: InputDecoration(
              labelText: 'Description', border: OutlineInputBorder()),
          maxLines: 3,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
      ],
    );
  }

  Widget _buildCommercialVehiclesSparesForm() {
    return Column(
      children: [
        TextFormField(
          controller: controllers['thumb'],
          decoration:
              InputDecoration(labelText: 'thumb', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['title'],
          decoration:
              InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['category'],
          decoration: InputDecoration(
              labelText: 'Category', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['brand'],
          decoration:
              InputDecoration(labelText: 'Brand', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['price'],
          decoration:
              InputDecoration(labelText: 'Price', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['year'],
          decoration:
              InputDecoration(labelText: 'year', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['description'],
          decoration: InputDecoration(
              labelText: 'Description', border: OutlineInputBorder()),
          maxLines: 3,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          controller: controllers['model'],
          decoration:
              InputDecoration(labelText: 'model', border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['firstName'],
          decoration: InputDecoration(
              labelText: 'firstName', border: OutlineInputBorder()),
          maxLines: 1,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['lastName'],
          decoration: InputDecoration(
              labelText: 'lastName', border: OutlineInputBorder()),
          maxLines: 1,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
      ],
    );
  }
}
