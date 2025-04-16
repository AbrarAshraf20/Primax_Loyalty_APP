// lib/main.dart
import 'package:flutter/material.dart';
import 'package:primax/routes/app_routes.dart';
import 'package:primax/screen/splash_screen/splash_screen.dart';
import 'package:primax/services/connectivity_service.dart';
import 'package:provider/provider.dart';
import 'core/di/service_locator.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/points_provider.dart';
import 'core/providers/profile_provider.dart';
import 'core/providers/rewards_provider.dart';
import 'core/providers/scan_provider.dart';

void main() {
  // Initialize dependency injection
  setupServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Core services
        ChangeNotifierProvider<ConnectivityService>(
          create: (_) => locator<ConnectivityService>(),
        ),

        // Create AuthProvider first - VERY IMPORTANT since others depend on it
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),

        // Other providers
        ChangeNotifierProvider<ProfileProvider>(
          create: (_) => ProfileProvider(),
        ),
        ChangeNotifierProvider<RewardsProvider>(
          create: (_) => RewardsProvider(),
        ),
        ChangeNotifierProvider<ScanProvider>(
          create: (_) => ScanProvider(),
        ),
        ChangeNotifierProvider<PointsProvider>(
          create: (_) => PointsProvider(),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Lucky Draw App',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
              useMaterial3: true,
            ),
            // home: SplashScreen(),
            // Use named routes for navigation
            initialRoute: AppRoutes.splash,
            routes: AppRoutes.routes,
          );
        },
      ),
    );
  }
}