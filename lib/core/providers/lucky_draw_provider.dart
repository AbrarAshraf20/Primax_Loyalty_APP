// lib/providers/lucky_draw_provider.dart
import 'package:flutter/material.dart';
import 'package:primax/core/di/service_locator.dart';
import 'package:primax/services/lucky_draw_service.dart';
import '../../models/lucky_draw.dart';
import '../network/api_exception.dart';


class LuckyDrawProvider extends ChangeNotifier {
  final LuckyDrawService _luckyDrawService = locator<LuckyDrawService>();

  // State variables
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  List<LuckyDraw> _luckyDraws = [];
  List<LuckyDraw> get luckyDraws => _luckyDraws;

  LuckyDraw? _selectedDraw;
  LuckyDraw? get selectedDraw => _selectedDraw;

  // Fetch all lucky draws
  Future<void> fetchLuckyDraws() async {
    _setLoading(true);
    _clearError();

    try {
      final draws = await _luckyDrawService.getLuckyDraws();
      _luckyDraws = draws;
      notifyListeners();
    } on ApiException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError('An unexpected error occurred: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Fetch a specific lucky draw
  Future<void> fetchLuckyDrawById(int id) async {
    _setLoading(true);
    _clearError();

    try {
      final draw = await _luckyDrawService.getLuckyDrawById(id);
      _selectedDraw = draw;
      notifyListeners();
    } on ApiException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError('An unexpected error occurred: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Participate in a lucky draw
  Future<bool> participateInLuckyDraw(int drawId) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _luckyDrawService.participateInLuckyDraw(drawId);
      _setLoading(false);
      return success;
    } on ApiException catch (e) {
      _setError(e.message);
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred: $e');
      _setLoading(false);
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
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = '';
  }

  void selectDraw(LuckyDraw draw) {
    _selectedDraw = draw;
    notifyListeners();
  }

  void clearSelectedDraw() {
    _selectedDraw = null;
    notifyListeners();
  }
}