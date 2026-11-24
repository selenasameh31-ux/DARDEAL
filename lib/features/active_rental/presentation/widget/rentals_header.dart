import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class RentalsHeader extends StatelessWidget {
  final int propertyCount;

  const RentalsHeader({super.key, required this.propertyCount});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "You have $propertyCount active properties in Egypt",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: context.hintColor,
          ),
        ),
      ),
    );
  }
}
