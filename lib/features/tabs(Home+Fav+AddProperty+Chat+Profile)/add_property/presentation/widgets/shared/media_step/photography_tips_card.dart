
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
class PhotographyTipsCard extends StatelessWidget {
  const PhotographyTipsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.textFieldBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? DarkColors.darkHintTextFieldColor
              : LightColors.lightHintTextFieldColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: const Color(0xFF0C6B6B), size: 20),
              const SizedBox(width: 8),
              const Text(
                "Professional Photography Tips",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTipRow(
            context,
            title: "Natural Light",
            description:
                "Take photos during the day with blinds open for the best atmosphere.",
          ),
          const SizedBox(height: 12),
          _buildTipRow(
            context,
            title: "Landscape Mode",
            description:
                "Keep your phone horizontal for wider, more immersive views.",
          ),
          const SizedBox(height: 12),
          _buildTipRow(
            context,
            title: "Clean Up",
            description:
                "Declutter surfaces and remove personal items before shooting.",
          ),
        ],
      ),
    );
  }

  Widget _buildTipRow(
    BuildContext context, {
    required String title,
    required String description,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle, color: const Color(0xFF0C6B6B), size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: "$title: ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: context.titleColor,
                fontFamily: AppFonts.font,
                fontSize: 13,
              ),
              children: [
                TextSpan(
                  text: description,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: context.titleColor,
                    fontFamily: AppFonts.font,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
