import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class ResendEmailOtpUseCase {
  final AuthRepository repository;

  ResendEmailOtpUseCase(this.repository);

  Future<void> call({required String email}) async {
    return await repository.resendEmailOtp(email: email);
  }
}
