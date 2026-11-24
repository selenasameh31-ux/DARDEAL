import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class EmailVerificationScreen extends StatelessWidget {
  final String email;
  final String? token;

  const EmailVerificationScreen({
    super.key,
    required this.email,
    this.token,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) {
        final bloc = sl<EmailVerificationBloc>();
        // Automatically send OTP to email as soon as the screen opens
        bloc.add(SendEmailOtpRequested(email: email));
        return bloc;
      },
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) return;
          context.read<SessionCubit>().logout();
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.signIn,
            (route) => false,
          );
        },
        child: Scaffold(
          backgroundColor: context.scaffoldBgColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: EmailVerificationForm(email: email),
            ),
          ),
        ),
      ),
    );
  }
}

class EmailVerificationForm extends StatefulWidget {
  final String email;

  const EmailVerificationForm({super.key, required this.email});

  @override
  State<EmailVerificationForm> createState() => _EmailVerificationFormState();
}

class _EmailVerificationFormState extends State<EmailVerificationForm> {
  String _otp = "";

  // Cooldown timer for Resend button (60 seconds)
  static const int _cooldownSeconds = 60;
  int _secondsLeft = 0;
  Timer? _cooldownTimer;

  @override
  void initState() {
    super.initState();
    // Start cooldown immediately since OTP was sent on screen open
    _startCooldown();
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _startCooldown() {
    setState(() => _secondsLeft = _cooldownSeconds);
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        if (mounted) setState(() => _secondsLeft = 0);
      } else {
        if (mounted) setState(() => _secondsLeft--);
      }
    });
  }

  void _verifyOtp() {
    if (_otp.length != 6) {
      AppSnackBar.warning(context, "Please enter the complete 6-digit code.");
      return;
    }

    context.read<EmailVerificationBloc>().add(
          VerifyEmailOtpRequested(email: widget.email, otp: _otp),
        );
  }

  void _resendOtp() {
    if (_secondsLeft > 0) {
      AppSnackBar.warning(
        context,
        "Please wait $_secondsLeft seconds before requesting a new code.",
      );
      return;
    }

    context.read<EmailVerificationBloc>().add(
          ResendEmailOtpRequested(email: widget.email),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmailVerificationBloc, EmailVerificationState>(
      listener: (context, state) {
        if (state is EmailVerificationSuccess) {
          // Navigate to role selection after successful verification
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.roleSelection,
            (route) => false,
          );
        }

        if (state is EmailSendSuccess) {
          AppSnackBar.info(
            context,
            "Verification code sent to ${widget.email}. Check your inbox (or spam).",
            duration: const Duration(seconds: 4),
          );
        }

        if (state is EmailResendSuccess) {
          _startCooldown();
          AppSnackBar.success(context, state.message);
        }

        if (state is EmailVerificationError) {
          AppSnackBar.error(context, state.message);
        }
      },
      builder: (context, state) {
        final loading = state is EmailVerificationLoading;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () {
                context.read<SessionCubit>().logout();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.signIn,
                  (route) => false,
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: SvgPicture.asset(
                  AppIcons.ArrowIcon,
                  width: 28,
                  height: 28,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).textTheme.titleLarge?.color ??
                        Theme.of(context).colorScheme.onBackground,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),

            /// Title + Subtitle
            const Center(
              child: AppPageTitle(
                title: "Email Verification",
                subtitle: "Enter the verification code sent to your email",
              ),
            ),

            const SizedBox(height: 40),

            /// OTP Boxes
            OtpCodeField(length: 6, onCompleted: (code) => _otp = code),

            const SizedBox(height: 20),

            /// Resend row with cooldown timer
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "If you didn't receive a code, ",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontFamily: AppFonts.font,
                          fontSize: 15,
                        ),
                  ),
                  GestureDetector(
                    onTap: _resendOtp,
                    child: _secondsLeft > 0
                        ? Text(
                            "Resend ($_secondsLeft s)",
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontFamily: AppFonts.font,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15,
                                      color: Colors.grey,
                                    ),
                          )
                        : Text(
                            "Resend",
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
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
            AuthButton(
              text: "Verify & Continue",
              loading: loading,
              onPressed: _verifyOtp,
            ),
          ],
        );
      },
    );
  }
}
