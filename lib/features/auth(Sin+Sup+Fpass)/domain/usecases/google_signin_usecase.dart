import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class GoogleSignInUseCase {
  final AuthRepository repository;

  GoogleSignInUseCase(this.repository);

  Future<AuthEntity> call(String idToken) async {
    return await repository.googleSignIn(idToken: idToken);
  }
}
