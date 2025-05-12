import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:primax/core/utils/app_config.dart';
import 'package:primax/screen/calaim_point_screen/claim_points_screen.dart';
import 'package:primax/screen/profile_screen/my_addresses.dart';
import 'package:primax/screen/profile_screen/personal_info.dart';
import 'package:provider/provider.dart';
import 'package:primax/core/providers/profile_provider.dart';
import 'package:primax/core/providers/auth_provider.dart';
import 'package:primax/routes/routes.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _loadProfileData();
      _isInitialized = true;
    }
  }

  // Fetch profile data when screen loads
  Future<void> _loadProfileData() async {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    await profileProvider.getProfileDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, _) {
          final user = profileProvider.userProfile;
          final isLoading = profileProvider.isLoading;
          final authProvider = Provider.of<AuthProvider>(context);

          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/LuckyDraw.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: RefreshIndicator(
              onRefresh: _loadProfileData,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Material(
                            borderRadius: BorderRadius.circular(20),
                            elevation: 2,
                            child: InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: SvgPicture.asset("assets/icons/Back.svg"),
                              ),
                            ),
                          ),
                          SizedBox(width: 70),
                          Text(
                            'User Profile',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

                    // Profile Section
                    isLoading
                        ? Center(child: CircularProgressIndicator())
                        : Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 80,
                            backgroundImage: user?.image != null
                                ? NetworkImage("${AppConfig.imageBaseUrl}${user!.image!}")
                                : AssetImage('assets/images/user_profile.png') as ImageProvider,
                          ),
                          SizedBox(height: 8),
                          Text(
                            user?.name ?? "User Name",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "ID: ${user?.id ?? "N/A"}",
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(height: 6),
                          Container(
                            width: 90,
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  const Color(0xFF00C853),
                                  const Color(0xFF00B0FF),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/icons/Group2.svg'),
                                SizedBox(width: 4),
                                Text(
                                  '${user?.tokens ?? 0}',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 16),

                    // Verification & QR Code Section
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xffF3F3F3),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatusButton(
                                SvgPicture.asset("assets/icons/Group_c.svg"),
                                // user?.isVerified ==
                                    true ? "Verified" : "Unverified",
                                // user?.isVerified ==
                                    true ? Colors.green : Colors.orange,
                              ),
                              _buildStatusButton(
                                SvgPicture.asset("assets/icons/Group_b.svg"),
                                user?.role ?? "User",
                                Colors.red,
                              ),
                              _buildStatusButton(
                                SvgPicture.asset("assets/icons/Group_a.svg"),
                                "QR Code",
                                Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Notification Box
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF00C853),
                              const Color(0xFF00B0FF),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset("assets/icons/Notification_icon.svg", color: Colors.white),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "New Messages",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "You get registration points - 300pts",
                                    style: TextStyle(color: Colors.white70, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            SvgPicture.asset("assets/icons/Vector.svg", color: Colors.white, height: 30),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Menu Items
                    _buildMenuItem("Personal Information", SvgPicture.asset("assets/icons/user.svg", color: Colors.black87), context, () {
                      // Navigate to personal info edit screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PersonalInfoScreen(),
                        ),
                      );
                    }),
                    _buildMenuItem("Address", SvgPicture.asset("assets/icons/home_a.svg", color: Colors.black87), context, () {
                      // Navigate to address management screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyAddressesScreen(),
                        ),
                      );

                    }),
                    _buildMenuItem("Claimed Points", SvgPicture.asset("assets/icons/Frame_a.svg", color: Colors.black87), context, () {
                      // Navigate to points history screen
                      launchNewScreen(context, Routes.pointsHistory);
                      // Navigator.pushNamed(context, Routes.pointsHistory);
                    }),
                    _buildMenuItemWithSwitch("Notifications", SvgPicture.asset("assets/icons/Notifications.svg", color: Colors.black87), context),
                    _buildMenuItem("Change Password", SvgPicture.asset("assets/icons/Fats_Delivery.svg", color: Colors.black87), context, () {
                      launchNewScreen(context, Routes.resetPassword);

                      // Navigate to change password screen
                    }),

                    SizedBox(height: 20),
                    Divider(
                      color: Colors.black,
                      thickness: 1.5,
                      indent: 20,
                      endIndent: 20,
                    ),
                    ListTile(
                      leading: Icon(Icons.logout, color: Colors.red),
                      title: Text("Sign Out", style: TextStyle(color: Colors.red)),
                      onTap: () async {
                        // Show confirmation dialog
                        final shouldLogout = await _showLogoutConfirmationDialog(context);

                        if (shouldLogout == true) {
                          // Logout and navigate to login screen
                          await authProvider.logout();
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            Routes.login,
                                (route) => false,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusButton(Widget icon, String label, Color color) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          radius: 22,
          child: icon,
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: color)),
      ],
    );
  }

  Widget _buildMenuItem(String title, Widget icon, BuildContext context, VoidCallback onTap) {
    return ListTile(
      leading: icon,
      title: Text(
        title,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 18),
      onTap: onTap,
    );
  }

  Widget _buildMenuItemWithSwitch(String title, Widget icon, BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isNotificationsEnabled = true; // This would come from a provider in a real app

        return ListTile(
          leading: icon,
          title: Text(
            title,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          ),
          trailing: Switch(
            value: isNotificationsEnabled,
            activeTrackColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                isNotificationsEnabled = value;
                // Update notification settings in the backend
              });
            },
          ),
        );
      },
    );
  }

  Future<bool?> _showLogoutConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sign Out'),
        content: Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Sign Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}