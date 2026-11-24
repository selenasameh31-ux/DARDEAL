import 'package:graduation_project_flutter/core/routing/routes_export.dart';

/// An orange pill banner showing the offer validity window.
/// Matches the HTML design's accent-orange pill.
class OfferValidityBanner extends StatelessWidget {
  final String label;
  final IconData icon;

  const OfferValidityBanner({
    super.key,
    this.label = 'Offer valid for 48 hours',
    this.icon = Icons.schedule_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark
        ? const Color(0xFF431407).withValues(alpha: 0.5)
        : const Color(0xFFFFEDD5);
    final textColor = isDark
        ? const Color(0xFFFCA186)
        : const Color(0xFF9A3412);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: AppFonts.font,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
