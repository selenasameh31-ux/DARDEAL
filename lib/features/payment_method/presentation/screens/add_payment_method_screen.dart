import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class AddPaymentMethodScreen extends StatefulWidget {
  const AddPaymentMethodScreen({super.key});

  @override
  State<AddPaymentMethodScreen> createState() => _AddPaymentMethodScreenState();
}

class _AddPaymentMethodScreenState extends State<AddPaymentMethodScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardHolderController = TextEditingController();
  String _cardType = 'Visa'; // Default

  void _savePaymentMethod() {
    if (_formKey.currentState!.validate()) {
      // هنا يمكن إضافة منطق حفظ البيانات (API أو تخزين محلي)
      // ثم العودة إلى الشاشة السابقة مع إشارة النجاح
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment method added successfully!')),
      );
    }
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cardHolderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Scaffold(
      backgroundColor: context.scaffoldBgColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0.0,
        backgroundColor: context.scaffoldBgColor,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 56,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: context.titleColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Add Payment Method",
          style: TextStyle(
            color: context.titleColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: AppFonts.font,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _savePaymentMethod,
            child: Text(
              "Save",
              style: TextStyle(
                color: context.attentionColor,
                fontWeight: FontWeight.w600,
                fontSize: 15,
                fontFamily: AppFonts.font,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Card Type Selector
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: context.textFieldBgColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colors.outlineVariant.withOpacity(0.5),
                ),
              ),
              child: DropdownButtonFormField<String>(
                value: _cardType,
                decoration: const InputDecoration(
                  labelText: "Card Type",
                  border: InputBorder.none,
                ),
                items: const [
                  DropdownMenuItem(value: "Visa", child: Text("Visa")),
                  DropdownMenuItem(
                    value: "Mastercard",
                    child: Text("Mastercard"),
                  ),
                  DropdownMenuItem(value: "PayPal", child: Text("PayPal")),
                ],
                onChanged: (value) {
                  setState(() {
                    _cardType = value!;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select card type' : null,
              ),
            ),
            const SizedBox(height: 16),

            if (_cardType != 'PayPal') ...[
              // Card Number
              _buildTextField(
                controller: _cardNumberController,
                label: "Card Number",
                hint: "1234 5678 9012 3456",
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Card number is required';
                  if (value.replaceAll(' ', '').length < 16)
                    return 'Enter a valid 16-digit card number';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Expiry and CVV in a row
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _expiryController,
                      label: "Expiry Date",
                      hint: "MM/YY",
                      keyboardType: TextInputType.datetime,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Expiry date is required';
                        if (!RegExp(
                          r'^(0[1-9]|1[0-2])\/\d{2}$',
                        ).hasMatch(value)) {
                          return 'Enter MM/YY format';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _cvvController,
                      label: "CVV",
                      hint: "123",
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'CVV is required';
                        if (value.length < 3) return 'Enter 3 or 4 digits';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Cardholder Name
            _buildTextField(
              controller: _cardHolderController,
              label: "Cardholder Name",
              hint: "Name on card",
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'Cardholder name is required';
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Save Button (Duplicate for clarity)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _savePaymentMethod,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.attentionColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Save Payment Method",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w500,
            color: context.hintColor,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colors.outlineVariant.withOpacity(0.5),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colors.outlineVariant.withOpacity(0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: context.primaryColor, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          style: theme.textTheme.bodyMedium?.copyWith(color: context.titleColor),
        ),
      ],
    );
  }
}
