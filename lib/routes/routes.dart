// lib/routes/routes.dart
import 'package:flutter/material.dart';
import 'package:primax/screen/calaim_point_screen/claim_points_screen.dart';
import 'package:primax/screen/create_account_screen/create_account_screen.dart';
import 'package:primax/screen/platform_screen/platform_screen.dart';
import 'package:primax/screen/lucky_draw/lucky_draw_detail_screen.dart';
import 'package:primax/screen/lucky_draw/lucky_draw_screen.dart';
import 'package:primax/screen/scan/veryfiyserial.dart';

// Import screens
import '../screen/login_screen/enter_otp.dart';
import '../screen/splash_screen/splash_screen.dart';
import '../screen/login_screen/login_screen.dart';
import '../screen/profile_screen/user_profilescreen.dart';
import '../screen/scan/scan_screen.dart';
import '../screen/reward_screen.dart';
import '../screen/luckdraw_screen.dart';
import '../screen/donation_screen.dart';
import '../screen/dashboard_screen/dashboard_screen.dart';
import '../screen/dashboard_screen/dashboard_screen.dart';
import '../screen/forgot_passowrd/forgot_password.dart';
import '../screen/reset_password/reset_password.dart';
import '../screen/reset_password/set_password.dart';
import '../screen/homescreen.dart';

// Define routes
class Routes {
  // Route names
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String platform = '/platform';
  static const String otp = '/otp';
  static const String home = '/home';
  static const String dashboard = '/dashboard';
  static const String profile = '/drawer';
  static const String scan = '/scan';
  static const String verifySerial = '/verify-serial';
  static const String rewards = '/rewards';
  static const String luckyDraw = '/lucky-draw';
  static const String luckyDrawDetails = '/lucky-draw-details';
  static const String donation = '/donation';
  static const String pointsHistory = '/points-history';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String setPassword = '/set-password';

  // Route map
  static final Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    otp: (context) => OtpScreen(email: '',),
    home: (context) => HomeScreen1(),
    dashboard: (context) => DashboardScreen(),
    profile: (context) => UserProfileScreen(),
    scan: (context) =>  ScanScreen(),
    // verifySerial: (context) =>  VerifySerial(),
    rewards: (context) =>  RewardScreen(),
    luckyDraw: (context) => LuckyDrawScreen(),
    luckyDrawDetails: (context) => LuckyDrawDetailScreen(),
    donation: (context) => DonationScreen(),
    platform: (context) => PlatformScreen(),
    pointsHistory: (context) =>  ClaimedPointsScreen(),
    forgotPassword: (context) => const ForgotPassword(),
    resetPassword: (context) => const ResetPassword(),
    setPassword: (context) => const SetPassword(),
  };

  // Navigation helper methods
  static void navigateTo(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  static void navigateAndReplace(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  static void navigateAndClearStack(BuildContext context, String routeName) {
    Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
  }

  // Authentication state-aware navigation
  static void navigateAfterLogin(BuildContext context) {
    navigateAndClearStack(context, dashboard);
  }

  static void navigateAfterLogout(BuildContext context) {
    navigateAndClearStack(context, login);
  }
  // static Route<dynamic> generateRoute(RouteSettings settings) {
  //   switch (settings.name) {
  //     case splash:
  //       return MaterialPageRoute(builder: (_) => SplashScreen());
  //
  //     case login:
  //       return MaterialPageRoute(builder: (_) => LoginScreen());
  //
  //     case register:
  //     // Handle route arguments for CreateAccountScreen
  //       return MaterialPageRoute(
  //         settings: settings, // Important: Pass the settings to access arguments
  //         builder: (context) => CreateAccountScreen.fromRouteArguments(context),
  //       );
  //
  //     case otp:
  //     // Handle route arguments for OtpScreen
  //       final args = settings.arguments as Map<String, dynamic>?;
  //       final email = args?['email'] as String? ?? '';
  //       return MaterialPageRoute(builder: (_) => OtpScreen(email: email));
  //
  //     case dashboard:
  //       return MaterialPageRoute(builder: (_) => DashboardScreen());
  //
  //     default:
  //       return MaterialPageRoute(
  //         builder: (_) => Scaffold(
  //           body: Center(
  //             child: Text('No route defined for ${settings.name}'),
  //           ),
  //         ),
  //       );
  //   }
  // }
}

// Update the main.dart to use these routes:
/*
void main() {
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ... your providers
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lucky Draw App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        initialRoute: Routes.splash,
        routes: Routes.routes,
      ),
    );
  }
}
*/