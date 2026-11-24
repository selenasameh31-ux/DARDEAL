import 'package:graduation_project_flutter/core/routing/routes_export.dart';

abstract class AuthRepository {
  Future<AuthEntity> login({
    required String emailOrPhone,
    required String password,
  });

  Future<AuthEntity> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required int gender,
  });

  // ================= ROLE SELECTION =================
  /// role: "Seeker" | "Owner" | "Seeker_Owner"
  Future<AuthEntity> selectRole({required String role});

  // ================= SOCIAL AUTH =================
  Future<AuthEntity> googleSignIn({required String idToken});
  Future<void> linkGoogle({required String idToken});
  Future<void> unlinkGoogle();

  Future<void> forgotPassword(String emailOrPhone);

  Future<String> verifyPasswordOtp({
    required String emailOrPhone,
    required String otp,
  });

  Future<void> resetPasswordWithToken({
    required String resetToken,
    required String newPassword,
    required String confirmPassword,
  });
}
