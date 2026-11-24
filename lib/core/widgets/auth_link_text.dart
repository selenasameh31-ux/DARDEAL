import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class AuthLinkText extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double fontSize;

  const AuthLinkText({
    super.key,
    required this.text,
    required this.onTap,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final linkColor = isDark
        ? DarkColors.darkAttentionText
        : LightColors.lightAttentionText;

    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          color: linkColor,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.underline,
          fontFamily: AppFonts.font,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
