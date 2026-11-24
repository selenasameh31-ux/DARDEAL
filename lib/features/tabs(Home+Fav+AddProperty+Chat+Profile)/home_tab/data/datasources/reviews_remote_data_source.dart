import 'package:graduation_project_flutter/core/routing/routes_export.dart';


// abstract class ReviewsRemoteDataSource {
//   Future<List<ReviewModel>> getPropertyReviews(int propertyId);
//   Future<ReviewSummaryModel> getPropertyReviewSummary(int propertyId);
//   Future<ReviewModel> createReview({required int propertyId, required int rating, required String comment});
//   Future<void> deleteReview(int reviewId);
//   Future<void> reportReview(int reviewId, String reason);
// }

// class ReviewsRemoteDataSourceImpl implements ReviewsRemoteDataSource {
//   final ApiConsumer apiConsumer;

//   ReviewsRemoteDataSourceImpl({required this.apiConsumer});

//   @override
//   Future<List<ReviewModel>> getPropertyReviews(int propertyId) async {
//     try {
//       final response = await apiConsumer.get('/api/v1/Reviews/property/$propertyId');
//       final data = response.data;
      
//       if (data is List) {
//         return data.map((json) => ReviewModel.fromJson(json)).toList();
//       } else if (data is Map) {
//         final items = data['data'] ?? data['items'] ?? data['reviews'];
//         if (items is List) {
//           return items.map((json) => ReviewModel.fromJson(json)).toList();
//         }
//       }
//       return [];
//     } catch (e) {
//       return [];
//     }
//   }

//   @override
//   Future<ReviewSummaryModel> getPropertyReviewSummary(int propertyId) async {
//     try {
//       final response = await apiConsumer.get('/api/v1/Reviews/property/$propertyId/summary');
//       final data = response.data;
      
//       if (data is Map) {
//         if (data['success'] == true && data['data'] != null) {
//           return ReviewSummaryModel.fromJson(Map<String, dynamic>.from(data['data']));
//         }
//         return ReviewSummaryModel.fromJson(Map<String, dynamic>.from(data));
//       }
//       // Fallback: empty summary
//       return ReviewSummaryModel(averageRating: 0.0, totalReviews: 0, ratingDistribution: {1: 0, 2: 0, 3: 0, 4: 0, 5: 0});
//     } catch (e) {
//       return ReviewSummaryModel(averageRating: 0.0, totalReviews: 0, ratingDistribution: {1: 0, 2: 0, 3: 0, 4: 0, 5: 0});
//     }
//   }

//   @override
//   Future<ReviewModel> createReview({required int propertyId, required int rating, required String comment}) async {
//     try {
//       final response = await apiConsumer.post(
//         '/api/v1/Reviews',
//         data: {'propertyId': propertyId, 'rating': rating, 'comment': comment},
//       );
//       final data = response.data;
//       if (data is Map) {
//         if (data['data'] != null) {
//           return ReviewModel.fromJson(Map<String, dynamic>.from(data['data']));
//         }
//         return ReviewModel.fromJson(Map<String, dynamic>.from(data));
//       }
//       // If the request succeeded but didn't return a JSON object, return a local dummy
//       return ReviewModel(
//         id: DateTime.now().millisecondsSinceEpoch,
//         propertyId: propertyId,
//         rating: rating,
//         comment: comment,
//         userName: 'You', // This handles the "You" requirement for optimistic updates
//         createdAt: 'Just now',
//       );
//     } catch (e) {
//       throw Exception('Error creating review: $e');
//     }
//   }

//   @override
//   Future<void> deleteReview(int reviewId) async {
//     try {
//       await apiConsumer.delete('/api/v1/Reviews/$reviewId');
//     } catch (e) {
//       throw Exception('Error deleting review: $e');
//     }
//   }

//   @override
//   Future<void> reportReview(int reviewId, String reason) async {
//     try {
//       await apiConsumer.post(
//         '/api/v1/Reviews/$reviewId/report',
//         data: {'reason': reason},
//       );
//     } catch (e) {
//       throw Exception('Error reporting review: $e');
//     }
//   }
// }





abstract class ReviewsRemoteDataSource {
  Future<List<ReviewModel>> getPropertyReviews(int propertyId);
  Future<ReviewSummaryModel> getPropertyReviewSummary(int propertyId);
  Future<ReviewModel> createReview({required int propertyId, required int rating, required String comment});
  Future<void> deleteReview(int reviewId);
  Future<void> reportReview(int reviewId, String reason);
}

class ReviewsRemoteDataSourceImpl implements ReviewsRemoteDataSource {
  final ApiConsumer apiConsumer;

  ReviewsRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<List<ReviewModel>> getPropertyReviews(int propertyId) async {
    try {
      final response = await apiConsumer.get('/api/v1/Reviews/property/$propertyId');
      final data = response.data;
      
      if (data is List) {
        return data.map((json) => ReviewModel.fromJson(json)).toList();
      } else if (data is Map) {
        dynamic items = data['data'];
        if (items is Map && items.containsKey('items')) {
          items = items['items'];
        } else if (items == null) {
          items = data['items'] ?? data['reviews'];
        }
        if (items is List) {
          return items.map((json) => ReviewModel.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<ReviewSummaryModel> getPropertyReviewSummary(int propertyId) async {
    try {
      final response = await apiConsumer.get('/api/v1/Reviews/property/$propertyId/summary');
      final data = response.data;
      
      if (data is Map) {
        if (data['success'] == true && data['data'] != null) {
          return ReviewSummaryModel.fromJson(Map<String, dynamic>.from(data['data']));
        }
        return ReviewSummaryModel.fromJson(Map<String, dynamic>.from(data));
      }
      // Fallback: empty summary
      return ReviewSummaryModel(averageRating: 0.0, totalReviews: 0, ratingDistribution: {1: 0, 2: 0, 3: 0, 4: 0, 5: 0});
    } catch (e) {
      return ReviewSummaryModel(averageRating: 0.0, totalReviews: 0, ratingDistribution: {1: 0, 2: 0, 3: 0, 4: 0, 5: 0});
    }
  }

  @override
  Future<ReviewModel> createReview({required int propertyId, required int rating, required String comment}) async {
    try {
      final response = await apiConsumer.post(
        '/api/v1/Reviews',
        data: {'propertyId': propertyId, 'rating': rating, 'comment': comment},
      );
      final data = response.data;
      if (data is Map) {
        if (data['data'] != null) {
          return ReviewModel.fromJson(Map<String, dynamic>.from(data['data']));
        }
        return ReviewModel.fromJson(Map<String, dynamic>.from(data));
      }
      // If the request succeeded but didn't return a JSON object, return a local dummy
      return ReviewModel(
        id: DateTime.now().millisecondsSinceEpoch,
        propertyId: propertyId,
        rating: rating,
        comment: comment,
        userName: 'You', // This handles the "You" requirement for optimistic updates
        createdAt: 'Just now',
      );
    } catch (e) {
      if (e.toString().contains('400')) {
        throw Exception('You have already submitted a review for this property or the data is invalid.');
      }
      throw Exception('Error creating review: $e');
    }
  }

  @override
  Future<void> deleteReview(int reviewId) async {
    try {
      await apiConsumer.delete('/api/v1/Reviews/$reviewId');
    } catch (e) {
      throw Exception('Error deleting review: $e');
    }
  }

  @override
  Future<void> reportReview(int reviewId, String reason) async {
    try {
      await apiConsumer.post(
        '/api/v1/Reviews/$reviewId/report',
        data: {'reason': reason},
      );
    } catch (e) {
      throw Exception('Error reporting review: $e');
    }
  }
}
