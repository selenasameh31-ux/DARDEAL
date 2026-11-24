import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class SaleProposedTermsCard extends StatelessWidget {
  final TextEditingController priceController;
  final ValueChanged<String> onPriceChanged;
  final bool isPriceEditable;
  final VoidCallback onEditTap;

  final String selectedPaymentMethod;
  final ValueChanged<String> onPaymentMethodChanged;

  final TextEditingController downPaymentController;
  final ValueChanged<String> onDownPaymentChanged;

  final String selectedInstallmentDuration;
  final ValueChanged<String> onInstallmentDurationChanged;

  final DateTime? leaseStart;
  final VoidCallback onLeaseStartTap;

  final bool showErrors;

  const SaleProposedTermsCard({
    super.key,
    required this.priceController,
    required this.onPriceChanged,
    required this.isPriceEditable,
    required this.onEditTap,
    required this.selectedPaymentMethod,
    required this.onPaymentMethodChanged,
    required this.downPaymentController,
    required this.onDownPaymentChanged,
    required this.selectedInstallmentDuration,
    required this.onInstallmentDurationChanged,
    required this.leaseStart,
    required this.onLeaseStartTap,
    this.showErrors = false,
  });

  String _calculateMonthlyInstallment(
    String priceStr,
    String downPaymentStr,
    String durationStr,
  ) {
    if (priceStr.isEmpty) return "—";

    final price = double.tryParse(priceStr.replaceAll(',', '')) ?? 0.0;

    final downPayment = downPaymentStr.isNotEmpty
        ? (double.tryParse(downPaymentStr.replaceAll(',', '')) ?? 0.0)
        : 0.0;

    if (price <= downPayment) return "—";

    int months = 12; // default
    final match = RegExp(r'\d+').firstMatch(durationStr);
    if (match != null) {
      months = int.tryParse(match.group(0) ?? '12') ?? 12;
    }

    if (months <= 0) return "—";

    final monthly = (price - downPayment) / months;

    final wholePart = monthly.round().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < wholePart.length; i++) {
      if (i > 0 && (wholePart.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(wholePart[i]);
    }

    return "${buffer.toString()} EGP";
  }

  Widget _buildPaymentMethodsSegmented(
    BuildContext context,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    final primaryColor = isDark
        ? colorScheme.primary
        : LightColors.lightmaincolor;
    final methods = ['Cash', 'Installments'];

    IconData getIconForOption(String option) {
      if (option == "Cash") return Icons.payments_outlined;
      if (option == "Installments") return Icons.credit_card_outlined;
      return Icons.account_balance_wallet_outlined;
    }

    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHighest
            : context.textFieldBgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: methods.map((method) {
          final isSelected = selectedPaymentMethod == method;
          return Expanded(
            child: GestureDetector(
              onTap: () => onPaymentMethodChanged(method),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? colorScheme.surface : Colors.white)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      getIconForOption(method),
                      size: 16,
                      color: isSelected
                          ? primaryColor
                          : colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      method,
                      style: TextStyle(
                        color: isSelected
                            ? primaryColor
                            : colorScheme.onSurfaceVariant,
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final fieldBg = isDark
        ? colorScheme.surfaceContainerHighest
        : Colors.grey[50];
    final borderColor = colorScheme.outlineVariant.withValues(alpha: 0.6);

    final showInstallments = selectedPaymentMethod == 'Installments';

    final primaryColor = isDark
        ? colorScheme.primary
        : LightColors.lightmaincolor;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Purchase Price Offer',
            style: TextStyle(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: fieldBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: (showErrors && priceController.text.isEmpty)
                    ? Colors.redAccent
                    : borderColor,
              ),
            ),
            child: Theme(
              data: theme.copyWith(
                textSelectionTheme: TextSelectionThemeData(
                  selectionHandleColor: Colors.transparent,
                  cursorColor: isDark
                      ? colorScheme.primary
                      : LightColors.lightmaincolor,
                  selectionColor:
                      (isDark
                              ? colorScheme.primary
                              : LightColors.lightmaincolor)
                          .withValues(alpha: 0.3),
                ),
              ),
              child: TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: onPriceChanged,
                readOnly: !isPriceEditable,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
                decoration: InputDecoration(
                  hintText: 'e.g. 3,500,000',
                  hintStyle: TextStyle(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    fontSize: 16,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: InputBorder.none,
                  suffixIcon: Container(
                    width: 80,
                    padding: const EdgeInsets.only(right: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'EGP',
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: onEditTap,
                          child: Icon(
                            Icons.edit_outlined,
                            size: 16,
                            color: isDark
                                ? colorScheme.primary
                                : LightColors.lightmaincolor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (showErrors && priceController.text.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 4),
              child: Text(
                'Proposed price is required',
                style: TextStyle(
                  color: Colors.redAccent.shade700,
                  fontSize: 11,
                ),
              ),
            ),
          const SizedBox(height: 16),
          AppDatePickerField(
            label: 'Handover Date',
            selectedDate: leaseStart,
            onTap: onLeaseStartTap,
            hasError: showErrors && leaseStart == null,
            errorMessage: 'Select handover date',
          ),
          const SizedBox(height: 20),

          Text(
            'Payment Method',
            style: TextStyle(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          _buildPaymentMethodsSegmented(context, colorScheme, isDark),
          const SizedBox(height: 20),

          // Installments inputs
          if (showInstallments) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Down Payment',
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: fieldBg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                (showErrors &&
                                    downPaymentController.text.isEmpty)
                                ? Colors.redAccent
                                : borderColor,
                          ),
                        ),
                        child: TextField(
                          controller: downPaymentController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: onDownPaymentChanged,
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 15,
                          ),
                          decoration: InputDecoration(
                            hintText: 'e.g. 500,000',
                            hintStyle: TextStyle(
                              color: colorScheme.onSurfaceVariant.withValues(
                                alpha: 0.5,
                              ),
                              fontSize: 13,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            border: InputBorder.none,
                            suffixText: 'EGP',
                            suffixStyle: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      if (showErrors && downPaymentController.text.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4, left: 4),
                          child: Text(
                            'Down payment is required',
                            style: TextStyle(
                              color: Colors.redAccent.shade700,
                              fontSize: 11,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Duration',
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      AppDropdownField(
                        value: selectedInstallmentDuration,
                        items: const [
                          '12 months',
                          '24 months',
                          '36 months',
                          '48 months',
                          '60 months',
                          '72 months',
                          '84 months',
                          '96 months',
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            onInstallmentDurationChanged(val);
                          }
                        },
                        variant: AppInputVariant.formStep,
                        icon: Icon(
                          Icons.unfold_more,
                          color: isDark
                              ? Colors.white54
                              : const Color(0xFF64748B),
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Monthly Installment estimation card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E2A2E)
                    : const Color(0xFFF2F8F8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFD6E4E4).withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Est. Monthly Installment",
                        style: TextStyle(
                          color: isDark
                              ? Colors.white60
                              : const Color(0xFF64748B),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _calculateMonthlyInstallment(
                          priceController.text,
                          downPaymentController.text,
                          selectedInstallmentDuration,
                        ),
                        style: TextStyle(
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.edit_calendar_outlined,
                    color: primaryColor.withValues(alpha: 0.6),
                    size: 22,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
