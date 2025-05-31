// lib/core/providers/lucky_draw_provider.dart
import 'package:flutter/foundation.dart';
import 'package:primax/core/di/service_locator.dart';
import 'package:primax/models/lucky_draw.dart';
import 'package:primax/services/lucky_draw_service.dart';
import '../network/api_exception.dart';

class LuckyDrawProvider extends ChangeNotifier {
  final LuckyDrawService _luckyDrawService = locator<LuckyDrawService>();

  // State variables
  bool _isLoading = false;
  String _errorMessage = '';
  List<LuckyDraw> _luckyDraws = [];
  LuckyDraw? _selectedDraw;

  // Getters
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<LuckyDraw> get luckyDraws => _luckyDraws;
  LuckyDraw? get selectedDraw => _selectedDraw;

  // Fetch all lucky draws
  Future<void> fetchLuckyDraws() async {
    _setLoading(true);
    _clearErrors();

    try {
      final fetchedDraws = await _luckyDrawService.getLuckyDraws();
      _luckyDraws = fetchedDraws;
      _setLoading(false);
    } on ApiException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError('Failed to load lucky draws: ${e.toString()}');
    }
  }

  // Select a lucky draw
  void selectDraw(LuckyDraw draw) {
    _selectedDraw = draw;
    notifyListeners();
  }

  // Enter a lucky draw
  Future<bool> enterLuckyDraw(int drawId, Map<String, String> paymentInfo, String cashornot) async {
    _setLoading(true);
    _clearErrors();

    try {
      final success = await _luckyDrawService.enterLuckyDraw(drawId, paymentInfo, cashornot);
      _setLoading(false);
      return success;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Failed to enter lucky draw: ${e.toString()}');
      return false;
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _isLoading = false;
    notifyListeners();
  }

  void _clearErrors() {
    _errorMessage = '';
    notifyListeners();
  }
}