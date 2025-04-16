// lib/models/point_transaction.dart

class PointTransaction {
  final int id;
  final int userId;
  final int points;
  final String type; // 'earned', 'redeemed', etc.
  final String? description;
  final String? rewardTitle;
  final String? barcode;
  final DateTime createdAt;

  PointTransaction({
    required this.id,
    required this.userId,
    required this.points,
    required this.type,
    this.description,
    this.rewardTitle,
    this.barcode,
    required this.createdAt,
  });

  factory PointTransaction.fromJson(Map<String, dynamic> json) {
    return PointTransaction(
      id: json['id'],
      userId: json['user_id'],
      points: json['points'] ?? 0,
      type: json['type'] ?? 'earned',
      description: json['description'],
      rewardTitle: json['reward_title'],
      barcode: json['barcode'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'points': points,
      'type': type,
      'description': description,
      'reward_title': rewardTitle,
      'barcode': barcode,
      'created_at': createdAt.toIso8601String(),
    };
  }
}