// lib/services/home_service.dart

import 'package:primax/core/di/service_locator.dart';
import 'package:primax/core/network/api_client.dart';

import '../models/home_response.dart';

class HomeService {
  final ApiClient _apiClient = locator<ApiClient>();

  // Fetch home data
  Future<HomeResponse> getHomeData() async {
    try {
      final response = await _apiClient.get('/home', requiresAuth: true);
      return HomeResponse.fromJson(response.data,);
    } catch (e) {
      rethrow;
    }
  }
}