import 'package:graduation_project_flutter/core/routing/routes_export.dart';

abstract class OffersRepository {
  Future<Either<Failure, PaginatedOffersModel>> getOffers({
    required int page,
    required int pageSize,
  });

  Future<Either<Failure, OfferEntity>> getOfferById(String id);

  Future<Either<Failure, OfferEntity>> createOffer(Map<String, dynamic> offerData);

  Future<Either<Failure, OfferEntity>> updateOffer(String id, Map<String, dynamic> offerData);

  Future<Either<Failure, void>> deleteOffer(String id);
}
