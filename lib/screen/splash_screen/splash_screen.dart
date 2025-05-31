import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:primax/core/providers/auth_provider.dart';
import 'package:primax/core/providers/profile_provider.dart';
import 'package:primax/routes/routes.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../onboard_screen/onboard_screen.dart';
import 'package:primax/screen/create_account_screen/create_account_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String appName = 'Primax Loyalty';
  String appVersion = '';

  @override
  void initState() {
    super.initState();
    _getAppInfo();
    _initializeApp();
  }
  
  Future<void> _getAppInfo() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appName = packageInfo.appName;
      appVersion = packageInfo.version;
    });
  }

  Future<void> _initializeApp() async {
    // Give the splash screen time to display
    await Future.delayed(const Duration(seconds: 2));

    // Check if the user has completed onboarding
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool onboardingComplete = prefs.getBool('onboardingComplete') ?? false;

    if (onboardingComplete) {
      // Check if the user is already logged in
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      if (authProvider.isLoggedIn) {
        // User is logged in, load drawer data
        final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
        try {
          await profileProvider.getProfileDetails();
        } catch (e) {
          print('Error loading drawer: $e');
          // Continue to dashboard even if drawer loading fails
        }

        // Navigate to dashboard
        Navigator.pushReplacementNamed(context, Routes.dashboard);
      } else {
        // User is not logged in, navigate to login screen
        Navigator.pushReplacementNamed(context, Routes.login);
      }
    } else {
      // User hasn't completed onboarding, navigate to onboarding screen
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) =>  OnboardScreen(),
      ));
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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/splash_logo.png', height: 200, width: 200),
                const SizedBox(height: 20),
                Text(
                  appName,
                  style: const TextStyle(
                    fontSize: 28, 
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 3.0,
                        color: Color.fromARGB(150, 0, 0, 0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Version $appVersion',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 2.0,
                        color: Color.fromARGB(150, 0, 0, 0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Lottie.asset(
                'assets/images/loader.json',
                height: 200,
                width: 200,
              ),
            ),
          )
        ],
      ),
    );
  }
}