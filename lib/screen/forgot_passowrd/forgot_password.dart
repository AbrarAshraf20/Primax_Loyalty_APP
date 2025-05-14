import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:primax/core/di/service_locator.dart';
import 'package:primax/core/providers/auth_provider.dart';
import 'package:primax/routes/routes.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_text__form_field.dart';
import '../login_screen/login_screen.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isSubmitted = false;
  bool _isSuccess = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // Method to handle password reset request
  // Handle password reset request
  Future<void> _requestPasswordReset(BuildContext context, AuthProvider authProvider) async {
    // Validate email
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your email address')),
      );
      return;
    }

    final success = await authProvider.requestPasswordReset(email);

    if (success) {
      // Show success message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Reset Link Sent'),
            content: Text(
                'A password reset link has been sent to your email address. '
                    'Please check your inbox and click on the link to reset your password.'
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  LoginScreen().launch(
                      context, pageRouteAnimation: PageRouteAnimation.Slide);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
    @override
    Widget build(BuildContext context) {
      // Get the auth provider
      final authProvider = Provider.of<AuthProvider>(context);

      return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                const Text(
                  'Forgot Password',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Enter your email address to get a password reset link',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 30),
                Text('Email Address', style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(height: 5),
                CustomTextFormField(
                  controller: _emailController,
                  hintText: 'Email Address',
                  hintStyle: TextStyle(color: Colors.grey),
                  textInputType: TextInputType.emailAddress,
                ),

                // Show error message if any
                if (authProvider.errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      authProvider.errorMessage,
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),

                const SizedBox(height: 30),

                // Button with loading state
                authProvider.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : CustomButton(
                  onPressed: () => _requestPasswordReset(context, authProvider),
                  width: double.maxFinite,
                  text: 'Send Reset Link',
                ),

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

                const SizedBox(height: 20),
                Center(
                  child: InkWell(
                    onTap: () {
                      // Navigate to create account screen
                    },
                    child: Text.rich(
                      TextSpan(
                        text: "Don't have an account? ",
                        style: const TextStyle(color: Colors.grey),
                        children: [
                          TextSpan(
                            text: 'Create Account',
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