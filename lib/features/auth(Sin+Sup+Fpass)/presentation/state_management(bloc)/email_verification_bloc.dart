import 'package:graduation_project_flutter/core/routing/routes_export.dart';

// ================== EVENTS ==================
abstract class EmailVerificationEvent {}

class SendEmailOtpRequested extends EmailVerificationEvent {
  final String email;
  SendEmailOtpRequested({required this.email});
}

class VerifyEmailOtpRequested extends EmailVerificationEvent {
  final String email;
  final String otp;
  VerifyEmailOtpRequested({required this.email, required this.otp});
}

class ResendEmailOtpRequested extends EmailVerificationEvent {
  final String email;
  ResendEmailOtpRequested({required this.email});
}

// ================== STATES ==================
abstract class EmailVerificationState {}

class EmailVerificationInitial extends EmailVerificationState {}

class EmailVerificationLoading extends EmailVerificationState {}

class EmailVerificationSuccess extends EmailVerificationState {}

class EmailVerificationError extends EmailVerificationState {
  final String message;
  EmailVerificationError(this.message);
}

class EmailSendSuccess extends EmailVerificationState {
  final String message;
  EmailSendSuccess(this.message);
}

class EmailResendSuccess extends EmailVerificationState {
  final String message;
  EmailResendSuccess(this.message);
}

// ================== BLOC ==================
class EmailVerificationBloc extends Bloc<EmailVerificationEvent, EmailVerificationState> {
  final VerifyEmailOtpUseCase verifyEmailOtpUseCase;
  final ResendEmailOtpUseCase resendEmailOtpUseCase;
  final SendEmailOtpUseCase sendEmailOtpUseCase;

  EmailVerificationBloc({
    required this.verifyEmailOtpUseCase,
    required this.resendEmailOtpUseCase,
    required this.sendEmailOtpUseCase,
  }) : super(EmailVerificationInitial()) {
    on<SendEmailOtpRequested>(_onSendOtpRequested);
    on<VerifyEmailOtpRequested>(_onVerifyOtpRequested);
    on<ResendEmailOtpRequested>(_onResendOtpRequested);
  }

  Future<void> _onSendOtpRequested(
    SendEmailOtpRequested event,
    Emitter<EmailVerificationState> emit,
  ) async {
    emit(EmailVerificationLoading());
    try {
      await sendEmailOtpUseCase(email: event.email);
      emit(EmailSendSuccess("Verification code sent to ${event.email}"));
    } catch (e) {
      emit(EmailVerificationError(e.toString()));
    }
  }

  Future<void> _onVerifyOtpRequested(
    VerifyEmailOtpRequested event,
    Emitter<EmailVerificationState> emit,
  ) async {
    emit(EmailVerificationLoading());
    try {
      await verifyEmailOtpUseCase(email: event.email, otpCode: event.otp);
      emit(EmailVerificationSuccess());
    } catch (e) {
      emit(EmailVerificationError(e.toString()));
    }
  }

  Future<void> _onResendOtpRequested(
    ResendEmailOtpRequested event,
    Emitter<EmailVerificationState> emit,
  ) async {
    emit(EmailVerificationLoading());
    try {
      await resendEmailOtpUseCase(email: event.email);
      emit(EmailResendSuccess("Code sent successfully. Please check your email."));
    } catch (e) {
      emit(EmailVerificationError(e.toString()));
    }
  }
}
