import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DeliveryInfoForm extends StatefulWidget {
  final Function(Map<String, String>?) onDeliveryInfoChanged;
  final bool showTermsConditions;
  final VoidCallback? onTermsPressed;
  final Function(Function())? onValidationReady;

  const DeliveryInfoForm({
    Key? key,
    required this.onDeliveryInfoChanged,
    this.showTermsConditions = true,
    this.onTermsPressed,
    this.onValidationReady,
  }) : super(key: key);

  @override
  DeliveryInfoFormState createState() => DeliveryInfoFormState();
}

class DeliveryInfoFormState extends State<DeliveryInfoForm> {
  bool _agreeToTerms = false;
  bool _showValidationErrors = false;
  
  // Controllers for form fields
  final _nameController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _addressController = TextEditingController();
  
  // Validation errors
  String? _nameError;
  String? _contactNumberError;
  String? _addressError;
  String? _termsError;

  @override
  void initState() {
    super.initState();
    // Provide the validation function to parent after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onValidationReady?.call(validateFields);
    });
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _contactNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _updateDeliveryInfo() {
    if (!_showValidationErrors) {
      // Only validate silently when not showing errors
      if (!_agreeToTerms) {
        widget.onDeliveryInfoChanged(null);
        return;
      }

      Map<String, String> deliveryInfo = {
        'name': _nameController.text.trim(),
        'contactNumber': _contactNumberController.text.trim(),
        'address': _addressController.text.trim(),
      };

      // Check if all required fields are filled
      if (deliveryInfo['name']!.isEmpty || 
          deliveryInfo['contactNumber']!.isEmpty ||
          deliveryInfo['address']!.isEmpty) {
        widget.onDeliveryInfoChanged(null);
        return;
      }

      widget.onDeliveryInfoChanged(deliveryInfo);
    }
  }
  
  bool validateFields() {
    setState(() {
      _showValidationErrors = true;
      _nameError = null;
      _contactNumberError = null;
      _addressError = null;
      _termsError = null;
    });
    
    bool isValid = true;
    
    // Validate name
    if (_nameController.text.trim().isEmpty) {
      _nameError = 'Full name is required';
      isValid = false;
    }
    
    // Validate contact number
    if (_contactNumberController.text.trim().isEmpty) {
      _contactNumberError = 'Contact number is required';
      isValid = false;
    }
    
    // Validate address
    if (_addressController.text.trim().isEmpty) {
      _addressError = 'Delivery address is required';
      isValid = false;
    }
    
    // Validate terms agreement
    if (!_agreeToTerms) {
      _termsError = 'Please agree to terms and conditions';
      isValid = false;
    }
    
    setState(() {});
    
    if (isValid) {
      Map<String, String> deliveryInfo = {
        'name': _nameController.text.trim(),
        'contactNumber': _contactNumberController.text.trim(),
        'address': _addressController.text.trim(),
      };
      
      widget.onDeliveryInfoChanged(deliveryInfo);
    } else {
      widget.onDeliveryInfoChanged(null);
    }
    
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Delivery Information',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Name field
          _buildInputField(
            label: 'Full Name',
            controller: _nameController,
            hintText: 'Enter your full name',
            keyboardType: TextInputType.text,
            errorText: _showValidationErrors ? _nameError : null,
          ),
          const SizedBox(height: 16),

          // Contact Number field
          _buildInputField(
            label: 'Contact Number',
            controller: _contactNumberController,
            hintText: 'Enter your contact number',
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            errorText: _showValidationErrors ? _contactNumberError : null,
          ),
          const SizedBox(height: 16),

          // Address field
          _buildInputField(
            label: 'Delivery Address',
            controller: _addressController,
            hintText: 'Enter your complete address',
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            errorText: _showValidationErrors ? _addressError : null,
          ),

          // Terms & Conditions
          if (widget.showTermsConditions) ...[
            const SizedBox(height: 20),
            _buildTermsAndConditions(),
          ],
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          onChanged: (_) {
            if (_showValidationErrors) {
              // Clear error when user starts typing
              setState(() {
                if (controller == _nameController) {
                  _nameError = null;
                } else if (controller == _contactNumberController) {
                  _contactNumberError = null;
                } else if (controller == _addressController) {
                  _addressError = null;
                }
              });
            }
            _updateDeliveryInfo();
          },
          decoration: InputDecoration(
            hintText: hintText,
            errorText: errorText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: errorText != null ? Colors.red : Colors.grey[300]!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: errorText != null ? Colors.red : const Color(0xFF00C853),
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTermsAndConditions() {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: _agreeToTerms,
              onChanged: (bool? value) {
                setState(() {
                  _agreeToTerms = value ?? false;
                  if (_showValidationErrors && _agreeToTerms) {
                    _termsError = null;
                  }
                });
                _updateDeliveryInfo();
              },
              activeColor: const Color(0xFF00C853),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _agreeToTerms = !_agreeToTerms;
                    if (_showValidationErrors && _agreeToTerms) {
                      _termsError = null;
                    }
                  });
                  _updateDeliveryInfo();
                },
                child: Text(
                  'I agree to the Terms & Conditions',
                  style: TextStyle(
                    fontSize: 14,
                    color: _showValidationErrors && _termsError != null ? Colors.red : Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
        
        // Terms error message
        if (_showValidationErrors && _termsError != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.red.shade300),
            ),
            child: Text(
              _termsError!,
              style: TextStyle(color: Colors.red.shade800, fontSize: 12),
            ),
          ),
        ],
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: widget.onTermsPressed,
            child: const Text(
              'View Terms & Conditions',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF00C853),
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}