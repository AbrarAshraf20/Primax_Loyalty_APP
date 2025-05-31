// lib/models/lucky_draw.dart

/// Model class for Lucky Draw
class LuckyDraw {
  final int id;
  final String name;
  final String thumbnail;
  final String status; // "on" or "off"
  final String userAllowedMultiTime; // "on" or "off"
  final String cashornot; // "1" for cash prizes, "0" for non-cash prizes
  final DateTime? endTime;
  final int minimumPoints;
  final int minimumUsers;
  final DateTime createdAt;
  final DateTime updatedAt;

  LuckyDraw({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.status,
    required this.userAllowedMultiTime,
    required this.cashornot,
    this.endTime,
    required this.minimumPoints,
    required this.minimumUsers,
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
      thumbnail: json['thumbnail'] ?? '',
      status: json['status'] ?? 'off',
      userAllowedMultiTime: json['user_allowed_multi_time'] ?? 'off',
      cashornot: json['cashornot'] ?? '1', // Default to cash if not specified
      endTime: json['end_time'] != null ? DateTime.parse(json['end_time']) : null,
      minimumPoints: json['minimum_points'] ?? 0,
      minimumUsers: int.tryParse(json['minimum_users']?.toString() ?? '0') ?? 0,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toString()),
    );
  }

  /// Convert a LuckyDraw instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'thumbnail': thumbnail,
      'status': status,
      'user_allowed_multi_time': userAllowedMultiTime,
      'cashornot': cashornot,
      'end_time': endTime?.toIso8601String(),
      'minimum_points': minimumPoints,
      'minimum_users': minimumUsers.toString(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}