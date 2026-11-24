import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class AuthOptionsScreen extends StatelessWidget {
  const AuthOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ================= Image Section =================
            Container(
              height: height * 0.50,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppImages.authOptions),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // ================= Content Section =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // -------- Header --------
                  Text(
                    "Welcome to DarDeal App",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 25,
                      fontFamily: AppFonts.font,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // -------- Description --------
                  Text(
                    "Create your account now and enjoy exclusive features, helping you find your dream property.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 19,
                      fontFamily: AppFonts.font,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // -------- Login Button --------
                  AuthButton(
                    text: "Login",
                    loading: false,
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, Routes.signIn);
                    },
                  ),

                  const SizedBox(height: 10),

                  // -------- Create Account Button --------
                  AuthButton(
                    text: "Create Account",
                    loading: false,
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, Routes.signUp);
                    },
                  ),

                  const SizedBox(height: 10),

                  // -------- Continue as Guest --------
                  AuthButton(
                    text: "Continue as a Guest",
                    loading: false,
                    onPressed: () {
                      context.read<SessionCubit>().setGuest();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.mainLayout,
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
