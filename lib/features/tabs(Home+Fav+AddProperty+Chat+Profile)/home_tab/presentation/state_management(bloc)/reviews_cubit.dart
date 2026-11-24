import 'package:graduation_project_flutter/core/routing/routes_export.dart';


abstract class ReviewsState {}

class ReviewsInitial extends ReviewsState {}
class ReviewsLoading extends ReviewsState {}
class ReviewsLoaded extends ReviewsState {
  final List<ReviewModel> reviews;
  final ReviewSummaryModel summary;

  ReviewsLoaded(this.reviews, this.summary);
}
class ReviewsError extends ReviewsState {
  final String message;

  ReviewsError(this.message);
}

class ReviewsCubit extends Cubit<ReviewsState> {
  final GetPropertyReviewsUseCase getPropertyReviewsUseCase;
  final GetPropertyReviewSummaryUseCase getPropertyReviewSummaryUseCase;
  final CreateReviewUseCase createReviewUseCase;

  ReviewsCubit({
    required this.getPropertyReviewsUseCase,
    required this.getPropertyReviewSummaryUseCase,
    required this.createReviewUseCase,
  }) : super(ReviewsInitial());

  Future<void> loadReviews(int propertyId) async {
    emit(ReviewsLoading());
    try {
      // Execute both futures concurrently
      final responses = await Future.wait([
        getPropertyReviewsUseCase(propertyId),
        getPropertyReviewSummaryUseCase(propertyId),
      ]);
      
      final reviews = responses[0] as List<ReviewModel>;
      final summary = responses[1] as ReviewSummaryModel;
      
      emit(ReviewsLoaded(reviews, summary));
    } catch (e) {
      emit(ReviewsError(e.toString()));
    }
  }

  Future<String?> addReview(int propertyId, int rating, String comment, {String? userName, String? userAvatar, int? currentUserId}) async {
    if (state is ReviewsLoaded) {
      final currentState = state as ReviewsLoaded;
      try {
        final optimisticReview = ReviewModel(
          id: DateTime.now().millisecondsSinceEpoch,
          propertyId: propertyId,
          rating: rating,
          comment: comment,
          userName: userName ?? 'Anonymous',
          userAvatar: userAvatar,
          userId: currentUserId,
          createdAt: DateTime.now().toUtc().toIso8601String(), // Ensure accurate UTC timestamp
        );

        // Optimistically update the list
        final updatedReviews = List<ReviewModel>.from(currentState.reviews)..insert(0, optimisticReview);
        
        // Optimistically update the summary
        final newTotal = currentState.summary.totalReviews + 1;
        final newAvg = ((currentState.summary.averageRating * currentState.summary.totalReviews) + rating) / newTotal;
        final newDist = Map<int, int>.from(currentState.summary.ratingDistribution);
        newDist[rating] = (newDist[rating] ?? 0) + 1;
        
        final updatedSummary = ReviewSummaryModel(
          averageRating: newAvg,
          totalReviews: newTotal,
          ratingDistribution: newDist,
        );

        emit(ReviewsLoaded(updatedReviews, updatedSummary));

        // Now actually save to backend
        await createReviewUseCase(propertyId, rating, comment);
        
        // Reload everything in background quietly to get true IDs and real DB state
        final responses = await Future.wait([
          getPropertyReviewsUseCase(propertyId),
          getPropertyReviewSummaryUseCase(propertyId),
        ]);
        
        emit(ReviewsLoaded(responses[0] as List<ReviewModel>, responses[1] as ReviewSummaryModel));
        return null; // Success
      } catch (e) {
        // If the backend call fails, revert the optimistic update
        emit(currentState);
        return e.toString(); // Return error
      }
    } else {
      // If not loaded yet, just create and then load
      try {
        await createReviewUseCase(propertyId, rating, comment);
        final responses = await Future.wait([
          getPropertyReviewsUseCase(propertyId),
          getPropertyReviewSummaryUseCase(propertyId),
        ]);
        emit(ReviewsLoaded(responses[0] as List<ReviewModel>, responses[1] as ReviewSummaryModel));
        return null; // Success
      } catch (e) {
        emit(ReviewsError(e.toString()));
        return e.toString();
      }
    }
  }
}
