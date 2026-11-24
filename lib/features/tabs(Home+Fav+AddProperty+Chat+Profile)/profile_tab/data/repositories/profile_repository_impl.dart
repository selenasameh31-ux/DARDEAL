import 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/profile_tab/data/datasources/profile_remote_data_source.dart';
import 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/profile_tab/data/models/profile_model.dart';
import 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/profile_tab/domain/repositories/profile_repository.dart';

import 'package:graduation_project_flutter/core/database/cache/cache_helper.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final RemoteProfileDataSource remote;
  final CacheHelper cacheHelper;

  ProfileRepositoryImpl({required this.remote, required this.cacheHelper});

  String get _token => cacheHelper.getToken() ?? '';

  @override
  Future<ProfileModel> getProfile() async {
    return await remote.getProfile(token: _token);
  }

  @override
  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    return await remote.updateProfile(token: _token, profile: profile);
  }

  @override
  Future<Map<String, dynamic>> getProfileStats() async {
    return await remote.getProfileStats(token: _token);
  }

  @override
  Future<Map<String, dynamic>> getOwnerStats() async {
    return await remote.getOwnerStats(token: _token);
  }
}
