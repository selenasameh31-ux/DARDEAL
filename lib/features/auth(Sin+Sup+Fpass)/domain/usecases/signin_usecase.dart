/*المسؤول عن تنفيذ منطق عملية تسجيل الدخول
الـ Bloc هيكلمه
وهو يكلم الـ Repository
ويرجع النتيجة.
يعني هو "زرار اللوجين" على مستوى المنطق. 
ده مسؤول عن تنفيذ عملية تسجيل الدخول عن طريق استدعاء الـ Repository
 */

import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<AuthEntity> call({
    required String emailOrPhone,
    required String password,
  }) {
    return repository.login(emailOrPhone: emailOrPhone, password: password);
  }
}
