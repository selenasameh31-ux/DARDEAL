import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class AppPageTitle extends StatelessWidget {
  final String title;
  final String? subtitle;

  const AppPageTitle({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final titleColor = isDark
        ? DarkColors.darkTitleAndSubTitleText
        : LightColors.lightTitleAndSubTitleText;

    final subTitleColor = isDark
        ? DarkColors.darkTitleAndSubTitleText
        : LightColors.lightTitleAndSubTitleText;

    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppFonts.font,
            fontWeight: FontWeight.w700,
            fontSize: 25,
            color: titleColor,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 5),
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppFonts.font,
              fontSize: 15,
              color: subTitleColor,
            ),
          ),
        ],
      ],
    );
  }
}
