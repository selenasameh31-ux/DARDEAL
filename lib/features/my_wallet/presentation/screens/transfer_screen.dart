import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final TextEditingController _recipientController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  void _submitTransfer() {
    if (_recipientController.text.isEmpty) {
      AppSnackBar.info(context, 'Please enter recipient email or phone');
      return;
    }
    if (_amountController.text.isEmpty) {
      AppSnackBar.info(context, 'Please enter an amount');
      return;
    }
    // منطق التحويل الفعلي
    AppSnackBar.info(
      context,
      'Transfer \$${_amountController.text} to ${_recipientController.text}',
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Scaffold(
      backgroundColor: context.scaffoldBgColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: colors.surface,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 56,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: context.titleColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Transfer",
          style: theme.textTheme.titleLarge?.copyWith(
            color: context.titleColor,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        actions: const [],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              "Send money to someone",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.titleColor,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Enter recipient details and amount",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: context.hintColor,
              ),
            ),
            const SizedBox(height: 24),

            // Recipient field
            _buildInputField(
              context,
              label: "Recipient email or phone",
              hint: "example@email.com or +123456789",
              controller: _recipientController,
            ),
            const SizedBox(height: 20),

            // Amount field
            _buildInputField(
              context,
              label: "Amount",
              hint: "0.00",
              controller: _amountController,
              prefix: "\$",
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),

            // Note field (optional)
            _buildInputField(
              context,
              label: "Note (optional)",
              hint: "What's this for?",
              controller: _noteController,
            ),
            const SizedBox(height: 32),

            // Transfer button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submitTransfer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.attentionColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Send Money",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    BuildContext context, {
    required String label,
    required String hint,
    required TextEditingController controller,
    String prefix = "",
    TextInputType keyboardType = TextInputType.text,
  }) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: context.hintColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: context.textFieldBgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.outlineVariant),
          ),
          child: Row(
            children: [
              if (prefix.isNotEmpty)
                Text(
                  prefix,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: context.titleColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (prefix.isNotEmpty) const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  decoration: InputDecoration(
                    hintText: hint,
                    border: InputBorder.none,
                    hintStyle: theme.textTheme.bodyLarge?.copyWith(
                      color: context.hintColor,
                    ),
                  ),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: context.titleColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
