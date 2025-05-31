import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum PaymentMethod { jazzCash, easyPaisa, bankAccount }

class PaymentMethodSelection extends StatefulWidget {
  final Function(Map<String, String>?) onPaymentInfoChanged;
  final bool showTermsConditions;
  final VoidCallback? onTermsPressed;

  const PaymentMethodSelection({
    Key? key,
    required this.onPaymentInfoChanged,
    this.showTermsConditions = true,
    this.onTermsPressed,
  }) : super(key: key);

  @override
  _PaymentMethodSelectionState createState() => _PaymentMethodSelectionState();
}

class _PaymentMethodSelectionState extends State<PaymentMethodSelection> {
  PaymentMethod? _selectedMethod;
  bool _agreeToTerms = false;
  
  // Controllers for form fields
  final _accountHolderController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _bankNameController = TextEditingController();

  @override
  void dispose() {
    _accountHolderController.dispose();
    _accountNumberController.dispose();
    _bankNameController.dispose();
    super.dispose();
  }

  void _updatePaymentInfo() {
    if (_selectedMethod == null || !_agreeToTerms) {
      widget.onPaymentInfoChanged(null);
      return;
    }

    Map<String, String> paymentInfo = {
      'method': _selectedMethod!.name,
      'accountHolderName': _accountHolderController.text.trim(),
      'accountNumber': _accountNumberController.text.trim(),
    };

    if (_selectedMethod == PaymentMethod.bankAccount) {
      paymentInfo['bankName'] = _bankNameController.text.trim();
    }

    // Check if all required fields are filled
    if (paymentInfo['accountHolderName']!.isEmpty || 
        paymentInfo['accountNumber']!.isEmpty ||
        (_selectedMethod == PaymentMethod.bankAccount && paymentInfo['bankName']!.isEmpty)) {
      widget.onPaymentInfoChanged(null);
      return;
    }

    widget.onPaymentInfoChanged(paymentInfo);
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
            'Select Payment Method',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Payment method options
          _buildPaymentMethodOption(
            PaymentMethod.jazzCash,
            'JazzCash',
            'assets/icons/jazzcash.png', // You might want to add this icon
          ),
          const SizedBox(height: 12),
          
          _buildPaymentMethodOption(
            PaymentMethod.easyPaisa,
            'EasyPaisa',
            'assets/icons/easypaisa.png', // You might want to add this icon
          ),
          const SizedBox(height: 12),
          
          _buildPaymentMethodOption(
            PaymentMethod.bankAccount,
            'Bank Account',
            'assets/icons/bank.png', // You might want to add this icon
          ),
          
          const SizedBox(height: 20),

          // Payment details form
          if (_selectedMethod != null) ...[
            const Divider(),
            const SizedBox(height: 20),
            _buildPaymentForm(),
          ],

          // Terms & Conditions
          if (widget.showTermsConditions) ...[
            const SizedBox(height: 20),
            _buildTermsAndConditions(),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentMethodOption(PaymentMethod method, String title, String iconPath) {
    final isSelected = _selectedMethod == method;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMethod = method;
          // Clear form when switching methods
          _accountHolderController.clear();
          _accountNumberController.clear();
          _bankNameController.clear();
        });
        _updatePaymentInfo();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? const Color(0xFF00C853) : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? const Color(0xFF00C853).withOpacity(0.1) : Colors.transparent,
        ),
        child: Row(
          children: [
            // Icon placeholder (you can replace with actual icons)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.payment, color: Colors.grey),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? const Color(0xFF00C853) : Colors.black87,
                ),
              ),
            ),
            Radio<PaymentMethod>(
              value: method,
              groupValue: _selectedMethod,
              onChanged: (PaymentMethod? value) {
                setState(() {
                  _selectedMethod = value;
                  // Clear form when switching methods
                  _accountHolderController.clear();
                  _accountNumberController.clear();
                  _bankNameController.clear();
                });
                _updatePaymentInfo();
              },
              activeColor: const Color(0xFF00C853),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_getMethodDisplayName()} Details',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Bank Name (only for bank account)
        if (_selectedMethod == PaymentMethod.bankAccount) ...[
          _buildInputField(
            label: 'Bank Name',
            controller: _bankNameController,
            hintText: 'Enter bank name',
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 16),
        ],

        // Account Holder Name
        _buildInputField(
          label: 'Account Holder Name',
          controller: _accountHolderController,
          hintText: 'Enter account holder name',
          keyboardType: TextInputType.text,
        ),
        const SizedBox(height: 16),

        // Account Number
        _buildInputField(
          label: 'Account Number',
          controller: _accountNumberController,
          hintText: 'Enter account number',
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
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
          onChanged: (_) => _updatePaymentInfo(),
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
                _updatePaymentInfo();
              },
              activeColor: const Color(0xFF00C853),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _agreeToTerms = !_agreeToTerms;
                  });
                  _updatePaymentInfo();
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

  String _getMethodDisplayName() {
    switch (_selectedMethod) {
      case PaymentMethod.jazzCash:
        return 'JazzCash';
      case PaymentMethod.easyPaisa:
        return 'EasyPaisa';
      case PaymentMethod.bankAccount:
        return 'Bank Account';
      default:
        return '';
    }
  }
}