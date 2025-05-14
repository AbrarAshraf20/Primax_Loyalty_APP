import 'package:flutter/material.dart';
import '../main.dart'; // Import to access the global ScaffoldMessengerKey

class CustomSnackBar {
  static void show({
    BuildContext? context,
    required String message,
    Color backgroundColor = Colors.black87,
    Color textColor = Colors.white,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    bool floating = true,
    EdgeInsets? margin,
    double? width,
  }) {
    // Create the SnackBar
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: textColor),
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      action: action,
      behavior: SnackBarBehavior.floating,
      margin: margin ?? const EdgeInsets.only(bottom: 90, left: 10, right: 10),
      width: width,
      dismissDirection: DismissDirection.up,
    );

    // Use the global key if available, otherwise fall back to context
    if (rootScaffoldMessengerKey.currentState != null) {
      // Hide any existing SnackBars first
      rootScaffoldMessengerKey.currentState!.hideCurrentSnackBar();
      // Show the new SnackBar
      rootScaffoldMessengerKey.currentState!.showSnackBar(snackBar);
    } else if (context != null) {
      // Fall back to context if global key isn't available
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  // Success snackbar (green)
  static void showSuccess({
    BuildContext? context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    show(
      context: context,
      message: message,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      duration: duration,
      action: action,
    );
  }

  // Error snackbar (red)
  static void showError({
    BuildContext? context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    show(
      context: context,
      message: message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      duration: duration,
      action: action,
    );
  }

  // Info snackbar (blue)
  static void showInfo({
    BuildContext? context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    show(
      context: context,
      message: message,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      duration: duration,
      action: action,
    );
  }

  // Show a SnackBar directly from anywhere without a context
  static void showGlobal({
    required String message,
    Color backgroundColor = Colors.black87,
    Color textColor = Colors.white,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    show(
      context: null, // No context needed when using global key
      message: message,
      backgroundColor: backgroundColor,
      textColor: textColor,
      duration: duration,
      action: action,
    );
  }
}