import 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/profile_tab/data/models/profile_model.dart';

abstract class EditProfileState {}

class EditProfileInitial extends EditProfileState {}

class EditProfileLoading extends EditProfileState {}

class EditProfileLoaded extends EditProfileState {
  final ProfileModel profile;

  EditProfileLoaded(this.profile);
}

class EditProfileSuccess extends EditProfileState {
  final String message;

  EditProfileSuccess(this.message);
}

class EditProfileError extends EditProfileState {
  final String message;
  final bool isUnauthorized;

  EditProfileError(this.message, {this.isUnauthorized = false});
}
