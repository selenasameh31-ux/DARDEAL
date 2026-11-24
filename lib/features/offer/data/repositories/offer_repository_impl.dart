import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class OfferRepositoryImpl implements OfferRepository {
  final OfferRemoteDataSource remote;

  OfferRepositoryImpl(this.remote);

  // ================= GET PROPERTY SUMMARY =================

  @override
  Future<PropertySummaryEntity> getPropertySummary(String propertyId) async {
    return await remote.getPropertySummary(propertyId);
  }

  // ================= CREATE OFFER =================

  @override
  Future<OfferEntity> createOffer({
    required String propertyId,
    required double offerPrice,
    required bool isTermsAccepted,
    String? message,
    String? seekerNotes,
    String? proposedMoveInDate,
    String? proposedEndDate,
  }) async {
    final offerModel = await remote.createOffer(
      propertyId: propertyId,
      offerPrice: offerPrice,
      isTermsAccepted: isTermsAccepted,
      message: message,
      seekerNotes: seekerNotes,
      proposedMoveInDate: proposedMoveInDate,
      proposedEndDate: proposedEndDate,
    );
    return offerModel.toEntity();
  }

  // ================= SUBMIT OFFER =================

  @override
  Future<OfferEntity> submitOffer(OfferEntity offer) async {
    if (offer.id == null) {
      throw Exception(
        'Cannot submit offer: offer.id is null. '
        'The offer must be created (and have a valid id) before submitting.',
      );
    }

    final offerModel = await remote.submitOffer(
      offerId: offer.id!,
      offerData: {
        'propertyId': offer.propertyId,
        'offerPrice': offer.offerPrice,
        'isTermsAccepted': offer.isTermsAccepted,
      },
    );
    return offerModel.toEntity();
  }

  // ================= CONFIRM PAYMENT =================

  @override
  Future<PaymentEntity> confirmPayment({
    required String offerId,
    required double amount,
    required String paymentMethod,
  }) async {
    final paymentModel = await remote.confirmPayment(
      offerId: offerId,
      amount: amount,
      paymentMethod: paymentMethod,
    );
    return paymentModel.toEntity();
  }

  // ================= COMPLETE HANDOVER =================

  @override
  Future<void> completeHandover({
    required String offerId,
    File? contractFile,
  }) async {
    await remote.completeHandover(
      offerId: offerId,
      contractFile: contractFile,
    );
  }
  @override
  Future<List<OfferEntity>> getSentOffers() async {
    final offers = await remote.getSentOffers();
    return offers.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<OfferEntity>> getReceivedOffers() async {
    final offers = await remote.getReceivedOffers();
    return offers.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<OfferEntity>> getMyOffers() async {
    final offers = await remote.getMyOffers();
    return offers.map((e) => e.toEntity()).toList();
  }

  @override
  Future<OfferEntity> getOfferById(String offerId) async {
    final offer = await remote.getOfferById(offerId: offerId);
    return offer.toEntity();
  }

  @override
  Future<OfferEntity> reviewOffer({
    required String offerId,
    required String action,
    required double counterPrice,
    required String message,
  }) async {
    final offer = await remote.reviewOffer(
      offerId: offerId,
      action: action,
      counterPrice: counterPrice,
      message: message,
    );
    return offer.toEntity();
  }
  @override
  Future<Map<String, dynamic>> initiatePayment({
    required int offerId,
    required String idempotencyKey,
  }) async {
    return await remote.initiatePayment(
      offerId: offerId,
      idempotencyKey: idempotencyKey,
    );
  }

  @override
  Future<String> checkPaymentStatus({
    required int paymentId,
  }) async {
    return await remote.checkPaymentStatus(
      paymentId: paymentId,
    );
  }
}
