import 'package:graduation_project_flutter/core/routing/routes_export.dart';

abstract class OffersRemoteDataSource {
  Future<PaginatedOffersModel> getOffers(int page, int pageSize);
  Future<OfferModel> getOfferById(String id);
  Future<OfferModel> createOffer(Map<String, dynamic> offerData);
  Future<OfferModel> updateOffer(String id, Map<String, dynamic> offerData);
  Future<void> deleteOffer(String id);
}

class OffersRemoteDataSourceImpl implements OffersRemoteDataSource {
  final ApiConsumer api;

  OffersRemoteDataSourceImpl({required this.api});

  @override
  Future<PaginatedOffersModel> getOffers(int page, int pageSize) async {
    final response = await api.get(
      EndPoints.offers,
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
      },
    );

    // 🔍 طباعة الـ raw response بالكامل قبل أي parsing
    debugPrint("=== GET OFFERS RAW RESPONSE ===");
    debugPrint("📥 response.data = ${response.data}");
    debugPrint("📥 response.data.runtimeType = ${response.data.runtimeType}");
    debugPrint("================================");

    try {
      return PaginatedOffersModel.fromJson(response.data);
    } catch (parseError) {
      debugPrint("❌ PARSE ERROR in getOffers: $parseError");
      debugPrint("❌ Raw data was: ${response.data}");
      rethrow;
    }
  }

  @override
  Future<OfferModel> getOfferById(String id) async {
    final response = await api.get(EndPoints.offer(id));

    debugPrint("=== GET OFFER BY ID RAW ===");
    debugPrint("📥 response.data = ${response.data}");
    debugPrint("===========================");

    try {
      final data = (response.data is Map && response.data['data'] != null)
          ? response.data['data']
          : response.data;
      return OfferModel.fromJson(data);
    } catch (parseError) {
      debugPrint("❌ PARSE ERROR in getOfferById: $parseError");
      rethrow;
    }
  }

  @override
  Future<OfferModel> createOffer(Map<String, dynamic> offerData) async {
    final response = await api.post(
      EndPoints.offers,
      data: offerData,
    );

    debugPrint("📤 CREATE OFFER RAW = ${response.data}");

    try {
      final data = (response.data is Map && response.data['data'] != null)
          ? response.data['data']
          : response.data;
      return OfferModel.fromJson(data);
    } catch (parseError) {
      debugPrint("❌ PARSE ERROR in createOffer: $parseError");
      rethrow;
    }
  }

  @override
  Future<OfferModel> updateOffer(String id, Map<String, dynamic> offerData) async {
    final response = await api.put(
      EndPoints.offer(id),
      data: offerData,
    );

    debugPrint("🔄 UPDATE OFFER RAW = ${response.data}");

    try {
      final data = (response.data is Map && response.data['data'] != null)
          ? response.data['data']
          : response.data;
      return OfferModel.fromJson(data);
    } catch (parseError) {
      debugPrint("❌ PARSE ERROR in updateOffer: $parseError");
      rethrow;
    }
  }

  @override
  Future<void> deleteOffer(String id) async {
    final response = await api.delete(EndPoints.offer(id));
    debugPrint("🗑️ DELETE OFFER RAW = ${response.data}");
  }
}

