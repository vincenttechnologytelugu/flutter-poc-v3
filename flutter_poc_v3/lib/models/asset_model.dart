// lib/models/asset_model.dart

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

  factory AssetModel.fromJson(Map<String, dynamic> map) {
    return AssetModel(
      url: map['url'] ?? '',
      type: map['type'] ?? '',
      id: map['_id'] ?? '',
      createdAt: map['created_at'] ?? '',
    );
  }
}
