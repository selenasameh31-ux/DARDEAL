import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class NotificationsTabs extends StatelessWidget {
  final TabController tabController;

  const NotificationsTabs({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark 
        ? DarkColors.darkTextFieldColor 
        : LightColors.lightmaincolor.withOpacity(0.1);

    final indicatorColor = context.primaryColor;

    final selectedTextColor = isDark 
        ? DarkColors.darkBackGround 
        : Colors.white;

    final unselectedTextColor = isDark 
        ? DarkColors.darkTitleAndSubTitleText 
        : LightColors.lightHintTextFieldColor;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 40,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TabBar(
        controller: tabController,
        indicator: BoxDecoration(
          color: indicatorColor,
          borderRadius: BorderRadius.circular(20),
        ),
        labelColor: selectedTextColor,
        unselectedLabelColor: unselectedTextColor,
        labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, fontFamily: AppFonts.font),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 13, fontFamily: AppFonts.font),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'All'),
          Tab(text: 'Offers'),
          Tab(text: 'Payments'),
          Tab(text: 'Rentals'),
        ],
      ),
    );
  }
}
