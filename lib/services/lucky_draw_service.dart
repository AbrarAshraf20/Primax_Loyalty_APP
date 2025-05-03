// lib/services/lucky_draw_service.dart
import '../core/network/api_client.dart';
import '../core/network/api_exception.dart';
import '../models/lucky_draw.dart';

class LuckyDrawService {
  final ApiClient _apiClient = ApiClient();

  // Get all lucky draws
  Future<List<LuckyDraw>> getLuckyDraws() async {
    try {
      final response = await _apiClient.get(
        '/lucky-draws',
        requiresAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> drawsData = response.data['data'] ?? [];
        return drawsData
            .map((item) => LuckyDraw.fromJson(item))
            .toList();
      } else {
        throw ApiException(message: 'Failed to load lucky draws');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  // Enter a lucky draw
  Future<bool> enterLuckyDraw(int drawId) async {
    try {
      final response = await _apiClient.post(
        '/enter-user',
        body: {
          'lucky_draw_id': drawId,
        },
        requiresAuth: true,
      );

      return response.isSuccess;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  // Get lucky draw winners
  Future<List<Map<String, dynamic>>> getLuckyDrawWinners(int drawId) async {
    try {
      final response = await _apiClient.get(
        '/lucky-draws/$drawId/winners',
        requiresAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> winnersData = response.data['data'] ?? [];
        return winnersData.cast<Map<String, dynamic>>();
      } else {
        throw ApiException(message: 'Failed to load winners');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred: ${e.toString()}');
    }
  }
}