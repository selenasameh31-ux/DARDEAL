import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class AppSectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final EdgeInsetsGeometry? padding;
  final bool showDivider;
  final Color? dividerColor;
  final Widget? trailing;

  const AppSectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.padding,
    this.showDivider = false,
    this.dividerColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final titleColor = isDark
        ? DarkColors.darkTitleAndSubTitleText
        : LightColors.lightTitleAndSubTitleText;

    final subtitleColor = isDark
        ? DarkColors.darkHintTextFieldColor
        : LightColors.lightHintTextFieldColor;

    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: AppFonts.font,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: TextStyle(
                fontFamily: AppFonts.font,
                fontSize: 14,
                color: subtitleColor,
              ),
            ),
          ],
          if (showDivider) ...[
            const SizedBox(height: 8),
            Container(
              height: 1,
              width: double.infinity,
              color: dividerColor ?? const Color(0xFF97BCBB),
            ),
          ],
        ],
      ),
    );
  }
}
