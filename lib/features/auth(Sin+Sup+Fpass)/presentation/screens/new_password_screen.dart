// import 'package:graduation_project_flutter/core/routing/routes_export.dart';

// class NewPasswordScreen extends StatelessWidget {
//   final String resetToken;

//   const NewPasswordScreen({
//     super.key,
//     required this.resetToken,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: LightColors.lightBackGround,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: NewPasswordForm(
//             resetToken: resetToken,
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:graduation_project_flutter/core/routing/routes_export.dart';

// class NewPasswordScreen extends StatelessWidget {
//   final String resetToken;

//   const NewPasswordScreen({
//     super.key,
//     required this.resetToken,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: LightColors.lightBackGround,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 40),

//               /// Title
//               const Center(
//                 child: Text(
//                   "New Password",
//                   style: TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.w600,
//                     fontFamily: AppFonts.font,
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 20),

//               /// Subtitle
//               const Text(
//                 "Enter your new password",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),

//               const SizedBox(height: 30),

//               /// Form
//               Expanded(
//                 child: NewPasswordForm(
//                   resetToken: resetToken,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:graduation_project_flutter/core/routing/routes_export.dart';

// class NewPasswordScreen extends StatelessWidget {
//   final String resetToken;

//   const NewPasswordScreen({
//     super.key,
//     required this.resetToken,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: LightColors.lightBackGround,
//       resizeToAvoidBottomInset: true,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [

//               const SizedBox(height: 10),

//               /// Title + Subtitle بنفس ستايل اللوجين
//               const Center(
//                 child: AppPageTitle(
//                   title: "New Password",
//                   subtitle: "Enter your new password",
//                 ),
//               ),

//               const SizedBox(height: 40),

//               /// Form
//               NewPasswordForm(resetToken: resetToken),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class NewPasswordScreen extends StatelessWidget {
  final String resetToken;

  const NewPasswordScreen({super.key, required this.resetToken});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final iconColor = context.titleColor;

    return Scaffold(
      backgroundColor: context.scaffoldBgColor,

      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              /// Title + Subtitle
              const Center(
                child: AppPageTitle(
                  title: "New Password",
                  subtitle: "Enter your new password",
                ),
              ),

              const SizedBox(height: 40),

              /// Form
              NewPasswordForm(resetToken: resetToken),
            ],
          ),
        ),
      ),
    );
  }
}
