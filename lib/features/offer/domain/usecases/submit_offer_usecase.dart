import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class SubmitOfferUseCase {
  final OfferRepository repository;

  SubmitOfferUseCase(this.repository);

  Future<OfferEntity> call(OfferEntity offer) {
    return repository.submitOffer(offer);
  }
}
