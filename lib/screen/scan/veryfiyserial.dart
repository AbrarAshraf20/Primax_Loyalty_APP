/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../core/utils/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text__form_field.dart';
import '../dashboard_screen/dashboard_screen.dart';
import '../login_screen/login_screen.dart';

class VerifySerial extends StatefulWidget {
  // Role: Installer, Dealer, or Distributor
  const VerifySerial({Key? key}) : super(key: key);

  @override
  State<VerifySerial> createState() => _VerifySerialState();
}

class _VerifySerialState extends State<VerifySerial> {
  bool isEmailSelected = true;
  bool isPasswordVisible = false;
  bool isKeepSignedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Verify Serial ',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),



            const SizedBox(height: 20),
            Text('Name',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
            const SizedBox(height: 5),
            CustomTextFormField(
              // decoration: InputDecoration(
              hintText: 'Name',
              hintStyle: TextStyle(color: Colors.grey),

            ),
            const SizedBox(height: 20),
            Text('Mobile',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
            const SizedBox(height: 5),
            CustomTextFormField(
              // decoration: InputDecoration(
              hintText:   'Mobile',
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(8),
              // ),
              hintStyle: TextStyle(color: Colors.grey),
              // ),
            ),
            const SizedBox(height: 20),
            Text('Item',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
            const SizedBox(height: 5),
            CustomTextFormField(
              obscureText: !isPasswordVisible,
              hintStyle: TextStyle(color: Colors.grey),
              // decoration: InputDecoration(
              hintText: 'Item',
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(8),
              // )
               suffix: IconButton(
                                 icon: SvgPicture.asset('assets/icons/MainIcon.svg'),
                                 onPressed: () {}
                             ),

              // ),
            ),
            const SizedBox(height: 20),
            Text('City',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
            const SizedBox(height: 5),
            CustomTextFormField(
              // decoration: InputDecoration(
              hintText: 'City',
              hintStyle: TextStyle(color: Colors.grey),
              suffix: IconButton(
                  icon: SvgPicture.asset('assets/icons/MainIcon.svg'),
                  onPressed: () {}
              ),

            ),
            const SizedBox(height: 20),
            Text('Customer Name',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
            const SizedBox(height: 5),
            CustomTextFormField(
              // decoration: InputDecoration(
              hintText: 'Customer name',
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(8),
              // ),
              hintStyle: TextStyle(color: Colors.grey),

            ),
            const SizedBox(height: 20),
            Text('Customer Contact info',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
            const SizedBox(height: 5),
            CustomTextFormField(
              obscureText: !isPasswordVisible,
              hintStyle: TextStyle(color: Colors.grey),
              // decoration: InputDecoration(
              hintText: 'Customer Contact info',
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(8),
              // ),

              // ),
            ),
            const SizedBox(height: 20),
            Text('Customer address',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
            const SizedBox(height: 5),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Customer address",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              ),
            ),
            const SizedBox(height: 20),
            Text('Upload Pics of Installation Site',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
            const SizedBox(height: 5),
            CustomTextFormField(
              obscureText: !isPasswordVisible,
              hintStyle: TextStyle(color: Colors.grey),
              // decoration: InputDecoration(
              hintText: 'Dreg file her',
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(8),
              // ),
               suffix: Container(
                 width: 120,height: 50,
                 decoration: BoxDecoration( 
                   borderRadius: BorderRadius.circular(5),
                   gradient: LinearGradient(

                   colors: [
                     const Color(0xFF00C853), // Default green
                     const Color(0xFF00B0FF), // Default blue
                   ],
                 ),),
                 child: Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [Image.asset(
                   'assets/images/folder.png',scale: 2, // Replace with actual asset

                                  ),

                     Text('Browse...',style: TextStyle(color: Colors.white),)],),
                 ),),
              // ),
            ),
            const SizedBox(height: 20),
            Text('Remarks',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
            const SizedBox(height: 5),
            CustomTextFormField(
              obscureText: !isPasswordVisible,
              hintStyle: TextStyle(color: Colors.grey),
              // decoration: InputDecoration(
              hintText: 'Remarks',
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(8),
              // ),

              // ),
            ),

            const SizedBox(height: 20),
            CustomButton(
              onPressed: () {
                // Handle login
                DashboardScreen().launch(context,pageRouteAnimation: PageRouteAnimation.Slide,);

              },
              width: double.maxFinite,
              text:'Save',
            ),

          ],
        ),
      ),
    );
  }
}*/



import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../core/providers/scan_provider.dart';
import '../../core/utils/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text__form_field.dart';
import '../dashboard_screen/dashboard_screen.dart';

class VerifySerial extends StatefulWidget {
  final String scanNumber;
  
  const VerifySerial({
    Key? key, 
    required this.scanNumber
  }) : super(key: key);

  @override
  State<VerifySerial> createState() => _VerifySerialState();
}

class _VerifySerialState extends State<VerifySerial> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  bool isLoading = false;
  File? _selectedImage;
  
  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerContactController = TextEditingController();
  final TextEditingController _customerAddressController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _cnicController = TextEditingController();
  final TextEditingController _serialNumController = TextEditingController();
  
  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _itemController.dispose();
    _cityController.dispose();
    _customerNameController.dispose();
    _customerContactController.dispose();
    _customerAddressController.dispose();
    _remarksController.dispose();
    _cnicController.dispose();
    _serialNumController.dispose();
    super.dispose();
  }
  
  Future<void> _pickImage() async {
    // Show option dialog for camera or gallery
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 200,
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'Select Image Source',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Camera option
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _getImage(ImageSource.camera);
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: const Color(0xFF00B0FF).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: const Color(0xFF00B0FF),
                            size: 30,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Camera',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Gallery option
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _getImage(ImageSource.gallery);
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: const Color(0xFF00C853).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.image,
                            color: const Color(0xFF00C853),
                            size: 30,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Gallery',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  
  Future<void> _getImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 80, // Reduce image quality to save space
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }
  
  // Submit the form
  Future<void> _submitForm() async {
    // Validate the form
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    // Check if image is selected
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an installation image')),
      );
      return;
    }
    
    setState(() {
      isLoading = true;
    });
    
    final scanProvider = Provider.of<ScanProvider>(context, listen: false);
    
    try {
      final success = await scanProvider.verifySerial(
        serialNumber: widget.scanNumber, // Pass the scan number
        name: _nameController.text,
        mobile: _mobileController.text,
        item: _itemController.text,
        city: _cityController.text,
        customerName: _customerNameController.text,
        customerContactInfo: _customerContactController.text,
        customerAddress: _customerAddressController.text,
        remarks: _remarksController.text,
        cnic: _cnicController.text,
        serialNum: _serialNumController.text,
        image: _selectedImage!,
      );
      
      setState(() {
        isLoading = false;
      });
      
      if (success) {
        _showSuccessScreen();
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }
  
  // Show success screen with API response
  void _showSuccessScreen() {
    final scanProvider = Provider.of<ScanProvider>(context, listen: false);
    final message = scanProvider.verificationMessage;
    final barcode = scanProvider.verificationBarcode;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.green,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Success!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  message, // Use API response message
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                // Display barcode if available
                if (barcode.isNotEmpty)
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.qr_code, size: 20, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          'Barcode: $barcode',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),
                CustomButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pop(); // Go back to scan screen
                  },
                  width: double.infinity,
                  text: 'Done',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/LuckyDraw.png"), // Ensure the correct path
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Material(
                      borderRadius: BorderRadius.circular(20),
                      elevation: 2,
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: Icon(CupertinoIcons.back, color: Colors.black),
                        ),
                      ),
                    ),
                    Text(
                      'Verify Serial',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    // Consumer<ScanProvider>(
                    //   builder: (context, provider, _) {
                    //     return Container(
                    //       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    //       decoration: BoxDecoration(
                    //         gradient: LinearGradient(
                    //           begin: Alignment.topCenter,
                    //           end: Alignment.bottomCenter,
                    //           colors: [
                    //             const Color(0xFF00C853), // Default green
                    //             const Color(0xFF00B0FF), // Default blue
                    //           ],
                    //         ),
                    //         borderRadius: BorderRadius.circular(10),
                    //       ),
                    //       child: Row(
                    //         children: [
                    //           Icon(Icons.stars, color: Colors.white),
                    //           SizedBox(width: 4),
                    //           Text('160', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    //         ],
                    //       ),
                    //     );
                    //   },
                    // )
                  ],
                ),
                const SizedBox(height: 10),
                
                // Display scan number
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF00B0FF), width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.qr_code, color: const Color(0xFF00B0FF)),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Serial number of inverter', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(widget.scanNumber, style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

              Text('CNIC Number', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 5),
              CustomTextFormField(
                controller: _cnicController,
                hintText: 'CNIC Number (e.g., 12345-1234567-1)',
                hintStyle: TextStyle(color: Colors.grey),
                textInputType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter CNIC number';
                  }
                  // Basic CNIC validation (13 digits with or without dashes)
                  String cnicPattern = r'^[0-9]{5}-?[0-9]{7}-?[0-9]{1}$';
                  RegExp regExp = RegExp(cnicPattern);
                  if (!regExp.hasMatch(value.replaceAll('-', '').replaceAll(' ', ''))) {
                    return 'Please enter a valid CNIC number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              Text('Serial Number', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 5),
              CustomTextFormField(
                controller: _serialNumController,
                hintText: 'Serial Number',
                hintStyle: TextStyle(color: Colors.grey),
                validator: (value) => value == null || value.isEmpty ? 'Please enter serial number' : null,
              ),
              const SizedBox(height: 20),

              Text('Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 5),
              CustomTextFormField(
                controller: _nameController,
                hintText: 'Name',
                hintStyle: TextStyle(color: Colors.grey),
                validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 20),

              Text('Mobile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 5),
              CustomTextFormField(
                controller: _mobileController,
                hintText: 'Mobile',
                hintStyle: TextStyle(color: Colors.grey),
                // keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty ? 'Please enter mobile number' : null,
              ),
              const SizedBox(height: 20),

              Text('Inverter Model', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 5),
              CustomTextFormField(
                controller: _itemController,
                hintText: 'Inverter Model',
                hintStyle: TextStyle(color: Colors.grey),
                suffix: IconButton(
                  icon: Icon(Icons.search, color: const Color(0xFF00B0FF)),
                  onPressed: () {},
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please enter item name' : null,
              ),
              const SizedBox(height: 20),

              Text('City', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 5),
              CustomTextFormField(
                controller: _cityController,
                hintText: 'City',
                hintStyle: TextStyle(color: Colors.grey),
                suffix: IconButton(
                  icon: Icon(Icons.search, color: const Color(0xFF00B0FF)),
                  onPressed: () {},
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please enter city' : null,
              ),
              const SizedBox(height: 20),

              Text('Customer Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 5),
              CustomTextFormField(
                controller: _customerNameController,
                hintText: 'Customer name',
                hintStyle: TextStyle(color: Colors.grey),
                validator: (value) => value == null || value.isEmpty ? 'Please enter customer name' : null,
              ),
              const SizedBox(height: 20),

              Text('Customer Contact info', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 5),
              CustomTextFormField(
                controller: _customerContactController,
                hintText: 'Customer Contact info',
                hintStyle: TextStyle(color: Colors.grey),
                // keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty ? 'Please enter customer contact info' : null,
              ),
              const SizedBox(height: 20),

              Text('Customer address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 5),
              TextField(
                controller: _customerAddressController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Customer address",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
              ),
              const SizedBox(height: 20),

              Text('Upload Selfie with inverter', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 5),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        child: _selectedImage != null 
                          ? Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.green),
                                SizedBox(width: 8),
                                Expanded(child: Text('Image selected', overflow: TextOverflow.ellipsis)),
                              ],
                            )
                          : Text('Upload Selfie with inverter', style: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    InkWell(
                      onTap: _pickImage,
                      child: Container(
                        width: 120,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF00C853), // Default green
                              const Color(0xFF00B0FF), // Default blue
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.file_upload, color: Colors.white, size: 20),
                              Text('Browse...', style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Text('Remarks', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 5),
              CustomTextFormField(
                controller: _remarksController,
                hintText: 'Remarks',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              
              // Error message if any
              Consumer<ScanProvider>(
                builder: (context, provider, _) {
                  if (provider.errorMessage.isNotEmpty) {
                    return Container(
                      padding: EdgeInsets.all(12),
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        provider.errorMessage,
                        style: TextStyle(color: Colors.red.shade800),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),

              // Submit button
              CustomButton(
                onPressed: _submitForm,
                isLoading: isLoading,
                width: double.infinity,
                text: 'Submit',
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
