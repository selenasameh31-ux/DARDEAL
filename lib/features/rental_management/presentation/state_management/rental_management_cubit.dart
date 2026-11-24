import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_flutter/features/active_rental/data/models/paginated_rentals_model.dart';
import 'package:graduation_project_flutter/features/active_rental/domain/entities/rental_payment_entity.dart';
import 'package:graduation_project_flutter/features/active_rental/domain/repositories/active_rental_repository.dart';


part 'rental_management_state.dart';

class RentalManagementCubit extends Cubit<RentalManagementState> {
  final ActiveRentalRepository repository;

  RentalManagementCubit({required this.repository})
      : super(RentalManagementInitial());

  // ── Load paginated list ────────────────────────────────────────────────────
  Future<void> loadRentals({int page = 1, int pageSize = 20, String? status}) async {
    emit(RentalManagementLoading());
    final result = await repository.getRentals(
      page: page,
      pageSize: pageSize,
      status: status,
    );
    result.fold(
      (failure) => emit(RentalManagementError(failure.message)),
      (data) => emit(RentalManagementLoaded(data)),
    );
  }

  // ── Load payments for a specific rental ───────────────────────────────────
  Future<void> loadPayments(int rentalId) async {
    emit(RentalPaymentsLoading(rentalId));
    final result = await repository.getRentalPayments(rentalId);
    result.fold(
      (failure) => emit(RentalPaymentsError(rentalId, failure.message)),
      (payments) => emit(RentalPaymentsLoaded(rentalId, payments)),
    );
  }

  // ── Terminate a rental ────────────────────────────────────────────────────
  Future<void> terminateRental(int rentalId, String reason) async {
    emit(RentalTerminateLoading(rentalId));
    final result = await repository.terminateRental(id: rentalId, reason: reason);
    result.fold(
      (failure) => emit(RentalTerminateError(rentalId, failure.message)),
      (_) async {
        emit(RentalTerminateSuccess(rentalId));
        await loadRentals();
      },
    );
  }
}
