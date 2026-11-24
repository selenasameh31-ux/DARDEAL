import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class FavouriteCategoryFilterRent extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const FavouriteCategoryFilterRent({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mainThemeColor = isDark
        ? DarkColors.darkmainColor
        : LightColors.lightmaincolor;

    return SizedBox(
      height: 35,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;

          final unselectedBgColor = isDark
              ? const Color(0xff4A4A4A)
              : Colors.grey[300];
          final unselectedTextColor = isDark
              ? DarkColors.darkTitleAndSubTitleText
              : LightColors.lightTitleAndSubTitleText;
          final selectedTextColor = isDark
              ? DarkColors.darkBackGround
              : Colors.white;

          return GestureDetector(
            onTap: () => onCategorySelected(category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? mainThemeColor : unselectedBgColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected ? selectedTextColor : unselectedTextColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontFamily: AppFonts.font,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Alias for backward compatibility
typedef FavouriteCategoryFilter = FavouriteCategoryFilterRent;
