import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:primax/core/providers/profile_provider.dart';
import 'package:primax/core/providers/auth_provider.dart';
import 'package:primax/routes/routes.dart';

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
                        ? NetworkImage(userProfile!.image!)
                        : AssetImage('assets/images/Nola_Risk.png') as ImageProvider,
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
              DrawerItem(
                icon: SvgPicture.asset("assets/icons/Group_1.svg"),
                text: "Message Center",
                onTap: () {
                  Navigator.pop(context);
                  // Navigator.pushNamed(context, Routes.messageCenter);
                },
              ),
              DrawerItem(
                icon: SvgPicture.asset("assets/icons/Group_5.svg"),
                text: "Account Ledger",
                onTap: () {
                  Navigator.pop(context);
                  // Navigator.pushNamed(context, Routes.accountLedger);
                },
              ),
              Divider(indent: 35, endIndent: 25),
              DrawerItem(
                icon: SvgPicture.asset("assets/icons/Group_2.svg"),
                text: "Terms and Conditions",
                onTap: () {
                  Navigator.pop(context);
                  // Navigator.pushNamed(context, Routes.termsAndConditions);
                },
              ),
              DrawerItem(
                icon: SvgPicture.asset("assets/icons/Group_3.svg"),
                text: "Privacy Policy",
                onTap: () {
                  Navigator.pop(context);
                  // Navigator.pushNamed(context, Routes.privacyPolicy);
                },
              ),
              DrawerItem(
                icon: SvgPicture.asset("assets/icons/Group_4.svg"),
                text: "Contact Support",
                onTap: () {
                  Navigator.pop(context);
                  // Navigator.pushNamed(context, Routes.contactSupport);
                },
              ),
              Divider(indent: 35, endIndent: 25),
              DrawerItem(
                icon: SvgPicture.asset("assets/icons/Sign_Out.svg"),
                text: "Sign Out",
                color: Colors.red,
                onTap: () {
                  Navigator.pop(context); // Close drawer first
                  _showSignOutConfirmationDialog(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Show confirmation dialog before signing out
  void _showSignOutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) { // Use a new dialogContext
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
                // Close the dialog first
                Navigator.pop(dialogContext);

                // Get auth provider and sign out
                // Use a BuildContext that is guaranteed to be active
                _performSignOut(context);
              },
              child: Text('Sign Out', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // Perform sign out in a separate method to avoid context issues
  void _performSignOut(BuildContext context) {
    // Store the navigator state before any async operations
    final navigator = Navigator.of(context);

    // Perform sign out
    Provider.of<AuthProvider>(context, listen: false).logout().then((_) {
      // Use the stored navigator to navigate
      navigator.pushNamedAndRemoveUntil(
          Routes.login,
              (route) => false
      );
    }).catchError((error) {
      // Handle any errors here
      print('Error signing out: $error');

      // Show error message if needed
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign out. Please try again.'))
      );
    });
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