import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:graduation_project_flutter/core/errors/failure.dart';
import 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/profile_tab/data/models/profile_model.dart';

abstract class EditProfileRepository {
  Future<Either<Failure, ProfileModel>> getProfile();
  Future<Either<Failure, void>> updateProfile({required Map<String, dynamic> data});
  Future<Either<Failure, dynamic>> uploadProfilePhoto(File image);
}
