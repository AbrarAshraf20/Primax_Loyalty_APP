import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:primax/core/providers/profile_provider.dart';
import 'package:primax/screen/donation_screen.dart';
import 'package:primax/screen/luckdraw_screen.dart';
import 'package:primax/screen/reward_screen.dart';
import 'package:primax/screen/scan/scan_screen.dart';

import '../lucky_draw/lucky_draw_screen.dart';
import '../homescreen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 2; // Default selected item (Home)

  final List<Widget> _pages = [
    ScanScreen(),
    RewardScreen(),
    HomeScreen1(),
    LuckyDrawScreen(),
    DonationScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Schedule the drawer data loading AFTER the first build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  // Fetch user data when dashboard loads
  Future<void> _loadUserData() async {
    try {
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      await profileProvider.getProfileDetails();
    } catch (e) {
      print('Error loading user data: $e');
      // You could show a snackbar here if needed
    }
  }

  // Handle back button press

  Future<bool> _onWillPop() async {
    if (_selectedIndex != 2) {
      // If not on home screen, navigate to home screen
      setState(() {
        _selectedIndex = 2;
      });
      return false;
    } else {
      // On home screen, show exit dialog
      bool shouldExit = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Exit App'),
          content: Text('Are you sure you want to exit?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Yes'),
            ),
          ],
        ),
      ) ?? false;

      return shouldExit; // Return the user's choice
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true, // Extend the body behind the bottom app bar
        body: Stack(
          children: [
            // Main content that fills the screen
            IndexedStack(
              index: _selectedIndex,
              children: _pages.map((page) {
                // Add bottom padding to each page to ensure content isn't hidden behind the nav bar
                return Padding(
                  padding: EdgeInsets.only(bottom: 80),
                  child: page,
                );
              }).toList(),
            ),
          ],
        ),

      // Fixed bottom app bar that won't move with keyboard
      bottomNavigationBar: _buildBottomNavBar(),

      // Floating action button stays with the bottom app bar
      floatingActionButton: Container(
        height: 60,
        width: 60,
        margin: EdgeInsets.only(top: 10), // Adjust position to make it more visible
        child: FloatingActionButton(
          elevation: 8,
          onPressed: () {
            setState(() {
              _selectedIndex = 2; // Home selected
            });
          },
          backgroundColor: Colors.green,
          shape: const CircleBorder(),
          child: Image.asset(
            "assets/images/app_home.png",
            width: 50,
            height: 50,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      height: 90, // Increased height to accommodate text
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8,
            spreadRadius: 3,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomAppBar(
        height: 80,
        elevation: 0,
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0, // Increased notch margin for clearer space around home button
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Left side of the bottom nav bar
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem("assets/icons/Group.svg", "Scan", 0),
                  _buildNavItem("assets/icons/Group3.svg", "Rewards", 1),
                ],
              ),
            ),

            // Empty space for floating action button
            SizedBox(width: 60),
            // Right side of the bottom nav bar
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // _customLuckyDrawNavItem("assets/icons/Group5.svg", 3),
                  _buildNavItem("assets/icons/Group4.svg", "Lucky Draw", 3),

                  _buildNavItem("assets/icons/Group4.svg", "Donate", 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Special custom item for Lucky Draw with precise text sizing
  Widget _customLuckyDrawNavItem(String assetPath, int index) {
    bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        width: 70, // Fixed width to prevent overflow
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              assetPath,
              width: 24,
              height: 24,
              color: isSelected ? Colors.green : Colors.grey,
            ),
            const SizedBox(height: 4),
            // Split "Lucky Draw" into two separate text widgets
            Text(
              "Lucky Draw",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(String assetPath, String label, int index) {
    bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        width: 70, // Fixed width to prevent overflow
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              assetPath,
              width: 24,
              height: 24,
              color: isSelected ? Colors.green : Colors.grey,
            ),
            const SizedBox(height: 4),
            Container(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.green : Colors.grey,
                ),
                maxLines: 1,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
      ),
    );
  }
}