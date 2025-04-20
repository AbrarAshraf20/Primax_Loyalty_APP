// lib/core/di/service_locator.dart
import 'package:get_it/get_it.dart';
import 'package:primax/services/connectivity_service.dart';

import '../network/api_client.dart';
import '../providers/auth_provider.dart';
import '../providers/points_provider.dart';
import '../providers/profile_provider.dart';
import '../providers/rewards_provider.dart';
import '../providers/scan_provider.dart';

// Import service classes
import '../../services/auth_service.dart';
import '../../services/profile_service.dart';
import '../../services/rewards_service.dart';
import '../../services/scan_service.dart';
import '../../services/points_service.dart';



final GetIt locator = GetIt.instance;

void setupServiceLocator() {
  // Core services
  locator.registerLazySingleton<ConnectivityService>(() {
    final service = ConnectivityService();
    service.initialize();
    return service;
  });

  // API client
  locator.registerLazySingleton<ApiClient>(() => ApiClient());

  // Feature-specific services
  locator.registerLazySingleton<AuthService>(() => AuthService());
  locator.registerLazySingleton<ProfileService>(() => ProfileService());
  locator.registerLazySingleton<RewardsService>(() => RewardsService());
  locator.registerLazySingleton<ScanService>(() => ScanService());
  locator.registerLazySingleton<PointsService>(() => PointsService());

  // Register providers
  locator.registerFactory<AuthProvider>(() => AuthProvider());
  locator.registerFactory<ProfileProvider>(() => ProfileProvider());
  locator.registerFactory<RewardsProvider>(() => RewardsProvider());
  locator.registerFactory<ScanProvider>(() => ScanProvider());
  locator.registerFactory<PointsProvider>(() => PointsProvider());
}