// lib/services/rewards_service.dart
import 'dart:convert';

import '../core/network/api_client.dart';
import '../core/network/api_exception.dart';
import '../core/di/service_locator.dart';
import '../models/reward_model.dart';
import '../models/reward_history_model.dart';

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
  Future<Map<String, dynamic>> redeemReward(int rewardId, Map<String, String> paymentInfo,String cashornot) async {
    try {
      print('Service Debug: Starting redemption for reward $rewardId');
      print('Service Debug: Payment info received: $paymentInfo');
      
      // Prepare the fields with reward ID and payment information
      Map<String, String> fields = {
        'id': rewardId.toString(),
        'cashornot':cashornot, // if cache string 1 if not string 0
      };

      // Check if cash reward or non-cash reward
      if (cashornot == "1") {
        // Cash reward - send payment information
        // fields['payment_method'] = paymentInfo['method'] ?? ''; // Easypase jazz cash
        fields['account_holder_name'] = paymentInfo['accountHolderName'] ?? ''; // Name of the account holder
        fields['account_number'] = paymentInfo['accountNumber'] ?? '';
        fields['person_name'] = '';
        fields['person_address'] = '';
        fields['person_phone'] = '';
        
        // Add bank name if payment method is bank account
        if (paymentInfo['method'] == 'bankAccount' && paymentInfo.containsKey('bankName')) {
          fields['payment_method'] = paymentInfo['bankName']!;
        }else{
          fields['payment_method'] = paymentInfo['method'] ?? ''; // Easypase jazz cash

        }
      } else {
        // Non-cash reward - send delivery information
        fields['payment_method'] = '';
        fields['account_holder_name'] = '';
        fields['account_number'] = '';
        fields['person_name'] = paymentInfo['name'] ?? '';
        fields['person_address'] = paymentInfo['address'] ?? '';
        fields['person_phone'] = paymentInfo['contactNumber'] ?? '';
      }

      print('Service Debug: Sending fields to API: $fields');

      final response = await _apiClient.postFormData(
        '/redeem',
        fields: fields,
      );
      
      print('Service Debug: API response received: ${response.data}');
      print('Service Debug: Response isSuccess: ${response.isSuccess}');
      
      // Return the response data with success status and message
      if (response.data != null) {
        final success = response.data["success"] == true || response.data["success"] == "true";
        final message = response.data["message"] ?? (success ? "Redemption successful" : "Redemption failed");
        
        return {
          'success': success,
          'message': message,
          'data': response.data
        };
      }
      
      // If no data, return default response
      return {
        'success': response.isSuccess,
        'message': response.isSuccess ? "Redemption successful" : "Redemption failed",
        'data': null
      };
    } on ApiException catch (e) {
      print('Service Debug: ApiException caught: ${e.message}');
      rethrow;
    } catch (e) {
      print('Service Debug: General exception caught: $e');
      throw ApiException(message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  // Get rewards history
  Future<List<RewardHistory>> getRewardsHistory() async {
    try {
      final response = await _apiClient.get('/rewards-history');

      if (response.data != null && response.data['data'] != null) {
        final historyData = response.data['data'] as List;
        return historyData.map((item) => RewardHistory.fromJson(item)).toList();
      } else {
        return [];
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred: ${e.toString()}');
    }
  }
}