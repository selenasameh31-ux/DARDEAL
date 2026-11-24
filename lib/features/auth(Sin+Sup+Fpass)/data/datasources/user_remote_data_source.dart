// الفايل ده مسئول عن التعامل مع كل APIs الخاصة بالـ User (Auth / Email / Phone / Password)
/*يعني هنا مربوط الـ EndPoints بالـ ApiConsumer وبينفذ الريكوستات علشان يرجع الداتا جاهزة
 لباقي طبقات التطبيق. (Presentation Layer + Domain Layer + Data Layer)
*/

import 'package:graduation_project_flutter/core/routing/routes_export.dart';

abstract class RemoteUserDataSource {
  // ================= AUTH =================

  Future<UserModel> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required int gender,
  });

  Future<UserModel> login({
    required String emailOrPhone,
    required String password,
  });
  // ================= ROLE SELECTION =================
  Future<UserModel> selectRole({required String role});

  Future<UserModel> refreshToken({required String refreshToken});

  Future<void> logout({required String refreshToken, required String token});

  Future<Map<String, dynamic>> authStatus({required String token});

  // ================= SOCIAL AUTH =================

  Future<UserModel> googleSignIn({required String idToken});
  Future<void> linkGoogle({required String idToken});
  Future<void> unlinkGoogle();

  // ================= Email Verification =================

  Future<void> sendEmailOtp({required String email, required String token});

  Future<void> verifyEmailToken({required String tokenFromLink});

  Future<void> verifyEmailOtp({
    required String email,
    required String otpCode,
    required String token,
  });

  Future<void> resendEmailOtp({required String email, required String token});

  Future<Map<String, dynamic>> emailStatus({required String token});

  // ================= PASSWORD =================

  Future<void> forgotPasswordEmail({required String email});

  Future<void> forgotPasswordPhone({required String phone});

  Future<String> verifyPasswordOtp({
    required String emailOrPhone,
    required String otpCode,
  });

  Future<void> resetPasswordWithToken({
    required String resetToken,
    required String newPassword,
    required String confirmPassword,
  });

  // ================= PHONE =================

  Future<void> sendPhoneOtp({
    required String phoneNumber,
    required String token,
  });

  Future<void> verifyPhoneOtp({
    required String phoneNumber,
    required String otpCode,
    required String token,
  });

  Future<void> resendPhoneOtp({
    required String phoneNumber,
    required String token,
  });

  Future<void> phoneStatus({required String token});
}

class RemoteUserDataSourceImpl implements RemoteUserDataSource {
  final ApiConsumer api;

  RemoteUserDataSourceImpl(this.api);

  // ================= AUTH =================

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required int gender,
  }) async {
    final response = await api.post(
      EndPoints.newUser,
      data: {
        "name": name,
        "email": email,
        "phone": phone,
        "password": password,
        "gender": gender,
      },
    );

    return UserModel.fromJson(response.data);
  }

  @override
  Future<UserModel> login({
    required String emailOrPhone,
    required String password,
  }) async {
    final response = await api.post(
      EndPoints.loggedinUser,
      data: {"emailOrPhone": emailOrPhone, "password": password},
    );

    return UserModel.fromJson(response.data);
  }

  @override
  Future<UserModel> refreshToken({required String refreshToken}) async {
    final response = await api.post(
      EndPoints.refreshAccessToken,
      data: {"refreshToken": refreshToken},
    );

    return UserModel.fromJson(response.data);
  }

  @override
  Future<void> logout({
    required String refreshToken,
    required String token,
  }) async {
    await api.post(
      EndPoints.logoutUser,
      token: token,
      data: {"refreshToken": refreshToken},
    );
  }

  @override
  Future<Map<String, dynamic>> authStatus({required String token}) async {
    final response = await api.get(
      EndPoints.userEmailAndPhoneVerify,
      token: token,
    );

    return response.data["data"];
  }
  
  // ================= ROLE SELECTION =================
  @override
  Future<UserModel> selectRole({required String role}) async {
    final response = await api.post(EndPoints.roleSelect, data: {"role": role});
    return UserModel.fromJson(response.data);
  }

  // ================= SOCIAL AUTH =================

  @override
  Future<UserModel> googleSignIn({required String idToken}) async {
    final response = await api.post(
      EndPoints.googleSignIn,
      data: {"idToken": idToken},
    );
    return UserModel.fromJson(response.data);
  }

  @override
  Future<void> linkGoogle({required String idToken}) async {
    await api.post(EndPoints.linkGoogle, data: {"idToken": idToken});
  }

  @override
  Future<void> unlinkGoogle() async {
    await api.post(EndPoints.unlinkGoogle);
  }

  // ================= EMAIL =================

  @override
  Future<void> sendEmailOtp({
    required String email,
    required String token,
  }) async {
    await api.post(
      EndPoints.sendOTPViaEmail,
      token: token,
      data: {"email": email},
    );
  }

  @override
  Future<void> verifyEmailToken({required String tokenFromLink}) async {
    await api.get(
      EndPoints.verifyEmailUsingToken,
      queryParameters: {"token": tokenFromLink},
    );
  }

  @override
  Future<void> verifyEmailOtp({
    required String email,
    required String otpCode,
    required String token,
  }) async {
    await api.post(
      EndPoints.alternativeSendOTP,
      token: token,
      data: {"email": email, "otpCode": otpCode},
    );
  }

  @override
  Future<void> resendEmailOtp({
    required String email,
    required String token,
  }) async {
    await api.post(
      EndPoints.resendOTPViaEmail,
      token: token,
      data: {"email": email},
    );
  }

  @override
  Future<Map<String, dynamic>> emailStatus({required String token}) async {
    final response = await api.get(
      EndPoints.emailVerificationStatus,
      token: token,
    );

    return response.data["data"];
  }

  // ================= PASSWORD =================

  @override
  Future<void> forgotPasswordEmail({required String email}) async {
    await api.post(EndPoints.passwordResetViaEmail, data: {"email": email});
  }

  @override
  Future<void> forgotPasswordPhone({required String phone}) async {
    await api.post(EndPoints.passwordResetViaPhone, data: {"phone": phone});
  }

  @override
  Future<String> verifyPasswordOtp({
    required String emailOrPhone,
    required String otpCode,
  }) async {
    final response = await api.post(
      EndPoints.verifyOTPforPassReset,
      data: {"emailOrPhone": emailOrPhone, "otpCode": otpCode},
    );

    return response.data["data"]["resetToken"];
  }

  @override
  Future<void> resetPasswordWithToken({
    required String resetToken,
    required String newPassword,
    required String confirmPassword,
  }) async {
    await api.post(
      EndPoints.resetPasswordUsingToken,
      data: {
        "token": resetToken,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
      },
    );
  }
  // ================= PHONE =================

  @override
  Future<void> sendPhoneOtp({
    required String phoneNumber,
    required String token,
  }) async {
    await api.post(
      EndPoints.sendOTPViaphone,
      token: token,
      data: {"phoneNumber": phoneNumber},
    );
  }

  @override
  Future<void> verifyPhoneOtp({
    required String phoneNumber,
    required String otpCode,
    required String token,
  }) async {
    await api.post(
      EndPoints.verifyPhoneOTP,
      token: token,
      data: {"phoneNumber": phoneNumber, "otpCode": otpCode},
    );
  }

  @override
  Future<void> resendPhoneOtp({
    required String phoneNumber,
    required String token,
  }) async {
    await api.post(
      EndPoints.resendOTPViaPhone,
      token: token,
      data: {"phoneNumber": phoneNumber},
    );
  }

  @override
  Future<void> phoneStatus({required String token}) async {
    await api.get(EndPoints.phoneVerificationStatus, token: token);
  }
}
