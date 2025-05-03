import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:primax/screen/donation_screen.dart';
import 'package:primax/screen/luckdraw_screen.dart';
import 'package:primax/screen/lucky_draw/lucky_draw_screen.dart';
import 'package:primax/screen/reward_screen.dart';
import 'package:primax/screen/scan/scan_screen.dart';

import '../profile/drawer.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      body: IndexedStack(
        index: _selectedIndex, // Keeps state when switching tabs
        children: _pages,
      ),
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _selectedIndex = 2; // Home selected
          });
        },
        backgroundColor: Colors.green,
        shape: const CircleBorder(),
        child: SvgPicture.asset("assets/icons/home.svg",
            width: 30, height: 30, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration:  BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300, // Shadow color
            blurRadius: 8, // Softness of the shadow
            spreadRadius: 3, // How much the shadow spreads
            offset: Offset(0, -2), // Moves the shadow upwards
          ),
        ],
      ),
      child: BottomAppBar(
        elevation: 0, // Elevation removed (handled by the shadow)
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                  child: _buildNavItem("assets/icons/Group.svg", "Scan", 0)),
              Expanded(
                  child: _buildNavItem("assets/icons/Group3.svg", "Rewards", 1)),
              const Expanded(child: SizedBox()), // Empty space for FloatingActionButton
              Expanded(
                  child: _buildNavItem("assets/icons/Group5.svg", "Lucky Draw", 3)),
              Expanded(
                  child: _buildNavItem("assets/icons/Group4.svg", "Donations", 4)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(String assetPath, String label, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(assetPath,
              width: 28,
              height: 28,
              color: _selectedIndex == index ? Colors.green : Colors.grey),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: _selectedIndex == index ? Colors.green : Colors.grey)),
        ],
      ),
    );
  }
}
