// lib/screens/edit_my_ad_screen.dart
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/services/my_ads_sevice.dart';

class EditMyAdScreen extends StatefulWidget {
  final Map<String, dynamic> ad;

  const EditMyAdScreen({super.key, required this.ad});

  @override
  // ignore: library_private_types_in_public_api
  _EditMyAdScreenState createState() => _EditMyAdScreenState();
}

class _EditMyAdScreenState extends State<EditMyAdScreen> {
  final _formKey = GlobalKey<FormState>();
  final MyAdsService _myAdsService = MyAdsService();
  final Map<String, dynamic> _editedFields = {};
  bool _isLoading = false;

  // Add this method to get fields based on category
  List<String> getCategoryFields(String category) {
    switch (category.toLowerCase()) {
      case 'cars':
        return [
          'title',
          'state',
          'city',
          'location',
          'price',
          'fuelType',
          'brand',
          'model',
          'ownerType',
          'condition',
          'year',
          'transmissionType',
          'description'
        ];
      case 'bikes':
        return [
          'title',
          'state',
          'city',
          'location',
          'price',
          'brand',
          'model',
          'year',
           'condition',
          'ownerType',
         
          
          'description'
        ];
      case 'mobiles':
        return [
          'title',
          'state',
          'city',
          'location',
          'price',
          'brand',
          'model',
          'warranty',
          'storage',
          'color',

          'condition',
          'operatingSystem',
          'screenSize',
          'camera',
          'battery',
          'year',

          'description'
        ];
        case 'jobs':
        return [
          'title',
          'state',
          'city',
          'location',
          'comapany'
          'industry',
          'position',

          'salary',
          'experienceLevel',
         
          'jobType',
          'year',
           'price',

         
          'qualifications',
          'condition',
          'description'
         
          
        ];
        case 'electronics & appliances':
        return [
          'title',
          'state',
          'city',
          'location',
          'price',
          'brand',
  "electronics_category"
         

          'condition',
          'product',
          'warranty',
         
          'year',

          'description'
        ];
        case 'furniture':
        return [
          'title',
          'state',
          'city',
          'location',
          'price',
          'product',
          'material',
          'condition',
          'year',
          'description'
        ];
        case 'pets':
        return [
          'title',
          'state',
          'city',
          'location',
          'price',
          'vaccinationType',
          'pet_category'
          'breed',
          'condition',
          'year',
          'description'
        ];
        case 'properties':
        return [
          'title',
          'state',
          'city',
          'location',
         
          'type',
          'condition',
           'price',
            'area',
          'bedrooms',
          'bathrooms',
          'ownerType',
          'furnishing',
         'floorNumber',
         'totalFloors',
 
          'year',
          'description'
        ];
      case 'fashion':
      return [
        'title',
        'state',
        'city',
        'location',
        'fashion_category',
        'price',
        'brand',
        'product',
      
        'size',
         'year',
        'condition',
       
        'description'
      ];
      case 'Books, Sports & Hobbies':
        return [
          'title',
          'state',
          'city',
          'location',
          'price',
           'year',
           'product',
          'hobby_category',
         
          'condition',

          'description'
        ];
        case 'services':
        return [
          'title',
          'state',
          'city',
          'location',
          'price',
        
          'condition',
          'year',
          'description'
        ];
        case 'Commercial Vehicles & Spares':
        return [
          'title',
          'state',
          'city',
          'location',
          'price',
          'fuelType',
          'brand',
          'model',
          'warranty',
          'transmission',
          'color'

          'condition',
          'year',
          
          'description'
         
        ];

      
        

      // Add more categories as needed
      default:
        return ['title', 'state', 'city', 'location', 'price', 'description'];
    }
  }

  final List<String> restrictedFields = [
    "posted_by",
    "created_at",
    "last_updated_at",
    "published_at",
    "isActive",
    "category",
    "sold_at",
    "deleted_at",
    "action_flags",
    "_id",
    'thumb',
    'featured_at',
    "manual_boost_allowed_at",
    "valid_till",
    "subscription_plan",
    "assets"
  ];

  @override
  void initState() {
    super.initState();
    _initializeEditableFields();
  }

  void _initializeEditableFields() {
    widget.ad.forEach((key, value) {
      if (!restrictedFields.contains(key)) {
        _editedFields[key] = value;
      }
    });
  }

  // Widget _buildFormField(String fieldName, dynamic value) {
  //   if (restrictedFields.contains(fieldName)) return SizedBox.shrink();
  //   // Check if the field is 'action_flags'
  //   if (fieldName == 'action_flags') {
  //     return Padding(
  //       padding: EdgeInsets.symmetric(vertical: 8),
  //       child: TextFormField(
  //         initialValue: value?.toString() ?? '',
  //         readOnly: true,
  //         // enabled: false,
  //         decoration: InputDecoration(
  //           labelText: fieldName.replaceAll('_', ' ').toUpperCase(),
  //           border: OutlineInputBorder(),
  //           filled: true,
  //           fillColor: Colors.grey[200],
  //           disabledBorder: OutlineInputBorder(
  //             borderSide: BorderSide(color: Colors.grey),
  //           ),
  //         ),
  //         style: TextStyle(
  //           color: Colors.grey[700],
  //         ),
  //       ),
  //     );
  //   }

  //   return Padding(
  //     padding: EdgeInsets.symmetric(vertical: 8),
  //     child: TextFormField(
  //       initialValue: value?.toString() ?? '',
  //       decoration: InputDecoration(
  //         labelText: fieldName.replaceAll('_', ' ').toUpperCase(),
  //         border: OutlineInputBorder(),
  //       ),
  //       onChanged: (newValue) {
  //         setState(() {
  //           _editedFields[fieldName] = newValue;
  //         });
  //       },
  //       validator: (value) {
  //         if (value == null || value.isEmpty) {
  //           return 'Please enter $fieldName';
  //         }
  //         return null;
  //       },
  //     ),
  //   );
  // }


  // Modify _buildFormField method
  Widget _buildFormField(String fieldName, dynamic value) {
    // Get allowed fields for current category
    final allowedFields = getCategoryFields(widget.ad['category'] ?? '');
    
    // If field is not in allowed list or is restricted, don't show it
    if (!allowedFields.contains(fieldName.toLowerCase()) || 
        restrictedFields.contains(fieldName)) {
      return const SizedBox.shrink();
    }

    // Format field label
    String label = fieldName.replaceAll('_', ' ').toUpperCase();
    
    // Special handling for specific fields
    switch (fieldName.toLowerCase()) {
      case 'fueltype':
        return _buildDropdownField(
          label,
          value?.toString() ?? '',
          ['Petrol', 'Diesel', 'CNG', 'Electric', 'Hybrid'],
        );
      case 'condition':
        return _buildDropdownField(
          label,
          value?.toString() ?? '',
          ['New', 'Like New', 'Good', 'Fair'],
        );
      case 'ownertype':
        return _buildDropdownField(
          label,
          value?.toString() ?? '',
          ['First', 'Second', 'Third', 'Fourth & Above'],
        );
      case 'transmissiontype':
        return _buildDropdownField(
          label,
          value?.toString() ?? '',
          ['Manual', 'Automatic'],
        );
      default:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: TextFormField(
            initialValue: value?.toString() ?? '',
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
            ),
            onChanged: (newValue) {
              setState(() {
                _editedFields[fieldName] = newValue;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $fieldName';
              }
              return null;
            },
          ),
        );
    }
  }



// Add dropdown field builder
  Widget _buildDropdownField(String label, String currentValue, List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: items.contains(currentValue) ? currentValue : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _editedFields[label.toLowerCase()] = newValue;
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select $label';
          }
          return null;
        },
      ),
    );
  }



  Future<void> _updateAd() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _myAdsService.updateAd(
        context,
        widget.ad['_id'],
        _editedFields,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ad updated successfully')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update ad: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Ad'),
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Form(
//               key: _formKey,
//               child: ListView(
//                 padding: EdgeInsets.all(16),
//                 children: [
//                   ..._editedFields.entries.map(
//                     (entry) => _buildFormField(entry.key, entry.value),
//                   ),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: _updateAd,
//                     style: ElevatedButton.styleFrom(
//                       padding: EdgeInsets.symmetric(vertical: 16),
//                     ),
//                     child: Text(
//                       'SAVE CHANGES',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Ad'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Show only fields for current category
                  ...getCategoryFields(widget.ad['category'] ?? '')
                      .where((field) => _editedFields.containsKey(field))
                      .map((field) => _buildFormField(field, _editedFields[field])),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updateAd,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'SAVE CHANGES',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}