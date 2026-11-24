// Data models for all /api/v1/Lookups/* API responses.
// Each model is intentionally thin — just enough to carry the data we need.
//
// ⚠️ IMPORTANT: The DarDeal backend uses `nameEn` / `nameAr` (not `name`),
//               and `iconName` (Material icon name as string, e.g. "wifi").
//               The response envelope is: { success, data: [...], message }.

/// Generic lookup item returned by amenities, facilities, rules, property-types.
///
/// API shape (amenities example):
/// ```json
/// { "id": 1, "nameEn": "Air Conditioning", "nameAr": null, "iconName": "ac_unit", "category": "Climate" }
/// ```
///
/// API shape (rules/facilities example):
/// ```json
/// { "id": 1, "code": "no_smoking", "nameEn": "No Smoking", "nameAr": "...", "iconName": "smoke_free", "category": "HouseRule", "displayOrder": 1 }
/// ```
import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class LookupItemModel {
  final int id;
  final String nameEn;
  final String? nameAr;
  final String? code;
  final String? iconName;
  final String? category;
  final int displayOrder;

  const LookupItemModel({
    required this.id,
    required this.nameEn,
    this.nameAr,
    this.code,
    this.iconName,
    this.category,
    this.displayOrder = 0,
  });

  factory LookupItemModel.fromJson(Map<String, dynamic> json) {
    return LookupItemModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nameEn: json['nameEn']?.toString() ?? json['name']?.toString() ?? '',
      nameAr: json['nameAr']?.toString(),
      code: json['code']?.toString(),
      iconName: json['iconName']?.toString(),
      category: json['category']?.toString(),
      displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
    );
  }

  /// Returns the best display name for the current locale.
  /// Falls back to English if Arabic is null/empty.
  String get displayName =>
      (nameAr != null && nameAr!.isNotEmpty) ? nameAr! : nameEn;
}

/// Governorate returned by GET /api/v1/Lookups/governorates
class GovernorateModel {
  final int id;
  final String nameEn;
  final String? nameAr;

  const GovernorateModel({required this.id, required this.nameEn, this.nameAr});

  factory GovernorateModel.fromJson(Map<String, dynamic> json) {
    return GovernorateModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nameEn: json['nameEn']?.toString() ?? json['name']?.toString() ?? '',
      nameAr: json['nameAr']?.toString(),
    );
  }

  String get displayName =>
      (nameAr != null && nameAr!.isNotEmpty) ? nameAr! : nameEn;
}

/// City returned by GET /api/v1/Lookups/cities?governorateId=X
class CityModel {
  final int id;
  final String nameEn;
  final String? nameAr;
  final int governorateId;

  const CityModel({
    required this.id,
    required this.nameEn,
    this.nameAr,
    required this.governorateId,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nameEn: json['nameEn']?.toString() ?? json['name']?.toString() ?? '',
      nameAr: json['nameAr']?.toString(),
      governorateId: (json['governorateId'] as num?)?.toInt() ?? 0,
    );
  }

  String get displayName =>
      (nameAr != null && nameAr!.isNotEmpty) ? nameAr! : nameEn;
}

/// District returned by GET /api/v1/Lookups/districts?cityId=X
class DistrictModel {
  final int id;
  final String nameEn;
  final String? nameAr;
  final int cityId;

  const DistrictModel({
    required this.id,
    required this.nameEn,
    this.nameAr,
    required this.cityId,
  });

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nameEn: json['nameEn']?.toString() ?? json['name']?.toString() ?? '',
      nameAr: json['nameAr']?.toString(),
      cityId: (json['cityId'] as num?)?.toInt() ?? 0,
    );
  }

  String get displayName =>
      (nameAr != null && nameAr!.isNotEmpty) ? nameAr! : nameEn;
}

/// Icon name string → Material IconData mapping.
/// The API returns icon names as strings like "wifi", "pool", "ac_unit".
/// This map resolves them to actual Flutter IconData.
IconData resolveIconName(String? iconName) {
  if (iconName == null || iconName.isEmpty) return Icons.star_outline;
  return _iconMap[iconName] ?? Icons.star_outline;
}

const Map<String, IconData> _iconMap = {
  // Amenities
  'ac_unit': Icons.ac_unit,
  'whatshot': Icons.whatshot,
  'wifi': Icons.wifi,
  'local_parking': Icons.local_parking,
  'elevator': Icons.elevator,
  'pool': Icons.pool,
  'fitness_center': Icons.fitness_center,
  'security': Icons.security,
  'balcony': Icons.balcony,
  'yard': Icons.yard,
  'local_laundry_service': Icons.local_laundry_service,
  'kitchen': Icons.kitchen,
  'chair': Icons.chair,
  'pets': Icons.pets,
  'videocam': Icons.videocam,
  'doorbell': Icons.doorbell,
  'inventory': Icons.inventory,
  'child_friendly': Icons.child_friendly,
  'person': Icons.person,
  'solar_power': Icons.solar_power,
  // Rules
  'smoke_free': Icons.smoke_free,
  'celebration': Icons.celebration,
  'volume_off': Icons.volume_off,
  'door_front': Icons.door_front_door,
  'schedule': Icons.schedule,
  'male': Icons.male,
  'female': Icons.female,
  'school': Icons.school,
  'work': Icons.work,
  'diversity_3': Icons.diversity_3,
  'family_restroom': Icons.family_restroom,
  // Nearby Facilities
  'local_hospital': Icons.local_hospital,
  'train': Icons.train,
  'shopping_bag': Icons.shopping_bag,
  'local_grocery_store': Icons.local_grocery_store,
  'mosque': Icons.mosque,
  'local_pharmacy': Icons.local_pharmacy,
  'restaurant': Icons.restaurant,
  'park': Icons.park,
  'sports_soccer': Icons.sports_soccer,
  'directions_bus': Icons.directions_bus,
  'account_balance': Icons.account_balance,
  'local_gas_station': Icons.local_gas_station,
  // Generic fallbacks
  'star': Icons.star,
  'star_outline': Icons.star_outline,
  'check': Icons.check,
  'home': Icons.home,
  'bed': Icons.bed,
  'bathtub': Icons.bathtub,
  'room': Icons.room,
  'rule': Icons.rule,
  'location_on': Icons.location_on,
};

/// Safely extracts a List<T> from a DarDeal API response envelope.
///
/// The DarDeal backend wraps all responses as:
/// ```json
/// { "success": true, "data": [...], "message": "..." }
/// ```
///
/// This helper handles:
/// - `{ data: [...] }` envelope (standard)
/// - Direct `[...]` array (edge cases)
/// - `{ data: { items: [...] } }` paginated envelope
List<T> parseLookupList<T>(
  dynamic responseData,
  T Function(Map<String, dynamic>) fromJson,
) {
  List<dynamic>? items;
  if (responseData is List) {
    items = responseData;
  } else if (responseData is Map) {
    final data = responseData['data'];
    if (data is List) {
      items = data;
    } else if (data is Map && data['items'] is List) {
      items = data['items'] as List;
    }
  }
  if (items == null) return [];
  return items.whereType<Map<String, dynamic>>().map(fromJson).toList();
}
