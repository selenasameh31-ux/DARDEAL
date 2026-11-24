import 'package:flutter/foundation.dart';
import 'package:graduation_project_flutter/core/database/api/api_consumer.dart';
import 'package:graduation_project_flutter/core/database/api/end_points.dart';
import 'package:graduation_project_flutter/features/offer_request/data/models/offer_request_model.dart';
import 'package:graduation_project_flutter/features/offer_request/data/models/paginated_offer_requests_model.dart';

abstract class OfferRequestRemoteDataSource {
  Future<PaginatedOfferRequestsModel> getOfferRequests(int page, int pageSize);
  Future<OfferRequestModel> getOfferRequestById(String id);
  Future<OfferRequestModel> createOfferRequest(Map<String, dynamic> data);
  Future<OfferRequestModel> updateOfferRequest(String id, Map<String, dynamic> data);
  Future<void> deleteOfferRequest(String id);
}

class OfferRequestRemoteDataSourceImpl implements OfferRequestRemoteDataSource {
  final ApiConsumer api;

  OfferRequestRemoteDataSourceImpl({required this.api});

  @override
  Future<PaginatedOfferRequestsModel> getOfferRequests(int page, int pageSize) async {
    final response = await api.get(
      EndPoints.offerRequests,
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
      },
    );

    debugPrint("📥 GET OFFER REQUESTS RAW = ${response.data}");
    
    return PaginatedOfferRequestsModel.fromJson(response.data);
  }

  @override
  Future<OfferRequestModel> getOfferRequestById(String id) async {
    final response = await api.get(EndPoints.offerRequest(id));
    
    debugPrint("📥 GET OFFER REQUEST BY ID RAW = ${response.data}");
    
    final data = response.data['data'] ?? response.data;
    return OfferRequestModel.fromJson(data);
  }

  @override
  Future<OfferRequestModel> createOfferRequest(Map<String, dynamic> data) async {
    final response = await api.post(
      EndPoints.offerRequests,
      data: data,
    );

    debugPrint("📤 CREATE OFFER REQUEST RAW = ${response.data}");
    
    final responseData = response.data['data'] ?? response.data;
    return OfferRequestModel.fromJson(responseData);
  }

  @override
  Future<OfferRequestModel> updateOfferRequest(String id, Map<String, dynamic> data) async {
    final response = await api.put(
      EndPoints.offerRequest(id),
      data: data,
    );

    debugPrint("🔄 UPDATE OFFER REQUEST RAW = ${response.data}");
    
    final responseData = response.data['data'] ?? response.data;
    return OfferRequestModel.fromJson(responseData);
  }

  @override
  Future<void> deleteOfferRequest(String id) async {
    final response = await api.delete(EndPoints.offerRequest(id));
    debugPrint("🗑️ DELETE OFFER REQUEST RAW = ${response.data}");
  }
}
