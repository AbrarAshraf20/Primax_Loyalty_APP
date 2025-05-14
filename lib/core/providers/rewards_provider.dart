// lib/providers/rewards_provider.dart
import 'package:flutter/foundation.dart';
import 'package:primax/core/di/service_locator.dart';
import 'package:primax/services/rewards_service.dart';
import '../../models/reward_model.dart';
import '../network/api_exception.dart';
import 'profile_provider.dart';

class RewardsProvider extends ChangeNotifier {
  final RewardsService _rewardsService = locator<RewardsService>();
  final ProfileProvider _profileProvider = locator<ProfileProvider>();

  // State variables
  bool _isLoading = false;
  String _errorMessage = '';

  List<Reward> _allRewards = [];
  List<Reward> _clubRewards = [];
  List<Reward> _featuredRewards = [];

  // Getters
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  List<Reward> get allRewards => _allRewards;
  List<Reward> get clubRewards => _clubRewards;
  List<Reward> get featuredRewards => _featuredRewards;

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
  Future<bool> redeemReward(int rewardId) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _rewardsService.redeemReward(rewardId);

      if (success) {
        // Refresh drawer to get updated points
        await _profileProvider.getProfileDetails();
      }

      _setLoading(false);
      return success;
    } on ApiException catch (e) {
      _setError(e.message);
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred');
      _setLoading(false);
      return false;
    }
  }

  // Load all rewards data at once
  Future<void> loadAllRewardsData() async {
    _setLoading(true);
    _clearError();

    try {
      // Run all requests in parallel
      final results = await Future.wait([
        _rewardsService.getAllRewards(),
        _rewardsService.getClubRewards(),
        _rewardsService.getFeaturedRewards(),
      ]);

      _allRewards = results[0];
      _clubRewards = results[1];
      _featuredRewards = results[2];

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
}