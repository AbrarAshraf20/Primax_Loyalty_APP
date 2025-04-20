class Claim {
  final int id;
  final String userId;
  final String itemName;
  final String points;
  final String serialNumber;
  final String createdAt;
  final String updatedAt;

  Claim({
    required this.id,
    required this.userId,
    required this.itemName,
    required this.points,
    required this.serialNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Claim.fromJson(Map<String, dynamic> json) {
    return Claim(
      id: json['id'],
      userId: json['user_id'],
      itemName: json['item_name'],
      points: json['points'],
      serialNumber: json['serial_number'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'item_name': itemName,
      'points': points,
      'serial_number': serialNumber,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

// lib/models/claims_response.dart

class ClaimsResponse {
  final bool success;
  final String message;
  final List<Claim> data;

  ClaimsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ClaimsResponse.fromJson(Map<String, dynamic> json) {
    List<Claim> claims = (json['data'] as List)
        .map((claimJson) => Claim.fromJson(claimJson))
        .toList();

    return ClaimsResponse(
      success: json['success'],
      message: json['message'],
      data: claims,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((claim) => claim.toJson()).toList(),
    };
  }
}