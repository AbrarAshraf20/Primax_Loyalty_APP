class RewardHistory {
  final int id;
  final String userId;
  final String rewardId;
  final String itemName;
  final String points;
  final String? personName;
  final String? personAddress;
  final String? personPhone;
  final String? accountHolderName;
  final String? accountNumber;
  final String? paymentMethod;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  RewardHistory({
    required this.id,
    required this.userId,
    required this.rewardId,
    required this.itemName,
    required this.points,
    this.personName,
    this.personAddress,
    this.personPhone,
    this.accountHolderName,
    this.accountNumber,
    this.paymentMethod,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  // Check if this is a cash reward based on payment info
  bool get isCashReward => paymentMethod != null && paymentMethod!.isNotEmpty;

  // Get status color
  String get displayStatus {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      case 'completed':
        return 'Completed';
      default:
        return status;
    }
  }

  factory RewardHistory.fromJson(Map<String, dynamic> json) {
    return RewardHistory(
      id: json['id'],
      userId: json['user_id'],
      rewardId: json['reward_id'],
      itemName: json['item_name'],
      points: json['points'],
      personName: json['person_name'],
      personAddress: json['person_address'],
      personPhone: json['person_phone'],
      accountHolderName: json['account_holder_name'],
      accountNumber: json['account_number'],
      paymentMethod: json['payment_method'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'reward_id': rewardId,
      'item_name': itemName,
      'points': points,
      'person_name': personName,
      'person_address': personAddress,
      'person_phone': personPhone,
      'account_holder_name': accountHolderName,
      'account_number': accountNumber,
      'payment_method': paymentMethod,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class RewardHistoryResponse {
  final bool success;
  final String message;
  final List<RewardHistory> data;

  RewardHistoryResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory RewardHistoryResponse.fromJson(Map<String, dynamic> json) {
    List<RewardHistory> rewardHistoryList = (json['data'] as List)
        .map((item) => RewardHistory.fromJson(item))
        .toList();

    return RewardHistoryResponse(
      success: json['success'],
      message: json['message'] ?? '',
      data: rewardHistoryList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((history) => history.toJson()).toList(),
    };
  }
}