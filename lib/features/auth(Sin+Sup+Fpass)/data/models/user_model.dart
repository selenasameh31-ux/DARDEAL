// المودل ده معمول لما : الريسبونس يحتوي على داتا هنستخدمها جوه التطبيق لكن لو:مجرد Success / Message أو مفيش داتا مهمة مش لازم
/*
  الملف ده مسئول عن تمثيل الريسبونس اللي بيرجع من APIs الخاصة بالـ Authentication
  زي (Register / Login / Refresh Token).
  الريسبونس اللي بييجي من السيرفر متقسم كده: (success) + (data >> (user جزء جوة الداتا))

  فكدا المودل متقسم لجزئين 
  1) UserModel  +  2) User
*/
//الموديل ده مسئول عن استقبال بيانات الـ JSON من الـ API
// وبيحوّلها لـ AuthEntity عشان تتستخدم في طبقة الـ Domain

import 'package:graduation_project_flutter/core/routing/routes_export.dart';

//بيمثل الريسبونس كله (Auth Response)
class UserModel {
  final bool success; //(العملية نجحت ولا لأ)
  final String token; //(Access Token)
  final String refreshToken;
  final String expiration; //(مدة صلاحية التوكن)
  final User user; //(وبيكون object من نوع User)

  UserModel({
    required this.success,
    required this.token,
    required this.refreshToken,
    required this.expiration,
    required this.user,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final data = json["data"] ?? {};

    return UserModel(
      success: json["success"] ?? false,
      token: data["token"] ?? json["token"] ?? "",
      refreshToken: data["refreshToken"] ?? json["refreshToken"] ?? "",
      expiration: data["expiration"] ?? json["expiration"] ?? "",
      user: data["user"] != null ? User.fromJson(data["user"]) : User.fromJson(json["user"] ?? {}),
    );
  }

  // التحويل من مودل لانتيتي
  AuthEntity toEntity() {
    return AuthEntity(
      token: token,
      refreshToken: refreshToken,
      expiration: expiration,
      user: user.toEntity(),
    );
  }
}

//بيمثل بيانات المستخدم نفسه
class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String status;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final bool hasPassword;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.status,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.hasPassword,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"].toString(),
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      role: json["role"] ?? "",
      status: json["status"] ?? "",
      isEmailVerified: json["isEmailVerified"] ?? false,
      isPhoneVerified: json["isPhoneVerified"] ?? false,
      hasPassword: json["hasPassword"] ?? false,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      phone: phone,
      role: role,
      status: status,
      isEmailVerified: isEmailVerified,
      isPhoneVerified: isPhoneVerified,
      hasPassword: hasPassword,
    );
  }
}
