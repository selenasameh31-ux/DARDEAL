import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class DividerWithText extends StatelessWidget {
  final String text;

  const DividerWithText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    //  تحديد إذا كان دارك
    final isDark = Theme.of(context).brightness == Brightness.dark;

    //  لون الخطين حسب الثيم
    final dividerColor = isDark
        ? DarkColors.darkHintTextFieldColor
        : LightColors.lightHintTextFieldColor;

    //  لون النص حسب الثيم
    final textColor = isDark
        ? DarkColors.darkHintTextFieldColor
        : LightColors.lightHintTextFieldColor;

    return Row(
      children: [
        Expanded(child: Divider(thickness: 1, color: dividerColor)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            text,
            style: TextStyle(
              fontFamily: AppFonts.font,
              fontSize: 16,
              color: textColor,
            ),
          ),
        ),
        Expanded(child: Divider(thickness: 1, color: dividerColor)),
      ],
    );
  }
}
