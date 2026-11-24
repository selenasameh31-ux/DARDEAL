
// ─────────────────────────────────────────────────────────────────────────────
// CONTRACT
// ─────────────────────────────────────────────────────────────────────────────
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
abstract class LookupRemoteDataSource {
  Future<List<LookupItemModel>> fetchAmenities();
  Future<List<LookupItemModel>> fetchNearbyFacilities();
  Future<List<LookupItemModel>> fetchRules({String? category});
  Future<List<LookupItemModel>> fetchPropertyTypes();
  Future<List<GovernorateModel>> fetchGovernorates();
  Future<List<CityModel>> fetchCities(int governorateId);
  Future<List<DistrictModel>> fetchDistricts(int cityId);
}

// ─────────────────────────────────────────────────────────────────────────────
// IMPLEMENTATION
// ─────────────────────────────────────────────────────────────────────────────
class LookupRemoteDataSourceImpl implements LookupRemoteDataSource {
  final ApiConsumer api;

  LookupRemoteDataSourceImpl(this.api);

  @override
  Future<List<LookupItemModel>> fetchAmenities() async {
    final response = await api.get(EndPoints.getAmenities);
    return parseLookupList(response.data, LookupItemModel.fromJson);
  }

  @override
  Future<List<LookupItemModel>> fetchNearbyFacilities() async {
    final response = await api.get(EndPoints.getNearbyFacilities);
    return parseLookupList(response.data, LookupItemModel.fromJson);
  }

  @override
  Future<List<LookupItemModel>> fetchRules({String? category}) async {
    final response = await api.get(
      EndPoints.getRules,
      queryParameters: category != null ? {'category': category} : null,
    );
    return parseLookupList(response.data, LookupItemModel.fromJson);
  }

  @override
  Future<List<LookupItemModel>> fetchPropertyTypes() async {
    final response = await api.get(EndPoints.getPropertyTypes);
    return parseLookupList(response.data, LookupItemModel.fromJson);
  }

  @override
  Future<List<GovernorateModel>> fetchGovernorates() async {
    final response = await api.get(EndPoints.getGovernorates);
    return parseLookupList(response.data, GovernorateModel.fromJson);
  }

  @override
  Future<List<CityModel>> fetchCities(int governorateId) async {
    final response = await api.get(
      EndPoints.getCities,
      queryParameters: {'governorateId': governorateId},
    );
    return parseLookupList(response.data, CityModel.fromJson);
  }

  @override
  Future<List<DistrictModel>> fetchDistricts(int cityId) async {
    final response = await api.get(
      EndPoints.getDistricts,
      queryParameters: {'cityId': cityId},
    );
    return parseLookupList(response.data, DistrictModel.fromJson);
  }
}
