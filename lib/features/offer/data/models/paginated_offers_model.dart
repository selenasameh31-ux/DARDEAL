import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class PaginatedOffersModel {
  final List<OfferModel> offers;
  final int currentPage;
  final int totalPages;
  final int totalCount;

  const PaginatedOffersModel({
    required this.offers,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
  });

  static int _toInt(dynamic val, int fallback) {
    if (val == null) return fallback;
    if (val is int) return val;
    if (val is double) return val.toInt();
    return int.tryParse(val.toString()) ?? fallback;
  }

  factory PaginatedOffersModel.fromJson(dynamic rawJson) {
    debugPrint("📦 PaginatedOffersModel rawType=${rawJson.runtimeType}");

    List<OfferModel> parsedOffers = [];

    // Case 1: response is a raw List
    if (rawJson is List) {
      debugPrint("✅ Response is a direct List (${rawJson.length} items)");
      parsedOffers = rawJson.map((e) {
        debugPrint("  ➡️ $e");
        return OfferModel.fromJson(e as Map<String, dynamic>);
      }).toList();
      return PaginatedOffersModel(
        offers: parsedOffers,
        currentPage: 1,
        totalPages: 1,
        totalCount: parsedOffers.length,
      );
    }

    // Case 2: response is a Map
    if (rawJson is Map<String, dynamic>) {
      final dataField = rawJson['data'];

      if (dataField is List) {
        debugPrint("✅ json['data'] is List (${dataField.length} items)");
        parsedOffers = dataField.map((e) {
          debugPrint("  ➡️ $e");
          return OfferModel.fromJson(e as Map<String, dynamic>);
        }).toList();
      } else if (rawJson['items'] is List) {
        final items = rawJson['items'] as List;
        debugPrint("✅ json['items'] is List (${items.length} items)");
        parsedOffers = items.map((e) {
          debugPrint("  ➡️ $e");
          return OfferModel.fromJson(e as Map<String, dynamic>);
        }).toList();
      } else if (dataField is Map && dataField['items'] is List) {
        final items = dataField['items'] as List;
        debugPrint("✅ json['data']['items'] is List (${items.length} items)");
        parsedOffers = items.map((e) {
          debugPrint("  ➡️ $e");
          return OfferModel.fromJson(e as Map<String, dynamic>);
        }).toList();
      } else {
        debugPrint("⚠️ Could not find list. Keys=${rawJson.keys.toList()} | dataType=${dataField?.runtimeType}");
      }

      return PaginatedOffersModel(
        offers: parsedOffers,
        currentPage: _toInt(rawJson['currentPage'] ?? rawJson['page'], 1),
        totalPages: _toInt(rawJson['totalPages'], 1),
        totalCount: _toInt(rawJson['totalCount'] ?? rawJson['total'], parsedOffers.length),
      );
    }

    debugPrint("⚠️ Unknown response format: $rawJson");
    return const PaginatedOffersModel(
      offers: [],
      currentPage: 1,
      totalPages: 1,
      totalCount: 0,
    );
  }
}
