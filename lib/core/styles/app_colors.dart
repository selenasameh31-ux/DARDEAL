import 'package:graduation_project_flutter/core/routing/routes_export.dart';

//------------------------Light Mode----------------------------

class LightColors {
  static const Color lightmaincolor = Color(0xff235265);
  static const Color lightBackGround = Color(0xffFDFAFA);
  static const Color lightAttentionText = Color(0xffEF761B);
  static const Color lightSupportColor = Color(0xff97BCBB);
  static const Color lightTitleAndSubTitleText = Color(0xff030303);
  static const Color lightBodyColors = Color(0xff363636);
  static const Color lightTextFieldColor = Color(0xffECECEC);
  static const Color lightHintTextFieldColor = Color(0xff676767);

// لون الزرار في اللايت
  static const Color lightButtonBg = Color(0xffFDFAFA);
  static const Color lightButtonBorder = Color(0xff252525);
  static const Color lightButtonText = Color(0xff252525);
  static const Color lightButtonTextPressed = Color(0xff97BCBB);
  static const Color lightButtonBorderPressed = Color(0xff97BCBB);
}

//------------------------Dark Mode----------------------------

class DarkColors {
  static const Color darkmainColor = Color(0xffD0EBF4);
  static const Color darkBackGround = Color(0xff363636);
  static const Color darkAttentionText = Color(0xff389FA4);
  static const Color darkSupporterColor = Color(0xff97BCBB);
  static const Color darkTitleAndSubTitleText = Color(0xffF5F5F5);
  static const Color darkBodyColors = Color(0xffFDFAFA);
  static const Color darkTextFieldColor = Color(0xff3E3E3E);
  static const Color darkHintTextFieldColor = Color.fromARGB(255, 157, 157, 157);

  // لون الزرار في الدارك
  static const Color darkButtonBg = Color(0xff363636);
  static const Color darkButtonBorder = Color(0xffFDFAFA);
  static const Color darkButtonText = Color(0xffFDFAFA);
  static const Color darkButtonTextPressed = Color(0xff235265);
  static const Color darkButtonBorderPressed = Color(0xffD0EBF4);
}

extension ThemeExt on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  Color get scaffoldBgColor => isDark ? DarkColors.darkBackGround : LightColors.lightBackGround;
  Color get primaryColor => isDark ? DarkColors.darkmainColor : LightColors.lightmaincolor;
  Color get titleColor => isDark ? DarkColors.darkTitleAndSubTitleText : LightColors.lightTitleAndSubTitleText;
  Color get bodyColor => isDark ? DarkColors.darkBodyColors : LightColors.lightBodyColors;
  Color get hintColor => isDark ? DarkColors.darkHintTextFieldColor : LightColors.lightHintTextFieldColor;
  Color get textFieldBgColor => isDark ? DarkColors.darkTextFieldColor : LightColors.lightTextFieldColor;
  Color get attentionColor => isDark ? DarkColors.darkAttentionText : LightColors.lightAttentionText;

  // Button Colors
  Color get buttonBgColor => isDark ? DarkColors.darkButtonBg : LightColors.lightButtonBg;
  Color get buttonPressedBgColor => isDark ? DarkColors.darkmainColor : LightColors.lightmaincolor;
  Color get buttonBorderColor => isDark ? DarkColors.darkButtonBorder : LightColors.lightButtonBorder;
  Color get buttonTextColor => isDark ? DarkColors.darkButtonText : LightColors.lightButtonText;
  Color get buttonPressedTextColor => isDark ? LightColors.lightButtonText : DarkColors.darkButtonText;
  Color get tagTextColor => isDark ? DarkColors.darkBackGround : Colors.white;
  Color get titleColor87 => titleColor.withOpacity(0.87);
}
