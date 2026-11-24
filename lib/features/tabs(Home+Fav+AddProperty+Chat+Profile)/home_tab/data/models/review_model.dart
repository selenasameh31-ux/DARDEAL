import 'package:graduation_project_flutter/core/routing/routes_export.dart';


class ReviewModel {
  final int id;
  final int? propertyId;
  final int? userId;
  final String? userName;
  final String? userAvatar;
  final int? rating;
  final String? comment;
  final String? createdAt;
  final String? ownerResponse;
  final String? ownerResponseDate;

  ReviewModel({
    required this.id,
    this.propertyId,
    this.userId,
    this.userName,
    this.userAvatar,
    this.rating,
    this.comment,
    this.createdAt,
    this.ownerResponse,
    this.ownerResponseDate,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] ?? 0,
      propertyId: json['propertyId'],
      userId: json['userId'] ?? json['authorId'] ?? json['user']?['id'] ?? json['author']?['id'] ?? json['reviewer']?['id'],
      userName: json['userName'] ?? json['authorName'] ?? json['user']?['name'] ?? json['user']?['fullName'] ?? json['author']?['name'] ?? json['reviewer']?['name'] ?? 'Anonymous',
      userAvatar: _getFullImageUrl(json['userAvatar'] ?? json['authorAvatar'] ?? json['user']?['avatar'] ?? json['user']?['profilePicture'] ?? json['user']?['photo'] ?? json['author']?['avatar'] ?? json['reviewer']?['profilePhoto']),
      rating: json['rating'] ?? 5,
      comment: json['comment'] ?? json['text'] ?? json['review'] ?? "",
      createdAt: json['createdAt'] ?? json['date'],
      ownerResponse: json['ownerResponse'] ?? json['response'],
      ownerResponseDate: json['ownerResponseDate'] ?? json['responseDate'],
    );
  }

  static String? _getFullImageUrl(dynamic path) {
    if (path == null || path.toString().isEmpty) return null;
    String url = path.toString();
    if (url.startsWith('http')) return url;
    if (!url.startsWith('/')) url = '/$url';
    return '${EndPoints.baseUrl}$url';
  }

  Map<String, dynamic> toJson() => {
    'propertyId': propertyId,
    'rating': rating,
    'comment': comment,
  };
}

class ReviewSummaryModel {
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingDistribution; // {5: 20, 4: 10, ...}

  ReviewSummaryModel({
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
  });

  factory ReviewSummaryModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    Map<int, int> distribution = {};
    
    // Handle various response formats
    if (data['ratingDistribution'] != null) {
      final dist = data['ratingDistribution'];
      if (dist is Map) {
        dist.forEach((key, value) {
          distribution[int.tryParse(key.toString()) ?? 0] = (value as num?)?.toInt() ?? 0;
        });
      }
    } else if (data['breakdown'] != null) {
      final breakdown = data['breakdown'];
      if (breakdown is List) {
        for (var item in breakdown) {
          distribution[item['stars'] ?? item['rating'] ?? 0] = item['count'] ?? 0;
        }
      }
    }

    // Ensure all star levels exist
    for (int i = 1; i <= 5; i++) {
      distribution.putIfAbsent(i, () => 0);
    }

    return ReviewSummaryModel(
      averageRating: (data['averageRating'] ?? data['average'] ?? 0.0) is num 
          ? (data['averageRating'] ?? data['average'] ?? 0.0).toDouble() 
          : 0.0,
      totalReviews: (data['totalReviews'] ?? data['total'] ?? data['count'] ?? 0) is num
          ? (data['totalReviews'] ?? data['total'] ?? data['count'] ?? 0).toInt()
          : 0,
      ratingDistribution: distribution,
    );
  }
}
