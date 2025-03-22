// In product_model.dart
class AssetModel {
  final String url;
  final String type;
  final String id;
  final String createdAt;

  AssetModel({
    required this.url,
    required this.type,
    required this.id,
    required this.createdAt,
  });

  // Updated fromJson to handle the nested response structure
  factory AssetModel.fromJson(Map<String, dynamic> json) {
    // Handle the nested 'data' structure
    final data = json['data'] as Map<String, dynamic>? ?? json;
    
    return AssetModel(
      url: data['path'] ?? '', // Changed from 'url' to 'path'
      type: 'image/jpeg', // Default type since it's not in response
      id: data['_id'] ?? '',
      createdAt: DateTime.now().toIso8601String(), // Default since it's not in response
    );
  }
}