// register_bloc.dart
import 'package:graduation_project_flutter/core/routing/routes_export.dart';

// ==================== EVENTS ====================
abstract class RegisterEvent {}

class RegisterRequested extends RegisterEvent {
  final String name;
  final String email;
  final String phone;
  final String password;
  final int gender;

  RegisterRequested({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.gender,
  });
}

// ==================== STATES ====================
abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final AuthEntity auth;

  RegisterSuccess(this.auth);
}

class RegisterFailure extends RegisterState {
  final String error;

  RegisterFailure(this.error);
}

// ==================== BLOC ====================
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase registerUseCase;

  RegisterBloc(this.registerUseCase) : super(RegisterInitial()) {
    on<RegisterRequested>(_onRegisterRequested);
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());

    try {
      final result = await registerUseCase(
        name: event.name,
        email: event.email,
        phone: event.phone,
        password: event.password,
        gender: event.gender,
      );

      emit(RegisterSuccess(result));
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }
}
