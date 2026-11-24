import 'package:dartz/dartz.dart';
import 'package:graduation_project_flutter/core/errors/failure.dart';
import 'package:graduation_project_flutter/features/active_rental/data/models/paginated_rentals_model.dart';
import 'package:graduation_project_flutter/features/active_rental/domain/entities/rental_entity.dart';
import 'package:graduation_project_flutter/features/active_rental/domain/entities/rental_payment_entity.dart';

abstract class ActiveRentalRepository {
  Future<Either<Failure, PaginatedRentalsModel>> getRentals({
    required int page,
    required int pageSize,
    String? status,
  });

  Future<Either<Failure, RentalEntity>> getRentalById(int id);

  Future<Either<Failure, List<RentalPaymentEntity>>> getRentalPayments(int id);

  Future<Either<Failure, void>> addRentalPayment({
    required int id,
    required double amount,
    required String paidAt,
    required String notes,
  });

  Future<Either<Failure, void>> terminateRental({
    required int id,
    required String reason,
  });

  Future<Either<Failure, int>> getRentalsCount();
}
