import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class ListingTabBar extends StatelessWidget {
  final String selectedTab;
  final Function(String) onTabSelected;

  const ListingTabBar({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final categories = ["All", "Draft", "Review", "Live", "Rejected"];

    return SizedBox(
      height: 35,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return _tabButton(context, category, selectedTab == category);
        },
      ),
    );
  }

  Widget _tabButton(BuildContext context, String label, bool isSelected) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mainThemeColor = context.primaryColor;

    final unselectedBgColor = isDark ? const Color(0xff4A4A4A) : Colors.grey[300];
    final unselectedTextColor = context.titleColor;
    final selectedTextColor = isDark ? DarkColors.darkBackGround : Colors.white;

    return GestureDetector(
      onTap: () => onTabSelected(label),
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
          label,
          style: TextStyle(
            color: isSelected ? selectedTextColor : unselectedTextColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontFamily: AppFonts.font,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
