import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class VerifyEmailOtpUseCase {
  final AuthRepository repository;

  VerifyEmailOtpUseCase(this.repository);

  Future<void> call({required String email, required String otpCode}) async {
    return await repository.verifyEmailOtp(email: email, otpCode: otpCode);
  }
}
