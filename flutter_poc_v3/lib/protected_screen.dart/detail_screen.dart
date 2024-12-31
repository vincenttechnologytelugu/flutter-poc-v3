


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
        controllers['salary'] = TextEditingController();
        controllers['industry'] = TextEditingController();
        controllers['position'] = TextEditingController();
        controllers['experienceLevel'] = TextEditingController();
        controllers['qualifications'] = TextEditingController();
        controllers['contact_info'] = TextEditingController();
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
        Uri.parse('http://172.26.0.1:8080/adposts'),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Item posted successfully!')),
        );
        Navigator.pop(context);
      } else if(response.statusCode ==204){
log("mo data found:${response.statusCode}");
      }else {
        throw Exception('Failed to post item: ${response.body}');
      }
    } catch (e) {
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
                ElevatedButton(
                  onPressed: _postItem,
                  child: Text('Post Item'),
                ),
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
          decoration: InputDecoration(labelText: 'thumb',
           border: OutlineInputBorder()
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['title'],
          decoration: InputDecoration(labelText: 'Title',
          border: OutlineInputBorder()
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['city'],
          decoration: InputDecoration(labelText: 'City',
           border: OutlineInputBorder()
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
         TextFormField(
          controller: controllers['verifiedSeller'],
          decoration: InputDecoration(labelText: 'verifiedSeller',
           border: OutlineInputBorder()
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
             SizedBox(height: 10),
             TextFormField(
          controller: controllers['category'],
          decoration: InputDecoration(labelText: 'category',
           border: OutlineInputBorder()
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['description'],
          decoration: InputDecoration(labelText: 'description',
          
           border: OutlineInputBorder()),
          maxLines: 3,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['price'],
          decoration: InputDecoration(labelText: 'Price',
           border: OutlineInputBorder()
          ),
          keyboardType: TextInputType.number,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 20),
        Text("Specifications", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['make'],
          decoration: InputDecoration(labelText: 'Make',
           border: OutlineInputBorder()
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['model'],
          decoration: InputDecoration(labelText: 'Model',
           border: OutlineInputBorder()
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['mfgYear'],
          decoration: InputDecoration(labelText: 'Manufacturing Year',
          
           border: OutlineInputBorder()
           ),
          keyboardType: TextInputType.number,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['odoReading'],
          decoration: InputDecoration(labelText: 'Odometer Reading',
           border: OutlineInputBorder()
          ),
          keyboardType: TextInputType.number,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['transmissionType'],
          decoration: InputDecoration(labelText: 'Transmission Type',
           border: OutlineInputBorder()
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['inWarranty'],
          decoration: InputDecoration(labelText: 'In Warranty',
           border: OutlineInputBorder()
          ),
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
          decoration: InputDecoration(labelText: 'transmissionType',
           border: OutlineInputBorder()
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['fuelType'],
          decoration: InputDecoration(labelText: 'Fuel Type',
          
           border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['ownership'],
          decoration: InputDecoration(labelText: 'ownership',
           border: OutlineInputBorder()
          ),
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
          decoration: InputDecoration(labelText: 'Title'),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['ownerType'],
          decoration: InputDecoration(labelText: 'Property Type'),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['bedrooms'],
          decoration: InputDecoration(labelText: 'Bedrooms'),
          keyboardType: TextInputType.number,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['bathrooms'],
          decoration: InputDecoration(labelText: 'Bathrooms'),
          keyboardType: TextInputType.number,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['area'],
          decoration: InputDecoration(labelText: 'Area (sq ft)'),
          keyboardType: TextInputType.number,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['price'],
          decoration: InputDecoration(labelText: 'Price'),
          keyboardType: TextInputType.number,
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
          decoration: InputDecoration(labelText: 'title'),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['company'],
          decoration: InputDecoration(labelText: 'Company'),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['jobType'],
          decoration: InputDecoration(labelText: 'Job Type'),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['location'],
          decoration: InputDecoration(labelText: 'Location'),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['salary'],
          decoration: InputDecoration(labelText: 'Salary'),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['city'],
          decoration: InputDecoration(labelText: 'city'),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['experienceLevel'],
          decoration: InputDecoration(labelText: 'Experience Level'),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['position'],
          decoration: InputDecoration(labelText: 'position'),
          maxLines: 3,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['industry'],
          decoration: InputDecoration(labelText: 'industry'),
          maxLines: 3,
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controllers['contact_info'],
          decoration: InputDecoration(labelText: 'Contact Information'),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
      ],
    );
  }
}


// import 'package:flutter/material.dart';

// class DetailScreen extends StatefulWidget {
//   final Map<String, dynamic> item;

//   const DetailScreen({super.key, required this.item});

//   @override
//   State<DetailScreen> createState() => _DetailScreenState();
// }

// class _DetailScreenState extends State<DetailScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Column(
//           children: [
//             //Text(widget.item["caption"]),
//             Text("Include Some Details")
//           ],
//         ),

//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Icon(
//                 widget.item["icon"],
//                 size: 100,
//                 color: widget.item["color"],
//               ),
//               SizedBox(height: 20),
//               Text(
//                 widget.item["caption"],
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 20),
//               _buildCategorySpecificContent(),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   // Implement post item functionality
//                 },
//                 child: Text('Post Item'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCategorySpecificContent() {
//     switch (widget.item["caption"]) {
//       case "Cars":
//         return _buildCarForm();
//       case "Property":
//         return _buildPropertyForm();
//       case "Mobiles":
//         return _buildMobileForm();
//         case "Jobs":
//         return _buildJobForm();
//         case "Bikes":
//         return _buildBikeForm();
//         case "Electronics":
//         return _buildElectronicsForm();
//         case "Furniture":
//         return _buildFurnitureForm();
//         case "Fashion":
//         return _buildFashionForm();
//          case "Books and Sports":
//          return _buildBooksAndSportsForm();
//         // return _buildBooksForm();
//         case "Pets":
//         return _buildPetsForm();
//         case "Services":
//         return _buildServicesForm();
//         case "Commercial Vehicles":
//         return _buildCommercialVehiclesForm();

       
       
//       // Add cases for other categories
//       default:
//         return Text("Form for ${widget.item["caption"]} category");
//     }
//   }

//   Widget _buildCarForm() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
        
//         // Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR8e61foEH1tVRlDS4OMHtW8UnC_EvBw3Hq9w&s"),
//          SizedBox(height: 10),
//         TextFormField(decoration: InputDecoration(labelText: 'Title')),
//         SizedBox(height: 10),
//         TextFormField(decoration: InputDecoration(labelText: 'City')),
//          SizedBox(height: 10),
//         TextFormField(decoration: InputDecoration(labelText: 'veriFiedSeller')),
//          SizedBox(height: 10),
//         TextFormField(decoration: InputDecoration(labelText: 'category')),
//          SizedBox(height: 10),
//         TextFormField(decoration: InputDecoration(labelText: 'description')),
//          SizedBox(height: 10),
//         TextFormField(decoration: InputDecoration(labelText: 'price')),
//          SizedBox(height: 10),
//         Text("Specifications",style: TextStyle(fontSize: 30),),
//          SizedBox(height: 10),
//         TextFormField(decoration: InputDecoration(labelText: 'make')),
//          SizedBox(height: 10),
//         TextFormField(decoration: InputDecoration(labelText: 'model')),
//          SizedBox(height: 10),
//         TextFormField(decoration: InputDecoration(labelText: 'mfgYear')),
//          SizedBox(height: 10),
//         TextFormField(decoration: InputDecoration(labelText: 'odoReading')),
//          SizedBox(height: 10),
//         TextFormField(decoration: InputDecoration(labelText: 'inWarranty')),
//          SizedBox(height: 10),
//         TextFormField(decoration: InputDecoration(labelText: 'inWarranty')),
//          SizedBox(height: 10),
//         TextFormField(decoration: InputDecoration(labelText: 'transmissionType')),
//          SizedBox(height: 10),
//         TextFormField(decoration: InputDecoration(labelText: 'fuelType')),

//       ],
//     );
//   }

//   Widget _buildPropertyForm() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         TextFormField(decoration: InputDecoration(labelText: 'Property Type')),
//         TextFormField(decoration: InputDecoration(labelText: 'Bedrooms')),
//         TextFormField(decoration: InputDecoration(labelText: 'Bathrooms')),
//         TextFormField(decoration: InputDecoration(labelText: 'Area (sq ft)')),
//         TextFormField(decoration: InputDecoration(labelText: 'Price')),
//       ],
//     );
//   }

//   Widget _buildMobileForm() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         TextFormField(decoration: InputDecoration(labelText: 'Brand')),
//         TextFormField(decoration: InputDecoration(labelText: 'Model')),
//         TextFormField(decoration: InputDecoration(labelText: 'Storage')),
//         TextFormField(decoration: InputDecoration(labelText: 'Condition')),
//         TextFormField(decoration: InputDecoration(labelText: 'Price')),
//       ],
//     );
//   }
//   Widget _buildJobForm() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         TextFormField(decoration: InputDecoration(labelText: 'jobType')),
//         TextFormField(decoration: InputDecoration(labelText: 'Company')),
//         TextFormField(decoration: InputDecoration(labelText: 'Location')),
//         TextFormField(decoration: InputDecoration(labelText: 'Salary')),
//         TextFormField(decoration: InputDecoration(labelText: 'Description')),
//          TextFormField(decoration: InputDecoration(labelText: 'Title')),
//         TextFormField(decoration: InputDecoration(labelText: 'city')),
//         TextFormField(decoration: InputDecoration(labelText: 'posted_at')),
//         TextFormField(decoration: InputDecoration(labelText: 'category')),
//         TextFormField(decoration: InputDecoration(labelText: 'industry')),
//          TextFormField(decoration: InputDecoration(labelText: 'position')),
//         TextFormField(decoration: InputDecoration(labelText: 'experienceLevel')),
//         TextFormField(decoration: InputDecoration(labelText: 'qualifications')),
//         TextFormField(decoration: InputDecoration(labelText: 'contact_info')),
//       ],
//     );
//   }
//   Widget _buildBikeForm() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         TextFormField(decoration: InputDecoration(labelText: 'Bike Type')),
//         TextFormField(decoration: InputDecoration(labelText: 'Brand')),
//         TextFormField(decoration: InputDecoration(labelText: 'Model')),
//         TextFormField(decoration: InputDecoration(labelText: 'Price')),
//       ],
//     );
//   }
//   Widget _buildElectronicsForm() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         TextFormField(decoration: InputDecoration(labelText: 'Electronics Type')),
//         TextFormField(decoration: InputDecoration(labelText: 'Brand')),
//         TextFormField(decoration: InputDecoration(labelText: 'Model')),
//         TextFormField(decoration: InputDecoration(labelText: 'Price')),
//       ],
//     );
//   }
//   Widget _buildFurnitureForm() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         TextFormField(decoration: InputDecoration(labelText: 'Furniture Type')),
//         TextFormField(decoration: InputDecoration(labelText: 'Brand')),
//         TextFormField(decoration: InputDecoration(labelText: 'Model')),
//         TextFormField(decoration: InputDecoration(labelText: 'Price')),
//       ],
//     );
//   }
//   Widget _buildFashionForm() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         TextFormField(decoration: InputDecoration(labelText: 'Fashion Type')),
//         TextFormField(decoration: InputDecoration(labelText: 'Brand')),
//         TextFormField(decoration: InputDecoration(labelText: 'Model')),
//         TextFormField(decoration: InputDecoration(labelText: 'Price')),
//       ],
//     );
//   }
//   Widget _buildBooksAndSportsForm() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         TextFormField(decoration: InputDecoration(labelText: 'Books&Sports Type')),
//         TextFormField(decoration: InputDecoration(labelText: 'Brand')),
//         TextFormField(decoration: InputDecoration(labelText: 'Model')),
//         TextFormField(decoration: InputDecoration(labelText: 'Price')),
//       ],
//     );
//   }
//   Widget _buildPetsForm() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         TextFormField(decoration: InputDecoration(labelText: 'Pets Type')),
//         TextFormField(decoration: InputDecoration(labelText: 'Brand')),
//         TextFormField(decoration: InputDecoration(labelText: 'Model')),
//         TextFormField(decoration: InputDecoration(labelText: 'Price')),
//       ],
//     );
//   }
//   Widget _buildServicesForm() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         TextFormField(decoration: InputDecoration(labelText: 'Services Type')),
//         TextFormField(decoration: InputDecoration(labelText: 'Brand')),
//         TextFormField(decoration: InputDecoration(labelText: 'Model')),
//         TextFormField(decoration: InputDecoration(labelText: 'Price')),
//       ],
//     );
//   }
//   Widget _buildCommercialVehiclesForm() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         TextFormField(decoration: InputDecoration(labelText: 'Commercial Vehicles Type')),
//         TextFormField(decoration: InputDecoration(labelText: 'Brand')),
//         TextFormField(decoration: InputDecoration(labelText: 'Model')),
//         TextFormField(decoration: InputDecoration(labelText: 'Price')),
//       ],
//     );
//   }
// }
