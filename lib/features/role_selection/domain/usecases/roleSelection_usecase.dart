import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class SelectRoleUseCase {
  final AuthRepository repository;

  SelectRoleUseCase(this.repository);

  Future<AuthEntity> call({required String role}) {
    return repository.selectRole(role: role);
  }
}