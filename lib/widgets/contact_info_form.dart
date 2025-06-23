import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContactInfoForm extends StatefulWidget {
  final Function(Map<String, String>?) onContactInfoChanged;
  final bool showTermsConditions;
  final VoidCallback? onTermsPressed;

  const ContactInfoForm({
    Key? key,
    required this.onContactInfoChanged,
    this.showTermsConditions = true,
    this.onTermsPressed,
  }) : super(key: key);

  @override
  _ContactInfoFormState createState() => _ContactInfoFormState();
}

class _ContactInfoFormState extends State<ContactInfoForm> {
  bool _agreeToTerms = false;
  
  // Controllers for form fields
  final _nameController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _contactNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _updateContactInfo() {
    if (!_agreeToTerms) {
      widget.onContactInfoChanged(null);
      return;
    }

    Map<String, String> contactInfo = {
      'name': _nameController.text.trim(),
      'contactNumber': _contactNumberController.text.trim(),
    };
    
    // Add address if provided (optional)
    if (_addressController.text.trim().isNotEmpty) {
      contactInfo['address'] = _addressController.text.trim();
    }

    // Check if all required fields are filled
    if (contactInfo['name']!.isEmpty || 
        contactInfo['contactNumber']!.isEmpty) {
      widget.onContactInfoChanged(null);
      return;
    }

    widget.onContactInfoChanged(contactInfo);
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
            'Contact Information',
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
          ),
          const SizedBox(height: 16),

          // Contact Number field
          _buildInputField(
            label: 'Contact Number',
            controller: _contactNumberController,
            hintText: 'Enter your contact number',
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 16),

          // Address field (optional)
          _buildInputField(
            label: 'Address',
            controller: _addressController,
            hintText: 'Enter your address (optional)',
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            isOptional: true,
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
    bool isOptional = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            if (isOptional) ...[
              const Text(
                ' (Optional)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
              ),
          ],
        ]),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          onChanged: (_) => _updateContactInfo(),
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF00C853)),
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
                });
                _updateContactInfo();
              },
              activeColor: const Color(0xFF00C853),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _agreeToTerms = !_agreeToTerms;
                  });
                  _updateContactInfo();
                },
                child: const Text(
                  'I agree to the Terms & Conditions',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
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