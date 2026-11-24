import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class ConfirmPaymentUseCase {
  final OfferRepository repository;

  ConfirmPaymentUseCase(this.repository);

  Future<PaymentEntity> call({
    required String offerId,
    required double amount,
    required String paymentMethod,
  }) {
    return repository.confirmPayment(
      offerId: offerId,
      amount: amount,
      paymentMethod: paymentMethod,
    );
  }
}
