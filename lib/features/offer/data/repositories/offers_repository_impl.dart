import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class OffersRepositoryImpl implements OffersRepository {
  final OffersRemoteDataSource remoteDataSource;

  OffersRepositoryImpl({required this.remoteDataSource});

  
  Failure _handleException(dynamic error) {
    try {
      if (error is DioException) {
        final data = error.response?.data;

        debugPrint('==== DIO ERROR DATA ====');
        debugPrint(data.toString());
        debugPrint('TYPE: ${data.runtimeType}');
        debugPrint('========================');

        if (data is String) {
          return ServerFailure(data);
        }

        if (data is Map || data is Map<String, dynamic>) {
          final msg =
              data['message']?.toString() ??
              data['title']?.toString() ??
              'Unknown server error';

          return ServerFailure(msg);
        }

        return ServerFailure(error.message ?? 'Network error');
      }

      return ServerFailure(error.toString());
    } catch (e) {
      debugPrint('HANDLE EXCEPTION ERROR: $e');
      return ServerFailure('Unexpected error occurred');
    }
  }

    @override
  Future<Either<Failure, PaginatedOffersModel>> getOffers({
    required int page,
    required int pageSize,
  }) async {
    try {
      final response = await remoteDataSource.getOffers(
        page,
        pageSize,
      );

      debugPrint('RAW OFFERS RESPONSE:');
      debugPrint(response.toString());
      debugPrint('TYPE: ${response.runtimeType}');

      return Right(response);
    } catch (e, s) {
      debugPrint('PARSE ERROR: $e');
      debugPrintStack(stackTrace: s);

      return Left(_handleException(e));
    }
  }


  @override
  Future<Either<Failure, OfferEntity>> getOfferById(String id) async {
    try {
      final result = await remoteDataSource.getOfferById(id);
      return Right(result.toEntity());
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, OfferEntity>> createOffer(Map<String, dynamic> offerData) async {
    try {
      final result = await remoteDataSource.createOffer(offerData);
      return Right(result.toEntity());
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, OfferEntity>> updateOffer(String id, Map<String, dynamic> offerData) async {
    try {
      final result = await remoteDataSource.updateOffer(id, offerData);
      return Right(result.toEntity());
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteOffer(String id) async {
    try {
      await remoteDataSource.deleteOffer(id);
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }
}
