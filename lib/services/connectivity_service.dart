// lib/core/services/connectivity_service.dart
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Service to check and monitor network connectivity
class ConnectivityService extends ChangeNotifier {
  // Singleton pattern
  static final ConnectivityService _instance = ConnectivityService._();
  factory ConnectivityService() => _instance;
  ConnectivityService._();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription? _connectivitySubscription;

  // Connection status
  bool _isConnected = true;
  bool get isConnected => _isConnected;

  // Stream for backwards compatibility
  final StreamController<bool> _connectionStatusController =
  StreamController<bool>.broadcast();
  Stream<bool> get connectionStatusStream => _connectionStatusController.stream;

  void initialize() {
    // Use try/catch since connectivity API has changed
    try {
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_handleConnectivityChange);
      _checkInitialConnection();
    } catch (e) {
      print('Error setting up connectivity listener: $e');
    }
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    _connectionStatusController.close();
    super.dispose();
  }

  Future<void> _checkInitialConnection() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      _handleConnectivityChange(connectivityResult);
    } catch (e) {
      print('Error checking connectivity: $e');
      // Default to connected if we can't check
      _updateConnectionStatus(true);
    }
  }

  // Handle different return types from connectivity package
  void _handleConnectivityChange(dynamic connectivityResult) {
    if (connectivityResult is List<ConnectivityResult>) {
      // New API returns a list
      final isConnected = connectivityResult.any((result) => result != ConnectivityResult.none);
      _updateConnectionStatus(isConnected);
    } else if (connectivityResult is ConnectivityResult) {
      // Old API returns a single result
      final isConnected = connectivityResult != ConnectivityResult.none;
      _updateConnectionStatus(isConnected);
    }
  }

  void _updateConnectionStatus(bool isConnected) {
    if (_isConnected != isConnected) {
      _isConnected = isConnected;

      // Notify Provider listeners
      notifyListeners();

      // Notify stream listeners
      if (!_connectionStatusController.isClosed) {
        _connectionStatusController.add(isConnected);
      }
    }
  }

  // Check connectivity on demand
  Future<bool> checkConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();

      if (result is List<ConnectivityResult>) {
        return result.any((r) => r != ConnectivityResult.none);
      } else if (result is ConnectivityResult) {
        return result != ConnectivityResult.none;
      }

      return true; // Default if unknown result type
    } catch (e) {
      print('Error checking connectivity: $e');
      return true; // Default to true if we can't check
    }
  }
}