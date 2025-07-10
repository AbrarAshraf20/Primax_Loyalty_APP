import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:primax/core/utils/app_config.dart';
import 'package:primax/screen/profile_screen/my_addresses.dart';
import 'package:primax/screen/profile_screen/personal_info.dart';
import 'package:provider/provider.dart';
import 'package:primax/core/providers/profile_provider.dart';
import 'package:primax/core/providers/auth_provider.dart';
import 'package:primax/routes/routes.dart';

class UserProfileScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;
  
  const UserProfileScreen({Key? key, this.onBackPressed}) : super(key: key);
  
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Schedule the profile data loading after the current frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfileData();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Don't load data here as it can cause setState during build
  }

  // Fetch drawer data when screen loads
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
                              onTap: widget.onBackPressed ?? () => Navigator.pop(context),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(CupertinoIcons.back,color: Colors.black,),
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
                            backgroundImage: user?.image != null && user!.image!.isNotEmpty
                                ? NetworkImage(
                                    user.image!.startsWith('http')
                                      ? user.image!
                                      : "${AppConfig.imageBaseUrl}${user.image!}"
                                  )
                                : AssetImage('assets/images/user_profile.png') as ImageProvider,
                            onBackgroundImageError: (exception, stackTrace) {
                              // If image fails to load, fall back to default
                              print('Error loading profile image: $exception');
                            },
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
                              mainAxisSize: MainAxisSize.min,
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
                                SvgPicture.asset("assets/icons/verification.svg"),
                                // Check email verification status (emailVerifiedAt is not null)
                                user?.emailVerifiedAt != null ? "Verified" : "Unverified",
                                user?.emailVerifiedAt != null ? Colors.green : Colors.orange,
                              ),
                              _buildStatusButton(
                               user?.role =='Installer' ? SvgPicture.asset("assets/icons/installer.svg")
                                :user?.role =='Dealer'?SvgPicture.asset("assets/icons/dealer.svg")
                                :SvgPicture.asset("assets/icons/distributer.svg"),
                                // Capitalize the first letter of the role and handle null cases
                                user?.role != null
                                    ? user!.role!.isNotEmpty
                                        ? user.role![0].toUpperCase() + user.role!.substring(1).toLowerCase()
                                        : "User"
                                    : "User",
                                Colors.red,
                              ),
                              // _buildStatusButton(
                              //   SvgPicture.asset("assets/icons/qr_code.svg"),
                              //   "QR Code",
                              //   Colors.black,
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Notification Box
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 16),
                    //   child: Container(
                    //     padding: EdgeInsets.all(12),
                    //     decoration: BoxDecoration(
                    //       gradient: LinearGradient(
                    //         colors: [
                    //           const Color(0xFF00C853),
                    //           const Color(0xFF00B0FF),
                    //         ],
                    //       ),
                    //       borderRadius: BorderRadius.circular(8),
                    //     ),
                    //     child: Row(
                    //       children: [
                    //         SvgPicture.asset("assets/icons/notification.svg", color: Colors.white),
                    //         SizedBox(width: 10),
                    //         Expanded(
                    //           child: Column(
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               Text(
                    //                 "New Messages",
                    //                 style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    //               ),
                    //               Text(
                    //                 "You get registration points - 300pts",
                    //                 style: TextStyle(color: Colors.white70, fontSize: 12),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //         SvgPicture.asset("assets/icons/Vector.svg", color: Colors.white, height: 30),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 16),

                    // Menu Items
                    _buildMenuItem("Personal Information", SvgPicture.asset("assets/icons/user.svg", color: Colors.black87), context, () {
                      // Navigate to personal info edit screen and refresh on return
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PersonalInfoScreen(),
                        ),
                      ).then((_) {
                        // Force refresh profile data when returning from edit screen
                        _loadProfileData();
                      });
                    }),
                    _buildMenuItem("Address", SvgPicture.asset("assets/icons/home.svg", color: Colors.black87), context, () {
                      // Navigate to address management screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyAddressesScreen(),
                        ),
                      );

                    }),
                    _buildMenuItem("Claimed Points", SvgPicture.asset("assets/icons/messages.svg", color: Colors.black87), context, () {
                      // Navigate to points history screen
                      launchNewScreen(context, Routes.pointsHistory);
                      // Navigator.pushNamed(context, Routes.pointsHistory);
                    }),
                    _buildMenuItem("History", Icon(Icons.card_giftcard, color: Colors.black87), context, () {
                      // Navigate to rewards history screen
                      Navigator.pushNamed(context, Routes.rewardsHistory);
                    }),
                    // _buildMenuItemWithSwitch("Notifications", SvgPicture.asset("assets/icons/notification.svg", color: Colors.black87), context),
                    _buildMenuItem("Change Password", SvgPicture.asset("assets/icons/lock.svg", color: Colors.black87), context, () {
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
                    ListTile(
                      leading: Icon(Icons.delete_forever, color: Colors.red),
                      title: Text("Delete Account", style: TextStyle(color: Colors.red)),
                      onTap: () async {
                        // Show confirmation dialog
                        final shouldDelete = await _showDeleteAccountConfirmationDialog(context);

                        if (shouldDelete == true) {
                          // Delete account
                          await _deleteAccount(authProvider);
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

  Future<bool?> _showDeleteAccountConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Delete Account'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to permanently delete your account?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('This action cannot be undone and will:'),
            SizedBox(height: 8),
            Text('• Delete all your personal information'),
            Text('• Remove all your points and rewards'),
            Text('• Cancel any pending claims'),
            Text('• Remove access to the app'),
            SizedBox(height: 16),
            Text(
              'If you\'re experiencing issues, please contact support instead.',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete Account', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount(AuthProvider authProvider) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Deleting account...'),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final success = await authProvider.deleteAccount();
      
      // Close loading dialog
      Navigator.of(context).pop();

      if (success) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Account deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigate to login screen and clear all routes
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.login,
          (route) => false,
        );
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage.isNotEmpty 
                ? authProvider.errorMessage 
                : 'Failed to delete account. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Close loading dialog
      Navigator.of(context).pop();
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}