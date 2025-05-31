import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum MessageType { success, error, info, warning }

class MessageDialog {
  static void show({
    required BuildContext context,
    required String title,
    required String message,
    required MessageType type,
    String? buttonText,
    VoidCallback? onButtonPressed,
    bool barrierDismissible = true,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: _buildDialogContent(
            context: context,
            title: title,
            message: message,
            type: type,
            buttonText: buttonText,
            onButtonPressed: onButtonPressed,
          ),
        );
      },
    );
  }

  static Widget _buildDialogContent({
    required BuildContext context,
    required String title,
    required String message,
    required MessageType type,
    String? buttonText,
    VoidCallback? onButtonPressed,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon/Animation
          _buildIcon(type),
          
          const SizedBox(height: 24),
          
          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3142),
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          // Message
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          // Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: onButtonPressed ?? () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: _getButtonColor(type),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              child: Text(
                buttonText ?? _getDefaultButtonText(type),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildIcon(MessageType type) {
    switch (type) {
      case MessageType.success:
        return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFF4CAF50).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle,
            size: 50,
            color: Color(0xFF4CAF50),
          ),
        );
        
      case MessageType.error:
        return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFFF44336).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.error,
            size: 50,
            color: Color(0xFFF44336),
          ),
        );
        
      case MessageType.warning:
        return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFFFF9800).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.warning,
            size: 50,
            color: Color(0xFFFF9800),
          ),
        );
        
      case MessageType.info:
      default:
        return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFF2196F3).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.info,
            size: 50,
            color: Color(0xFF2196F3),
          ),
        );
    }
  }

  static Color _getButtonColor(MessageType type) {
    switch (type) {
      case MessageType.success:
        return const Color(0xFF4CAF50);
      case MessageType.error:
        return const Color(0xFFF44336);
      case MessageType.warning:
        return const Color(0xFFFF9800);
      case MessageType.info:
      default:
        return const Color(0xFF2196F3);
    }
  }

  static String _getDefaultButtonText(MessageType type) {
    switch (type) {
      case MessageType.success:
        return 'Great!';
      case MessageType.error:
        return 'Try Again';
      case MessageType.warning:
        return 'Understood';
      case MessageType.info:
      default:
        return 'OK';
    }
  }

  // Convenience methods for common use cases
  static void showSuccess({
    required BuildContext context,
    required String message,
    String title = 'Success!',
    String? buttonText,
    VoidCallback? onButtonPressed,
  }) {
    show(
      context: context,
      title: title,
      message: message,
      type: MessageType.success,
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
    );
  }

  static void showError({
    required BuildContext context,
    required String message,
    String title = 'Error',
    String? buttonText,
    VoidCallback? onButtonPressed,
  }) {
    show(
      context: context,
      title: title,
      message: message,
      type: MessageType.error,
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
    );
  }

  static void showInfo({
    required BuildContext context,
    required String message,
    String title = 'Information',
    String? buttonText,
    VoidCallback? onButtonPressed,
  }) {
    show(
      context: context,
      title: title,
      message: message,
      type: MessageType.info,
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
    );
  }

  static void showWarning({
    required BuildContext context,
    required String message,
    String title = 'Warning',
    String? buttonText,
    VoidCallback? onButtonPressed,
  }) {
    show(
      context: context,
      title: title,
      message: message,
      type: MessageType.warning,
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
    );
  }
}