import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/profile_tab/data/models/profile_model.dart';
import 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/profile_tab/domain/repositories/profile_repository.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileModel profile;
  final Map<String, dynamic> stats;

  ProfileLoaded({required this.profile, required this.stats});
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository;

  ProfileCubit({required this.repository}) : super(ProfileInitial());

  Future<void> fetchProfileData() async {
    emit(ProfileLoading());
    try {
      final profile = await repository.getProfile();
      final stats = await repository.getProfileStats();
      emit(ProfileLoaded(profile: profile, stats: stats));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
