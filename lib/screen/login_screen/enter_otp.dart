import 'dart:async';
import 'package:flutter/material.dart';
import 'package:primax/screen/dashboard_screen/dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../core/providers/auth_provider.dart';
import '../../widgets/custom_button.dart';

class OtpScreen extends StatefulWidget {
  final String email;

  const OtpScreen({Key? key, required this.email}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  // Changed from 4 to 6 text fields
  final List<TextEditingController> _controllers =
  List.generate(6, (index) => TextEditingController());

  Timer? _timer;
  int _remainingSeconds = 60;
  bool _canResendOtp = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _canResendOtp = true;
          _timer?.cancel();
        }
      });
    });
  }

  String get _getOtpCode {
    return _controllers.fold<String>('', (code, controller) => code + (controller.text.isEmpty ? '' : controller.text));
  }

  Future<void> _verifyOtp() async {
    String otp = _getOtpCode;

    // Updated to check for 6 digits instead of 4
    if (otp.length != 6) {
      toast('Please enter the complete 6-digit OTP code');
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.register(otp);

    if (success) {
      toast('Registration successful!');

      // Navigate to the dashboard screen and remove all previous routes
      DashboardScreen().launch(
        context,
        isNewTask: true,  // Clear previous screens
        pageRouteAnimation: PageRouteAnimation.Slide,
      );
    } else {
      if (authProvider.errorMessage.isNotEmpty) {
        toast(authProvider.errorMessage);
      } else {
        toast('Invalid OTP. Please try again.');
      }
    }
  }

  Future<void> _resendOtp() async {
    if (!_canResendOtp) return;

    setState(() {
      _canResendOtp = false;
      _remainingSeconds = 60;
    });

    _startTimer();

    // Here you would call the API to resend OTP
    // For now, just show a toast message
    toast('OTP resent successfully');
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // Format email for display (mask middle part)
    String maskedEmail = widget.email;
    if (widget.email.contains('@')) {
      final parts = widget.email.split('@');
      if (parts[0].length > 2) {
        maskedEmail = parts[0].substring(0, 2) +
            '*' * (parts[0].length - 2) +
            '@' + parts[1];
      }
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Button
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: Color(0xffE4E7EB),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            const SizedBox(height: 30),

            // Title
            const Text(
              "Enter OTP",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Subtitle with email
            Text.rich(
              TextSpan(
                text: "We've sent an OTP code to your email, ",
                style: TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(
                    text: maskedEmail,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // OTP Fields - Updated to 6 fields with adjusted spacing and width
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  6, // Changed from 4 to 6
                      (index) => SizedBox(
                    width: 45, // Slightly smaller to fit 6 fields
                    height: 50,
                    child: TextField(
                      controller: _controllers[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: '0',
                        hintStyle: TextStyle(color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) { // Changed from index < 3 to index < 5
                          FocusScope.of(context).nextFocus();
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Resend Text with timer
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _canResendOtp
                        ? "Didn't receive the code? "
                        : "We will resend the code in $_remainingSeconds seconds",
                    style: TextStyle(color: Colors.grey),
                  ),
                  if (_canResendOtp)
                    GestureDetector(
                      onTap: _resendOtp,
                      child: Text(
                        "Resend",
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Verify Button
            CustomButton(
              width: double.infinity,
              text: authProvider.isLoading ? "Verifying..." : "Verify",
              isLoading: authProvider.isLoading,
              onPressed: authProvider.isLoading ? (){} : _verifyOtp,
            ),
          ],
        ),
      ),
    );
  }
}