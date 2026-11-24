// import 'package:graduation_project_flutter/core/routing/routes_export.dart';

// //  EVENTS
// abstract class ForgotPasswordEvent {}

// class ForgotPasswordRequested extends ForgotPasswordEvent {
//   final String emailOrPhone;

//   ForgotPasswordRequested(this.emailOrPhone);
// }

// class VerifyOtpRequested extends ForgotPasswordEvent {
//   final String emailOrPhone;
//   final String otp;

//   VerifyOtpRequested({
//     required this.emailOrPhone,
//     required this.otp,
//   });
// }

// class ResetPasswordRequested extends ForgotPasswordEvent {
//   final String resetToken;
//   final String newPassword;
//   final String confirmPassword;

//   ResetPasswordRequested({
//     required this.resetToken,
//     required this.newPassword,
//     required this.confirmPassword,
//   });
// }
// //  STATES

// abstract class ForgotPasswordState {}

// class ForgotPasswordInitial extends ForgotPasswordState {}

// class ForgotPasswordLoading extends ForgotPasswordState {}

// class OtpSent extends ForgotPasswordState {
//   final String emailOrPhone;
//   OtpSent(this.emailOrPhone);
// }

// class ResetPasswordSuccess extends ForgotPasswordState {}

// class ForgotPasswordError extends ForgotPasswordState {
//   final String message;

//   ForgotPasswordError(this.message);
// }

// class OtpVerified extends ForgotPasswordState {
//   final String resetToken;
//   OtpVerified(this.resetToken);
// }

// //  BLOC

// class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
//   final ForgotPasswordUseCase forgotPasswordUseCase;
//   final VerifyOtpUseCase verifyOtpUseCase;
//   final ResetPasswordUseCase resetPasswordUseCase;

//   ForgotPasswordBloc({
//     required this.forgotPasswordUseCase,
//     required this.verifyOtpUseCase,
//     required this.resetPasswordUseCase,
//   }) : super(ForgotPasswordInitial()) {
//     on<ForgotPasswordRequested>(_onForgotRequested);
//     on<VerifyOtpRequested>(_onVerifyRequested);
//     on<ResetPasswordRequested>(_onResetRequested);
//   }

//   Future<void> _onForgotRequested(
//     ForgotPasswordRequested event,
//     Emitter<ForgotPasswordState> emit,
//   ) async {
//     emit(ForgotPasswordLoading());

//     try {
//       await forgotPasswordUseCase(event.emailOrPhone);
//       emit(OtpSent(event.emailOrPhone));
//     } catch (e) {
//       emit(ForgotPasswordError(e.toString()));
//     }
//   }

//   Future<void> _onVerifyRequested(
//   VerifyOtpRequested event,
//   Emitter<ForgotPasswordState> emit,
// ) async {
//   emit(ForgotPasswordLoading());

//   try {
//     final resetToken = await verifyOtpUseCase(
//       emailOrPhone: event.emailOrPhone,
//       otp: event.otp,
//     );

//     emit(OtpVerified(resetToken));
//   } catch (e) {
//     emit(ForgotPasswordError(e.toString()));
//   }
// }

//   Future<void> _onResetRequested(
//   ResetPasswordRequested event,
//   Emitter<ForgotPasswordState> emit,
// ) async {
//   emit(ForgotPasswordLoading());

//   try {
//     await resetPasswordUseCase(
//       resetToken: event.resetToken,
//       newPassword: event.newPassword,
//       confirmPassword: event.confirmPassword,
//     );

//     emit(ResetPasswordSuccess());
//   } catch (e) {
//     emit(ForgotPasswordError(e.toString()));
//   }
// }
//   }

import 'package:graduation_project_flutter/core/routing/routes_export.dart';

// EVENTS
abstract class ForgotPasswordEvent {}

class ForgotPasswordRequested extends ForgotPasswordEvent {
  final String emailOrPhone;

  ForgotPasswordRequested(this.emailOrPhone);
}

class VerifyOtpRequested extends ForgotPasswordEvent {
  final String emailOrPhone;
  final String otp;

  VerifyOtpRequested({required this.emailOrPhone, required this.otp});
}

class ResetPasswordRequested extends ForgotPasswordEvent {
  final String resetToken;
  final String newPassword;
  final String confirmPassword;

  ResetPasswordRequested({
    required this.resetToken,
    required this.newPassword,
    required this.confirmPassword,
  });
}

// STATES
abstract class ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class OtpSent extends ForgotPasswordState {
  final String emailOrPhone;
  OtpSent(this.emailOrPhone);
}

class OtpVerified extends ForgotPasswordState {
  final String resetToken;
  OtpVerified(this.resetToken);
}

class ResetPasswordSuccess extends ForgotPasswordState {}

class ForgotPasswordError extends ForgotPasswordState {
  final String message;

  ForgotPasswordError(this.message);
}

// BLOC
class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  ForgotPasswordBloc({
    required this.forgotPasswordUseCase,
    required this.verifyOtpUseCase,
    required this.resetPasswordUseCase,
  }) : super(ForgotPasswordInitial()) {
    on<ForgotPasswordRequested>(_onForgotRequested);
    on<VerifyOtpRequested>(_onVerifyRequested);
    on<ResetPasswordRequested>(_onResetRequested);
  }

  Future<void> _onForgotRequested(
    ForgotPasswordRequested event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(ForgotPasswordLoading());

    try {
      await forgotPasswordUseCase(event.emailOrPhone);
      emit(OtpSent(event.emailOrPhone));
    } catch (e) {
      emit(ForgotPasswordError(e.toString()));
    }
  }

  Future<void> _onVerifyRequested(
    VerifyOtpRequested event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(ForgotPasswordLoading());
    try {
      final resetToken = await verifyOtpUseCase(
        emailOrPhone: event.emailOrPhone,
        otp: event.otp,
      );
      emit(OtpVerified(resetToken));
    } catch (e) {
      emit(ForgotPasswordError(e.toString()));
    }
  }

  Future<void> _onResetRequested(
    ResetPasswordRequested event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(ForgotPasswordLoading());

    try {
      await resetPasswordUseCase(
        resetToken: event.resetToken,
        newPassword: event.newPassword,
        confirmPassword: event.confirmPassword,
      );

      emit(ResetPasswordSuccess());
    } catch (e) {
      emit(ForgotPasswordError(e.toString()));
    }
  }
}
