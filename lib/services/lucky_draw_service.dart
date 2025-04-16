// lib/services/lucky_draw_service.dart
import 'package:primax/models/lucky_draw.dart';

import '../core/network/api_client.dart';
import '../core/network/api_exception.dart';
import '../core/di/service_locator.dart';

/// Service class for lucky draw-related API endpoints
class LuckyDrawService {
  // Get ApiClient from service locator
  final ApiClient _apiClient = locator<ApiClient>();

  // Get all lucky draws
  Future<List<LuckyDraw>> getLuckyDraws() async {
    try {
      final response = await _apiClient.get('/lucky-draws');

      // Parse the response data into models objects
      final List<dynamic> drawsList = response.data['data'];
      return drawsList.map((json) => LuckyDraw.fromJson(json)).toList();
    } on ApiException catch (e) {
      // You can handle specific error cases here
      throw e;
    }
  }

  // Get a specific lucky draw by ID
  Future<LuckyDraw> getLuckyDrawById(int id) async {
    try {
      final response = await _apiClient.get('/lucky-draws/$id');
      return LuckyDraw.fromJson(response.data['data']);
    } on ApiException catch (e) {
      throw e;
    }
  }

  // Participate in a lucky draw
  Future<bool> participateInLuckyDraw(int drawId) async {
    try {
      final response = await _apiClient.post(
        '/lucky-draws/$drawId/participate',
        requiresAuth: true,
      );
      return response.isSuccess;
    } on ApiException catch (e) {
      throw e;
    }
  }

  // Get raw JSON response for a custom endpoint
  Future<Map<String, dynamic>> getCustomData(String endpoint, {Map<String, dynamic>? queryParams}) async {
    try {
      final response = await _apiClient.get(
        endpoint,
        queryParams: queryParams,
      );
      return response.data;
    } on ApiException catch (e) {
      throw e;
    }
  }
}