// lib/models/brand_model.dart

class Brand {
  final String id;
  final String name;
  final String? imageUrl;

  Brand({
    required this.id,
    required this.name,
    this.imageUrl,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? json['image'] ?? json['logo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
    };
  }
}