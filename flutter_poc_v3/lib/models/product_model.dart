import 'dart:developer';

class ProductModel {
  final int? id;
  final String? title;
  final double? price;
  final String? model;
  final int? year;
  final String? location;
  final String? brand;
  final String? fuel;
  final String? transmission;
  final int? mileage;
  final int? ownerType;
  final String? condition;
  final String? description;
  final String? category;
  final String? city;
  final String? thumb;

  ProductModel({
    this.id,
    this.title,
    this.price,
    this.model,
    this.year,
    this.location,
    this.brand,
    this.fuel,
    this.transmission,
    this.mileage,
    this.ownerType,
    this.condition,
    this.description,
    this.category,
    this.city,
    this.thumb,
  });

  factory ProductModel.fromJson(Map<String, dynamic> map) {
    try {
      log('Parsing JSON: $map'); // Add this debug log
      return ProductModel(
        id: map['id'],
        title: map['title']?.toString(),
        price: map['price'] != null 
            ? (map['price'] is double 
                ? map['price'] 
                : double.tryParse(map['price'].toString())) 
            : null,
        model: map['model']?.toString(),
        year: map['year'] != null 
            ? (map['year'] is int 
                ? map['year'] 
                : int.tryParse(map['year'].toString())) 
            : null,
        location: map['location']?.toString(),
        brand: map['brand']?.toString(),
        fuel: map['fuel']?.toString(),
        transmission: map['transmission']?.toString(),
        mileage: map['mileage'] != null 
            ? (map['mileage'] is int 
                ? map['mileage'] 
                : int.tryParse(map['mileage'].toString())) 
            : null,
        ownerType: map['ownerType'] != null 
            ? (map['ownerType'] is int 
                ? map['ownerType'] 
                : int.tryParse(map['ownerType'].toString())) 
            : null,
        condition: map['condition']?.toString(),
        description: map['description']?.toString(),
        category: map['category']?.toString(),
        city: map['city']?.toString(),
        thumb: map['thumb']?.toString(),
      );
    } catch (e) {
      log('Error parsing JSON: $e');
      rethrow;
    }
  }
}
