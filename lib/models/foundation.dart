// lib/core/models/foundation.dart

class Foundation {
  final int id;
  final String foundationName;
  final String foundationLink;
  final String foundationDescription;
  final String image;
  final String createdAt;
  final String updatedAt;

  Foundation({
    required this.id,
    required this.foundationName,
    required this.foundationLink,
    required this.foundationDescription,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  // Create a Foundation object from JSON
  factory Foundation.fromJson(Map<String, dynamic> json) {
    return Foundation(
      id: json['id'] ?? 0,
      foundationName: json['foundation_name'] ?? '',
      foundationLink: json['foundation_link'] ?? '',
      foundationDescription: json['foundation_description'] ?? '',
      image: json['image'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  // Convert Foundation object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'foundation_name': foundationName,
      'foundation_link': foundationLink,
      'foundation_description': foundationDescription,
      'image': image,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}