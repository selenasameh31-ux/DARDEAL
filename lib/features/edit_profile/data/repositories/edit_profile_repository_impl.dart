import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:graduation_project_flutter/core/errors/failure.dart';
import 'package:graduation_project_flutter/features/edit_profile/data/datasources/edit_profile_remote_data_source.dart';
import 'package:graduation_project_flutter/features/edit_profile/domain/repositories/edit_profile_repository.dart';
import 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/profile_tab/data/models/profile_model.dart';

class EditProfileRepositoryImpl implements EditProfileRepository {
  final EditProfileRemoteDataSource remoteDataSource;

  EditProfileRepositoryImpl({required this.remoteDataSource});

  Failure _handleError(dynamic error) {
    if (error is DioException) {
      debugPrint("DioException Details: ${error.response?.data}");
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.error is SocketException) {
        return NoInternetFailure();
      }

      final statusCode = error.response?.statusCode;
      final message = _extractMessage(error.response?.data) ?? "Something went wrong";

      if (statusCode == 400) {
        return ServerFailure(message);
      } else if (statusCode == 401) {
        return UnauthorizedFailure(message);
      } else if (statusCode == 403) {
        return ForbiddenFailure(message);
      } else if (statusCode == 404) {
        return NotFoundFailure(message);
      } else if (statusCode == 500) {
        return ServerFailure("Internal Server Error");
      }
      return ServerFailure(message);
    } else if (error is SocketException) {
      return NoInternetFailure();
    }
    return ServerFailure(error.toString());
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data.containsKey('message')) return data['message'].toString();
      if (data.containsKey('error')) return data['error'].toString();
    }
    if (data is String) return data;
    return null;
  }

  @override
  Future<Either<Failure, ProfileModel>> getProfile() async {
    try {
      final profile = await remoteDataSource.getProfile();
      return Right(profile);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile({required Map<String, dynamic> data}) async {
    try {
      await remoteDataSource.updateProfile(data: data);
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, dynamic>> uploadProfilePhoto(File image) async {
    try {
      final response = await remoteDataSource.uploadProfilePhoto(image);
      return Right(response);
    } catch (e) {
      return Left(_handleError(e));
    }
  }
}
