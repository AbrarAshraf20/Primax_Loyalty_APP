// lib/core/di/service_locator.dart
import 'package:get_it/get_it.dart';
import 'package:primax/core/providers/home_provider.dart';
import 'package:primax/core/providers/lucky_draw_provider.dart';
import 'package:primax/services/connectivity_service.dart';
import 'package:primax/services/home_service.dart';
import 'package:primax/services/lucky_draw_service.dart';

import '../../services/donation_service.dart' show DonationService;
import '../network/api_client.dart';
import '../providers/auth_provider.dart';
import '../providers/donation_provider.dart';
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
  locator.registerLazySingleton<HomeService>(() => HomeService());
  locator.registerLazySingleton<ProfileService>(() => ProfileService());
  locator.registerLazySingleton<RewardsService>(() => RewardsService());
  locator.registerLazySingleton<ScanService>(() => ScanService());
  locator.registerLazySingleton<PointsService>(() => PointsService());
  locator.registerLazySingleton<DonationService>(() => DonationService());
  locator.registerLazySingleton<LuckyDrawService>(() => LuckyDrawService());


  // Register providers

  // Register providers
  locator.registerFactory<AuthProvider>(() => AuthProvider());
  locator.registerFactory<HomeProvider>(() => HomeProvider());
  locator.registerFactory<ProfileProvider>(() => ProfileProvider());
  locator.registerFactory<RewardsProvider>(() => RewardsProvider());
  locator.registerFactory<ScanProvider>(() => ScanProvider());
  locator.registerFactory<PointsProvider>(() => PointsProvider());
  locator.registerFactory<DonationProvider>(() => DonationProvider());
  locator.registerFactory<LuckyDrawProvider>(() => LuckyDrawProvider());


}