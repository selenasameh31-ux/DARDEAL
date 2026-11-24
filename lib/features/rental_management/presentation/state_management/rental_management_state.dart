part of 'rental_management_cubit.dart';

abstract class RentalManagementState {}

class RentalManagementInitial extends RentalManagementState {}

// ── Rentals list states ───────────────────────────────────────────────────────
class RentalManagementLoading extends RentalManagementState {}

class RentalManagementLoaded extends RentalManagementState {
  final PaginatedRentalsModel data;
  RentalManagementLoaded(this.data);
}

class RentalManagementError extends RentalManagementState {
  final String message;
  RentalManagementError(this.message);
}

// ── Payment history states ────────────────────────────────────────────────────
class RentalPaymentsLoading extends RentalManagementState {
  final int rentalId;
  RentalPaymentsLoading(this.rentalId);
}

class RentalPaymentsLoaded extends RentalManagementState {
  final int rentalId;
  final List<RentalPaymentEntity> payments;
  RentalPaymentsLoaded(this.rentalId, this.payments);
}

class RentalPaymentsError extends RentalManagementState {
  final int rentalId;
  final String message;
  RentalPaymentsError(this.rentalId, this.message);
}

// ── Terminate states ──────────────────────────────────────────────────────────
class RentalTerminateLoading extends RentalManagementState {
  final int rentalId;
  RentalTerminateLoading(this.rentalId);
}

class RentalTerminateSuccess extends RentalManagementState {
  final int rentalId;
  RentalTerminateSuccess(this.rentalId);
}

class RentalTerminateError extends RentalManagementState {
  final int rentalId;
  final String message;
  RentalTerminateError(this.rentalId, this.message);
}
