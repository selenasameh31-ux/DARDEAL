import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class VerificationForm extends StatefulWidget {
  final String emailOrPhone;

  const VerificationForm({super.key, required this.emailOrPhone});

  @override
  State<VerificationForm> createState() => _VerificationFormState();
}

class _VerificationFormState extends State<VerificationForm> {
  String _otp = "";

  void _verifyOtp() {
    if (_otp.length != 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter 6-digit code")));
      return;
    }

    context.read<ForgotPasswordBloc>().add(
      VerifyOtpRequested(emailOrPhone: widget.emailOrPhone, otp: _otp),
    );
  }

  void _resendOtp() {
    context.read<ForgotPasswordBloc>().add(
      ForgotPasswordRequested(widget.emailOrPhone),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state is OtpVerified) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<ForgotPasswordBloc>(),
                child: NewPasswordScreen(resetToken: state.resetToken),
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
        final loading = state is ForgotPasswordLoading;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(Icons.arrow_back_ios_new, size: 24, color: Theme.of(context).textTheme.titleLarge?.color ?? Colors.black),
              ),
            ),

            const SizedBox(height: 15),

            /// Title + Subtitle
            const Center(
              child: AppPageTitle(
                title: "Verification",
                subtitle: "Enter Verification Code",
              ),
            ),

            const SizedBox(height: 40),

            /// OTP Boxes
            OtpCodeField(length: 6, onCompleted: (code) => _otp = code),

            const SizedBox(height: 20),

            /// Resend
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "If you didn’t receive a code, ",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontFamily: AppFonts.font,
                      fontSize: 15,
                    ),
                  ),
                  GestureDetector(
                    onTap: _resendOtp,
                    child: Text(
                      "Resend",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontFamily: AppFonts.font,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// Submit Button
            AuthButton(text: "Submit", loading: loading, onPressed: _verifyOtp),

            const SizedBox(height: 40),

            Center(
              child: Text(
                "Don’t have an account?",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontFamily: AppFonts.font,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 15),

            AuthButton(
              text: "Sign up",
              loading: false,
              onPressed: () {
                Navigator.pushNamed(context, Routes.signUp);
              },
            ),

            const SizedBox(height: 40),

            const DividerWithText(text: "Or Sign up with"),

            const SizedBox(height: 10),

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
    );
  }
}
