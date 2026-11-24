import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class CreateOfferUseCase {
  final OfferRepository repository;

  CreateOfferUseCase(this.repository);

  Future<OfferEntity> call({
    required String propertyId,
    required double offerPrice,
    required bool isTermsAccepted,
    String? message,
    String? seekerNotes,
    String? proposedMoveInDate,
    String? proposedEndDate,
  }) async {
    // 1. Fetch user's sent offers to check for duplicates
    final sentOffers = await repository.getSentOffers();

    // 2. Check if an active offer (pending or accepted) exists for the same property
    final hasActiveOffer = sentOffers.any(
      (offer) =>
          offer.propertyId == propertyId &&
          (offer.status == OfferStatusType.pending ||
              offer.status == OfferStatusType.accepted),
    );

    if (hasActiveOffer) {
      throw ConflictException(
        'You already have an active offer for this property.',
      );
    }

    // 3. Create the new offer if no duplicate is found
    return repository.createOffer(
      propertyId: propertyId,
      offerPrice: offerPrice,
      isTermsAccepted: isTermsAccepted,
      message: message,
      seekerNotes: seekerNotes,
      proposedMoveInDate: proposedMoveInDate,
      proposedEndDate: proposedEndDate,
    );
  }
}
