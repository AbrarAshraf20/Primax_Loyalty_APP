
class Reward {
  final int id;
  final String itemName;
  final String title;
  final String priceInTokens;
  final String image;
  final String status;
  final String claimStatus;
  final String? link;
  final String itemType;
  final String createdAt;
  final String updatedAt;

  Reward({
    required this.id,
    required this.itemName,
    required this.title,
    required this.priceInTokens,
    required this.image,
    required this.status,
    required this.claimStatus,
    this.link,
    required this.itemType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(
      id: json['id'],
      itemName: json['item_name'],
      title: json['title'],
      priceInTokens: json['price_in_tokens'],
      image: json['image'],
      status: json['status'],
      claimStatus: json['claim_status'],
      link: json['link'],
      itemType: json['item_type'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item_name': itemName,
      'title': title,
      'price_in_tokens': priceInTokens,
      'image': image,
      'status': status,
      'claim_status': claimStatus,
      'link': link,
      'item_type': itemType,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class RewardsResponse {
  final bool success;
  final String message;
  final List<Reward> data;

  RewardsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory RewardsResponse.fromJson(Map<String, dynamic> json) {
    List<Reward> rewards = (json['data'] as List)
        .map((rewardJson) => Reward.fromJson(rewardJson))
        .toList();

    return RewardsResponse(
      success: json['success'],
      message: json['message'],
      data: rewards,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((reward) => reward.toJson()).toList(),
    };
  }
}