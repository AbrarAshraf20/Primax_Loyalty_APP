// lib/services/points_service.dart
import '../core/network/api_client.dart';
import '../core/network/api_exception.dart';
import '../core/di/service_locator.dart';
import '../models/claimed_point.dart';

class PointsService {
  final ApiClient _apiClient = locator<ApiClient>();

  // Get claimed points history
  Future<List<ClaimedPoint>> getClaimedPoints() async {
    try {
      final response = await _apiClient.get('/claimed_points');

      if (response.data != null && response.data['success'] == true && response.data['data'] != null) {
        final transactionsData = response.data['data'] as List;

        return transactionsData
            .map((transactionJson) => ClaimedPoint.fromJson(transactionJson))
            .toList();
      } else {
        return [];
      }
    } on ApiException {
      rethrow;
    }
  }
  // Get user's total points
  Future<int> getTotalPoints() async {
    try {
      final response = await _apiClient.get('/profile-details');

      if (response.data != null) {
        final userData = response.data['user'] ?? response.data;
        return userData['points'] ?? 0;
      } else {
        return 0;
      }
    } on ApiException {
      rethrow;
    }
  }
}