import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final iconColor = isDark
        ? DarkColors.darkTitleAndSubTitleText
        : LightColors.lightTitleAndSubTitleText;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<RegisterBloc>()),
        BlocProvider(create: (_) => sl<GoogleAuthBloc>()),
      ],

      child: Scaffold(
        backgroundColor: context.scaffoldBgColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: MultiBlocListener(
              listeners: [
                BlocListener<RegisterBloc, RegisterState>(
                  listener: (context, state) async {
                    if (state is RegisterSuccess) {
                      // await is critical: token must be in cache BEFORE
                      // EmailVerificationScreen fires SendEmailOtpRequested
                      await context.read<SessionCubit>().authenticateUser(
                        state.auth.user,
                        state.auth.token,
                        refreshToken: state.auth.refreshToken,
                      );
                      if (!context.mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EmailVerificationScreen(
                            email: state.auth.user.email,
                            token: state.auth.token,
                          ),
                        ),
                      );
                    }
                    if (state is RegisterFailure) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.error)));
                    }
                  },
                ),
                BlocListener<GoogleAuthBloc, GoogleAuthState>(
                  listener: (context, state) {
                    if (state is GoogleAuthSuccess && state.user != null) {
                      context.read<SessionCubit>().authenticateUser(
                        state.user!.user,
                        state.user!.token,
                        refreshToken: state.user!.refreshToken,
                      );
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.roleSelection,
                        (route) => false,
                      );
                    }
                    if (state is GoogleAuthFailure) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.error)));
                    }
                  },
                ),
              ],
              child: BlocBuilder<RegisterBloc, RegisterState>(
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AuthOptionsScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        icon: SvgPicture.asset(
                          AppIcons.ArrowIcon,
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            iconColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Center(
                        child: AppPageTitle(
                          title: "Let's create your account!",
                          subtitle: "Fill the information below",
                        ),
                      ),

                      const SizedBox(height: 30),

                      RegisterForm(loading: state is RegisterLoading),

                      const SizedBox(height: 25),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(
                              fontFamily: AppFonts.font,
                              fontSize: 16,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyLarge!.color,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                fontFamily: AppFonts.font,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodySmall!.color,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      const DividerWithText(text: "Or Sign Up with"),
                      const SizedBox(height: 20),
                      Center(
                        child: BlocBuilder<GoogleAuthBloc, GoogleAuthState>(
                          builder: (context, googleState) {
                            if (googleState is GoogleAuthLoading) {
                              return const CircularProgressIndicator();
                            }
                            return GoogleAuthButton(
                              onTap: () {
                                context.read<GoogleAuthBloc>().add(
                                  SignInWithGoogleEvent(),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}