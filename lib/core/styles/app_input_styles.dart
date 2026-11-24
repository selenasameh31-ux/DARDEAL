import 'package:graduation_project_flutter/core/routing/routes_export.dart';

enum AppInputVariant { standard, formStep, outlined }

class AppInputStyles {
  static const double borderRadius = 12.0;
  static const EdgeInsetsGeometry contentPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 14,
  );
  static const EdgeInsetsGeometry margin = EdgeInsets.only(bottom: 20);

  static const double fontSize = 16.0;
  static const double labelFontSize = 14.0;

  static TextStyle getTextStyle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      color: isDark ? DarkColors.darkBodyColors : LightColors.lightBodyColors,
      fontSize: fontSize,
      fontFamily: AppFonts.font,
    );
  }

  static TextStyle getHintStyle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      color: isDark
          ? DarkColors.darkHintTextFieldColor
          : LightColors.lightHintTextFieldColor,
      fontSize: labelFontSize,
      fontFamily: AppFonts.font,
    );
  }

  static BoxDecoration getContainerDecoration(
    BuildContext context, {
    AppInputVariant variant = AppInputVariant.standard,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bgColor;
    Color borderColor;

    switch (variant) {
      case AppInputVariant.formStep:
        bgColor = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF7FDF9);
        borderColor = isDark
            ? const Color(0xFF4A4A4A)
            : const Color(0xFFE2E8F0);
        break;
      case AppInputVariant.outlined:
        bgColor = Colors.transparent;
        borderColor = isDark ? Colors.grey.shade300 : Colors.grey.shade600;
        break;
      case AppInputVariant.standard:
        bgColor = isDark
            ? DarkColors.darkTextFieldColor
            : LightColors.lightTextFieldColor;
        borderColor = isDark ? Colors.grey.shade300 : Colors.grey.shade600;
        break;
    }

    return BoxDecoration(
      color: bgColor,
      border: Border.all(color: borderColor, width: 1),
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }

  static EdgeInsetsGeometry getMargin(AppInputVariant variant) {
    if (variant == AppInputVariant.formStep) {
      return EdgeInsets.zero;
    }
    return margin;
  }
}
