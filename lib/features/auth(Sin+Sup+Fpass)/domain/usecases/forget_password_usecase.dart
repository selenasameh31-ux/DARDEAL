import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class ForgotPasswordUseCase {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  Future<void> call(String emailOrPhone) async {
    await repository.forgotPassword(emailOrPhone);
  }
}
