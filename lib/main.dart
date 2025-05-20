// lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:primax/core/providers/lucky_draw_provider.dart';
import 'package:primax/screen/create_account_screen/create_account_screen.dart';
import 'package:primax/services/connectivity_service.dart';
import 'package:primax/widgets/custom_snackbar.dart';
import 'package:provider/provider.dart';
import 'core/di/service_locator.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/donation_provider.dart';
import 'core/providers/home_provider.dart';
import 'core/providers/network_status_provider.dart';
import 'core/providers/points_provider.dart';
import 'core/providers/profile_provider.dart';
import 'core/providers/rewards_provider.dart';
import 'core/providers/scan_provider.dart';
import 'firebase_options.dart';
import 'routes/routes.dart';

Future<void> _initializeGeolocator() async {
  // Check and request location permissions
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled - handle this case
    print('Location services are disabled.');
    return;
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again
      print('Location permissions are denied');
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle this case
    print('Location permissions are permanently denied, we cannot request permissions.');
    return;
  }

  // If we got here, permissions are granted
  print('Location permissions are granted');
}

Future<void> main() async {
  // Initialize dependency injection
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Geolocator
  await _initializeGeolocator();

  // Setup service locator
  setupServiceLocator();

  // Run app
  runApp(const MyApp());
}

// Global key for the ScaffoldMessenger - used for showing SnackBars without affecting layout
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Core services
        ChangeNotifierProvider(
          create: (_) => locator<ConnectivityService>(),
        ),

        // NetworkStatusProvider - add this provider
        ChangeNotifierProvider(
          create: (context) => NetworkStatusProvider(
            Provider.of<ConnectivityService>(context, listen: false),
          ),
        ),

        // Auth provider needs to be first as others depend on it
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),

        ChangeNotifierProvider(create: (_) => locator<HomeProvider>()),

        // Other providers
        ChangeNotifierProxyProvider<AuthProvider, ProfileProvider>(
          create: (_) => ProfileProvider(),
          update: (_, auth, profileProvider) => profileProvider!,
        ),
        ChangeNotifierProxyProvider<ProfileProvider, RewardsProvider>(
          create: (_) => RewardsProvider(),
          update: (_, profile, rewardsProvider) => rewardsProvider!,
        ),
        // ChangeNotifierProxyProvider<ProfileProvider, LuckyDrawProvider>(
        //   create: (_) => LuckyDrawProvider(),
        //   update: (_, profile, luckDrawProvider) => luckDrawProvider!,
        // ),
        ChangeNotifierProxyProvider<ProfileProvider, ScanProvider>(
          create: (_) => ScanProvider(),
          update: (_, profile, scanProvider) => scanProvider!,
        ),
        ChangeNotifierProvider<PointsProvider>(
          create: (_) => PointsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => locator<DonationProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => locator<LuckyDrawProvider>(),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Lucky Draw App',
            scaffoldMessengerKey: rootScaffoldMessengerKey, // Use global key for SnackBar management
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
              useMaterial3: true,
              // Configure SnackBar theme to appear above bottom navigation
              snackBarTheme: const SnackBarThemeData(
                behavior: SnackBarBehavior.floating,
                insetPadding: EdgeInsets.only(bottom: 90, left: 10, right: 10),
              ),
            ),
            onGenerateRoute: (settings) {
              // Debug print to verify route name
              print('Current route: ${settings.name}');

              switch (settings.name) {
                case Routes.register:
                  return MaterialPageRoute(
                    builder: (context) => CreateAccountScreen.fromRouteSettings(settings),
                  );
                default:
                // Return null to let the routes property handle other routes
                  return null;
              }
            },
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
    print('Checking route: $routeName'); // Debug print

    // Skip empty route names
    if (routeName.isEmpty) {
      return;
    }

    // Check if it's a public route first
    final List<String> publicRoutes = [
      Routes.splash,
      Routes.login,
      Routes.otp,
      Routes.forgotPassword,
      Routes.resetPassword,
      // Routes.platform,
      Routes.register,
      Routes.createAccount,
    ];

    if (publicRoutes.contains(routeName)) {
      print('Public route - allowing access');
      return;
    }

    // Only check authentication for protected routes
    if (!authProvider.isLoggedIn) {
      print('User not logged in - redirecting to login');
      navigator?.pushNamedAndRemoveUntil(
        Routes.login,
            (route) => false,
      );
    }
  }
}
