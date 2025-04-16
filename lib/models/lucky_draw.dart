// lib/models/lucky_draw.dart

/// Example models class for Lucky Draw
class LuckyDraw {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final int pointsRequired;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;

  LuckyDraw({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.pointsRequired,
    required this.startDate,
    required this.endDate,
    required this.isActive,
  });

  /// Factory constructor to create a LuckyDraw instance from JSON
  factory LuckyDraw.fromJson(Map<String, dynamic> json) {
    return LuckyDraw(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
      pointsRequired: json['points_required'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      isActive: json['is_active'],
    );
  }

  /// Convert a LuckyDraw instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'points_required': pointsRequired,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'is_active': isActive,
    };
  }
}