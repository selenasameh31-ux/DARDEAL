import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class CheckPaymentStatusUseCase {
  final OfferRepository repository;

  CheckPaymentStatusUseCase(this.repository);

  Future<String> call({required int paymentId}) {
    return repository.checkPaymentStatus(paymentId: paymentId);
  }
}
