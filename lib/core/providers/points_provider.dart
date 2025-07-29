// lib/providers/points_provider.dart
import 'package:flutter/foundation.dart';
import 'package:primax/core/di/service_locator.dart';
import 'package:primax/models/claimed_point.dart';
import 'package:primax/services/points_service.dart';
import '../network/api_exception.dart';

class PointsProvider extends ChangeNotifier {
  final PointsService _pointsService = locator<PointsService>();

  // State variables
  bool _isLoading = false;
  String _errorMessage = '';
  List<ClaimedPoint> _claimedPoints = [];
  int _totalPoints = 0;

  // Getters
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<ClaimedPoint> get claimedPoints => _claimedPoints;
  int get totalPoints => _totalPoints;

  // Get claimed points history
  Future<void> getClaimedPoints() async {
    _setLoading(true);
    _clearError();

    try {
      final transactions = await _pointsService.getClaimedPoints();
      _claimedPoints = transactions;

      _setLoading(false);
    } on ApiException catch (e) {
      _setError(e.message);
      _setLoading(false);
    } catch (e) {
      _setError('An unexpected error occurred');
      _setLoading(false);
    }
  }

  // Get total points
  Future<void> getTotalPoints() async {
    _setLoading(true);
    _clearError();

    try {
      final points = await _pointsService.getTotalPoints();
      _totalPoints = points;

      _setLoading(false);
    } on ApiException catch (e) {
      _setError(e.message);
      _setLoading(false);
    } catch (e) {
      _setError('An unexpected error occurred');
      _setLoading(false);
    }
  }

  // Refresh all points data
  Future<void> refreshPointsData() async {
    _setLoading(true);
    _clearError();

    try {
      // Run all requests in parallel
      final results = await Future.wait([
        _pointsService.getClaimedPoints(),
        _pointsService.getTotalPoints(),
      ]);

      _claimedPoints = results[0] as List<ClaimedPoint>;
      _totalPoints = results[1] as int;

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

  // Update total points (called from other providers)
  void updateTotalPoints(int points) {
    _totalPoints = points;
    notifyListeners();
  }
}