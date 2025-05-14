// lib/core/providers/home_provider.dart

import 'package:flutter/foundation.dart';
import 'package:primax/services/brand_service.dart';

import '../../models/brand_model.dart';

class HomeProvider extends ChangeNotifier {
  final BrandService _brandService = BrandService();

  // State variables
  bool _isBrandsLoading = false;
  String _errorMessage = '';
  bool _isUnauthorized = false;
  List<Brand> _brands = [];
  bool _isInitialized = false;

  // Getters
  bool get isLoading => _isBrandsLoading;
  bool get isBrandsLoading => _isBrandsLoading;
  String get errorMessage => _errorMessage;
  bool get isUnauthorized => _isUnauthorized;
  List<Brand> get brands => _brands;

  // Constructor
  HomeProvider();

  // Initialize provider - call this after widget is built
  Future<void> initialize() async {
    if (!_isInitialized) {
      await fetchBrands();
      _isInitialized = true;
    }
  }

  // Fetch brands from Firestore
  Future<void> fetchBrands() async {
    _setBrandsLoading(true);
    _clearError();

    try {
      _brands = await _brandService.getBrands();
      _isUnauthorized = false;
    } catch (e) {
      _setError('Failed to load brands: $e');
      // Check if error is unauthorized
      if (e.toString().toLowerCase().contains('unauthorized') ||
          e.toString().toLowerCase().contains('401')) {
        _isUnauthorized = true;
        _setError('Your session has expired. Please login again.');
      }
    } finally {
      _setBrandsLoading(false);
    }
  }

  // Refresh data
  Future<void> refreshData() async {
    return fetchBrands();
  }

  // Helper methods
  void _setBrandsLoading(bool loading) {
    _isBrandsLoading = loading;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = '';
    _isUnauthorized = false;
  }
}