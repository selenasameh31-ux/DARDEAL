import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<void> call({
    required String resetToken,
    required String newPassword,
    required String confirmPassword,
  }) {
    return repository.resetPasswordWithToken(
      resetToken: resetToken,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
  }
}
