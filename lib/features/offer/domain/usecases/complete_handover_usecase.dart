import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class CompleteHandoverUseCase {
  final OfferRepository repository;

  CompleteHandoverUseCase(this.repository);

  Future<void> call({
    required String offerId,
    File? contractFile,
  }) {
    return repository.completeHandover(
      offerId: offerId,
      contractFile: contractFile,
    );
  }
}
