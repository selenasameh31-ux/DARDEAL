import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_flutter/core/errors/failure.dart';
import 'package:graduation_project_flutter/core/session/cubit/session_cubit.dart';
import 'package:graduation_project_flutter/core/session/cubit/session_state.dart';
import 'package:graduation_project_flutter/features/edit_profile/domain/repositories/edit_profile_repository.dart';
import 'package:graduation_project_flutter/features/edit_profile/presentation/state_management(bloc)/edit_profile_state.dart';
import 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/profile_tab/data/models/profile_model.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final EditProfileRepository repository;
  final SessionCubit sessionCubit;

  EditProfileCubit({
    required this.repository,
    required this.sessionCubit,
  }) : super(EditProfileInitial());

  // ─── Load profile data from the API (source of truth) ──────────────────────
  Future<void> loadProfile() async {
    emit(EditProfileLoading());
    final result = await repository.getProfile();
    result.fold(
      (failure) => _handleFailure(failure),
      (profile) => emit(EditProfileLoaded(profile)),
    );
  }

  // ─── Submit all profile changes ─────────────────────────────────────────────
  Future<void> submitProfileChanges({
    required String name,
    required String gender,
    required String birthDate,
    required String address,
    required int districtId,
    required int cityId,
    required int governorateId,
    File? image,
  }) async {
    emit(EditProfileLoading());

    // ── Step 1: Upload photo if a new image was selected ──────────────────────
    String? newProfilePhotoUrl;
    if (image != null) {
      final uploadResult = await repository.uploadProfilePhoto(image);
      uploadResult.fold(
        (failure) {
          // Non-fatal: log and continue without a photo URL
          debugPrint('[EditProfileCubit] Photo upload failed: ${failure.message}');
        },
        (responseData) {
          // Raw response is already printed inside the data source.
          // Try all known shapes without assumptions:
          newProfilePhotoUrl = _extractPhotoUrl(responseData);
          debugPrint('[EditProfileCubit] Extracted photo URL: $newProfilePhotoUrl');
        },
      );
    }

    // ── Step 2: Build PUT payload ─────────────────────────────────────────────
    final Map<String, dynamic> payload = {
      "name": name,
      if (gender.isNotEmpty) "gender": gender,
      if (address.isNotEmpty) "address": address,
      if (birthDate.isNotEmpty && !birthDate.startsWith('2000-01-01T00:00:00')) "birthDate": birthDate,
      if (districtId > 0) "districtId": districtId,
      if (cityId > 0) "cityId": cityId,
      if (governorateId > 0) "governorateId": governorateId,
    };

    // Only include profilePhoto if we actually got a URL from the upload
    if (newProfilePhotoUrl != null && newProfilePhotoUrl!.isNotEmpty) {
      payload["profilePhoto"] = newProfilePhotoUrl;
    }

    // ── Step 3: PUT /api/v1/users/profile ────────────────────────────────────
    final updateResult = await repository.updateProfile(data: payload);

    await updateResult.fold(
      (failure) async => _handleFailure(failure),
      (_) async {
        // ── Step 4: Re-fetch fresh profile and sync SessionCubit ──────────────
        final freshResult = await repository.getProfile();
        freshResult.fold(
          (failure) {
            debugPrint('[EditProfileCubit] Re-fetch after update failed: ${failure.message}');
            // Update succeeded — still notify success, just log the re-fetch failure
            emit(EditProfileSuccess("Profile updated successfully"));
          },
          (freshProfile) {
            debugPrint('[EditProfileCubit] Re-fetched profilePhoto from server: ${freshProfile.profilePhoto}');
            _syncSessionCubit(freshProfile, photoUrl: newProfilePhotoUrl, localImage: image);
            emit(EditProfileSuccess("Profile updated successfully"));
          },
        );
      },
    );
  }

  // ─── Helpers ────────────────────────────────────────────────────────────────

  /// Defensively extracts a photo URL from any response shape the server might return.
  /// Returns null if no URL is found (meaning photo upload stored the file but returned nothing).
  String? _extractPhotoUrl(dynamic data) {
    if (data == null) return null;

    if (data is String && data.isNotEmpty) return data;

    if (data is Map<String, dynamic>) {
      // Shape: { "data": "https://..." }
      final inner = data['data'];
      if (inner is String && inner.isNotEmpty) return inner;

      // Shape: { "url": "https://..." }
      final url = data['url'];
      if (url is String && url.isNotEmpty) return url;

      // Shape: { "data": { "url": "..." } }
      if (inner is Map<String, dynamic>) {
        final nested = inner['url'] ?? inner['path'] ?? inner['profilePhoto'] ?? inner['photoUrl'];
        if (nested is String && nested.isNotEmpty) return nested;
      }

      // Shape: { "profilePhoto": "..." }
      final photo = data['profilePhoto'];
      if (photo is String && photo.isNotEmpty) return photo;
    }

    return null; // Endpoint uploaded but returned no URL
  }

  /// Syncs the in-memory SessionCubit with the latest server data.
  void _syncSessionCubit(ProfileModel fresh, {String? photoUrl, File? localImage}) {
    if (sessionCubit.state is! SessionAuthenticated) return;

    final currentUser = (sessionCubit.state as SessionAuthenticated).user;
    final updatedUser = currentUser.copyWith(
      name: fresh.name?.isNotEmpty == true ? fresh.name : currentUser.name,
      gender: fresh.gender?.isNotEmpty == true ? fresh.gender : currentUser.gender,
      dateOfBirth: fresh.birthDate?.isNotEmpty == true ? fresh.birthDate : currentUser.dateOfBirth,
      address: fresh.address?.isNotEmpty == true ? fresh.address : currentUser.address,
      // Use the newly uploaded photoUrl if available, otherwise use the fresh URL from the server,
      // and if neither is available, fallback to the current one.
      profileImagePath: (photoUrl != null && photoUrl.isNotEmpty)
          ? photoUrl
          : (fresh.profilePhoto?.isNotEmpty == true ? fresh.profilePhoto : currentUser.profileImagePath),
    );
    sessionCubit.updateProfile(updatedUser, profileImage: localImage);
  }

  /// Centralised failure routing — 401 & 403 log the user out.
  void _handleFailure(Failure failure) {
    if (failure is UnauthorizedFailure || failure is ForbiddenFailure) {
      sessionCubit.logout();
      emit(EditProfileError(failure.message, isUnauthorized: true));
    } else {
      emit(EditProfileError(failure.message));
    }
  }
}
