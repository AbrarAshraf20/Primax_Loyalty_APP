// lib/models/point_transaction.dart

class PointTransaction {
  final int id;
  final String userId;
  final String itemName;
  final int points;
  final String serialNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  PointTransaction({
    required this.id,
    required this.userId,
    required this.itemName,
    required this.points,
    required this.serialNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PointTransaction.fromJson(Map<String, dynamic> json) {
    return PointTransaction(
      id: json['id'],
      userId: json['user_id'].toString(),
      itemName: json['item_name'] ?? '',
      points: int.tryParse(json['points'].toString()) ?? 0,
      serialNumber: json['serial_number'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'item_name': itemName,
      'points': points.toString(),
      'serial_number': serialNumber,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}