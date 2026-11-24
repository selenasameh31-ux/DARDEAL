import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class GetPropertySummaryUseCase {
  final OfferRepository repository;

  GetPropertySummaryUseCase(this.repository);

  Future<PropertySummaryEntity> call(String propertyId) {
    return repository.getPropertySummary(propertyId);
  }
}
