import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DeliveryInfoForm extends StatefulWidget {
  final Function(Map<String, String>?) onDeliveryInfoChanged;
  final bool showTermsConditions;
  final VoidCallback? onTermsPressed;

  const DeliveryInfoForm({
    Key? key,
    required this.onDeliveryInfoChanged,
    this.showTermsConditions = true,
    this.onTermsPressed,
  }) : super(key: key);

  @override
  _DeliveryInfoFormState createState() => _DeliveryInfoFormState();
}

class _DeliveryInfoFormState extends State<DeliveryInfoForm> {
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

  void _updateDeliveryInfo() {
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

          // Address field
          _buildInputField(
            label: 'Delivery Address',
            controller: _addressController,
            hintText: 'Enter your complete address',
            keyboardType: TextInputType.multiline,
            maxLines: 3,
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
          onChanged: (_) => _updateDeliveryInfo(),
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
                _updateDeliveryInfo();
              },
              activeColor: const Color(0xFF00C853),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _agreeToTerms = !_agreeToTerms;
                  });
                  _updateDeliveryInfo();
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