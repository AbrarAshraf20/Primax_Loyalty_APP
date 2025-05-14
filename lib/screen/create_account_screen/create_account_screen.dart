import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../core/utils/app_colors.dart';
import '../../core/utils/pakistan_locations.dart';
import '../../core/providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text__form_field.dart';
import '../../widgets/searchable_dropdown.dart';
import '../login_screen/login_screen.dart';
import '../login_screen/enter_otp.dart';

class CreateAccountScreen extends StatefulWidget {
  final String role; // Role: Installer, Dealer, or Distributor

  // Constructor now has an optional named parameter
  const CreateAccountScreen({Key? key, required this.role}) : super(key: key);

  // This static method allows us to create the screen from route arguments
  static CreateAccountScreen fromRouteSettings(RouteSettings settings) {
    // Extract and cast the arguments
    final args = settings.arguments as Map<String, dynamic>?;
    print('Route arguments: $args');    // Get role with fallback to default value if null
    final role = args?['role'] as String? ?? 'User Sign up';
    return CreateAccountScreen(role: role);
  }

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form field controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _provinceController = TextEditingController();
  final _cityController = TextEditingController();
  final _cnicController = TextEditingController();
  final _shopNumberController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _selectedProvince;
  List<String> _availableCities = [];

  bool isPasswordVisible = false;
  bool isTermsAccepted = false;

  @override
  void initState() {
    super.initState();
    // Add listeners to update dependent fields
    _provinceController.addListener(_updateCitiesForSelectedProvince);
  }

  void _updateCitiesForSelectedProvince() {
    final province = _provinceController.text;
    if (province.isNotEmpty) {
      setState(() {
        _selectedProvince = province;
        _availableCities = PakistanLocation.getCitiesForProvince(province);

        // Clear city if it's not in the list of available cities
        if (_availableCities.isNotEmpty &&
            _cityController.text.isNotEmpty &&
            !_availableCities.contains(_cityController.text)) {
          _cityController.clear();
        }
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _provinceController.dispose();
    _cityController.dispose();
    _cnicController.dispose();
    _shopNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Helper method to normalize phone number to +92 format
  String _normalizePhoneNumber(String phoneNumber) {
    // Remove any non-digit characters except '+'
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

    // Extract the digits after prefixes
    final RegExp pkPhoneRegex = RegExp(r'^(?:\+92|0092|0)?(3\d{2})(\d{7})$');
    final match = pkPhoneRegex.firstMatch(cleanNumber);

    if (match != null) {
      final networkCode = match.group(1);
      final subscriberNumber = match.group(2);
      return '+92$networkCode$subscriberNumber';
    }

    // Check if it's already in +92 format
    if (cleanNumber.startsWith('+92') && cleanNumber.length == 13) {
      return cleanNumber;
    }

    // Default fallback - shouldn't reach here as we validate format first
    return phoneNumber;
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!isTermsAccepted) {
      toast('Please accept the Terms & Conditions');
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final success = await authProvider.sendRegistrationOtp(
      name: _nameController.text,
      email: _emailController.text,
      phoneNumber: _normalizePhoneNumber(_phoneController.text),
      province: _provinceController.text,
      city: _cityController.text,
      cnic: _cnicController.text,
      shopNumber: _shopNumberController.text,
      role: widget.role.split(' ')[0], // Extract role name (e.g., "Installer" from "Installer Sign up")
      password: _passwordController.text,
    );

    if (success) {
      // Navigate to OTP verification screen
      OtpScreen(email: _emailController.text).launch(
        context,
        pageRouteAnimation: PageRouteAnimation.Slide,
      );
    } else {
      // Show error message
      if (authProvider.errorMessage.isNotEmpty) {
        toast(authProvider.errorMessage);
      } else {
        toast('Failed to register. Please try again.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    print('Current role: ${widget.role}');
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                '${widget.role}',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),

              // Name Field
              Text('Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 5),
              CustomTextFormField(
                controller: _nameController,
                hintText: 'Name',
                hintStyle: TextStyle(color: Colors.grey),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),
              Text('Email Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 5),
              CustomTextFormField(
                controller: _emailController,
                hintText: 'Enter Email Address',
                hintStyle: TextStyle(color: Colors.grey),
                textInputType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),
              Text('Phone Number', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 5),
              CustomTextFormField(
                controller: _phoneController,
                hintText: 'Phone Number (e.g., 03001234567)',
                hintStyle: TextStyle(color: Colors.grey),
                textInputType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }

                  // Remove any non-digit characters except '+'
                  final cleanNumber = value.replaceAll(RegExp(r'[^\d+]'), '');

                  // Pakistani phone number validation
                  final RegExp pkPhoneRegex = RegExp(r'^(?:\+92|0092|0)?(3\d{2})(\d{7})$');
                  if (!pkPhoneRegex.hasMatch(cleanNumber)) {
                    return 'Enter a valid Pakistani mobile number (e.g., 03001234567)';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),
              // Province dropdown with improved event handling
              SearchableDropdown(
                label: 'Province',
                hintText: 'Select a province',
                items: PakistanLocation.provinces,
                controller: _provinceController,
                onChanged: (value) {
                  // Only update if the value actually changed
                  if (value != _selectedProvince) {
                    setState(() {
                      _selectedProvince = value;
                      _availableCities = PakistanLocation.getCitiesForProvince(value);
                      // Clear city when province changes
                      _cityController.clear();
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your province';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),
              // City dropdown with improved handling
              SearchableDropdown(
                label: 'City',
                hintText: _availableCities.isEmpty
                    ? 'First select a province'
                    : 'Select or enter a city',
                items: _availableCities,
                controller: _cityController,
                onChanged: (value) {
                  // We don't need to do anything special on city change
                  // Just accept the value
                },
                allowManualEntry: true,
                isSearchable: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select or enter your city';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),
              Text('CNIC Number', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 5),
              CustomTextFormField(
                controller: _cnicController,
                hintText: 'CNIC Number',
                hintStyle: TextStyle(color: Colors.grey),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your CNIC number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),
              Text('Company/Shop Number', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 5),
              CustomTextFormField(
                controller: _shopNumberController,
                hintText: 'Company/Shop Number',
                hintStyle: TextStyle(color: Colors.grey),
              ),

              // const SizedBox(height: 20),
              // Text('Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              // const SizedBox(height: 5),
              // CustomTextFormField(
              //   controller: _addressController,
              //   hintText: 'Address',
              //   hintStyle: TextStyle(color: Colors.grey),
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter your address';
              //     }
              //     return null;
              //   },
              // ),

              const SizedBox(height: 20),
              Text('Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 5),
              CustomTextFormField(
                controller: _passwordController,
                obscureText: !isPasswordVisible,
                hintText: 'Password',
                hintStyle: TextStyle(color: Colors.grey),
                suffix: IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: isTermsAccepted,
                    onChanged: (value) => setState(() => isTermsAccepted = value ?? false),
                    activeColor: Colors.green,
                  ),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: "By Continuing, you agree to our ",
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                        children: [
                          TextSpan(
                            text: 'Terms & Conditions',
                            style: const TextStyle(color: Colors.blue, fontSize: 12),
                            // Add navigation action here for terms
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              CustomButton(
                onPressed: authProvider.isLoading
                    ? (){}
                    : _register,
                width: double.maxFinite,
                text: authProvider.isLoading ? 'Please wait...' : 'Sign up',
                isLoading: authProvider.isLoading,
              ),

              const SizedBox(height: 30),
              InkWell(
                onTap: () {
                  LoginScreen().launch(
                    context,
                    pageRouteAnimation: PageRouteAnimation.Slide,
                  );
                },
                child: Center(
                  child: Text.rich(
                    TextSpan(
                      text: "Already have an account? ",
                      style: const TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: 'Sign in here',
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
                  Expanded(child: Divider(color: Colors.blueGrey, indent: 2, endIndent: 10)),
                  Text('Or'),
                  Expanded(child: Divider(color: Colors.blueGrey, indent: 10, endIndent: 2)),
                ],
              ),

              const SizedBox(height: 30),
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
                  SizedBox(width: 5),
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
                  SizedBox(width: 5),
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