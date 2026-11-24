import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class ReviewsRepositoryImpl implements ReviewsRepository {
  final ReviewsRemoteDataSource remoteDataSource;

  ReviewsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ReviewModel>> getPropertyReviews(int propertyId) {
    return remoteDataSource.getPropertyReviews(propertyId);
  }

  @override
  Future<ReviewSummaryModel> getPropertyReviewSummary(int propertyId) {
    return remoteDataSource.getPropertyReviewSummary(propertyId);
  }

  @override
  Future<ReviewModel> createReview({required int propertyId, required int rating, required String comment}) {
    return remoteDataSource.createReview(propertyId: propertyId, rating: rating, comment: comment);
  }

  @override
  Future<void> deleteReview(int reviewId) {
    return remoteDataSource.deleteReview(reviewId);
  }

  @override
  Future<void> reportReview(int reviewId, String reason) {
    return remoteDataSource.reportReview(reviewId, reason);
  }
}
