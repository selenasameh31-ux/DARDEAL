import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class GoogleAuthButton extends StatelessWidget {
  final VoidCallback onTap;

  const GoogleAuthButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    //  تحديد إذا كان دارك
    final isDark = Theme.of(context).brightness == Brightness.dark;

    //  لون البوردر حسب الثيم
    final borderColor = isDark
        ? DarkColors.darkHintTextFieldColor
        : LightColors.lightHintTextFieldColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(
            color: borderColor, //
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/google2.svg',
            width: 40,
            height: 40,
          ),
        ),
      ),
    );
  }
}
