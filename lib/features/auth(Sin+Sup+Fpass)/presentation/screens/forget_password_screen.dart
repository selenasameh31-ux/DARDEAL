import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final iconColor = textTheme.titleLarge?.color;

    return BlocProvider(
      create: (_) => sl<ForgotPasswordBloc>(),

      child: Scaffold(
        backgroundColor: context.scaffoldBgColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
              listener: (context, state) {
                if (state is OtpSent) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<ForgotPasswordBloc>(),
                        child: VerificationScreen(
                          emailOrPhone: state.emailOrPhone,
                        ),
                      ),
                    ),
                  );
                }

                if (state is ForgotPasswordError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Back Button (دائري عند الضغط)
                    InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {
                        Navigator.pushReplacementNamed(context, Routes.signIn);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 24,
                          color: iconColor ?? Theme.of(context).textTheme.titleLarge?.color ?? Colors.black,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// Title + Subtitle
                    const Center(
                      child: AppPageTitle(
                        title: "Forgot Password",
                        subtitle: "Enter your email or phone",
                      ),
                    ),

                    const SizedBox(height: 40),

                    /// Form
                    ForgotPasswordForm(loading: state is ForgotPasswordLoading),

                    const SizedBox(height: 40),

                    /// Don't have account text
                    Center(
                      child: Text(
                        "Don’t have an account?",
                        style: TextStyle(
                          fontFamily: AppFonts.font,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).textTheme.bodySmall!.color,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// Sign up Button
                    AuthButton(
                      text: "Sign up",
                      loading: false,
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.signUp);
                      },
                    ),
                    const SizedBox(height: 40),

                    /// Divider
                    const DividerWithText(text: "Or Sign up with"),

                    const SizedBox(height: 5),

                    /// Google Button مع تأثير دائري عند الضغط
                    Center(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: GoogleAuthButton(onTap: () {}),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
