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

  final List<String> restrictedFields = [
    "posted_by",
    "created_at",
    "last_updated_at",
    "published_at",
    "isActive",
    "category",
    "sold_at",
    "deleted_at",
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

  Widget _buildFormField(String fieldName, dynamic value) {
    if (restrictedFields.contains(fieldName)) return SizedBox.shrink();
    // Check if the field is 'action_flags'
    if (fieldName == 'action_flags') {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: TextFormField(
          initialValue: value?.toString() ?? '',
          readOnly: true,
          // enabled: false,
          decoration: InputDecoration(
            labelText: fieldName.replaceAll('_', ' ').toUpperCase(),
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.grey[200],
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
          style: TextStyle(
            color: Colors.grey[700],
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        initialValue: value?.toString() ?? '',
        decoration: InputDecoration(
          labelText: fieldName.replaceAll('_', ' ').toUpperCase(),
          border: OutlineInputBorder(),
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

  Future<void> _updateAd() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {

      await _myAdsService.updateAd(context,widget.ad['_id'], _editedFields, );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Ad'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  ..._editedFields.entries.map(
                    (entry) => _buildFormField(entry.key, entry.value),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updateAd,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
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
