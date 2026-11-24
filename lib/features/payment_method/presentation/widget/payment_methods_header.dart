import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class PaymentMethodsHeader extends StatelessWidget {
  const PaymentMethodsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your Payment Methods",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: context.titleColor,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Manage your saved cards and payment options",
            style: theme.textTheme.bodySmall?.copyWith(
              color: context.hintColor,
            ),
          ),
        ],
      ),
    );
  }
}
