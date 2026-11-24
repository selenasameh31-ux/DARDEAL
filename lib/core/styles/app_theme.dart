import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class AppTheme {
  // لون الخلفية و التيكست و الزراير في اللايت
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: AppFonts.font,
    scaffoldBackgroundColor: LightColors.lightBackGround,
    primaryColor: LightColors.lightmaincolor,
    secondaryHeaderColor: LightColors.lightSupportColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: LightColors.lightmaincolor,
      primary: LightColors.lightmaincolor,
      brightness: Brightness.light,
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: LightColors.lightTitleAndSubTitleText),
      bodyMedium: TextStyle(color: LightColors.lightmaincolor),
      bodySmall: TextStyle(color: LightColors.lightAttentionText),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: LightColors.lightmaincolor,
      selectionColor: Color(0x66235265),
      selectionHandleColor: LightColors.lightmaincolor,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: AppFonts.font,
    scaffoldBackgroundColor: DarkColors.darkBackGround,
    primaryColor: DarkColors.darkmainColor,
    secondaryHeaderColor: DarkColors.darkSupporterColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: DarkColors.darkmainColor,
      primary: DarkColors.darkmainColor,
      brightness: Brightness.dark,
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: DarkColors.darkTitleAndSubTitleText),
      bodyMedium: TextStyle(color: DarkColors.darkmainColor),
      bodySmall: TextStyle(color: DarkColors.darkAttentionText),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: DarkColors.darkmainColor,
      selectionColor: Color(0x66235265),
      selectionHandleColor: DarkColors.darkmainColor,
    ),
  );
}
