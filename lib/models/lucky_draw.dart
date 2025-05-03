// lib/models/lucky_draw.dart

/// Model class for Lucky Draw
class LuckyDraw {
  final int id;
  final String name;
  final String status; // "on" or "off"
  final String userAllowedMultiTime; // "on" or "off"
  final DateTime? endTime;
  final int minimumPoints;
  final DateTime createdAt;
  final DateTime updatedAt;

  LuckyDraw({
    required this.id,
    required this.name,
    required this.status,
    required this.userAllowedMultiTime,
    this.endTime,
    required this.minimumPoints,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convenience getter to check if lucky draw is active
  bool get isActive => status == 'on';

  /// Convenience getter to check if multiple participation is allowed
  bool get allowsMultipleParticipation => userAllowedMultiTime == 'on';

  /// Factory constructor to create a LuckyDraw instance from JSON
  factory LuckyDraw.fromJson(Map<String, dynamic> json) {
    return LuckyDraw(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      status: json['status'] ?? 'off',
      userAllowedMultiTime: json['user_allowed_multi_time'] ?? 'off',
      endTime: json['end_time'] != null ? DateTime.parse(json['end_time']) : null,
      minimumPoints: json['minimum_points'] ?? 0,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toString()),
    );
  }

  /// Convert a LuckyDraw instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'user_allowed_multi_time': userAllowedMultiTime,
      'end_time': endTime?.toIso8601String(),
      'minimum_points': minimumPoints,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}