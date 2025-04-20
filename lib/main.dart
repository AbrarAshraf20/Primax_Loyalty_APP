// lib/main.dart
import 'package:flutter/material.dart';
import 'package:primax/services/connectivity_service.dart';
import 'package:provider/provider.dart';
import 'core/di/service_locator.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/points_provider.dart';
import 'core/providers/profile_provider.dart';
import 'core/providers/rewards_provider.dart';
import 'core/providers/scan_provider.dart';
import 'routes/routes.dart';


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

        // Auth provider needs to be first as others depend on it
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),

        // Other providers
        ChangeNotifierProxyProvider<AuthProvider, ProfileProvider>(
          create: (_) => ProfileProvider(),
          update: (_, auth, profileProvider) => profileProvider!,
        ),
        ChangeNotifierProxyProvider<ProfileProvider, RewardsProvider>(
          create: (_) => RewardsProvider(),
          update: (_, profile, rewardsProvider) => rewardsProvider!,
        ),
        ChangeNotifierProxyProvider<ProfileProvider, ScanProvider>(
          create: (_) => ScanProvider(),
          update: (_, profile, scanProvider) => scanProvider!,
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
            initialRoute: Routes.splash,
            routes: Routes.routes,
            // Use a navigation observer to handle authentication state
            navigatorObservers: [
              AuthNavigationObserver(authProvider),
            ],
          );
        },
      ),
    );
  }
}

/// Observer to handle navigation based on authentication state
class AuthNavigationObserver extends NavigatorObserver {
  final AuthProvider authProvider;

  AuthNavigationObserver(this.authProvider);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _checkAuthenticationForRoute(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _checkAuthenticationForRoute(newRoute);
    }
  }

  void _checkAuthenticationForRoute(Route<dynamic> route) {
    // Skip checking for certain routes
    final String routeName = route.settings.name ?? '';

    if (routeName == Routes.splash ||
        routeName == Routes.login ||
        routeName == Routes.otp ||
        routeName == Routes.forgotPassword ||
        routeName == Routes.resetPassword ||
        routeName == Routes.register) {
      return;
    }

    // Check if user is authenticated for protected routes
    if (!authProvider.isLoggedIn) {
      // If not authenticated, redirect to login after a short delay
      Future.delayed(const Duration(milliseconds: 100), () {
        navigator?.pushNamedAndRemoveUntil(
          Routes.login,
              (route) => false,
        );
      });
    }
  }
}