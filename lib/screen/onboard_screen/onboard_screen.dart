import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../widgets/custom_button.dart';
import '../login_screen/login_screen.dart';

class OnboardScreen extends StatefulWidget {
  @override
  _OnboardScreenState createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  final PageController _pageController = PageController();
  var _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Loyalty Program',
      'description': 'Earn points with every purchase\n and unlock exclusive rewards',


      'image': 'assets/images/purple_gift.png'
    },
    {
      'title': 'Daily Rewards',
      'description': 'Check in daily to collect bonus\n points and special prizes',


      'image': 'assets/images/Object_1.png'
    },
  ];

  Future<void> _completeOnboarding() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingComplete', true);
  }

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding().then((_) {
        // Navigate to the main app or home screen
        LoginScreen().launch(context,isNewTask: true,pageRouteAnimation: PageRouteAnimation.Fade);
      });
    }
  }

  void _skipOnboarding() {
    _completeOnboarding().then((_) {
      LoginScreen().launch(context,isNewTask: true,pageRouteAnimation: PageRouteAnimation.Fade);

      // Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.maxFinite,
            height: double.maxFinite,
            child: Image.asset(_currentPage !=1 ?'assets/images/Onboard.png':'assets/images/Onboard_2.png',fit: BoxFit.cover,),
          ),
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _onboardingData.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final data = _onboardingData[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(data['image']!, height: 350,fit: BoxFit.cover,),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(right: 60.0),
                          child: Text(
                            data['title']!,
                            style: const TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(right: 30.0),
                          child: Text(
                            data['description']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 20, color: Color(0xff707B81)),
                          ),
                        ),

                      ],
                    );
                  },
                ),
              ),
             /* Padding(
                padding: const EdgeInsets.only(left: 16.0,bottom: 10),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.,
                  children: [
                    Container(
                      height: 6,
                      width: 35,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                             Color(0xFF00C853), // Default green
                              Color(0xFF00B0FF), // Default blue
                          ],
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 3),
                    ...List.generate(
                      2,
                          (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        height: 6,
                        width: 10,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(3)
                        ),
                      ),
                    ),

                    const SizedBox(width: 110),

                    CustomButton(
                    borderRadius: 30,
                      width: 130,
                      onPressed: _nextPage,
                      text: _currentPage == _onboardingData.length - 3 ? 'Get Started' : 'Next',

                    ),

                  ],
                ),
              ),*/

              Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 10),
                child: Row(
                  children: [
                    // Smooth Page Indicator
                    SmoothPageIndicator(
                      controller: _pageController,  // PageController
                      count: _onboardingData.length, // Total pages
                      effect: ExpandingDotsEffect(
                        dotHeight: 6,
                        dotWidth: 10,
                        activeDotColor: Color(0xFF00C853),
                        dotColor: Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(width: 90),

                    CustomButton(
                      borderRadius: 30,
                      width: 130,
                      onPressed: _nextPage,
                      text: _currentPage == _onboardingData.length - 3 ? 'Get Started' : 'Next',

                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



//////

/*

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<String> _onboardingData = ["Page 1", "Page 2", "Page 3"]; // Example data

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to the next screen or home
      print("Navigate to home");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _onboardingData.length,
              itemBuilder: (context, index) {
                return Center(child: Text(_onboardingData[index])); // Replace with actual UI
              },
            ),
          ),

        ],
      ),
    );
  }
}

*/
