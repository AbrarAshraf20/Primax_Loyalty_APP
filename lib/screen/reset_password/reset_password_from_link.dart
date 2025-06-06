import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../core/providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text__form_field.dart';
import '../login_screen/login_screen.dart';

class ResetPasswordFromLink extends StatefulWidget {
  final String token;
  final String email;
  
  const ResetPasswordFromLink({
    Key? key,
    required this.token,
    required this.email,
  }) : super(key: key);

  @override
  State<ResetPasswordFromLink> createState() => _ResetPasswordFromLinkState();
}

class _ResetPasswordFromLinkState extends State<ResetPasswordFromLink> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers for form fields
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  void dispose() {
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
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // Get auth provider
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Call reset password function with token
    final success = await authProvider.resetPasswordWithToken(
      email: widget.email,
      token: widget.token,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    if (success) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to login screen after a short delay
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

    // If token or email is empty, show error screen
    if (widget.token.isEmpty || widget.email.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Reset Password'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Invalid Reset Link',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'This reset password link is invalid or has expired.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                },
                child: Text('Back to Login'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              const Text(
                'Reset Password',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Set a new password for ${widget.email}',
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

              // New Password Field
              const SizedBox(height: 30),
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
              Text('Confirm New Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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

              // Back to login link
              const SizedBox(height: 30),
              Center(
                child: InkWell(
                  onTap: () {
                    LoginScreen().launch(context,
                        pageRouteAnimation: PageRouteAnimation.Slide);
                  },
                  child: Text.rich(
                    TextSpan(
                      text: "Remember your password? ",
                      style: const TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}