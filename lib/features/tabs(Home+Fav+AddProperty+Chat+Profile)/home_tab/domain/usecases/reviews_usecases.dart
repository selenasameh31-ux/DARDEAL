import 'package:graduation_project_flutter/core/routing/routes_export.dart';


class GetPropertyReviewsUseCase {
  final ReviewsRepository repository;

  GetPropertyReviewsUseCase(this.repository);

  Future<List<ReviewModel>> call(int propertyId) {
    return repository.getPropertyReviews(propertyId);
  }
}

class GetPropertyReviewSummaryUseCase {
  final ReviewsRepository repository;

  GetPropertyReviewSummaryUseCase(this.repository);

  Future<ReviewSummaryModel> call(int propertyId) {
    return repository.getPropertyReviewSummary(propertyId);
  }
}

class CreateReviewUseCase {
  final ReviewsRepository repository;

  CreateReviewUseCase(this.repository);

  Future<ReviewModel> call(int propertyId, int rating, String comment) {
    return repository.createReview(propertyId: propertyId, rating: rating, comment: comment);
  }
}
