import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class HelpButton extends StatelessWidget {
  final VoidCallback onPressed;

  const HelpButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(foregroundColor: context.primaryColor),
        child: const Text("Need help with your rental?"),
      ),
    );
  }
}
