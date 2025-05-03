// lib/screen/splash_screen/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/providers/auth_provider.dart';
import '../dashboard_screen/dashboard_screen.dart';
import '../login_screen/login_screen.dart';
import '../onboard_screen/onboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkNavigationFlow();
  }

  Future<void> _checkNavigationFlow() async {
    // Delay for splash animation
    await Future.delayed(const Duration(seconds: 2));

    // Check if onboarding is completed
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool onboardingComplete = prefs.getBool('onboardingComplete') ?? false;

    if (!onboardingComplete) {
      // If onboarding not completed, go to onboarding screen
      if (mounted) {
        OnboardScreen().launch(
          context,
          isNewTask: true,
          pageRouteAnimation: PageRouteAnimation.Fade,
        );
      }
      return;
    }

    // Check if user is logged in with remember me
    if (!mounted) return;

    // Get auth provider
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Check login status
    final bool isLoggedIn = await authProvider.checkSavedCredentials();

    if (isLoggedIn) {
      // If user is logged in and remembered, go to dashboard
      if (mounted) {
        DashboardScreen().launch(
          context,
          isNewTask: true,
          pageRouteAnimation: PageRouteAnimation.Fade,
        );
      }
    } else {
      // Otherwise, go to login screen
      if (mounted) {
        LoginScreen().launch(
          context,
          isNewTask: true,
          pageRouteAnimation: PageRouteAnimation.Fade,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.maxFinite,
            height: double.maxFinite,
            child: Image.asset('assets/images/img_splash.png', fit: BoxFit.cover),
          ),
          Center(child: Image.asset('assets/images/app_logo.png', height: 200, width: 200)),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Lottie.asset('assets/images/loader.json', height: 200, width: 200),
            ),
          ),
        ],
      ),
    );
  }
}