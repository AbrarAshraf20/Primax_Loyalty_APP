// lib/models/home_model.dart

class HomeResponse {
  final bool status;
  final String message;
  final HomeData data;

  HomeResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    return HomeResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: HomeData.fromJson(json['data'] ?? {}),
    );
  }
}

class HomeData {
  final List<RewardItem> clubRewards;
  final List<RewardItem> featureRewards;
  final List<Banner> banners;

  HomeData({
    required this.clubRewards,
    required this.featureRewards,
    required this.banners,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    final clubRewardsList = (json['club_rewards'] as List?)?.map((item) => RewardItem.fromJson(item)).toList() ?? [];
    final featureRewardsList = (json['feature_rewards'] as List?)?.map((item) => RewardItem.fromJson(item)).toList() ?? [];
    final bannersList = (json['banners'] as List?)?.map((item) => Banner.fromJson(item)).toList() ?? [];

    return HomeData(
      clubRewards: clubRewardsList,
      featureRewards: featureRewardsList,
      banners: bannersList,
    );
  }
}

class RewardItem {
  final int id;
  final String itemName;
  final String title;
  final String priceInTokens;
  final String image;
  final String status;
  final String claimStatus;
  final String? link;
  final String itemType; // club or featured
  final String createdAt;
  final String updatedAt;

  RewardItem({
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

  factory RewardItem.fromJson(Map<String, dynamic> json) {
    return RewardItem(
      id: json['id'] ?? 0,
      itemName: json['item_name'] ?? '',
      title: json['title'] ?? '',
      priceInTokens: json['price_in_tokens'] ?? '0',
      image: json['image'] ?? '',
      status: json['status'] ?? '',
      claimStatus: json['claim_status'] ?? '0',
      link: json['link'],
      itemType: json['item_type'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class Banner {
  final int id;
  final String image;
  final String createdAt;
  final String updatedAt;

  Banner({
    required this.id,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Banner.fromJson(Map<String, dynamic> json) {
    return Banner(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}