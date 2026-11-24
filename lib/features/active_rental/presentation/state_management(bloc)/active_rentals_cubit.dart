import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_flutter/features/active_rental/domain/repositories/active_rental_repository.dart';
import 'package:graduation_project_flutter/features/active_rental/presentation/state_management(bloc)/active_rentals_state.dart';

class ActiveRentalsCubit extends Cubit<ActiveRentalsState> {
  final ActiveRentalRepository repository;

  ActiveRentalsCubit({required this.repository}) : super(ActiveRentalsInitial());

  int _currentPage = 1;
  int _pageSize = 20;
  String? _currentStatus;

  Future<void> getRentals({
    int page = 1,
    int pageSize = 20,
    String? status,
  }) async {
    _currentPage = page;
    _pageSize = pageSize;
    _currentStatus = status;

    emit(ActiveRentalsLoading());

    final result = await repository.getRentals(
      page: _currentPage,
      pageSize: _pageSize,
      status: _currentStatus,
    );

    result.fold(
      (failure) => emit(ActiveRentalsError(failure.message)),
      (data) => emit(ActiveRentalsSuccess(data)),
    );
  }

  Future<void> addRentalPayment({
    required int id,
    required double amount,
    required String paidAt,
    required String notes,
  }) async {
    emit(ActiveRentalsAddPaymentLoading());

    final result = await repository.addRentalPayment(
      id: id,
      amount: amount,
      paidAt: paidAt,
      notes: notes,
    );

    result.fold(
      (failure) => emit(ActiveRentalsAddPaymentError(failure.message)),
      (success) async {
        emit(ActiveRentalsAddPaymentSuccess());
        // Automatically refresh rentals list
        await getRentals(
          page: _currentPage,
          pageSize: _pageSize,
          status: _currentStatus,
        );
      },
    );
  }

  Future<void> terminateRental({
    required int id,
    required String reason,
  }) async {
    emit(ActiveRentalsTerminateLoading());

    final result = await repository.terminateRental(
      id: id,
      reason: reason,
    );

    result.fold(
      (failure) => emit(ActiveRentalsTerminateError(failure.message)),
      (success) async {
        emit(ActiveRentalsTerminateSuccess());
        // Automatically refresh rentals list
        await getRentals(
          page: _currentPage,
          pageSize: _pageSize,
          status: _currentStatus,
        );
      },
    );
  }
}
