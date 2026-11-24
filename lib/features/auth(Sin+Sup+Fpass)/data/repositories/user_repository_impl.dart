// ده التنفيذ الفعلي للـ AuthRepository
// بيستدعي الـ RemoteDataSource وبيحوّل الـ Model لـ Entity

import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class AuthRepositoryImpl implements AuthRepository {
  final RemoteUserDataSource remote;
  final UserLocalDataSource local;

  AuthRepositoryImpl({required this.remote, required this.local});

  @override
  Future<AuthEntity> login({
    required String emailOrPhone,
    required String password,
  }) async {
    final userModel = await remote.login(
      emailOrPhone: emailOrPhone,
      password: password,
    );

    final authEntity = userModel.toEntity();
    await local.saveAuthData(authEntity);
    return authEntity;
  }

  @override
  Future<AuthEntity> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required int gender,
  }) async {
    final userModel = await remote.register(
      name: name,
      email: email,
      phone: phone,
      password: password,
      gender: gender,
    );

    final authEntity = userModel.toEntity();
    await local.saveAuthData(authEntity);
    return authEntity;
  }

  // ================= SOCIAL AUTH =================

  @override
  Future<AuthEntity> googleSignIn({required String idToken}) async {
    final userModel = await remote.googleSignIn(idToken: idToken);
    final authEntity = userModel.toEntity();
    await local.saveAuthData(authEntity);
    return authEntity;
  }


  @override
  Future<void> linkGoogle({required String idToken}) async {
    await remote.linkGoogle(idToken: idToken);
  }

  @override
  Future<void> unlinkGoogle() async {
    await remote.unlinkGoogle();
  }
  
  // ================= FORGOT PASSWORD =================

  @override
  Future<void> forgotPassword(String emailOrPhone) async {
    if (emailOrPhone.contains("@")) {
      await remote.forgotPasswordEmail(email: emailOrPhone);
    } else {
      await remote.forgotPasswordPhone(phone: emailOrPhone);
    }
  }

  @override
  Future<String> verifyPasswordOtp({
    required String emailOrPhone,
    required String otp,
  }) async {
    return await remote.verifyPasswordOtp(
      emailOrPhone: emailOrPhone,
      otpCode: otp,
    );
  }

  @override
  Future<void> resetPasswordWithToken({
    required String resetToken,
    required String newPassword,
    required String confirmPassword,
  }) async {
    await remote.resetPasswordWithToken(
      resetToken: resetToken,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
  }
  // ================= ROLE SELECTION =================
  @override
  Future<AuthEntity> selectRole({required String role}) async {
    final userModel = await remote.selectRole(role: role);
    final authEntity = userModel.toEntity();
    await local.saveAuthData(authEntity);
    return authEntity;
  }

  // ================= EMAIL VERIFICATION =================
  @override
  Future<void> sendEmailOtp({required String email}) async {
    final token = local.getToken();
    await remote.sendEmailOtp(
      email: email,
      token: token ?? '',
    );
  }

  @override
  Future<void> verifyEmailOtp({
    required String email,
    required String otpCode,
  }) async {
    final token = local.getToken();
    await remote.verifyEmailOtp(
      email: email,
      otpCode: otpCode,
      token: token ?? '',
    );
  }

  @override
  Future<void> resendEmailOtp({
    required String email,
  }) async {
    final token = local.getToken();
    await remote.resendEmailOtp(
      email: email,
      token: token ?? '',
    );
  }

  @override
  Future<void> logout() async {
    await local.clearAuthData();
  }
}
