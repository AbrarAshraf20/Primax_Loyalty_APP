// lib/core/providers/home_provider.dart

import 'package:flutter/foundation.dart';
import 'package:primax/services/brand_service.dart';

import '../../models/brand_model.dart';

class HomeProvider extends ChangeNotifier {
  final BrandService _brandService = BrandService();

  // State variables
  bool _isBrandsLoading = false;
  String _errorMessage = '';
  List<Brand> _brands = [];
  bool _isInitialized = false;

  // Getters
  bool get isLoading => _isBrandsLoading;
  bool get isBrandsLoading => _isBrandsLoading;
  String get errorMessage => _errorMessage;
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
    } catch (e) {
      _setError('Failed to load brands: $e');
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
  }
}