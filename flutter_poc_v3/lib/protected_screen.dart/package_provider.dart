// package_provider.dart
import 'package:flutter/material.dart';

class Package {
  final String name;
  // ignore: non_constant_identifier_names
  final int image_attachments;
  
  // Add other fields as needed

  Package({
    required this.name,
    // ignore: non_constant_identifier_names
    required this.image_attachments,
  });
}

class PackageProvider extends ChangeNotifier {
  // Add your provider logic here
  // For example:
  String _selectedPackage = '';
  
  String get selectedPackage => _selectedPackage;
  
  void setSelectedPackage(String package) {
    _selectedPackage = package;
    notifyListeners();
  }
}
