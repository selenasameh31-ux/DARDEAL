
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
class FetchAmenitiesUseCase {
  final LookupRepository repository;
  FetchAmenitiesUseCase(this.repository);
  Future<List<LookupItemModel>> call({bool forceRefresh = false}) =>
      repository.getAmenities(forceRefresh: forceRefresh);
}

class FetchNearbyFacilitiesUseCase {
  final LookupRepository repository;
  FetchNearbyFacilitiesUseCase(this.repository);
  Future<List<LookupItemModel>> call({bool forceRefresh = false}) =>
      repository.getNearbyFacilities(forceRefresh: forceRefresh);
}

class FetchRulesUseCase {
  final LookupRepository repository;
  FetchRulesUseCase(this.repository);
  Future<List<LookupItemModel>> call({String? category, bool forceRefresh = false}) =>
      repository.getRules(category: category, forceRefresh: forceRefresh);
}

class FetchPropertyTypesUseCase {
  final LookupRepository repository;
  FetchPropertyTypesUseCase(this.repository);
  Future<List<LookupItemModel>> call({bool forceRefresh = false}) =>
      repository.getPropertyTypes(forceRefresh: forceRefresh);
}

class FetchGovernotatesUseCase {
  final LookupRepository repository;
  FetchGovernotatesUseCase(this.repository);
  Future<List<GovernorateModel>> call({bool forceRefresh = false}) =>
      repository.getGovernorates(forceRefresh: forceRefresh);
}

class FetchCitiesUseCase {
  final LookupRepository repository;
  FetchCitiesUseCase(this.repository);
  Future<List<CityModel>> call(int governorateId, {bool forceRefresh = false}) =>
      repository.getCities(governorateId, forceRefresh: forceRefresh);
}

class FetchDistrictsUseCase {
  final LookupRepository repository;
  FetchDistrictsUseCase(this.repository);
  Future<List<DistrictModel>> call(int cityId, {bool forceRefresh = false}) =>
      repository.getDistricts(cityId, forceRefresh: forceRefresh);
}
