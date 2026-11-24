import 'package:graduation_project_flutter/core/routing/routes_export.dart';
import 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/chat_tab/data/models/chat_models.dart';


// class SessionCubit extends Cubit<SessionState> {
//   final CacheHelper _cacheHelper;

//   SessionCubit(this._cacheHelper) : super(SessionInitial()) {
//     initSession();
//   }

//   void initSession() {
//     final token = _cacheHelper.getToken();
//     final userJson = _cacheHelper.getUserData();
//     final isGuest = _cacheHelper.isGuestMode();

//     if (token != null && userJson != null) {
//       try {
//         final Map<String, dynamic> userMap = json.decode(userJson);
//         final user = UserEntity.fromMap(userMap);
//         // Restore profile image from saved path
//         File? profileImage;
//         if (user.profileImagePath.isNotEmpty) {
//           final file = File(user.profileImagePath);
//           if (file.existsSync()) {
//             profileImage = file;
//           }
//         }
//         emit(SessionAuthenticated(user, profileImage: profileImage));
//       } catch (e) {
//         if (isGuest) {
//           emit(SessionGuest());
//         } else {
//           emit(SessionInitial());
//         }
//       }
//     } else if (isGuest) {
//       emit(SessionGuest());
//     } else {
//       emit(SessionInitial());
//     }
//   }

//   Future<void> authenticateUser(UserEntity user, String token, {String? refreshToken}) async {
//     await _cacheHelper.setGuestMode(false);
//     await _cacheHelper.saveToken(token);
//     if (refreshToken != null) {
//       await _cacheHelper.saveRefreshToken(refreshToken);
//     }
//     await _cacheHelper.saveUserId(user.id);

//     // Check if we had previous local profile data for this user
//     final existingJson = _cacheHelper.getUserData();
//     UserEntity finalUser = user;
//     if (existingJson != null) {
//       try {
//         final existingMap = json.decode(existingJson) as Map<String, dynamic>;
//         final existingUser = UserEntity.fromMap(existingMap);
//         // If same user, preserve local-only fields
//         if (existingUser.id == user.id) {
//           finalUser = user.copyWith(
//             gender: existingUser.gender.isNotEmpty ? existingUser.gender : null,
//             dateOfBirth: existingUser.dateOfBirth.isNotEmpty ? existingUser.dateOfBirth : null,
//             address: existingUser.address.isNotEmpty ? existingUser.address : null,
//             bio: existingUser.bio.isNotEmpty ? existingUser.bio : null,
//             profileImagePath: existingUser.profileImagePath.isNotEmpty ? existingUser.profileImagePath : null,
//           );
//         }
//       } catch (_) {}
//     }

//     await _cacheHelper.saveUserData(json.encode(finalUser.toMap()));

//     File? profileImage;
//     if (finalUser.profileImagePath.isNotEmpty) {
//       final file = File(finalUser.profileImagePath);
//       if (file.existsSync()) {
//         profileImage = file;
//       }
//     }

//     emit(SessionAuthenticated(finalUser, profileImage: profileImage));
//   }

//   Future<void> updateProfile(UserEntity updatedUser, {File? profileImage}) async {
//     if (state is SessionAuthenticated) {
//       // Save the image path into the user entity
//       UserEntity userToSave = updatedUser;
//       if (profileImage != null) {
//         userToSave = updatedUser.copyWith(profileImagePath: profileImage.path);
//       }
//       await _cacheHelper.saveUserData(json.encode(userToSave.toMap()));
//       final currentImage = profileImage ?? (state as SessionAuthenticated).profileImage;
//       emit(SessionAuthenticated(userToSave, profileImage: currentImage));
//     }
//   }

//   Future<void> logout() async {
//     await _cacheHelper.clearData();
//     emit(SessionInitial());
//   }

//   Future<void> setGuest() async {
//     await _cacheHelper.setGuestMode(true);
//     emit(SessionGuest());
//   }
// }







class SessionCubit extends Cubit<SessionState> {
  final CacheHelper _cacheHelper;
  final ApiConsumer _api;

  SessionCubit(this._cacheHelper, this._api) : super(SessionInitial()) {
    initSession();
  }

  // ─────────────────────────────────────────────────────────
  // INIT
  // ─────────────────────────────────────────────────────────

  void initSession() {
    final token = _cacheHelper.getToken();
    final userJson = _cacheHelper.getUserData();
    final isGuest = _cacheHelper.isGuestMode();

    if (token != null && userJson != null) {
      try {
        final Map<String, dynamic> userMap = json.decode(userJson);
        final user = UserEntity.fromMap(userMap);

        // Allow ChatModel to resolve otherParticipant from seeker/owner
        ChatModel.setCurrentUserId(user.id);

        emit(SessionAuthenticated(user,
            profileImage: _localFileOrNull(user.profileImagePath),
            imageUrl: _resolveImageUrl(user.profileImagePath)));

        // Sync from server to refresh any server-side data
        syncProfileWithServer();
      } catch (e) {
        if (isGuest) {
          emit(SessionGuest());
        } else {
          emit(SessionInitial());
        }
      }
    } else if (isGuest) {
      emit(SessionGuest());
    } else {
      emit(SessionInitial());
    }
  }

  // ─────────────────────────────────────────────────────────
  // SYNC FROM SERVER
  // ─────────────────────────────────────────────────────────

  Future<void> syncProfileWithServer() async {
    if (state is! SessionAuthenticated) return;
    try {
      final currentUser = (state as SessionAuthenticated).user;
      final response = await _api.get(EndPoints.currentUserProfileInfo);

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'] ?? response.data;

        print('================ SYNC DEBUG ================');
        print('GET /api/v1/users/profile response: $data');
        print('profilePhoto value: ${data['profilePhoto']}');
        print('============================================');

        // Only overwrite a field when the server returns a non-empty value
        final updatedUser = currentUser.copyWith(
          name: _pick(data['name'], currentUser.name),
          gender: _pick(data['gender'], currentUser.gender),
          dateOfBirth: _pick(data['birthDate'], currentUser.dateOfBirth),
          address: _pick(data['address'], currentUser.address),
          bio: _pick(data['bio'], currentUser.bio),
          profileImagePath: _pick(
              data['profilePhoto'], currentUser.profileImagePath),
        );

        await _cacheHelper.saveUserData(json.encode(updatedUser.toMap()));

        String? imageUrl = (state as SessionAuthenticated).imageUrl;
        File? profileImage = (state as SessionAuthenticated).profileImage;

        // If server returned a photo path, build a full URL and clear local file ref
        final serverPhotoPath = data['profilePhoto']?.toString() ?? '';
        if (serverPhotoPath.isNotEmpty) {
          imageUrl = _resolveImageUrl(serverPhotoPath);
          profileImage = null;
        }

        emit(SessionAuthenticated(updatedUser,
            profileImage: profileImage, imageUrl: imageUrl));
      }
    } catch (e) {
      print('syncProfileWithServer failed: $e');
    }
  }

  // ─────────────────────────────────────────────────────────
  // AUTHENTICATE (login / register / google)
  // ─────────────────────────────────────────────────────────

  Future<void> authenticateUser(
    UserEntity user,
    String token, {
    String? refreshToken,
  }) async {
    await _cacheHelper.setGuestMode(false);
    await _cacheHelper.saveToken(token);
    if (refreshToken != null) {
      await _cacheHelper.saveRefreshToken(refreshToken);
    }
    await _cacheHelper.saveUserId(user.id);
    ChatModel.setCurrentUserId(user.id);

    // Preserve any local-only fields from a previous cache entry for this user
    final existingJson = _cacheHelper.getUserData();
    UserEntity finalUser = user;
    if (existingJson != null) {
      try {
        final existingMap =
            json.decode(existingJson) as Map<String, dynamic>;
        final existingUser = UserEntity.fromMap(existingMap);
        if (existingUser.id == user.id) {
          finalUser = user.copyWith(
            gender:
                existingUser.gender.isNotEmpty ? existingUser.gender : null,
            dateOfBirth: existingUser.dateOfBirth.isNotEmpty
                ? existingUser.dateOfBirth
                : null,
            address:
                existingUser.address.isNotEmpty ? existingUser.address : null,
            bio: existingUser.bio.isNotEmpty ? existingUser.bio : null,
            profileImagePath: existingUser.profileImagePath.isNotEmpty
                ? existingUser.profileImagePath
                : null,
          );
        }
      } catch (_) {}
    }

    await _cacheHelper.saveUserData(json.encode(finalUser.toMap()));

    emit(SessionAuthenticated(finalUser,
        profileImage: _localFileOrNull(finalUser.profileImagePath),
        imageUrl: _resolveImageUrl(finalUser.profileImagePath)));

    // Sync from server right after login to get any server-saved photo URL
    await syncProfileWithServer();
  }

  // ─────────────────────────────────────────────────────────
  // UPDATE PROFILE (edit screen)
  // ─────────────────────────────────────────────────────────

  Future<void> updateProfile(
    UserEntity updatedUser, {
    File? profileImage,
  }) async {
    if (state is! SessionAuthenticated) return;
    try {
      String? serverPhotoUrl;

      // ── Step 1: upload photo ──────────────────────────────
      if (profileImage != null) {
        // The ASP.NET backend expects a single file field; try 'file' first
        // (confirmed key from curl test: it returns {"photoUrl": "..."})
        final formData = FormData.fromMap({
          'file': await MultipartFile.fromFile(profileImage.path),
        });

        final photoResponse = await _api.post(
          '/api/v1/users/profile/photo',
          data: formData,
        );

        print('================ DEBUG LOGS ================');
        print('1- POST /api/v1/users/profile/photo response: ${photoResponse.data}');

        if (photoResponse.statusCode == 200 ||
            photoResponse.statusCode == 201) {
          if (photoResponse.data != null) {
            dynamic raw = photoResponse.data;
            dynamic dataObj = (raw is Map && raw.containsKey('data'))
                ? raw['data']
                : raw;

            if (dataObj is String &&
                (dataObj.startsWith('http') || dataObj.startsWith('/'))) {
              serverPhotoUrl = dataObj;
            } else if (dataObj is Map) {
              // 'photoUrl' is the EXACT key this ASP.NET backend uses
              serverPhotoUrl = dataObj['photoUrl'] ??
                  dataObj['profilePhoto'] ??
                  dataObj['url'] ??
                  dataObj['path'] ??
                  dataObj['imageUrl'] ??
                  dataObj['image'] ??
                  dataObj['profileImagePath'] ??
                  dataObj['filePath'];

              // Fallback: search all values for anything URL-like
              if (serverPhotoUrl == null) {
                for (var v in dataObj.values) {
                  if (v is String &&
                      (v.startsWith('http://') ||
                          v.startsWith('https://') ||
                          v.contains('/uploads/'))) {
                    serverPhotoUrl = v;
                    break;
                  }
                }
              }
            }

            // Convert relative paths to absolute URLs
            if (serverPhotoUrl != null &&
                !serverPhotoUrl.startsWith('http')) {
              serverPhotoUrl = serverPhotoUrl.startsWith('/')
                  ? '${EndPoints.baseUrl}$serverPhotoUrl'
                  : '${EndPoints.baseUrl}/$serverPhotoUrl';
            }
          }
        }

        print('2- Extracted image URL: $serverPhotoUrl');
      }

      // ── Step 2: persist profile on server ────────────────
      UserEntity userToSave = updatedUser;
      if (serverPhotoUrl != null && serverPhotoUrl.isNotEmpty) {
        userToSave = updatedUser.copyWith(profileImagePath: serverPhotoUrl);
      } else if (profileImage != null) {
        // Store local path for immediate display only – NOT sent to backend
        userToSave = updatedUser.copyWith(profileImagePath: profileImage.path);
      }

      final putData = <String, dynamic>{
        'name': userToSave.name,
        'gender': userToSave.gender,
        'birthDate': userToSave.dateOfBirth,
        'address': userToSave.address,
        'bio': userToSave.bio,
      };

      // Only send profilePhoto when we have a real HTTP URL from the server
      if (userToSave.profileImagePath.startsWith('http')) {
        putData['profilePhoto'] = userToSave.profileImagePath;
      }

      print('3- PUT /api/v1/users/profile body: $putData');

      await _api.put(EndPoints.updateUserProfileInfo, data: putData);

      // ── Step 3: update local cache & state ───────────────
      await _cacheHelper.saveUserData(json.encode(userToSave.toMap()));

      File? currentImage =
          profileImage ?? (state as SessionAuthenticated).profileImage;
      String? currentImageUrl = (state as SessionAuthenticated).imageUrl;

      if (serverPhotoUrl != null && serverPhotoUrl.isNotEmpty) {
        currentImageUrl = serverPhotoUrl;
        currentImage = null; // server URL takes precedence
      }

      emit(SessionAuthenticated(userToSave,
          profileImage: currentImage, imageUrl: currentImageUrl));

      // ── Step 4: sync to confirm what the server actually saved
      await syncProfileWithServer();
    } catch (e) {
      print('updateProfile failed: $e');
      rethrow;
    }
  }

  // ─────────────────────────────────────────────────────────
  // LOGOUT / GUEST
  // ─────────────────────────────────────────────────────────

  Future<void> logout() async {
    await _cacheHelper.clearAuthData();
    emit(SessionInitial());
  }

  Future<void> setGuest() async {
    await _cacheHelper.setGuestMode(true);
    emit(SessionGuest());
  }

  // ─────────────────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────────────────

  /// Returns a full HTTP URL if [path] is a server path, otherwise null.
  String? _resolveImageUrl(String path) {
    if (path.isEmpty) return null;
    if (path.startsWith('http')) return path;
    // Relative server path (e.g. /uploads/profiles/171_xxx.jpg)
    if (!path.startsWith('/data') &&
        !path.startsWith('/private') &&
        !path.startsWith('/storage') &&
        !path.contains('image_picker') &&
        !path.contains('/cache/')) {
      return path.startsWith('/')
          ? '${EndPoints.baseUrl}$path'
          : '${EndPoints.baseUrl}/$path';
    }
    return null; // it's a local device path
  }

  /// Returns a [File] only if [path] is a local path that actually exists.
  File? _localFileOrNull(String path) {
    if (path.isEmpty) return null;
    if (path.startsWith('http')) return null;
    final f = File(path);
    return f.existsSync() ? f : null;
  }

  /// Returns [serverValue] if it is non-null and non-empty, else [fallback].
  String _pick(dynamic serverValue, String fallback) {
    final s = serverValue?.toString() ?? '';
    return s.isNotEmpty ? s : fallback;
  }
}
