import 'package:graduation_project_flutter/core/routing/routes_export.dart';

// abstract class SessionState {}

// class SessionInitial extends SessionState {}

// class SessionAuthenticated extends SessionState {
//   final UserEntity user;
//   final File? profileImage;

//   SessionAuthenticated(this.user, {this.profileImage});
// }

// class SessionGuest extends SessionState {}




abstract class SessionState {}

class SessionInitial extends SessionState {}

/// Authenticated state carries:
/// - [user]       : the full user entity (name, gender, address, bio, etc.)
/// - [profileImage] : a local File (used when the photo was just picked in this
///                    install and a server URL is not yet available)
/// - [imageUrl]   : an HTTPS URL returned by the server after photo upload or
///                  GET /api/v1/users/profile.  This survives reinstalls.
class SessionAuthenticated extends SessionState {
  final UserEntity user;
  final File? profileImage;   // local file – valid only in the current install
  final String? imageUrl;     // server URL – survives reinstall / device change

  SessionAuthenticated(
    this.user, {
    this.profileImage,
    this.imageUrl,
  });
}

class SessionGuest extends SessionState {}
