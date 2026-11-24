
/// Abstract contract for the Lookup feature.
/// Domain and Presentation layers depend only on this interface.
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
abstract class LookupRepository {
  Future<List<LookupItemModel>> getAmenities({bool forceRefresh = false});
  Future<List<LookupItemModel>> getNearbyFacilities({bool forceRefresh = false});
  Future<List<LookupItemModel>> getRules({String? category, bool forceRefresh = false});
  Future<List<LookupItemModel>> getPropertyTypes({bool forceRefresh = false});
  Future<List<GovernorateModel>> getGovernorates({bool forceRefresh = false});
  Future<List<CityModel>> getCities(int governorateId, {bool forceRefresh = false});
  Future<List<DistrictModel>> getDistricts(int cityId, {bool forceRefresh = false});
}
