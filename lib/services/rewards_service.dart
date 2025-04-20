// lib/services/rewards_service.dart
import '../core/network/api_client.dart';
import '../core/network/api_exception.dart';
import '../core/di/service_locator.dart';
import '../models/reward_model.dart';

class RewardsService {
  final ApiClient _apiClient = locator<ApiClient>();

  // Get all rewards
  Future<List<Reward>> getAllRewards() async {
    try {
      final response = await _apiClient.get('/rewards');

      if (response.data != null && response.data['data'] != null) {
        final rewardsData = response.data['data'] as List;

        return rewardsData.map((rewardJson) => Reward.fromJson(rewardJson)).toList();
      } else {
        return [];
      }
    } on ApiException {
      rethrow;
    }
  }

  // Get club rewards
  Future<List<Reward>> getClubRewards() async {
    try {
      final response = await _apiClient.get('/club-rewards');

      if (response.data != null && response.data['data'] != null) {
        final rewardsData = response.data['data'] as List;

        return rewardsData.map((rewardJson) => Reward.fromJson(rewardJson)).toList();
      } else {
        return [];
      }
    } on ApiException {
      rethrow;
    }
  }

  // Get featured rewards
  Future<List<Reward>> getFeaturedRewards() async {
    try {
      final response = await _apiClient.get('/featured-rewards');

      if (response.data != null && response.data['data'] != null) {
        final rewardsData = response.data['data'] as List;

        return rewardsData.map((rewardJson) => Reward.fromJson(rewardJson)).toList();
      } else {
        return [];
      }
    } on ApiException {
      rethrow;
    }
  }

  // Redeem a reward
  Future<bool> redeemReward(int rewardId) async {
    try {
      final response = await _apiClient.postFormData(
        '/redeem',
        fields: {
          'id': rewardId.toString(),
        },
      );

      return response.isSuccess;
    } on ApiException {
      rethrow;
    }
  }
}