import 'package:graduation_project_flutter/features/offer_request/data/models/offer_request_model.dart';

class PaginatedOfferRequestsModel {
  final List<OfferRequestModel> offerRequests;
  final int currentPage;
  final int totalPages;
  final int totalCount;

  const PaginatedOfferRequestsModel({
    required this.offerRequests,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
  });

  factory PaginatedOfferRequestsModel.fromJson(Map<String, dynamic> json) {
    List<OfferRequestModel> parsedOfferRequests = [];
    
    // Safely extract data array
    final data = json['data'];
    if (data != null && data is List) {
      parsedOfferRequests = data.map((e) => OfferRequestModel.fromJson(e)).toList();
    } else if (json['items'] != null && json['items'] is List) {
      parsedOfferRequests = (json['items'] as List).map((e) => OfferRequestModel.fromJson(e)).toList();
    } else if (data != null && data['items'] != null && data['items'] is List) {
      parsedOfferRequests = (data['items'] as List).map((e) => OfferRequestModel.fromJson(e)).toList();
    }

    return PaginatedOfferRequestsModel(
      offerRequests: parsedOfferRequests,
      currentPage: json['currentPage'] as int? ?? json['page'] as int? ?? 1,
      totalPages: json['totalPages'] as int? ?? 1,
      totalCount: json['totalCount'] as int? ?? 0,
    );
  }
}
