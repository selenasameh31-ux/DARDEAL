// register_usecase.dart
import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<AuthEntity> call({
    required String name,
    required String email,
    required String phone,
    required String password,
    required int gender,
  }) {
    return repository.register(
      name: name,
      email: email,
      phone: phone,
      password: password,
      gender: gender,
    );
  }
}
