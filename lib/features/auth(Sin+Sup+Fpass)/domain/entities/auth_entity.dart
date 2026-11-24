//يمثل نتيجة أي عملية Auth (token + user)
//هو الشكل النهائي اللي الـ UI هتستلمه بعد اللوجين و الباقي

import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class AuthEntity {
  final String token;
  final String refreshToken;
  final String expiration;
  final UserEntity user;

  const AuthEntity({
    required this.token,
    required this.refreshToken,
    required this.expiration,
    required this.user,
  });
}
