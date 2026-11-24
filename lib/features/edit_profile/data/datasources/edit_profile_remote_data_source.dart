import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:graduation_project_flutter/core/database/api/api_consumer.dart';
import 'package:graduation_project_flutter/core/database/api/end_points.dart';
import 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/profile_tab/data/models/profile_model.dart';

abstract class EditProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
  Future<void> updateProfile({required Map<String, dynamic> data});
  Future<dynamic> uploadProfilePhoto(File image);
}

class EditProfileRemoteDataSourceImpl implements EditProfileRemoteDataSource {
  final ApiConsumer api;

  EditProfileRemoteDataSourceImpl({required this.api});

  @override
  Future<ProfileModel> getProfile() async {
    try {
      final response = await api.get(EndPoints.profile);
      debugPrint("GET Profile Response: ${response.data}");
      // Assuming response structure contains a data object, depending on standard format.
      // Often the API returns { "data": { ... } } or just the object. We will handle safely.
      if (response.data is Map<String, dynamic> && response.data.containsKey('data')) {
        return ProfileModel.fromJson(response.data['data']);
      }
      return ProfileModel.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint("GET Profile Error: ${e.response?.data}");
      rethrow;
    }
  }

  @override
  Future<void> updateProfile({required Map<String, dynamic> data}) async {
    try {
      final response = await api.put(EndPoints.profile, data: data);
      debugPrint("PUT Profile Response: ${response.data}");
    } on DioException catch (e) {
      debugPrint("PUT Profile Error: ${e.response?.data}");
      rethrow;
    }
  }

  @override
  Future<dynamic> uploadProfilePhoto(File image) async {
    try {
      String fileName = image.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          image.path,
          filename: fileName,
        ),
      });

      // Using Dio directly from DioConsumer to allow FormData if ApiConsumer has issues,
      // but ApiConsumer's post takes Object? data so it supports FormData.
      final response = await api.post(
        EndPoints.uploadProfilePhoto,
        data: formData,
      );

      debugPrint("POST Profile Photo Response Type: ${response.data.runtimeType}");
      debugPrint("POST Profile Photo Response Body: ${response.data.toString()}");
      return response.data;
    } on DioException catch (e) {
      debugPrint("POST Profile Photo Error: ${e.response?.data}");
      rethrow;
    }
  }
}
