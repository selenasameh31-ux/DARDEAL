import 'package:graduation_project_flutter/core/routing/routes_export.dart';

abstract class OfferRepository {
  /// Fetches the property summary to display on the Make Offer screen
  Future<PropertySummaryEntity> getPropertySummary(String propertyId);

  /// Creates and stores a new offer locally before submission
  Future<OfferEntity> createOffer({
    required String propertyId,
    required double offerPrice,
    required bool isTermsAccepted,
    String? message,
    String? seekerNotes,
    String? proposedMoveInDate,
    String? proposedEndDate,
  });

  /// Submits the offer to the backend
  Future<OfferEntity> submitOffer(OfferEntity offer);

  /// Processes the deposit payment
  Future<PaymentEntity> confirmPayment({
    required String offerId,
    required double amount,
    required String paymentMethod,
  });

  /// Submits the completed handover checklist
  Future<void> completeHandover({
    required String offerId,
    File? contractFile,
  });
  Future<List<OfferEntity>> getSentOffers();

  Future<List<OfferEntity>> getReceivedOffers();

  Future<List<OfferEntity>> getMyOffers();

  Future<OfferEntity> getOfferById(String offerId);

  Future<OfferEntity> reviewOffer({
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
