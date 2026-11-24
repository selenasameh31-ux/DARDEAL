import 'package:graduation_project_flutter/core/routing/routes_export.dart';

// ─────────────────────────────────────────────────────────
// Abstract interface
// ─────────────────────────────────────────────────────────
abstract class OfferRemoteDataSource {
  Future<PropertySummaryEntity> getPropertySummary(String propertyId);

  Future<OfferModel> createOffer({
    required String propertyId,
    required double offerPrice,
    required bool isTermsAccepted,
    String? message,
    String? seekerNotes,
    String? proposedMoveInDate,
    String? proposedEndDate,
  });

  Future<OfferModel> submitOffer({
    required String offerId,
    required Map<String, dynamic> offerData,
  });

  Future<PaymentModel> confirmPayment({
    required String offerId,
    required double amount,
    required String paymentMethod,
  });

  Future<void> completeHandover({
    required String offerId,
    File? contractFile,
  });

  Future<List<OfferModel>> getSentOffers();
  Future<List<OfferModel>> getReceivedOffers();
  Future<List<OfferModel>> getMyOffers();

  Future<OfferModel> getOfferById({required String offerId});

  Future<OfferModel> reviewOffer({
    required String offerId,
    required String action,
    required double counterPrice,
    required String message,
  });

  Future<Map<String, dynamic>> initiatePayment({
    required int offerId,
    required String idempotencyKey,
  });

  Future<String> checkPaymentStatus({required int paymentId});
}

// ─────────────────────────────────────────────────────────
// Concrete implementation
// ─────────────────────────────────────────────────────────
class OfferRemoteDataSourceImpl implements OfferRemoteDataSource {
  final ApiConsumer api;
  final CacheHelper cacheHelper;

  OfferRemoteDataSourceImpl({required this.api, required this.cacheHelper});

  // 🔐 TOKEN
  String get _token {
    final token = cacheHelper.getToken() ?? '';
    print("🔐 TOKEN = $token");
    return token;
  }

  // ================= GET PROPERTY SUMMARY =================
  @override
  Future<PropertySummaryEntity> getPropertySummary(String propertyId) async {
    final endpoint = EndPoints.getPropertySummary.replaceAll(
      '{propertyId}',
      propertyId,
    );

    final response = await api.get(endpoint, token: _token);

    print("📦 PROPERTY SUMMARY RAW = ${response.data}");

    return OfferPropertyModel.fromJson(response.data).toEntity();
  }

  // ================= CREATE OFFER =================
  // Backend: POST /api/v1/Offers (CreateOfferDto)
  // This is the ONLY step needed — the backend creates and
  // submits the offer atomically. No separate submit endpoint exists.
  @override
  Future<OfferModel> createOffer({
    required String propertyId,
    required double offerPrice,
    required bool isTermsAccepted,
    String? message,
    String? seekerNotes,
    String? proposedMoveInDate,
    String? proposedEndDate,
  }) async {
    final parsedPropertyId = int.tryParse(propertyId);
    if (parsedPropertyId == null) {
      throw Exception(
        'Invalid propertyId: $propertyId. Must be a valid integer.',
      );
    }

    final dataMap = <String, dynamic>{
      'propertyId': parsedPropertyId,
      'offeredPrice': offerPrice,
      'currency': 'EGP',
    };

    if (message != null && message.isNotEmpty) dataMap['message'] = message;
    if (seekerNotes != null && seekerNotes.isNotEmpty)
      dataMap['seekerNotes'] = seekerNotes;
    if (proposedMoveInDate != null && proposedMoveInDate.isNotEmpty)
      dataMap['proposedMoveInDate'] = proposedMoveInDate;
    if (proposedEndDate != null && proposedEndDate.isNotEmpty)
      dataMap['proposedEndDate'] = proposedEndDate;

    final response = await api.post(
      EndPoints.createOffer,
      token: _token,
      data: dataMap,
    );

    print("📦 CREATE OFFER RAW = ${response.data}");

    return OfferModel.fromJson(response.data);
  }

  // ================= SUBMIT OFFER =================
  // NOTE: Swagger does NOT have a separate submit endpoint.
  // POST /api/v1/Offers already creates and submits atomically.
  // This method exists only to satisfy the OfferRepositoryImpl contract
  // and passes the data from the already-created offer through.
  @override
  Future<OfferModel> submitOffer({
    required String offerId,
    required Map<String, dynamic> offerData,
  }) async {
    // Return a pass-through model using data already available from createOffer.
    // No network call needed — the offer was already submitted in createOffer.
    print(
      "📦 SUBMIT OFFER (pass-through, offerId=$offerId) — offer already submitted via createOffer",
    );
    return OfferModel(
      id: offerId,
      propertyId: offerData['propertyId']?.toString() ?? '',
      offerPrice: (offerData['offerPrice'] as num?)?.toDouble() ?? 0.0,
      isTermsAccepted: offerData['isTermsAccepted'] == true,
      status: 'pending',
    );
  }

  // ================= CONFIRM PAYMENT =================
  @override
  Future<PaymentModel> confirmPayment({
    required String offerId,
    required double amount,
    required String paymentMethod,
  }) async {
    final endpoint = EndPoints.confirmPayment.replaceAll('{offerId}', offerId);

    final response = await api.post(
      endpoint,
      token: _token,
      data: {'amount': amount, 'paymentMethod': paymentMethod},
    );

    print("💳 PAYMENT RAW = ${response.data}");

    return PaymentModel.fromJson(response.data);
  }

  // ================= COMPLETE HANDOVER =================
  // Flow (per FLOW_1.MD):
  //   1. GET /api/v1/Contracts/my  → find contractId by propertyId
  //   2. POST /api/v1/Contracts/{contractId}/handover/pdf  (upload signed PDF)
  //   3. POST /api/v1/Contracts/{contractId}/handover/confirm  (no body)
  // NOTE: The old signContract step (PUT /api/v1/Contracts/{contractId}/sign)
  //       was removed from the backend — Digital Signatures replaced by physical PDF.
  @override
  Future<void> completeHandover({
    required String offerId,
    File? contractFile,
  }) async {
    // ── Step 1: Get Offer details to find propertyId ──
    final offer = await getOfferById(offerId: offerId);
    print("📄 OFFER propertyId = ${offer.propertyId}");

    // ── Step 2: Get contracts list and find the contractId ──
    final contractsResponse = await api.get(
      EndPoints.myContracts,
      token: _token,
    );
    print("📋 MY CONTRACTS RAW = ${contractsResponse.data}");

    // Parse robustly — backend may return data.items, data[], or []
    int? contractId;
    final rawData = contractsResponse.data;
    List<dynamic> contractsList = [];

    if (rawData is Map) {
      final inner = rawData['data'];
      if (inner is Map && inner['items'] is List) {
        contractsList = inner['items'] as List<dynamic>;
      } else if (inner is List) {
        contractsList = inner;
      }
    } else if (rawData is List) {
      contractsList = rawData;
    }

    print("📊 CONTRACTS COUNT = ${contractsList.length}");

    // Priority 1: find the contract for this property that is in a handover-ready state
    // (backend state machine: pending_handover or pending_pdf)
    // Priority 2: fall back to any contract matching propertyId (e.g. offerId match)
    final handoverStatuses = {'pending_handover', 'pending_pdf', 'awaiting_handover'};
    int? fallbackContractId;

    for (final contract in contractsList) {
      final cPropertyId = contract['propertyId']?.toString() ?? '';
      final cStatus = (contract['status'] as String? ?? '').toLowerCase();
      final cId = contract['contractId'] as int? ?? contract['id'] as int?;
      final cOfferId = contract['offerId']?.toString() ?? '';

      print("🔍 contract id=$cId | propertyId=$cPropertyId | offerId=$cOfferId | status=$cStatus");

      if (cPropertyId == offer.propertyId.toString()) {
        // Prefer a contract that is already in the handover pipeline
        if (handoverStatuses.contains(cStatus)) {
          contractId = cId;
          print("✅ Matched by handover status: contractId=$contractId (status=$cStatus)");
          break;
        }
        // Also try to match by offerId for precision
        if (cOfferId == offerId) {
          fallbackContractId = cId;
          print("🟡 Fallback match by offerId: contractId=$cId (status=$cStatus)");
        }
        // Last resort: first propertyId match
        fallbackContractId ??= cId;
      }
    }

    contractId ??= fallbackContractId;
    if (contractId != null) {
      print("✅ Using contractId=$contractId");
    }

    if (contractId == null) {
      throw Exception(
        'No contract found for offerId=$offerId (propertyId=${offer.propertyId}). '
        'Contracts returned: ${contractsList.length}. Cannot complete handover.',
      );
    }

    // ── Step 3: Upload signed PDF/Image (if provided) ──
    if (contractFile != null) {
      final uploadEndpoint = EndPoints.uploadHandoverPdf(contractId);

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(contractFile.path),
      });

      await api.post(
        uploadEndpoint,
        token: _token,
        data: formData,
      );
      print("📤 CONTRACT PDF UPLOADED SUCCESSFULLY for contractId=$contractId");
    }

    // ── Step 4: Confirm Handover (no request body required) ──
    final confirmEndpoint = EndPoints.confirmHandover(contractId);

    await api.post(
      confirmEndpoint,
      token: _token,
    );

    print("🏁 HANDOVER CONFIRMED SUCCESSFULLY for contractId=$contractId");
  }

  // ================= GET SENT OFFERS =================
  @override
  Future<List<OfferModel>> getSentOffers() async {
    final response = await api.get(
      EndPoints.sentOffers,
      token: _token,
      queryParameters: {'page': 1, 'pageSize': 20},
    );

    print("📦 SENT OFFERS RAW = ${response.data}");

    dynamic responseData = response.data;
    List data = [];
    if (responseData is Map) {
      if (responseData['data'] is Map && responseData['data']['items'] is List) {
        data = responseData['data']['items'];
      } else if (responseData['data'] is List) {
        data = responseData['data'];
      }
    } else if (responseData is List) {
      data = responseData;
    }

    return data.map((e) {
      print("➡️ SENT OFFER ITEM = $e");
      return OfferModel.fromJson(e);
    }).toList();
  }

  // ================= GET RECEIVED OFFERS =================
  @override
  Future<List<OfferModel>> getReceivedOffers() async {
    final response = await api.get(
      EndPoints.receivedOffers,
      token: _token,
      queryParameters: {'page': 1, 'pageSize': 20},
    );

    print("📦 RECEIVED OFFERS RAW = ${response.data}");

    dynamic responseData = response.data;
    List data = [];
    if (responseData is Map) {
      if (responseData['data'] is Map && responseData['data']['items'] is List) {
        data = responseData['data']['items'];
      } else if (responseData['data'] is List) {
        data = responseData['data'];
      }
    } else if (responseData is List) {
      data = responseData;
    }

    return data.map((e) => OfferModel.fromJson(e)).toList();
  }

  // ================= GET MY OFFERS =================
  @override
  Future<List<OfferModel>> getMyOffers() async {
    final response = await api.get(
      EndPoints.myOffers,
      token: _token,
      queryParameters: {'page': 1, 'pageSize': 20},
    );

    print("🔥 MY OFFERS RAW RESPONSE = ${response.data}");

    dynamic responseData = response.data;
    List data = [];
    if (responseData is Map) {
      if (responseData['data'] is Map && responseData['data']['items'] is List) {
        data = responseData['data']['items'];
      } else if (responseData['data'] is List) {
        data = responseData['data'];
      }
    } else if (responseData is List) {
      data = responseData;
    }

    print("📊 OFFERS COUNT = ${data.length}");

    return data.map((e) {
      print("➡️ OFFER ITEM = $e");
      return OfferModel.fromJson(e);
    }).toList();
  }

  // ================= GET OFFER BY ID =================
  @override
  Future<OfferModel> getOfferById({required String offerId}) async {
    final endpoint = EndPoints.offerById.replaceAll('{id}', offerId);

    final response = await api.get(endpoint, token: _token);

    print("📦 OFFER BY ID = ${response.data}");

    return OfferModel.fromJson(response.data);
  }

  // ================= REVIEW OFFER =================
  @override
  Future<OfferModel> reviewOffer({
    required String offerId,
    required String action,
    required double counterPrice,
    required String message,
  }) async {
    final endpoint = EndPoints.reviewOffer.replaceAll('{id}', offerId);

    final response = await api.put(
      endpoint,
      token: _token,
      data: {
        'action': action,
        'counterPrice': counterPrice,
        'message': message,
      },
    );

    print("📝 REVIEW OFFER RAW = ${response.data}");

    return OfferModel.fromJson(response.data);
  }

  // ================= INITIATE PAYMENT =================
  @override
  Future<Map<String, dynamic>> initiatePayment({
    required int offerId,
    required String idempotencyKey,
  }) async {
    final response = await api.post(
      EndPoints.initiatePayment,
      token: _token,
      data: {'offerId': offerId, 'idempotencyKey': idempotencyKey},
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  @override
  Future<String> checkPaymentStatus({required int paymentId}) async {
    final response = await api.get(
      EndPoints.paymentStatus(paymentId),
      token: _token,
    );
    return response.data['data']['status'] as String;
  }
}
