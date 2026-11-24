import 'package:graduation_project_flutter/core/routing/routes_export.dart';

abstract class ReviewsRepository {
  Future<List<ReviewModel>> getPropertyReviews(int propertyId);
  Future<ReviewSummaryModel> getPropertyReviewSummary(int propertyId);
  Future<ReviewModel> createReview({required int propertyId, required int rating, required String comment});
  Future<void> deleteReview(int reviewId);
  Future<void> reportReview(int reviewId, String reason);
}
