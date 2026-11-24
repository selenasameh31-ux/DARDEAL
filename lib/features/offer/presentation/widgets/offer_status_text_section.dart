import 'package:graduation_project_flutter/core/routing/routes_export.dart';

/// Displays the title and subtitle text for the offer success screen.
class OfferStatusTextSection extends StatelessWidget {
  final String title;
  final String subtitle;

  const OfferStatusTextSection({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: AppFonts.font,
            color: colorScheme.onSurface,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontFamily: AppFonts.font,
            color: colorScheme.onSurfaceVariant,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
