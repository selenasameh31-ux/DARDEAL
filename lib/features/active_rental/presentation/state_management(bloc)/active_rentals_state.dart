import 'package:graduation_project_flutter/features/active_rental/data/models/paginated_rentals_model.dart';

abstract class ActiveRentalsState {
  const ActiveRentalsState();
}

class ActiveRentalsInitial extends ActiveRentalsState {}

// Get Rentals States
class ActiveRentalsLoading extends ActiveRentalsState {}

class ActiveRentalsSuccess extends ActiveRentalsState {
  final PaginatedRentalsModel rentalsData;

  const ActiveRentalsSuccess(this.rentalsData);
}

class ActiveRentalsError extends ActiveRentalsState {
  final String message;

  const ActiveRentalsError(this.message);
}

// Add Payment States
class ActiveRentalsAddPaymentLoading extends ActiveRentalsState {}

class ActiveRentalsAddPaymentSuccess extends ActiveRentalsState {}

class ActiveRentalsAddPaymentError extends ActiveRentalsState {
  final String message;

  const ActiveRentalsAddPaymentError(this.message);
}

// Terminate Rental States
class ActiveRentalsTerminateLoading extends ActiveRentalsState {}

class ActiveRentalsTerminateSuccess extends ActiveRentalsState {}

class ActiveRentalsTerminateError extends ActiveRentalsState {
  final String message;

  const ActiveRentalsTerminateError(this.message);
}
