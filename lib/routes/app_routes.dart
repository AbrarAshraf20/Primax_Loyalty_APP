// lib/routes/app_routes.dart
import 'package:flutter/material.dart';
import 'package:primax/screen/create_account_screen/create_account_screen.dart';
import 'package:primax/screen/scan/veryfiyserial.dart';

// Import all your screens here
import '../screen/splash_screen/splash_screen.dart';
import '../screen/login_screen/login_screen.dart';
import '../screen/login_screen/enter_otp.dart';
import '../screen/dashboard_screen/dashboardscreen1.dart';
import '../screen/home_screen/home_screen.dart';
import '../screen/profile/user_profilescreen.dart';
import '../screen/scan/scan_screen.dart';
import '../screen/reward_screen.dart';
import '../screen/luckdraw_screen.dart';
import '../screen/donation_screen.dart';
import '../screen/forgot_passowrd/forgot_password.dart';
import '../screen/reset_password/reset_password.dart';
import '../screen/reset_password/set_password.dart';
import '../screen/homescreen.dart';

class AppRoutes {
  // Private constructor to prevent instantiation
  AppRoutes._();

  // Route names as constants
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String otp = '/otp';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String setPassword = '/set-password';

  static const String dashboard = '/dashboard';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';

  static const String scan = '/scan';
  static const String verifySerial = '/verify-serial';

  static const String rewards = '/rewards';
  static const String rewardDetails = '/reward-details';
  static const String luckyDraw = '/lucky-draw';
  static const String donation = '/donation';
  static const String pointsHistory = '/points-history';

  // Define routes
  static final Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const CreateAccountScreen(role: 'User'),
    otp: (context) => OtpScreen(),
    forgotPassword: (context) => const ForgotPassword(),
    resetPassword: (context) => const ResetPassword(),
    setPassword: (context) => const SetPassword(),

    dashboard: (context) => DashboardScreen1(),
    home: (context) => HomeScreen1(),
    profile: (context) => UserProfileScreen(),

    scan: (context) =>  ScanScreen(),
    verifySerial: (context) => const VerifySerial(),

    rewards: (context) =>  RewardScreen(),
    luckyDraw: (context) => LuckyDrawScreen(),
    donation: (context) => DonationScreen(),
    // pointsHistory: (context) =>  PointsHistoryScreen(),
  };

  // Routes that require parameters can be handled with onGenerateRoute
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case rewardDetails:
      // Example of handling route with parameters
        final args = settings.arguments as Map<String, dynamic>;
        final rewardId = args['rewardId'] as int;
        return MaterialPageRoute(
          builder: (_) => RewardDetailsScreen(rewardId: rewardId),
          settings: settings,
        );

    // Add more dynamic routes as needed

      default:
      // If the route is not recognized, return to dashboard
        return MaterialPageRoute(
          builder: (_) => DashboardScreen1(),
        );
    }
  }

  // Navigation helper methods

  /// Navigate to a new screen
  static Future<T?> navigateTo<T>(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.pushNamed<T>(context, routeName, arguments: arguments);
  }

  /// Navigate to a new screen and replace the current one
  static Future<T?> navigateAndReplace<T>(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.pushReplacementNamed<T, dynamic>(context, routeName, arguments: arguments);
  }

  /// Navigate to a new screen and clear the navigation stack
  static Future<T?> navigateAndClearStack<T>(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.pushNamedAndRemoveUntil<T>(
        context,
        routeName,
            (Route<dynamic> route) => false,
        arguments: arguments
    );
  }

  /// Navigate back to the previous screen
  static void goBack<T>(BuildContext context, [T? result]) {
    Navigator.pop<T>(context, result);
  }

  /// Pop until a specific route
  static void popUntil(BuildContext context, String routeName) {
    Navigator.popUntil(context, ModalRoute.withName(routeName));
  }

  /// Check if can go back
  static bool canGoBack(BuildContext context) {
    return Navigator.canPop(context);
  }

  // Helper methods for specific navigation scenarios

  /// Navigate to login screen and clear stack
  static void goToLogin(BuildContext context) {
    navigateAndClearStack(context, login);
  }

  /// Navigate to dashboard after login
  static void goToDashboard(BuildContext context) {
    navigateAndClearStack(context, dashboard);
  }

  /// Navigate to reward details screen with reward ID
  static void goToRewardDetails(BuildContext context, int rewardId) {
    navigateTo(
      context,
      rewardDetails,
      arguments: {'rewardId': rewardId},
    );
  }

  /// Navigate to OTP screen with email/phone
  static void goToOtp(BuildContext context, String identifier) {
    navigateTo(
      context,
      otp,
      arguments: {'identifier': identifier},
    );
  }

  /// Show a dialog
  static Future<T?> showAppDialog<T>(BuildContext context, Widget dialog) {
    return showDialog<T>(
      context: context,
      builder: (BuildContext context) => dialog,
      barrierDismissible: false,
    );
  }

  /// Show a bottom sheet
  static Future<T?> showAppBottomSheet<T>(BuildContext context, Widget bottomSheet) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true, // Makes it expandable
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => bottomSheet,
    );
  }
}

// Placeholder for a reward details screen
class RewardDetailsScreen extends StatelessWidget {
  final int rewardId;

  const RewardDetailsScreen({Key? key, required this.rewardId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reward Details')),
      body: Center(child: Text('Reward ID: $rewardId')),
    );
  }
}