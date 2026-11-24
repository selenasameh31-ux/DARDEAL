import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class InitiatePaymentUseCase {
  final OfferRepository repository;

  InitiatePaymentUseCase(this.repository);

  Future<Map<String, dynamic>> call({
    required int offerId,
    required String idempotencyKey,
  }) {
    return repository.initiatePayment(
      offerId: offerId,
      idempotencyKey: idempotencyKey,
    );
  }
}
