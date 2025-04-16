// lib/models/reward.dart

class Reward {
  final int id;
  final String title;
  final String description;
  final String? image;
  final int pointsRequired;
  final bool isActive;
  final bool isFeatured;
  final bool isClubReward;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Reward({
    required this.id,
    required this.title,
    required this.description,
    this.image,
    required this.pointsRequired,
    this.isActive = true,
    this.isFeatured = false,
    this.isClubReward = false,
    this.createdAt,
    this.updatedAt,
  });

  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'],
      pointsRequired: json['points_required'] ?? 0,
      isActive: json['is_active'] ?? true,
      isFeatured: json['is_featured'] ?? false,
      isClubReward: json['is_club_reward'] ?? false,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'points_required': pointsRequired,
      'is_active': isActive,
      'is_featured': isFeatured,
      'is_club_reward': isClubReward,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}