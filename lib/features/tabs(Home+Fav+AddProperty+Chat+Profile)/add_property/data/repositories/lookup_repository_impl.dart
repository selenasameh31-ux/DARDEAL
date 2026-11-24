
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
class LookupRepositoryImpl implements LookupRepository {
  final LookupRemoteDataSource remote;

  LookupRepositoryImpl(this.remote);

  // ── Cache Storage ──
  List<LookupItemModel>? _cachedAmenities;
  Future<List<LookupItemModel>>? _amenitiesFuture;

  List<LookupItemModel>? _cachedNearbyFacilities;
  Future<List<LookupItemModel>>? _nearbyFacilitiesFuture;

  List<LookupItemModel>? _cachedRules;
  Future<List<LookupItemModel>>? _rulesFuture;

  List<LookupItemModel>? _cachedPropertyTypes;
  Future<List<LookupItemModel>>? _propertyTypesFuture;

  List<GovernorateModel>? _cachedGovernorates;
  Future<List<GovernorateModel>>? _governoratesFuture;

  final Map<int, List<CityModel>> _cachedCities = {};
  final Map<int, Future<List<CityModel>>> _citiesFutures = {};

  final Map<int, List<DistrictModel>> _cachedDistricts = {};
  final Map<int, Future<List<DistrictModel>>> _districtsFutures = {};

  // ── Helper ──
  void _log(String message) {
    if (kDebugMode) debugPrint(message);
  }

  // ── Methods ──

  @override
  Future<List<LookupItemModel>> getAmenities({bool forceRefresh = false}) {
    if (forceRefresh) {
      _cachedAmenities = null;
      _amenitiesFuture = null;
      _log('[LOOKUP CACHE] Amenities cache cleared for refresh');
    }

    if (_cachedAmenities != null) {
      _log('[LOOKUP CACHE] Returning cached amenities');
      return Future.value(List<LookupItemModel>.unmodifiable(_cachedAmenities!));
    }

    if (_amenitiesFuture != null) return _amenitiesFuture!;

    _log('[LOOKUP CACHE] Fetching amenities from API');
    _amenitiesFuture = _fetchAmenities();
    return _amenitiesFuture!;
  }

  Future<List<LookupItemModel>> _fetchAmenities() async {
    try {
      final data = await remote.fetchAmenities();
      _cachedAmenities = data;
      _amenitiesFuture = null;
      return List<LookupItemModel>.unmodifiable(data);
    } catch (error) {
      _amenitiesFuture = null;
      rethrow;
    }
  }

  @override
  Future<List<LookupItemModel>> getNearbyFacilities({bool forceRefresh = false}) {
    if (forceRefresh) {
      _cachedNearbyFacilities = null;
      _nearbyFacilitiesFuture = null;
      _log('[LOOKUP CACHE] Nearby facilities cache cleared for refresh');
    }

    if (_cachedNearbyFacilities != null) {
      _log('[LOOKUP CACHE] Returning cached nearby facilities');
      return Future.value(List<LookupItemModel>.unmodifiable(_cachedNearbyFacilities!));
    }

    if (_nearbyFacilitiesFuture != null) return _nearbyFacilitiesFuture!;

    _log('[LOOKUP CACHE] Fetching nearby facilities from API');
    _nearbyFacilitiesFuture = _fetchNearbyFacilities();
    return _nearbyFacilitiesFuture!;
  }

  Future<List<LookupItemModel>> _fetchNearbyFacilities() async {
    try {
      final data = await remote.fetchNearbyFacilities();
      _cachedNearbyFacilities = data;
      _nearbyFacilitiesFuture = null;
      return List<LookupItemModel>.unmodifiable(data);
    } catch (error) {
      _nearbyFacilitiesFuture = null;
      rethrow;
    }
  }

  @override
  Future<List<LookupItemModel>> getRules({String? category, bool forceRefresh = false}) {
    if (forceRefresh) {
      _cachedRules = null;
      _rulesFuture = null;
      _log('[LOOKUP CACHE] Rules cache cleared for refresh');
    }

    if (_cachedRules != null) {
      _log('[LOOKUP CACHE] Returning cached rules');
      return Future.value(List<LookupItemModel>.unmodifiable(_cachedRules!));
    }

    if (_rulesFuture != null) return _rulesFuture!;

    _log('[LOOKUP CACHE] Fetching rules from API');
    _rulesFuture = _fetchRules(category);
    return _rulesFuture!;
  }

  Future<List<LookupItemModel>> _fetchRules(String? category) async {
    try {
      final data = await remote.fetchRules(category: category);
      _cachedRules = data;
      _rulesFuture = null;
      return List<LookupItemModel>.unmodifiable(data);
    } catch (error) {
      _rulesFuture = null;
      rethrow;
    }
  }

  @override
  Future<List<LookupItemModel>> getPropertyTypes({bool forceRefresh = false}) {
    if (forceRefresh) {
      _cachedPropertyTypes = null;
      _propertyTypesFuture = null;
      _log('[LOOKUP CACHE] Property types cache cleared for refresh');
    }

    if (_cachedPropertyTypes != null) {
      _log('[LOOKUP CACHE] Returning cached property types');
      return Future.value(List<LookupItemModel>.unmodifiable(_cachedPropertyTypes!));
    }

    if (_propertyTypesFuture != null) return _propertyTypesFuture!;

    _log('[LOOKUP CACHE] Fetching property types from API');
    _propertyTypesFuture = _fetchPropertyTypes();
    return _propertyTypesFuture!;
  }

  Future<List<LookupItemModel>> _fetchPropertyTypes() async {
    try {
      final data = await remote.fetchPropertyTypes();
      _cachedPropertyTypes = data;
      _propertyTypesFuture = null;
      return List<LookupItemModel>.unmodifiable(data);
    } catch (error) {
      _propertyTypesFuture = null;
      rethrow;
    }
  }

  @override
  Future<List<GovernorateModel>> getGovernorates({bool forceRefresh = false}) {
    if (forceRefresh) {
      _cachedGovernorates = null;
      _governoratesFuture = null;
      _log('[LOOKUP CACHE] Governorates cache cleared for refresh');
    }

    if (_cachedGovernorates != null) {
      _log('[LOOKUP CACHE] Returning cached governorates');
      return Future.value(List<GovernorateModel>.unmodifiable(_cachedGovernorates!));
    }

    if (_governoratesFuture != null) return _governoratesFuture!;

    _log('[LOOKUP CACHE] Fetching governorates from API');
    _governoratesFuture = _fetchGovernorates();
    return _governoratesFuture!;
  }

  Future<List<GovernorateModel>> _fetchGovernorates() async {
    try {
      final data = await remote.fetchGovernorates();
      _cachedGovernorates = data;
      _governoratesFuture = null;
      return List<GovernorateModel>.unmodifiable(data);
    } catch (error) {
      _governoratesFuture = null;
      rethrow;
    }
  }

  @override
  Future<List<CityModel>> getCities(int governorateId, {bool forceRefresh = false}) {
    if (forceRefresh) {
      _cachedCities.remove(governorateId);
      _citiesFutures.remove(governorateId);
      _log('[LOOKUP CACHE] Cities cache cleared for governorate $governorateId');
    }

    if (_cachedCities.containsKey(governorateId)) {
      _log('[LOOKUP CACHE] Returning cached cities for governorate $governorateId');
      return Future.value(List<CityModel>.unmodifiable(_cachedCities[governorateId]!));
    }

    if (_citiesFutures.containsKey(governorateId)) {
      return _citiesFutures[governorateId]!;
    }

    _log('[LOOKUP CACHE] Fetching cities for governorate $governorateId from API');
    final future = _fetchCities(governorateId);
    _citiesFutures[governorateId] = future;
    return future;
  }

  Future<List<CityModel>> _fetchCities(int governorateId) async {
    try {
      final data = await remote.fetchCities(governorateId);
      _cachedCities[governorateId] = data;
      _citiesFutures.remove(governorateId);
      return List<CityModel>.unmodifiable(data);
    } catch (error) {
      _citiesFutures.remove(governorateId);
      rethrow;
    }
  }

  @override
  Future<List<DistrictModel>> getDistricts(int cityId, {bool forceRefresh = false}) {
    if (forceRefresh) {
      _cachedDistricts.remove(cityId);
      _districtsFutures.remove(cityId);
      _log('[LOOKUP CACHE] Districts cache cleared for city $cityId');
    }

    if (_cachedDistricts.containsKey(cityId)) {
      _log('[LOOKUP CACHE] Returning cached districts for city $cityId');
      return Future.value(List<DistrictModel>.unmodifiable(_cachedDistricts[cityId]!));
    }

    if (_districtsFutures.containsKey(cityId)) {
      return _districtsFutures[cityId]!;
    }

    _log('[LOOKUP CACHE] Fetching districts for city $cityId from API');
    final future = _fetchDistricts(cityId);
    _districtsFutures[cityId] = future;
    return future;
  }

  Future<List<DistrictModel>> _fetchDistricts(int cityId) async {
    try {
      final data = await remote.fetchDistricts(cityId);
      _cachedDistricts[cityId] = data;
      _districtsFutures.remove(cityId);
      return List<DistrictModel>.unmodifiable(data);
    } catch (error) {
      _districtsFutures.remove(cityId);
      rethrow;
    }
  }
}
