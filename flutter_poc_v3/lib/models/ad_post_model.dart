// models/ad_post_model.dart
class AdPostResponse {
  final String message;
  final Pagination pagination;
  final List<AdPost> data;

  AdPostResponse({
    required this.message,
    required this.pagination,
    required this.data,
  });

  factory AdPostResponse.fromJson(Map<String, dynamic> json) {
    return AdPostResponse(
      message: json['message'],
      pagination: Pagination.fromJson(json['pagination']),
      data: (json['data'] as List).map((e) => AdPost.fromJson(e)).toList(),
    );
  }
}

class Pagination {
  final int currentPage;
  final int pageSize;
  final int matchingCount;
  final int totalPages;

  Pagination({
    required this.currentPage,
    required this.pageSize,
    required this.matchingCount,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['currentPage'],
      pageSize: json['pageSize'],
      matchingCount: json['matchingCount'],
      totalPages: json['totalPages'],
    );
  }
}

class AdPost {
  final String id;
  final String location;
  final String city;
  final String description;
  final String category;
  final String thumb;
  final int price;
  final String title;
  final String? brand;
  final String? condition;
  final String? model;
  final int? year;
  final int? mileage;
  final String? fuelType;
  final String? transmission;

  AdPost({
    required this.id,
    required this.location,
    required this.city,
    required this.description,
    required this.category,
    required this.thumb,
    required this.price,
    required this.title,
    this.brand,
    this.condition,
    this.model,
    this.year,
    this.mileage,
    this.fuelType,
    this.transmission,
  });

  factory AdPost.fromJson(Map<String, dynamic> json) {
    return AdPost(
      id: json['_id'],
      location: json['location'],
      city: json['city'],
      description: json['description'],
      category: json['category'],
      thumb: json['thumb'],
      price: json['price'],
      title: json['title'],
      brand: json['brand'],
      condition: json['condition'],
      model: json['model'],
      year: json['year'],
      mileage: json['mileage'],
      fuelType: json['fuelType'],
      transmission: json['transmission'],
    );
  }
}
