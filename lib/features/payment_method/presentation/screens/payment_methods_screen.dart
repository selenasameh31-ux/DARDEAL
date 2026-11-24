import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  List<Map<String, dynamic>> _paymentMethods = [
    {
      'type': 'Visa',
      'last4': '4242',
      'expiry': '12/2025',
      'holderName': 'Ahmed Hassan',
      'isDefault': true,
    },
    {
      'type': 'Mastercard',
      'last4': '5555',
      'expiry': '08/2026',
      'holderName': 'Ahmed Hassan',
      'isDefault': false,
    },
    {'type': 'PayPal', 'email': 'ahmed@example.com', 'isDefault': false},
  ];

  void _addNewPaymentMethod() async {
    // ✅ فتح شاشة إضافة طريقة دفع جديدة
    final result = await Navigator.push<Map<String, dynamic>?>(
      context,
      MaterialPageRoute(builder: (_) => const AddPaymentMethodScreen()),
    );

    if (result != null) {
      setState(() {
        // إضافة البطاقة الجديدة إلى القائمة
        _paymentMethods.add({
          'type': result['type'],
          'last4': result['last4'],
          'expiry': result['expiry'],
          'holderName': result['holderName'],
          'isDefault': false,
        });
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment method added successfully!')),
      );
    }
  }

  void _setDefaultMethod(int index) {
    setState(() {
      for (var i = 0; i < _paymentMethods.length; i++) {
        _paymentMethods[i]['isDefault'] = (i == index);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_paymentMethods[index]['type']} set as default'),
      ),
    );
  }

  void _removeMethod(int index) {
    setState(() {
      _paymentMethods.removeAt(index);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Payment method removed')));
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
          "Payment Methods",
          style: TextStyle(
            color: context.titleColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: AppFonts.font,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PaymentMethodsHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _paymentMethods.length,
              itemBuilder: (context, index) {
                return PaymentMethodCard(
                  method: _paymentMethods[index],
                  isDefault: _paymentMethods[index]['isDefault'],
                  onSetDefault: () => _setDefaultMethod(index),
                  onRemove: () => _removeMethod(index),
                );
              },
            ),
          ),
          AddPaymentMethodButton(onTap: _addNewPaymentMethod),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
