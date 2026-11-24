
/// Groups the shared Short-Term pricing fields used in both
/// Rent Full Property and Rent a Room flows:
/// - Nightly Rate (required)
/// - Security Deposit (optional, with subtitle)
/// - Minimum Stay / Maximum Stay dropdowns
///
/// UI-only — receives data and callbacks.
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
class ShortTermFields extends StatelessWidget {
  final String? nightlyRate;
  final String? deposit;
  final String depositSubtitle;
  final String? minimumStay;
  final String? maximumStay;
  final ValueChanged<String> onNightlyRateChanged;
  final ValueChanged<String> onDepositChanged;
  final ValueChanged<String?> onMinimumStayChanged;
  final ValueChanged<String?> onMaximumStayChanged;
  final String? Function(String?)? nightlyRateValidator;
  final String? Function(String?)? depositValidator;

  const ShortTermFields({
    super.key,
    this.nightlyRate,
    this.deposit,
    this.depositSubtitle = 'Held during stay, fully refundable',
    this.minimumStay,
    this.maximumStay,
    required this.onNightlyRateChanged,
    required this.onDepositChanged,
    required this.onMinimumStayChanged,
    required this.onMaximumStayChanged,
    this.nightlyRateValidator,
    this.depositValidator,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark ? Colors.white70 : const Color(0xFF0F172A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nightly Rate
        PricingInputField(
          label: 'Nightly Rate',
          hintText: 'e.g. 1,200',
          initialValue: nightlyRate,
          isRequired: true,
          validator: nightlyRateValidator,
          onChanged: onNightlyRateChanged,
        ),
        const SizedBox(height: 24),

        // Security Deposit
        PricingInputField(
          label: 'Security Deposit',
          hintText: 'e.g. 2,000',
          initialValue: deposit,
          isRequired: false,
          subtitleText: depositSubtitle,
          validator: depositValidator,
          onChanged: onDepositChanged,
        ),
        const SizedBox(height: 24),

        // Minimum Stay / Maximum Stay
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Minimum Stay',
                    style: TextStyle(
                      fontFamily: AppFonts.font,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: labelColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AppDropdownField(
                    value: minimumStay ?? '2 nights',
                    items: const [
                      '1 night',
                      '2 nights',
                      '3 nights',
                      '1 week',
                    ],
                    onChanged: onMinimumStayChanged,
                    variant: AppInputVariant.formStep,
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
                    'Maximum Stay',
                    style: TextStyle(
                      fontFamily: AppFonts.font,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: labelColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AppDropdownField(
                    value: maximumStay ?? '30 nights',
                    items: const [
                      '14 nights',
                      '30 nights',
                      '90 nights',
                      'No limit',
                    ],
                    onChanged: onMaximumStayChanged,
                    variant: AppInputVariant.formStep,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
