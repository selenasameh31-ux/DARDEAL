import 'package:graduation_project_flutter/core/routing/routes_export.dart';

// abstract class UserLocalDataSource {
//   Future<void> saveAuthData(AuthEntity auth);
//   Future<void> clearAuthData();
//   String? getToken();
//   String? getUserId();
// }

// class UserLocalDataSourceImpl implements UserLocalDataSource {
//   final CacheHelper cacheHelper;

//   UserLocalDataSourceImpl(this.cacheHelper);

//   @override
//   Future<void> saveAuthData(AuthEntity auth) async {
//     await cacheHelper.saveToken(auth.token);
//     if (auth.refreshToken != null) {
//       await cacheHelper.saveRefreshToken(auth.refreshToken!);
//     }
//     await cacheHelper.saveUserId(auth.user.id);
//     await cacheHelper.saveUserData(json.encode(auth.user.toMap()));
//     await cacheHelper.setGuestMode(false);
//   }

//   @override
//   Future<void> clearAuthData() async {
//     await cacheHelper.clearData();
//   }

//   @override
//   String? getToken() => cacheHelper.getToken();

//   @override
//   String? getUserId() => cacheHelper.getUserId();
// }



abstract class UserLocalDataSource {
  Future<void> saveAuthData(AuthEntity auth);
  Future<void> clearAuthData();
  String? getToken();
  String? getUserId();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final CacheHelper cacheHelper;

  UserLocalDataSourceImpl(this.cacheHelper);

  @override
  Future<void> saveAuthData(AuthEntity auth) async {
    await cacheHelper.saveToken(auth.token);
    if (auth.refreshToken != null) {
      await cacheHelper.saveRefreshToken(auth.refreshToken!);
    }
    await cacheHelper.saveUserId(auth.user.id);
    
    // Merge with existing local fields
    final existingJson = cacheHelper.getUserData();
    UserEntity finalUser = auth.user;
    if (existingJson != null) {
      try {
        final existingMap = json.decode(existingJson) as Map<String, dynamic>;
        final existingUser = UserEntity.fromMap(existingMap);
        if (existingUser.id == auth.user.id) {
          finalUser = auth.user.copyWith(
            gender: existingUser.gender.isNotEmpty ? existingUser.gender : null,
            dateOfBirth: existingUser.dateOfBirth.isNotEmpty ? existingUser.dateOfBirth : null,
            address: existingUser.address.isNotEmpty ? existingUser.address : null,
            bio: existingUser.bio.isNotEmpty ? existingUser.bio : null,
            profileImagePath: existingUser.profileImagePath.isNotEmpty ? existingUser.profileImagePath : null,
          );
        }
      } catch (_) {}
    }
    
    await cacheHelper.saveUserData(json.encode(finalUser.toMap()));
    await cacheHelper.setGuestMode(false);
  }

  @override
  Future<void> clearAuthData() async {
    await cacheHelper.clearAuthData();
  }

  @override
  String? getToken() => cacheHelper.getToken();

  @override
  String? getUserId() => cacheHelper.getUserId();
}
