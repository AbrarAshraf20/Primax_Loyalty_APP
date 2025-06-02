import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:primax/core/utils/app_config.dart';
import 'package:primax/screen/login_screen/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:primax/core/providers/profile_provider.dart';
import 'package:primax/core/providers/auth_provider.dart';
import 'package:primax/routes/routes.dart';

import '../general_screens/web_view_screen.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, _) {
        final userProfile = profileProvider.userProfile;
        final isLoading = profileProvider.isLoading;

        return Drawer(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.green],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                currentAccountPicture: Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 16),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : CircleAvatar(
                    radius: 50,
                    backgroundImage: userProfile?.image != null
                        ? NetworkImage("${AppConfig.imageBaseUrl}${userProfile!.image!}")
                        : AssetImage('assets/images/user_profile.png') as ImageProvider,
                  ),
                ),
                accountName: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    isLoading ? "Loading..." : (userProfile?.name ?? "User"),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                accountEmail: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    isLoading ? "..." : (userProfile?.email ?? ""),
                  ),
                ),
              ),
              DrawerItem(
                icon: SvgPicture.asset("assets/icons/user.svg"),
                text: "My Profile",
                onTap: () {
                  Navigator.pop(context); // Close drawer first
                  Navigator.pushNamed(context, Routes.profile);
                },
              ),
              // DrawerItem(
              //   icon: SvgPicture.asset("assets/icons/Group_1.svg"),
              //   text: "Message Center",
              //   onTap: () {
              //     Navigator.pop(context);
              //     // Navigator.pushNamed(context, Routes.messageCenter);
              //   },
              // ),
              // DrawerItem(
              //   icon: SvgPicture.asset("assets/icons/Group_5.svg"),
              //   text: "Claimed Point History",
              //   onTap: () {
              //     Navigator.pop(context);
              //
              //     Navigator.pushNamed(context, Routes.pointsHistory);
              //   },
              // ),
              Divider(indent: 35, endIndent: 25),
              DrawerItem(
                icon: SvgPicture.asset("assets/icons/Group_2.svg"),
                text: "Terms and Conditions",
                onTap: () {
                  Navigator.pop(context);
                  WebViewScreen(
                    url: '${AppConfig.imageBaseUrl}terms-and-conditions',
                    title: 'Terms and Conditions',
                  ).launch(context,
                      pageRouteAnimation: PageRouteAnimation.Slide);
                  // Navigator.pushNamed(context, Routes.termsAndConditions);
                },
              ),
              DrawerItem(
                icon: SvgPicture.asset("assets/icons/Group_3.svg"),
                text: "Privacy Policy",
                onTap: () {
                  Navigator.pop(context);

                  WebViewScreen(
                    url: '${AppConfig.imageBaseUrl}privacy-policy',
                    title: 'Privacy Policy',
                  ).launch(context,
                      pageRouteAnimation: PageRouteAnimation.Slide);

                  // Navigator.pushNamed(context, Routes.privacyPolicy);
                },
              ),
              DrawerItem(
                icon: SvgPicture.asset("assets/icons/Group_4.svg"),
                text: "Contact us",
                onTap: () {
                  Navigator.pop(context);

                  WebViewScreen(
                    url: '${AppConfig.imageBaseUrl}contact',
                    title: 'Contact us',
                  ).launch(context,
                      pageRouteAnimation: PageRouteAnimation.Slide);

                  // Navigator.pushNamed(context, Routes.contactSupport);
                },
              ),
              Divider(indent: 35, endIndent: 25),
              DrawerItem(
                icon: Icon(Icons.delete_forever, color: Colors.red),
                text: "Delete Account",
                color: Colors.red,
                onTap: () {
                  // Get auth provider BEFORE closing the drawer
                  final authProvider = Provider.of<AuthProvider>(context, listen: false);
                  
                  // Close drawer first
                  Navigator.pop(context);
                  
                  // Show account deletion confirmation dialog
                  _showDeleteAccountDialog(context, authProvider);
                },
              ),
              DrawerItem(
                icon: SvgPicture.asset("assets/icons/Sign_Out.svg"),
                text: "Sign Out",
                color: Colors.red,
                onTap: () {
                  // Get auth provider BEFORE closing the drawer
                  final authProvider = Provider.of<AuthProvider>(context, listen: false);
                  
                  // Close drawer first
                  Navigator.pop(context);
                  
                  // Show confirmation dialog
                  _showSimpleLogoutDialog(context, authProvider);
                },
              ),
            ],
          ),
        );
      },
    );
  }
  
  // Account deletion confirmation dialog with detailed warning
  void _showDeleteAccountDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return _DeleteAccountDialog(authProvider: authProvider);
      },
    );
  }


  // Simple confirmation dialog with pre-captured authProvider
  void _showSimpleLogoutDialog(BuildContext context, AuthProvider authProvider) {
    // Store navigator before showing dialog to ensure it's valid
    final navigator = Navigator.of(context);
    
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Sign Out'),
          content: Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Close dialog first
                Navigator.pop(dialogContext);
                
                // Start logout process in the background
                authProvider.logout().then((success) {
                  print("Logout ${success ? 'successful' : 'failed'}");
                }).catchError((error) {
                  print("Error during logout: $error");
                });
                
                // Use the stored navigator reference to navigate
                // Push a material page route directly to avoid any extension methods
                navigator.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                  (route) => false
                );
              },
              child: Text('Sign Out', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

class DrawerItem extends StatelessWidget {
  final Widget icon;
  final String text;
  final Color? color;
  final VoidCallback onTap;

  const DrawerItem({
    required this.icon,
    required this.text,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0),
      child: ListTile(
        leading: icon,
        title: Text(
          text,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: color ?? Color(0xff858EA9)
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

class _DeleteAccountDialog extends StatefulWidget {
  final AuthProvider authProvider;

  const _DeleteAccountDialog({required this.authProvider});

  @override
  _DeleteAccountDialogState createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<_DeleteAccountDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.warning, color: Colors.red, size: 28),
          SizedBox(width: 8),
          Text(
            'Delete Account',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Text(
                '⚠️ WARNING: This action cannot be undone!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red[700],
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Deleting your account will permanently remove:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            _buildWarningItem('• Your profile and personal information'),
            _buildWarningItem('• All earned points and rewards'),
            _buildWarningItem('• Lucky draw participation history'),
            _buildWarningItem('• Transaction and claim history'),
            _buildWarningItem('• Saved addresses and preferences'),
            _buildWarningItem('• All app data associated with your account'),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Text(
                'This action is irreversible. You will need to create a new account to use the app again.',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.orange[700],
                ),
              ),
            ),
            if (widget.authProvider.errorMessage.isNotEmpty) ...[
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Text(
                  widget.authProvider.errorMessage,
                  style: TextStyle(
                    color: Colors.red[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextButton(
            onPressed: widget.authProvider.isLoading ? null : () async {
              await _handleDeleteAccount();
            },
            child: widget.authProvider.isLoading
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : Text(
                    'DELETE ACCOUNT',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildWarningItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        style: TextStyle(color: Colors.grey[700]),
      ),
    );
  }

  Future<void> _handleDeleteAccount() async {
    // Show final confirmation
    bool finalConfirm = await _showFinalConfirmationDialog();
    if (!finalConfirm) return;
    
    try {
      final success = await widget.authProvider.deleteAccount();

      if (!mounted) return;

      if (success) {
        // Close dialog first
        Navigator.pop(context);
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Account deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigate to login screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
          (route) => false,
        );
      } else {
        // Error is already set in authProvider.errorMessage
        setState(() {}); // Refresh to show error
      }
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete account. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<bool> _showFinalConfirmationDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'Final Confirmation',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you absolutely sure you want to delete your account? This action cannot be undone.',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text('No, Keep Account'),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: Text(
                  'Yes, Delete Forever',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        );
      },
    ) ?? false;
  }
}