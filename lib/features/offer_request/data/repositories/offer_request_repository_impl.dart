import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:graduation_project_flutter/core/errors/failure.dart';
import 'package:graduation_project_flutter/core/errors/exceptions.dart';
import 'package:graduation_project_flutter/features/offer_request/data/datasources/offer_request_remote_data_source.dart';
import 'package:graduation_project_flutter/features/offer_request/domain/entities/offer_request_entity.dart';
import 'package:graduation_project_flutter/features/offer_request/data/models/paginated_offer_requests_model.dart';
import 'package:graduation_project_flutter/features/offer_request/domain/repositories/offer_request_repository.dart';

class OfferRequestRepositoryImpl implements OfferRequestRepository {
  final OfferRequestRemoteDataSource remoteDataSource;

  OfferRequestRepositoryImpl({required this.remoteDataSource});

  Failure _handleException(dynamic e) {
    if (e is ServerException) {
      return ServerFailure(e.message);
    } else if (e is UnauthorizedException) {
      return ServerFailure(e.message ?? "Unauthorized access");
    } else if (e is NotFoundException) {
      return ServerFailure(e.message ?? "Not found");
    } else if (e is DioException) {
      if (e.response != null) {
        final statusCode = e.response?.statusCode;
        if (statusCode == 500) {
          return ServerFailure("Server error occurred");
        } else if (statusCode == 401 || statusCode == 403) {
          return ServerFailure("Unauthorized access");
        } else if (statusCode == 404) {
          return ServerFailure("Not found");
        }
        return ServerFailure(e.response?.data?['message'] ?? e.message ?? "An unexpected error occurred");
      } else if (e.error is SocketException) {
        return NoInternetFailure();
      } else {
        return ServerFailure(e.message ?? "Network error occurred");
      }
    } else if (e is SocketException) {
      return NoInternetFailure();
    }
    return ServerFailure(e.toString());
  }

  @override
  Future<Either<Failure, PaginatedOfferRequestsModel>> getOfferRequests({
    required int page,
    required int pageSize,
  }) async {
    try {
      final result = await remoteDataSource.getOfferRequests(page, pageSize);
      return Right(result);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, OfferRequestEntity>> getOfferRequestById(String id) async {
    try {
      final result = await remoteDataSource.getOfferRequestById(id);
      return Right(result.toEntity());
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, OfferRequestEntity>> createOfferRequest(Map<String, dynamic> data) async {
    try {
      final result = await remoteDataSource.createOfferRequest(data);
      return Right(result.toEntity());
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, OfferRequestEntity>> updateOfferRequest(String id, Map<String, dynamic> data) async {
    try {
      final result = await remoteDataSource.updateOfferRequest(id, data);
      return Right(result.toEntity());
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteOfferRequest(String id) async {
    try {
      await remoteDataSource.deleteOfferRequest(id);
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }
}
