import 'package:graduation_project_flutter/core/routing/routes_export.dart';

// class MainBottomNavBar extends StatefulWidget {
//   const MainBottomNavBar({super.key});

//   @override
//   State<MainBottomNavBar> createState() => _MainBottomNavBarState();
// }

// class _MainBottomNavBarState extends State<MainBottomNavBar> {
//   int currentTab = 0;
//   double iconSize = 25;
//   double centerIconSize = 28;
//   double centerLift = -15;

//   // Tracks whether we are on step 0 of AddProperty (so navbar shows/hides)
//   final ValueNotifier<bool> _isOnAddPropertyFirstStep = ValueNotifier(true);

//   void _onTabTapped(int index) {
//     setState(() {
//       currentTab = index;
//     });
//   }

//   List<Widget> get tabs => [
//     const HomeScreen(), // 0: Home
//     const FavouriteScreen(), // 1: Favourite
//     AddPropertyScreen(
//       // 2: Add (Center)
//       onStepChanged: (step) {
//         _isOnAddPropertyFirstStep.value = step == 0;
//       },
//     ),
//     const ChatScreen(), // 3: Chat
//     const ProfileScreen(), // 4: Profile
//   ];

//   @override
//   Widget build(BuildContext context) {
//     // تحديد هل الثيم الحالي دارك أم لا
//     final bool isDark = Theme.of(context).brightness == Brightness.dark;

//     // قائمة الألوان اللي بتظهر خلف الصفحات (عشان نمنع الالوان المختلفة عن لون الباك جراوند)
//     final bgColor = Theme.of(context).scaffoldBackgroundColor;
//     final List<Color> tabColors = [bgColor, bgColor, bgColor, bgColor, bgColor];

//     return BlocProvider(
//       create: (context) => ChatBloc()..add(LoadChatsEvent()),
//       child: ValueListenableBuilder<bool>(
//         valueListenable: _isOnAddPropertyFirstStep,
//         builder: (context, isFirstStep, _) {
//           // Hide navbar when user is in AddProperty flow (step > 0)
//           final bool showNavBar = currentTab != 2 || isFirstStep;
//           return Scaffold(
//             backgroundColor: tabColors[currentTab],
//             resizeToAvoidBottomInset: false,
//             body: tabs[currentTab],
//             extendBody: true,
//             bottomNavigationBar: showNavBar ? _buildNavBar(isDark) : null,
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildNavBar(bool isDark) {
//     return SizedBox(
//       height: 90,
//       child: CustomPaint(
//         // لون الناف بار بناءً على الثيم
//         painter: NavBarPainter(
//           color: isDark ? const Color.fromARGB(255, 31, 31, 31) : Colors.white,
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               child: _buildItem(
//                 index: 0,
//                 label: "Home",
//                 icon: AppImages.home,
//                 pressedIcon: isDark
//                     ? AppImages.darkHomePressed
//                     : AppImages.lightHomePressed,
//                 isDark: isDark,
//               ),
//             ),
//             Expanded(
//               child: _buildItem(
//                 index: 1,
//                 label: "Favourite",
//                 icon: AppImages.favourite,
//                 pressedIcon: isDark
//                     ? AppImages.darkfavouritePressed
//                     : AppImages.lightfavouritePressed,
//                 isDark: isDark,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: _buildCenterItem(isDark),
//             ),
//             Expanded(
//               child: _buildItem(
//                 index: 3,
//                 label: "Chat",
//                 icon: AppImages.chat,
//                 pressedIcon: isDark
//                     ? AppImages.darkchatPressed
//                     : AppImages.lightchatPressed,
//                 isDark: isDark,
//               ),
//             ),
//             Expanded(
//               child: _buildItem(
//                 index: 4,
//                 label: "Profile",
//                 icon: AppImages.profile,
//                 pressedIcon: isDark
//                     ? AppImages.darkprofilePressed
//                     : AppImages.lightprofilePressed,
//                 isDark: isDark,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildItem({
//     required int index,
//     required String label,
//     required String icon,
//     required String pressedIcon,
//     required bool isDark,
//   }) {
//     final bool isSelected = currentTab == index;
//     double screenWidth = MediaQuery.of(context).size.width;
//     double dynamicFontSize = screenWidth < 360 ? 9 : 11;

//     // ألوان النصوص بناءً على حالة الاختيار والثيم
//     Color selectedColor = isDark
//         ? DarkColors.darkmainColor
//         : LightColors.lightmaincolor;
//     Color unselectedColor = const Color(0xff939393);

//     return GestureDetector(
//       onTap: () => _onTabTapped(index),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Image.asset(
//             isSelected ? pressedIcon : icon,
//             height: iconSize,
//             width: iconSize,
//             fit: BoxFit.contain,
//           ),
//           const SizedBox(height: 5),
//           Flexible(
//             child: Text(
//               label,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontFamily: AppFonts.font,
//                 fontWeight: FontWeight.w800,
//                 fontSize: dynamicFontSize,
//                 color: isSelected ? selectedColor : unselectedColor,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCenterItem(bool isDark) {
//     final bool isSelected = currentTab == 2;
//     double screenWidth = MediaQuery.of(context).size.width;
//     double dynamicFontSize = screenWidth < 360 ? 9 : 11;

//     return GestureDetector(
//       onTap: () => _onTabTapped(2),
//       child: Transform.translate(
//         offset: Offset(0, centerLift),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 62,
//               height: 62,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: isDark
//                     ? DarkColors.darkmainColor
//                     : LightColors.lightmaincolor,
//                 boxShadow: const [
//                   BoxShadow(blurRadius: 15, color: Colors.black26),
//                 ],
//               ),
//               child: Center(
//                 child: Image.asset(
//                   isDark ? AppImages.darkaddPressed : AppImages.lightaddPressed,
//                   height: centerIconSize,
//                   width: centerIconSize,
//                   color: isDark ? DarkColors.darkBackGround : Colors.white,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 6),
//             SizedBox(
//               width: 75,
//               child: Text(
//                 "Add Property",
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontFamily: AppFonts.font,
//                   fontWeight: FontWeight.w800,
//                   fontSize: dynamicFontSize,
//                   color: isSelected
//                       ? (isDark
//                             ? DarkColors.darkmainColor
//                             : LightColors.lightmaincolor)
//                       : const Color.fromARGB(255, 159, 159, 159),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class NavBarPainter extends CustomPainter {
//   final Color color;
//   NavBarPainter({required this.color});

//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..color = color
//       ..style = PaintingStyle.fill
//       ..isAntiAlias = true;

//     Path path = Path();
//     double centerX = size.width / 2;
//     double curveWidth = 46;
//     double curveHeight = 35;
//     double concaveDepth = 1;

//     path.moveTo(0, 0);
//     path.lineTo(centerX - curveWidth - 15, 0);
//     path.quadraticBezierTo(
//       centerX - curveWidth,
//       concaveDepth,
//       centerX - curveWidth + 14,
//       -curveHeight / 3,
//     );
//     path.quadraticBezierTo(
//       centerX,
//       -curveHeight,
//       centerX + curveWidth - 15,
//       -curveHeight / 3,
//     );
//     path.quadraticBezierTo(
//       centerX + curveWidth,
//       concaveDepth,
//       centerX + curveWidth + 13,
//       0,
//     );
//     path.lineTo(size.width, 0);
//     path.lineTo(size.width, size.height);
//     path.lineTo(0, size.height);
//     path.close();

//     canvas.drawShadow(path, Colors.black26, 8, true);
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(NavBarPainter oldDelegate) => oldDelegate.color != color;
// }



class MainBottomNavBar extends StatefulWidget {
  const MainBottomNavBar({super.key});

  @override
  State<MainBottomNavBar> createState() => _MainBottomNavBarState();
}

class _MainBottomNavBarState extends State<MainBottomNavBar> {
  int currentTab = 0;
  double iconSize = 25;
  double centerIconSize = 28;
  double centerLift = -15;

  // Tracks whether we are on step 0 of AddProperty (so navbar shows/hides)
  final ValueNotifier<bool> _isOnAddPropertyFirstStep = ValueNotifier(true);

  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = [
      const HomeScreen(), // 0: Home
      const FavouriteScreen(), // 1: Favourite
      AddPropertyScreen(
        // 2: Add (Center)
        onStepChanged: (step) {
          _isOnAddPropertyFirstStep.value = step == 0;
        },
      ),
      const ChatScreen(), // 3: Chat
      const ProfileScreen(), // 4: Profile
    ];
  }

  void _onTabTapped(int index) {
    setState(() {
      currentTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // تحديد هل الثيم الحالي دارك أم لا
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // قائمة الألوان اللي بتظهر خلف الصفحات (عشان نمنع الالوان المختلفة عن لون الباك جراوند)
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final List<Color> tabColors = [bgColor, bgColor, bgColor, bgColor, bgColor];

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<ChatBloc>()..add(FetchChatsEvent())),
        BlocProvider(create: (context) => sl<WishlistCubit>()..loadWishlist()),
      ],
      child: ValueListenableBuilder<bool>(
        valueListenable: _isOnAddPropertyFirstStep,
        builder: (context, isFirstStep, _) {
          // Hide navbar when user is in AddProperty flow (step > 0)
          final bool showNavBar = currentTab != 2 || isFirstStep;
          return Scaffold(
            backgroundColor: tabColors[currentTab],
            resizeToAvoidBottomInset: false,
            body: IndexedStack(
              index: currentTab,
              children: _tabs,
            ),
            extendBody: true,
            bottomNavigationBar: showNavBar ? _buildNavBar(isDark) : null,
          );
        },
      ),
    );
  }

  Widget _buildNavBar(bool isDark) {
    return SizedBox(
      height: 90,
      child: CustomPaint(
        // لون الناف بار بناءً على الثيم
        painter: NavBarPainter(
          color: isDark ? const Color.fromARGB(255, 31, 31, 31) : Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildItem(
                index: 0,
                label: "Home",
                icon: AppImages.home,
                pressedIcon: isDark
                    ? AppImages.darkHomePressed
                    : AppImages.lightHomePressed,
                isDark: isDark,
              ),
            ),
            Expanded(
              child: _buildItem(
                index: 1,
                label: "Favourite",
                icon: AppImages.favourite,
                pressedIcon: isDark
                    ? AppImages.darkfavouritePressed
                    : AppImages.lightfavouritePressed,
                isDark: isDark,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: _buildCenterItem(isDark),
            ),
            Expanded(
              child: _buildItem(
                index: 3,
                label: "Chat",
                icon: AppImages.chat,
                pressedIcon: isDark
                    ? AppImages.darkchatPressed
                    : AppImages.lightchatPressed,
                isDark: isDark,
              ),
            ),
            Expanded(
              child: _buildItem(
                index: 4,
                label: "Profile",
                icon: AppImages.profile,
                pressedIcon: isDark
                    ? AppImages.darkprofilePressed
                    : AppImages.lightprofilePressed,
                isDark: isDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem({
    required int index,
    required String label,
    required String icon,
    required String pressedIcon,
    required bool isDark,
  }) {
    final bool isSelected = currentTab == index;
    double screenWidth = MediaQuery.of(context).size.width;
    double dynamicFontSize = screenWidth < 360 ? 9 : 11;

    // ألوان النصوص بناءً على حالة الاختيار والثيم
    Color selectedColor = isDark
        ? DarkColors.darkmainColor
        : LightColors.lightmaincolor;
    Color unselectedColor = const Color(0xff939393);

    return GestureDetector(
      onTap: () => _onTabTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            isSelected ? pressedIcon : icon,
            height: iconSize,
            width: iconSize,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 5),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFonts.font,
                fontWeight: FontWeight.w800,
                fontSize: dynamicFontSize,
                color: isSelected ? selectedColor : unselectedColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterItem(bool isDark) {
    final bool isSelected = currentTab == 2;
    double screenWidth = MediaQuery.of(context).size.width;
    double dynamicFontSize = screenWidth < 360 ? 9 : 11;

    return GestureDetector(
      onTap: () => _onTabTapped(2),
      child: Transform.translate(
        offset: Offset(0, centerLift),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? DarkColors.darkmainColor
                    : LightColors.lightmaincolor,
                boxShadow: const [
                  BoxShadow(blurRadius: 15, color: Colors.black26),
                ],
              ),
              child: Center(
                child: Image.asset(
                  isDark ? AppImages.darkaddPressed : AppImages.lightaddPressed,
                  height: centerIconSize,
                  width: centerIconSize,
                  color: isDark ? DarkColors.darkBackGround : Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: 75,
              child: Text(
                "Add Property",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.font,
                  fontWeight: FontWeight.w800,
                  fontSize: dynamicFontSize,
                  color: isSelected
                      ? (isDark
                            ? DarkColors.darkmainColor
                            : LightColors.lightmaincolor)
                      : const Color.fromARGB(255, 159, 159, 159),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavBarPainter extends CustomPainter {
  final Color color;
  NavBarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    Path path = Path();
    double centerX = size.width / 2;
    double curveWidth = 46;
    double curveHeight = 35;
    double concaveDepth = 1;

    path.moveTo(0, 0);
    path.lineTo(centerX - curveWidth - 15, 0);
    path.quadraticBezierTo(
      centerX - curveWidth,
      concaveDepth,
      centerX - curveWidth + 14,
      -curveHeight / 3,
    );
    path.quadraticBezierTo(
      centerX,
      -curveHeight,
      centerX + curveWidth - 15,
      -curveHeight / 3,
    );
    path.quadraticBezierTo(
      centerX + curveWidth,
      concaveDepth,
      centerX + curveWidth + 13,
      0,
    );
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawShadow(path, Colors.black26, 8, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(NavBarPainter oldDelegate) => oldDelegate.color != color;
}
