import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class FavouriteSearchBarRent extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onFilterTap;
  final ValueChanged<String>? onChanged;

  const FavouriteSearchBarRent({
    super.key,
    required this.controller,
    required this.onFilterTap,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark
        ? DarkColors.darkTitleAndSubTitleText
        : LightColors.lightTitleAndSubTitleText;
    final mainThemeColor = isDark
        ? DarkColors.darkmainColor
        : LightColors.lightmaincolor;
    final bgColor = isDark
        ? DarkColors.darkTextFieldColor
        : LightColors.lightTextFieldColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: controller,
                cursorColor: mainThemeColor,
                textDirection:
                    RegExp(r'[\u0600-\u06FF]').hasMatch(controller.text)
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                onChanged: onChanged,
                style: TextStyle(color: titleColor, fontFamily: AppFonts.font),
                decoration: InputDecoration(
                  hintText: "Search your favourite property",
                  hintStyle: TextStyle(
                    color: isDark
                        ? DarkColors.darkHintTextFieldColor
                        : LightColors.lightHintTextFieldColor,
                    fontFamily: AppFonts.font,
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(Icons.search, color: titleColor, size: 24),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          GestureDetector(
            onTap: onFilterTap,
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: mainThemeColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: isDark
                    ? []
                    : [
                        BoxShadow(
                          color: mainThemeColor.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: Icon(
                Icons.tune_rounded,
                color: isDark
                    ? DarkColors.darkBackGround
                    : LightColors.lightBackGround,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Alias for backward compatibility
typedef FavouriteSearchBar = FavouriteSearchBarRent;
