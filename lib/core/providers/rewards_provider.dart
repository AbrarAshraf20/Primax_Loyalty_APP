// lib/providers/rewards_provider.dart
import 'package:flutter/foundation.dart';
import 'package:primax/core/di/service_locator.dart';
import 'package:primax/services/rewards_service.dart';
import '../../models/reward_model.dart';
import '../../models/reward_history_model.dart';
import '../network/api_exception.dart';
import 'profile_provider.dart';

class RewardsProvider extends ChangeNotifier {
  final RewardsService _rewardsService = locator<RewardsService>();
  final ProfileProvider _profileProvider = locator<ProfileProvider>();

  // State variables
  bool _isLoading = false;
  String _errorMessage = '';
  String _successMessage = '';

  List<Reward> _allRewards = [];
  List<Reward> _clubRewards = [];
  List<Reward> _featuredRewards = [];
  List<RewardHistory> _rewardsHistory = [];

  // Getters
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get successMessage => _successMessage;

  List<Reward> get allRewards => _allRewards;
  List<Reward> get clubRewards => _clubRewards;
  List<Reward> get featuredRewards => _featuredRewards;
  List<RewardHistory> get rewardsHistory => _rewardsHistory;

  // Get all rewards
  Future<void> getAllRewards() async {
    _setLoading(true);
    _clearError();

    try {
      final rewards = await _rewardsService.getAllRewards();
      _allRewards = rewards;

      _setLoading(false);
    } on ApiException catch (e) {
      _setError(e.message);
      _setLoading(false);
    } catch (e) {
      _setError('An unexpected error occurred');
      _setLoading(false);
    }
  }

  // Get club rewards
  Future<void> getClubRewards() async {
    _setLoading(true);
    _clearError();

    try {
      final rewards = await _rewardsService.getClubRewards();
      _clubRewards = rewards;

      _setLoading(false);
    } on ApiException catch (e) {
      _setError(e.message);
      _setLoading(false);
    } catch (e) {
      _setError('An unexpected error occurred');
      _setLoading(false);
    }
  }

  // Get featured rewards
  Future<void> getFeaturedRewards() async {
    _setLoading(true);
    _clearError();

    try {
      final rewards = await _rewardsService.getFeaturedRewards();
      _featuredRewards = rewards;

      _setLoading(false);
    } on ApiException catch (e) {
      _setError(e.message);
      _setLoading(false);
    } catch (e) {
      _setError('An unexpected error occurred');
      _setLoading(false);
    }
  }

  // Redeem a reward
  Future<bool> redeemReward(int rewardId, Map<String, String> paymentInfo,String cashornot) async {
    _setLoading(true);
    _clearError();
    _clearSuccess();

    try {
      print('Provider Debug: Starting redemption for reward $rewardId with payment info: $paymentInfo');
      
      final response = await _rewardsService.redeemReward(rewardId, paymentInfo,cashornot);
      
      print('Provider Debug: Service returned response: $response');

      final success = response['success'] as bool;
      final message = response['message'] as String;

      if (success) {
        _setSuccess(message);
        // Refresh profile to get updated points
        try {
          await _profileProvider.getProfileDetails();
          print('Provider Debug: Profile refreshed successfully');
        } catch (profileError) {
          print('Provider Debug: Error refreshing profile: $profileError');
          // Don't fail the entire operation if profile refresh fails
        }
      } else {
        _setError(message);
      }

      _setLoading(false);
      return success;
    } on ApiException catch (e) {
      print('Provider Debug: ApiException caught: ${e.message}');
      _setError(e.message);
      _setLoading(false);
      return false;
    } catch (e) {
      print('Provider Debug: General exception caught: $e');
      _setError('An unexpected error occurred: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  // Load all rewards data at once
  Future<void> loadAllRewardsData() async {
    _setLoading(true);
    _clearError();

    try {
      // Only call club rewards API
      _clubRewards = await _rewardsService.getClubRewards();

      _setLoading(false);
    } on ApiException catch (e) {
      _setError(e.message);
      _setLoading(false);
    } catch (e) {
      _setError('An unexpected error occurred');
      _setLoading(false);
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = '';
  }

  // Public method to clear error message from UI
  void clearErrorMessage() {
    _errorMessage = '';
    notifyListeners();
  }

  void _setSuccess(String message) {
    _successMessage = message;
    notifyListeners();
  }

  void _clearSuccess() {
    _successMessage = '';
  }

  // Get rewards history
  Future<void> getRewardsHistory() async {
    _setLoading(true);
    _clearError();

    try {
      final history = await _rewardsService.getRewardsHistory();
      _rewardsHistory = history;
      _setLoading(false);
    } on ApiException catch (e) {
      _setError(e.message);
      _setLoading(false);
    } catch (e) {
      _setError('An unexpected error occurred while fetching rewards history');
      _setLoading(false);
    }
  }
}