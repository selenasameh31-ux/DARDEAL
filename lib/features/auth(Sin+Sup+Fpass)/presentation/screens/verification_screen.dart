import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class VerificationScreen extends StatelessWidget {
  final String emailOrPhone;

  const VerificationScreen({super.key, required this.emailOrPhone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: VerificationForm(emailOrPhone: emailOrPhone),
        ),
      ),
    );
  }
}
