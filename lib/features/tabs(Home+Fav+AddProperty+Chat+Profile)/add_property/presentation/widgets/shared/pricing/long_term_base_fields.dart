
/// Groups the shared Long-Term pricing fields used in both
/// Rent Full Property and Rent a Room flows:
/// - Monthly Rent (required)
/// - Security Deposit (optional, with configurable subtitle)
///
/// UI-only — receives data and callbacks.
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
class LongTermBaseFields extends StatelessWidget {
  final String? monthlyRent;
  final String? deposit;
  final String depositSubtitle;
  final ValueChanged<String> onMonthlyRentChanged;
  final ValueChanged<String> onDepositChanged;
  final String? Function(String?)? rentValidator;
  final String? Function(String?)? depositValidator;

  const LongTermBaseFields({
    super.key,
    this.monthlyRent,
    this.deposit,
    this.depositSubtitle = 'Refundable amount returned at end of lease',
    required this.onMonthlyRentChanged,
    required this.onDepositChanged,
    this.rentValidator,
    this.depositValidator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Monthly Rent
        PricingInputField(
          label: 'Monthly Rent',
          hintText: 'e.g. 5,000',
          initialValue: monthlyRent,
          isRequired: true,
          validator: rentValidator,
          onChanged: onMonthlyRentChanged,
        ),
        const SizedBox(height: 24),

        // Security Deposit
        PricingInputField(
          label: 'Security Deposit',
          hintText: 'e.g. 30,000',
          initialValue: deposit,
          isRequired: false,
          subtitleText: depositSubtitle,
          validator: depositValidator,
          onChanged: onDepositChanged,
        ),
      ],
    );
  }
}
