import 'package:dartz/dartz.dart';
import 'package:graduation_project_flutter/core/errors/failure.dart';
import 'package:graduation_project_flutter/features/offer_request/domain/entities/offer_request_entity.dart';
import 'package:graduation_project_flutter/features/offer_request/data/models/paginated_offer_requests_model.dart';

abstract class OfferRequestRepository {
  Future<Either<Failure, PaginatedOfferRequestsModel>> getOfferRequests({
    required int page,
    required int pageSize,
  });

  Future<Either<Failure, OfferRequestEntity>> getOfferRequestById(String id);

  Future<Either<Failure, OfferRequestEntity>> createOfferRequest(Map<String, dynamic> data);

  Future<Either<Failure, OfferRequestEntity>> updateOfferRequest(String id, Map<String, dynamic> data);

  Future<Either<Failure, void>> deleteOfferRequest(String id);
}
