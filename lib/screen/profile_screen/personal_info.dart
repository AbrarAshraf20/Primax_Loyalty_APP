import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:primax/core/providers/profile_provider.dart';
import 'package:primax/models/user_model.dart';

import '../../core/utils/app_config.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({Key? key}) : super(key: key);

  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cnicController = TextEditingController();

  File? _selectedImage;

  // Regex pattern for Pakistan phone number validation
  final RegExp _pakistanPhoneRegex = RegExp(
    r'^(?:\+92|0092|0)?(3\d{2})(\d{7})$'
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  Future<void> _loadUserData() async {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    // Always fetch fresh profile data from server first
    await profileProvider.getProfileDetails();

    // Now get the updated user profile
    final user = profileProvider.userProfile;
    if (user != null) {
      _nameController.text = user.name ?? '';
      _emailController.text = user.email ?? '';
      _phoneController.text = user.phone ?? '';
      _cnicController.text = user.cnicNumber ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cnicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, _) {
          final user = profileProvider.userProfile;

          if (user == null) {
            return const Center(child: Text('No user data available'));
          }

          return Stack(
            children: [
              SafeArea(
                child: Column(
                  children: [
                    // Header with back button and title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.arrow_back_ios_new, size: 20),
                            ),
                          ),
                          const Expanded(
                            child: Center(
                              child: Text(
                                'Edit Profile',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          // Empty SizedBox for alignment
                          const SizedBox(width: 40),
                        ],
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Profile photo
                                Center(
                                  child: Stack(
                                    children: [
                                      // Profile image
                                      Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey.shade200,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              blurRadius: 8,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: ClipOval(
                                          child: _selectedImage != null
                                              // Show selected local image
                                              ? Image.file(
                                                  _selectedImage!,
                                                  fit: BoxFit.cover,
                                                  width: 120,
                                                  height: 120,
                                                )
                                              // Show image from server or placeholder
                                              : user.image != null && user.image!.isNotEmpty
                                                  ? FadeInImage.assetNetwork(
                                                      placeholder: 'assets/images/app_logo.png',
                                                      image: "${AppConfig.imageBaseUrl}${user.image}",
                                                      fit: BoxFit.cover,
                                                      width: 120,
                                                      height: 120,
                                                      imageErrorBuilder: (context, error, stackTrace) {
                                                        return Image.asset(
                                                          'assets/images/app_logo.png',
                                                          fit: BoxFit.cover,
                                                          width: 120,
                                                          height: 120,
                                                        );
                                                      },
                                                    )
                                                  : Image.asset(
                                                      'assets/images/app_logo.png',
                                                      fit: BoxFit.cover,
                                                      width: 120,
                                                      height: 120,
                                                    ),
                                        ),
                                      ),

                                      // Edit icon on image
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: _pickImage,
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [Color(0xFF00C853), Color(0xFF00B0FF)],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.2),
                                                  blurRadius: 6,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: const Icon(
                                              Icons.camera_alt,
                                              color: Colors.white,
                                              size: 22,
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Show "change photo" indicator text
                                      if (_selectedImage != null)
                                        Positioned(
                                          bottom: -20,
                                          left: 0,
                                          right: 0,
                                          child: Center(
                                            child: ShaderMask(
                                              shaderCallback: (Rect bounds) {
                                                return const LinearGradient(
                                                  colors: [Color(0xFF00C853), Color(0xFF00B0FF)],
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                ).createShader(bounds);
                                              },
                                              child: const Text(
                                                'Photo selected',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 30),

                                // Form fields
                                _buildFormField(
                                  label: 'Full Name',
                                  controller: _nameController,
                                ),
                                const SizedBox(height: 16),

                                _buildFormField(
                                  label: 'Email',
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 16),

                                _buildFormField(
                                  label: 'Phone Number',
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                ),
                                const SizedBox(height: 16),

                                _buildFormField(
                                  label: 'CNIC Number',
                                  controller: _cnicController,
                                ),
                                const SizedBox(height: 50),

                                // Save button
                                _buildSaveButton(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Loading indicator
              if (profileProvider.isLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }

  ImageProvider _getProfileImage(User user) {
    // First priority: newly selected image from device
    if (_selectedImage != null) {
      return FileImage(_selectedImage!);
    }
    // Second priority: existing image from server
    else if (user.image != null && user.image!.isNotEmpty) {
      return NetworkImage(user.image!);
    }
    // Fallback: default placeholder image
    else {
      return const AssetImage('assets/images/app_logo.png');
    }
  }

  // Simplified image picker method that avoids permission issues
  Future<void> _pickImage() async {
    try {
      // Show source selection dialog
      final source = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFF00C853)),
                title: const Text('Camera'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Color(0xFF00B0FF)),
                title: const Text('Gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        ),
      );

      if (source == null) return;

      // Handle camera specifically
      if (source == ImageSource.camera) {
        final status = await Permission.camera.request();
        if (!status.isGranted) {
          // Only show settings option if permission is permanently denied
          if (status.isPermanentlyDenied) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Camera permission is required to take photos'),
                action: SnackBarAction(
                  label: 'Settings',
                  onPressed: () => openAppSettings(),
                ),
              ),
            );
          }
          return;
        }
      }

      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Opening image picker...'),
          duration: Duration(milliseconds: 800),
        ),
      );

      // Use image picker with minimal options to prevent permission issues
      final ImagePicker picker = ImagePicker();
      final XFile? pickedImage = await picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 800,
        requestFullMetadata: false, // Skip additional permission checks
      );
      
      if (pickedImage == null) {
        return; // User cancelled selection
      }

      // Process the selected image
      final File imageFile = File(pickedImage.path);
      
      if (!await imageFile.exists()) {
        throw Exception('Selected image file not found');
      }
      
      final fileSize = await imageFile.length();
      if (fileSize > 5 * 1024 * 1024) { // 5MB
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image is too large. Please select an image smaller than 5MB'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
        return;
      }

      // Update state with the selected image
      setState(() {
        _selectedImage = imageFile;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image selected! Click Save to update your profile'),
          backgroundColor: Color(0xFF00C853),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting image: ${e.toString().split('\n')[0]}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Settings',
            textColor: Colors.white,
            onPressed: () => openAppSettings(),
          ),
        ),
      );
    }
  }

  // Dialog to guide user to settings - REMOVED per Apple guidelines
  // This method is no longer used as we should not show pre-permission dialogs

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    // Get the field name to check for server validation errors
    String fieldName = '';
    if (label == 'Full Name') fieldName = 'name';
    else if (label == 'Email') fieldName = 'email';
    else if (label == 'Phone Number') fieldName = 'phone';
    else if (label == 'CNIC Number') fieldName = 'cnic';

    // Get validation error from provider if it exists
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final String? serverError = profileProvider.getFieldError(fieldName);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(10),
            // Add red border if server validation error exists
            border: serverError != null
                ? Border.all(color: Colors.red, width: 1.0)
                : null,
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[50],
              // Add hint for phone number field
              hintText: label == 'Phone Number' ? '+92, 0092, 03xx-xxxxxxx' : null,
              // Add prefix text for phone number field
              prefixText: label == 'Phone Number' && !controller.text.startsWith('+') ? '+92 ' : null,
              prefixStyle: const TextStyle(color: Colors.grey),
              // Show error icon if server validation error exists
              suffixIcon: serverError != null
                  ? Icon(Icons.error, color: Colors.red)
                  : null,
              // Add server error message to input decoration
              errorText: serverError,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }

              // Client-side validation
              if (keyboardType == TextInputType.emailAddress && !value.contains('@')) {
                return 'Please enter a valid email';
              }

              // Validate Pakistan phone number for phone field
              if (keyboardType == TextInputType.phone) {
                if (!_pakistanPhoneRegex.hasMatch(value)) {
                  return 'Please enter a valid Pakistan mobile number';
                }
              }

              return null;
            },
            // Format the phone number as the user types
            onChanged: (value) {
              // When user starts typing, clear any server validation errors for this field
              if (serverError != null) {
                // We can't modify the validationErrors map directly, so we just rebuild UI
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  profileProvider.clearAllErrors();
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF2196F3)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: ElevatedButton(
        onPressed: _saveChanges,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
        child: const Text(
          'Save',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> _saveChanges() async {
    // Clear any previous validation errors before validating again
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    profileProvider.clearAllErrors();

    if (_formKey.currentState!.validate()) {
      // Show loading indicator if image is being uploaded (it may take longer)
      if (_selectedImage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Uploading profile image, please wait...'),
            duration: Duration(seconds: 1),
          )
        );
      }

      // Normalize the phone number to +92 format
      String normalizedPhone = normalizePhoneNumber(_phoneController.text);

      // Perform additional validation on the normalized phone
      if (!normalizedPhone.startsWith('+92') || normalizedPhone.length != 13) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid Pakistani phone number in the format +92xxxxxxxxxx'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          )
        );
        return;
      }

      final success = await profileProvider.updateProfile(
        name: _nameController.text,
        email: _emailController.text,
        phone: normalizedPhone,
        cnic: _cnicController.text,
        image: _selectedImage,
      );

      if (success) {
        // Reset selected image since it's now been saved to the server
        setState(() {
          _selectedImage = null;
        });

        // Refresh profile data to get the updated image URL from server
        await profileProvider.getProfileDetails();

        // Ensure app-wide profile data is updated
        if (profileProvider.userProfile != null) {
          // Force a profile fetch across the app
          await profileProvider.getProfileDetails();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Color(0xFF00C853),
          ),
        );

        // Return true and refresh parent screen
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${profileProvider.errorMessage}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Method to normalize Pakistan phone number to +92 format
  String normalizePhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) return phoneNumber;

    // Remove all spaces and dashes
    String cleanNumber = phoneNumber.replaceAll(RegExp(r'[\s-]'), '');

    // Match the number using regex
    Match? match = _pakistanPhoneRegex.firstMatch(cleanNumber);
    if (match != null) {
      // Group 1 is the carrier code (3xx), Group 2 is the 7-digit number
      String carrierCode = match.group(1) ?? '';
      String subscriberNumber = match.group(2) ?? '';

      // Format as +92 followed by the 10-digit number
      return '+92$carrierCode$subscriberNumber';
    }

    // If no match, return original input (should not happen with valid input)
    return phoneNumber;
  }
}