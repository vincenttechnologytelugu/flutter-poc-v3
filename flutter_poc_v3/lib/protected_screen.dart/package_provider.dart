// package_provider.dart
import 'package:flutter/material.dart';

class Package {
  final String name;
  final int image_attachments;
  
  // Add other fields as needed

  Package({
    required this.name,
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
