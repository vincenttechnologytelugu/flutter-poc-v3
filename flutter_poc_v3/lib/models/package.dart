// lib/models/package.dart
class Package {
  final String name;
  final String description;
  final String duration;
  final double price;
  final DateTime purchaseDate;
  final Map<String, dynamic> subscriptionRules;
  final bool isExpired;
  final String id;

  Package({
    required this.name,
    required this.description,
    required this.duration,
    required this.price,
    required this.purchaseDate,
    required this.subscriptionRules,
    required this.isExpired,
    required this.id,
  });
}
