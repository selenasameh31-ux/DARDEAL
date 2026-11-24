import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class ProposedTermsCard extends StatelessWidget {
  final TextEditingController priceController;
  final ValueChanged<String> onPriceChanged;
  final DateTime? leaseStart;
  final VoidCallback onLeaseStartTap;
  final DateTime? leaseEnd;
  final VoidCallback onLeaseEndTap;
  final String selectedPaymentTerm;
  final ValueChanged<String> onPaymentTermChanged;
  final bool showErrors;
  final bool isPriceEditable;
  final VoidCallback onEditTap;

  const ProposedTermsCard({
    super.key,
    required this.priceController,
    required this.onPriceChanged,
    required this.leaseStart,
    required this.onLeaseStartTap,
    required this.leaseEnd,
    required this.onLeaseEndTap,
    required this.selectedPaymentTerm,
    required this.onPaymentTermChanged,
    required this.isPriceEditable,
    required this.onEditTap,
    this.showErrors = false,
  });

  Widget _buildPaymentTermsSegmented(
    BuildContext context,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    final primaryColor = isDark
        ? colorScheme.primary
        : LightColors.lightmaincolor;
    final terms = ['Monthly', 'Quarterly', 'Yearly'];

    return Container(
      height: 45,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surfaceContainerHighest : context.textFieldBgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: terms.map((term) {
          final isSelected = selectedPaymentTerm == term;
          return Expanded(
            child: GestureDetector(
              onTap: () => onPaymentTermChanged(term),
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
                child: Center(
                  child: Text(
                    term,
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
            'Monthly Rent Offer',
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
                  selectionHandleColor:
                      Colors.transparent, // Hide the water drop handle
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
                  fontWeight: FontWeight.normal, // Explicitly normal
                ),
                decoration: InputDecoration(
                  hintText: 'e.g. 25,000',
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
                'Monthly rent is required',
                style: TextStyle(
                  color: Colors.redAccent.shade700,
                  fontSize: 11,
                ),
              ),
            ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: AppDatePickerField(
                  label: 'Lease Start',
                  selectedDate: leaseStart,
                  onTap: onLeaseStartTap,
                  hasError: showErrors && leaseStart == null,
                  errorMessage: 'Select start date',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppDatePickerField(
                  label: 'Lease End',
                  selectedDate: leaseEnd,
                  onTap: onLeaseEndTap,
                  hasError: showErrors && leaseEnd == null,
                  errorMessage: 'Select end date',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Payment Terms',
            style: TextStyle(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          _buildPaymentTermsSegmented(context, colorScheme, isDark),
        ],
      ),
    );
  }
}
