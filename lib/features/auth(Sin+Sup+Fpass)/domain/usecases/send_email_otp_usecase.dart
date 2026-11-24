import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class SendEmailOtpUseCase {
  final AuthRepository repository;

  SendEmailOtpUseCase(this.repository);

  Future<void> call({required String email}) async {
    return await repository.sendEmailOtp(email: email);
  }
}
