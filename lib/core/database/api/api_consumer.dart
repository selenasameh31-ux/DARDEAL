// الملف ده عبارة عن Interface (كلاس مجرد) بيحدد شكل الدوال اللي لازم تكون موجودة لأي كلاس مسؤول عن API Requests
// زي get و post و put و delete عشان يبقى عندنا تنظيم ثابت في التعامل مع الشبكة

import 'package:graduation_project_flutter/core/routing/routes_export.dart';

// abstract class ApiConsumer {
//   Future<Response> get(
//     String endpoint, {
//     Map<String, dynamic>? queryParameters,
//     String? token,
//   });

//   Future<Response> post(
//     String endpoint, {
//     Map<String, dynamic>? data,
//     Map<String, dynamic>? queryParameters,
//     String? token,
//   });

//   Future<Response> put(
//     String endpoint, {
//     Map<String, dynamic>? data,
//     Map<String, dynamic>? queryParameters,
//     String? token,
//   });

//   Future<Response> delete(
//     String endpoint, {
//     Map<String, dynamic>? data,
//     Map<String, dynamic>? queryParameters,
//     String? token,
//   });
// }




abstract class ApiConsumer {
  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    String? token,
  });

  Future<Response> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    String? token,
  });

  Future<Response> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    String? token,
  });

  Future<Response> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    String? token,
  });
}
