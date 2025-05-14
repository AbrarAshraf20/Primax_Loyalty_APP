import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:primax/screen/platform_screen/platform_screen.dart';
import 'package:provider/provider.dart';
import 'package:primax/core/providers/auth_provider.dart';
import 'package:primax/core/providers/profile_provider.dart';
import 'package:primax/routes/routes.dart';
import 'package:primax/screen/login_screen/enter_otp.dart';

import '../../core/utils/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text__form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isEmailSelected = true;
  bool isPasswordVisible = false;
  bool isKeepSignedIn = false;

  // Form controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

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
                'Login',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Welcome Back to the app',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              // Row(
              //   children: [
              //     GestureDetector(
              //       onTap: () => setState(() => isEmailSelected = true),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             'Email',
              //             style: TextStyle(
              //               fontSize: 16,
              //               color: isEmailSelected ? Colors.green : Colors.black,
              //               fontWeight: isEmailSelected
              //                   ? FontWeight.bold
              //                   : FontWeight.normal,
              //             ),
              //           ),
              //           if (isEmailSelected)
              //             Container(
              //               margin: const EdgeInsets.only(top: 4),
              //               height: 2,
              //               width: 50,
              //               color: Colors.green,
              //             ),
              //         ],
              //       ),
              //     ),
              //     // const SizedBox(width: 30),
              //     // GestureDetector(
              //     //   onTap: () => setState(() => isEmailSelected = false),
              //     //   child: Column(
              //     //     crossAxisAlignment: CrossAxisAlignment.start,
              //     //     children: [
              //     //       Text(
              //     //         'Phone Number',
              //     //         style: TextStyle(
              //     //           fontSize: 16,
              //     //           color: !isEmailSelected ? Colors.green : Colors.black,
              //     //           fontWeight: !isEmailSelected
              //     //               ? FontWeight.bold
              //     //               : FontWeight.normal,
              //     //         ),
              //     //       ),
              //     //       if (!isEmailSelected)
              //     //         Container(
              //     //           margin: const EdgeInsets.only(top: 4),
              //     //           height: 2,
              //     //           width: 90,
              //     //           color: Colors.green,
              //     //         ),
              //     //     ],
              //     //   ),
              //     // ),
              //   ],
              // ),
              const SizedBox(height: 30),
              Text('Email Address',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
              const SizedBox(height: 5),
              CustomTextFormField(
                controller: _emailController,
                hintText: isEmailSelected ? 'Enter email Address' : 'Phone Number',
                hintStyle: TextStyle(color: Colors.grey),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (isEmailSelected && !value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Password',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.forgotPassword);
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              CustomTextFormField(
                controller: _passwordController,
                obscureText: !isPasswordVisible,
                hintText: 'Password',
                hintStyle: TextStyle(color: Colors.grey),
                suffix: IconButton(
                  icon: Icon(
                    isPasswordVisible ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                  ),
                  onPressed: () => setState(() => isPasswordVisible = !isPasswordVisible),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Checkbox(
                    value: isKeepSignedIn,
                    onChanged: (value) => setState(() => isKeepSignedIn = value ?? false),
                  ),
                  const Text('Keep me signed in'),
                ],
              ),
              const SizedBox(height: 30),
              authProvider.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : CustomButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final email = _emailController.text.trim();
                    final password = _passwordController.text.trim();

                    final success = await authProvider.login(
                      identifier: email,
                      password: password,
                    );

                    if (success) {
                      // Load user profile data after login
                      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
                      await profileProvider.getProfileDetails();

                      // Navigate to dashboard
                      Navigator.pushReplacementNamed(context, Routes.dashboard);
                    } else {
                      // Show error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(authProvider.errorMessage)),
                      );
                    }
                  }
                },
                width: double.maxFinite,
                text: 'Login',
              ),
              if (authProvider.errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    authProvider.errorMessage,
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 30),
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Routes.platform,
                    );
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
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Expanded(child: Divider(color:Colors.blueGrey,indent: 2,endIndent: 10,)),
                  Text('Or'),
                  Expanded(child: Divider(color: Colors.blueGrey,indent: 10,endIndent: 2,)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(40)
                    ),
                    child: IconButton(
                      onPressed: () {
                        // Google login
                      },
                      icon: SvgPicture.asset('assets/icons/ic_google.svg'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(40)
                    ),
                    child: IconButton(
                      onPressed: () {
                        // Apple login
                      },
                      icon: SvgPicture.asset('assets/icons/ic_apple.svg'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(40)
                    ),
                    child: IconButton(
                      onPressed: () {
                        // Facebook login
                      },
                      icon: SvgPicture.asset('assets/icons/ic_facebook.svg'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}