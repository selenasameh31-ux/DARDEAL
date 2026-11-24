import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlighted;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? DarkColors.darkTitleAndSubTitleText
        : LightColors.lightTitleAndSubTitleText;
    final highlightColor = context.primaryColor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontFamily: AppFonts.font,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w600,
              color: isHighlighted ? highlightColor : textColor,
              fontFamily: AppFonts.font,
            ),
          ),
        ],
      ),
    );
  }
}
