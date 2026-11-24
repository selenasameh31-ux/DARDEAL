import 'package:graduation_project_flutter/core/routing/routes_export.dart';
import 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/profile_tab/data/models/profile_model.dart';

abstract class RemoteProfileDataSource {
  Future<ProfileModel> getProfile({required String token});
  Future<ProfileModel> updateProfile({required String token, required ProfileModel profile});
  Future<Map<String, dynamic>> getProfileStats({required String token});
  Future<Map<String, dynamic>> getOwnerStats({required String token});
}

class RemoteProfileDataSourceImpl implements RemoteProfileDataSource {
  final ApiConsumer api;

  RemoteProfileDataSourceImpl(this.api);

  @override
  Future<ProfileModel> getProfile({required String token}) async {
    final response = await api.get(EndPoints.currentUserProfileInfo, token: token);
    return ProfileModel.fromJson(response.data);
  }

  @override
  Future<ProfileModel> updateProfile({required String token, required ProfileModel profile}) async {
    final response = await api.put(
      EndPoints.updateUserProfileInfo,
      token: token,
      data: profile.toJson(),
    );
    return ProfileModel.fromJson(response.data);
  }

  Future<int> _fetchCount(String url, String token) async {
    try {
      final response = await api.get(url, token: token);
      if (response.data is int) return response.data;
      if (response.data is Map && response.data.containsKey('count')) {
        return (response.data['count'] as num).toInt();
      }
      return int.tryParse(response.data.toString()) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<Map<String, dynamic>> getProfileStats({required String token}) async {
    final results = await Future.wait([
      _fetchCount('/api/v1/Offers/count', token),
      _fetchCount('/api/v1/Wishlist/count', token),
      _fetchCount('/api/v1/Rentals/count', token),
      _fetchCount('/api/v1/Notifications/count', token),
    ]);

    return {
      'offersCount': results[0],
      'favoritesCount': results[1],
      'activeRentalsCount': results[2],
      'notificationsCount': results[3],
    };
  }

  @override
  Future<Map<String, dynamic>> getOwnerStats({required String token}) async {
    final response = await api.get(EndPoints.currentUserProfileInfo, token: token);
    return response.data;
  }
}
