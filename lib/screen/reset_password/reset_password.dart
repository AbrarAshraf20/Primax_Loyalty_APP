import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../core/providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text__form_field.dart';
import '../login_screen/login_screen.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers for form fields
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _oldPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Reset password function
  Future<void> _resetPassword() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Get form values
    final oldPassword = _oldPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final reEnterNewPassword = _confirmPasswordController.text.trim();

    // Get auth provider
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Call reset password function
    final success = await authProvider.resetPassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
      reEnterNewPassword: reEnterNewPassword,
    );

    if (success) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back to login screen after a short delay
      Future.delayed(const Duration(seconds: 2), () {
        LoginScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
      });
    } else {
      // Error is handled by the provider, which will update its errorMessage property
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access the auth provider
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: Text('Reset Password', style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Reset Password',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Reset password for your account',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),

              // Show error message if any
              if (authProvider.errorMessage.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          authProvider.errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),

              // Old Password Field
              const SizedBox(height: 30),
              Text('Current Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 5),
              CustomTextFormField(
                controller: _oldPasswordController,
                obscureText: !_oldPasswordVisible,
                hintText: 'Enter current password',
                hintStyle: TextStyle(color: Colors.grey),
                suffix: IconButton(
                  icon: Icon(
                    _oldPasswordVisible ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                    color: Colors.black,
                  ),
                  onPressed: () => setState(() => _oldPasswordVisible = !_oldPasswordVisible),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current password';
                  }
                  return null;
                },
              ),

              // New Password Field
              const SizedBox(height: 20),
              Text('New Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 5),
              CustomTextFormField(
                controller: _newPasswordController,
                obscureText: !_newPasswordVisible,
                hintText: 'Enter new password',
                hintStyle: TextStyle(color: Colors.grey),
                suffix: IconButton(
                  icon: Icon(
                    _newPasswordVisible ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                    color: Colors.black,
                  ),
                  onPressed: () => setState(() => _newPasswordVisible = !_newPasswordVisible),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),

              // Confirm New Password Field
              const SizedBox(height: 20),
              Text('Re-enter New Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 5),
              CustomTextFormField(
                controller: _confirmPasswordController,
                obscureText: !_confirmPasswordVisible,
                hintText: 'Re-enter new password',
                hintStyle: TextStyle(color: Colors.grey),
                suffix: IconButton(
                  icon: Icon(
                    _confirmPasswordVisible ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                    color: Colors.black,
                  ),
                  onPressed: () => setState(() => _confirmPasswordVisible = !_confirmPasswordVisible),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your new password';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),

              // Reset Password Button
              const SizedBox(height: 40),
              CustomButton(
                onPressed: authProvider.isLoading ? (){} : _resetPassword,
                width: double.maxFinite,
                text: authProvider.isLoading ? 'Resetting...' : 'Reset Password',
                isLoading: authProvider.isLoading,
              ),

              // Helper text
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'After resetting your password, you will need to login again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}