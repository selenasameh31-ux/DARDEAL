import 'package:dartz/dartz.dart';
import 'package:graduation_project_flutter/core/errors/exceptions.dart';
import 'package:graduation_project_flutter/core/errors/failure.dart';
import 'package:graduation_project_flutter/features/active_rental/data/datasources/active_rental_remote_data_source.dart';
import 'package:graduation_project_flutter/features/active_rental/data/models/paginated_rentals_model.dart';
import 'package:graduation_project_flutter/features/active_rental/domain/entities/rental_entity.dart';
import 'package:graduation_project_flutter/features/active_rental/domain/entities/rental_payment_entity.dart';
import 'package:graduation_project_flutter/features/active_rental/domain/repositories/active_rental_repository.dart';

class ActiveRentalRepositoryImpl implements ActiveRentalRepository {
  final ActiveRentalRemoteDataSource remoteDataSource;

  ActiveRentalRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PaginatedRentalsModel>> getRentals({
    required int page,
    required int pageSize,
    String? status,
  }) async {
    try {
      final response = await remoteDataSource.getRentals(page, pageSize, status);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RentalEntity>> getRentalById(int id) async {
    try {
      final response = await remoteDataSource.getRentalById(id);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RentalPaymentEntity>>> getRentalPayments(int id) async {
    try {
      final response = await remoteDataSource.getRentalPayments(id);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addRentalPayment({
    required int id,
    required double amount,
    required String paidAt,
    required String notes,
  }) async {
    try {
      await remoteDataSource.addRentalPayment(id, amount, paidAt, notes);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> terminateRental({
    required int id,
    required String reason,
  }) async {
    try {
      await remoteDataSource.terminateRental(id, reason);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getRentalsCount() async {
    try {
      final count = await remoteDataSource.getRentalsCount();
      return Right(count);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
