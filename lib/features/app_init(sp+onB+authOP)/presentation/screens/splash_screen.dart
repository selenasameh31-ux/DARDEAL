import 'package:graduation_project_flutter/core/routing/routes_export.dart';

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(const Duration(seconds: 3), () {
//       final sessionCubit = context.read<SessionCubit>();
//       final isGuest = sessionCubit.state is SessionGuest;
//       final isAuth = sessionCubit.state is SessionAuthenticated;
      
//       if (isGuest || isAuth) {
//         Navigator.pushReplacementNamed(context, Routes.mainLayout);
//       } else {
//         final cacheHelper = sl<CacheHelper>();
//         if (cacheHelper.isOnboardingDone()) {
//           Navigator.pushReplacementNamed(context, Routes.authOptions);
//         } else {
//           Navigator.pushReplacementNamed(context, Routes.onboarding);
//         }
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Color(0xFF235265), Color(0xFF97BCBB)],
//             stops: [0, 1.0],
//           ),
//         ),

//         child: Center(
//           child: Image.asset(AppImages.spLogo, fit: BoxFit.contain),
//         ),
//       ),
//     );
//   }
// }






class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () async {
      final cacheHelper = sl<CacheHelper>();
      final token = cacheHelper.getToken();
      final userJson = cacheHelper.getUserData();
      final isOnboardingDone = cacheHelper.isOnboardingDone();
      final isGuest = cacheHelper.isGuestMode();

      if ((token != null && token.isNotEmpty && userJson != null && userJson.isNotEmpty) || isGuest) {
        // User is authenticated or is a guest, go to main layout
        Navigator.pushReplacementNamed(context, Routes.mainLayout);
      } else {
        // Not authenticated and not guest
        if (isOnboardingDone) {
          Navigator.pushReplacementNamed(context, Routes.authOptions);
        } else {
          Navigator.pushReplacementNamed(context, Routes.onboarding);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF235265), Color(0xFF97BCBB)],
            stops: [0, 1.0],
          ),
        ),

        child: Center(
          child: Image.asset(AppImages.spLogo, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
