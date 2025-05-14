// // lib/core/navigation/deep_link_handler.dart
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:app_links/app_links.dart';
// import 'package:primax/screen/reset_password/reset_password.dart';
//
// class DeepLinkHandler {
//   static AppLinks? _appLinks;
//   static StreamSubscription<Uri>? _linkSubscription;
//
//   // Initialize deep linking
//   static Future<void> initAppLinks(BuildContext context) async {
//     _appLinks = AppLinks();
//
//     // Handle case where app is opened from a link
//     try {
//       final initialLink = await _appLinks!.getInitialLink();
//       if (initialLink != null) {
//         _handleLink(initialLink, context);
//       }
//     } on PlatformException {
//       // Link handling failed
//     }
//
//     // Handle case where app is already running and link is clicked
//     _linkSubscription = _appLinks!.uriLinkStream.listen((Uri uri) {
//       _handleLink(uri, context);
//     });
//   }
//
//   // Cleanup subscription
//   static void dispose() {
//     _linkSubscription?.cancel();
//   }
//
//   // Handle the deep link
//   static void _handleLink(Uri uri, BuildContext context) {
//     // Password reset links
//     if (uri.path.contains('/reset-password')) {
//       final token = uri.queryParameters['token'];
//       final email = uri.queryParameters['email'];
//
//       if (token != null && email != null) {
//         // Navigate to reset password screen with token and email
//         Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(
//             builder: (context) => ResetPassword(
//               token: token,
//               email: email,
//               fromDeepLink: true,
//             ),
//           ),
//               (route) => false, // Remove all previous routes
//         );
//       }
//     }
//   }
// }