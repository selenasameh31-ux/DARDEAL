import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  //>>>>>>>>>>>>>..API..<<<<<<<<<<<<<<<<<
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final iconColor = isDark
        ? DarkColors.darkTitleAndSubTitleText
        : LightColors.lightTitleAndSubTitleText;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<LoginBloc>()),
        BlocProvider(create: (_) => sl<GoogleAuthBloc>()),
      ],

      child: Scaffold(
        backgroundColor: context.scaffoldBgColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            // child: BlocConsumer<LoginBloc, LoginState>(
            child: MultiBlocListener(
              listeners: [
                BlocListener<LoginBloc, LoginState>(
                  listener: (context, state) {
                    if (state is LoginSuccess) {
                      context.read<SessionCubit>().authenticateUser(
                        state.auth.user,
                        state.auth.token,
                        refreshToken: state.auth.refreshToken,
                      );
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.mainLayout,
                        (route) => false,
                      );
                    }
                    if (state is LoginFailure) {
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
                        Routes.mainLayout,
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
              child: BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Back Button
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
                        icon: Icon(Icons.arrow_back_ios_new, size: 24, color: iconColor),
                      ),

                      const SizedBox(height: 10),

                      /// Title + Subtitle
                      const Center(
                        child: AppPageTitle(
                          title: "Let's get You Sign In!",
                          subtitle: "Enter your information below",
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// Login Form
                      LoginForm(loading: state is LoginLoading),

                      const SizedBox(height: 25),

                      /// OR Sign Up
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Sign Up',
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

                      /// Divider
                      const DividerWithText(text: "Or Sign In with"),

                      const SizedBox(height: 20),

                      /// Google Button
                      // Center(child: GoogleAuthButton(onTap: () {})),
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
