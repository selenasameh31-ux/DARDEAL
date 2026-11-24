import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class OfferSectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;

  const OfferSectionTitle({
    super.key,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    // Reusing the core AppSectionTitle for consistency, as requested to use core components
    return AppSectionTitle(
      title: title,
      subtitle: subtitle,
      padding: const EdgeInsets.symmetric(vertical: 16),
      showDivider: false,
    );
  }
}
