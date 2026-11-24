import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<String> call({required String emailOrPhone, required String otp}) {
    return repository.verifyPasswordOtp(emailOrPhone: emailOrPhone, otp: otp);
  }
}
