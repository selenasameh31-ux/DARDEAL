// ── Strict API Enums ───────────────────────────────────────────────────────

import 'package:graduation_project_flutter/core/routing/routes_export.dart';

enum BackendPropertyType {
  apartment,
  villa,
  studio,
  townhouse,
  duplex,
  penthouse,
  chalet,
  building,
  land,
  office,
}

extension BackendPropertyTypeExt on BackendPropertyType {
  String toApiValue() {
    switch (this) {
      case BackendPropertyType.apartment:
        return 'Apartment';
      case BackendPropertyType.villa:
        return 'Villa';
      case BackendPropertyType.studio:
        return 'Studio';
      case BackendPropertyType.townhouse:
        return 'Townhouse';
      case BackendPropertyType.duplex:
        return 'Duplex';
      case BackendPropertyType.penthouse:
        return 'Penthouse';
      case BackendPropertyType.chalet:
        return 'Chalet';
      case BackendPropertyType.building:
        return 'Building';
      case BackendPropertyType.land:
        return 'Land';
      case BackendPropertyType.office:
        return 'Office';
    }
  }

  String toUiLabel() => toApiValue();

  static BackendPropertyType? fromUiLabel(String label) {
    for (final type in BackendPropertyType.values) {
      if (type.toUiLabel().toLowerCase() == label.toLowerCase()) {
        return type;
      }
    }
    // Legacy mapping aliases (prevent complete failure if cached state exists)
    final lower = label.toLowerCase();
    if (lower.contains('house') || lower.contains('residential'))
      return BackendPropertyType.villa;
    if (lower.contains('commercial') || lower.contains('warehouse'))
      return BackendPropertyType.building;
    if (lower.contains('room')) return BackendPropertyType.apartment;

    return null;
  }
}

enum BackendListingType { sale, rentRoom, rentFullProperty }

extension BackendListingTypeExt on BackendListingType {
  String toApiValue() {
    switch (this) {
      case BackendListingType.sale:
        return 'sale';
      case BackendListingType.rentRoom:
        return 'rent-room';
      case BackendListingType.rentFullProperty:
        return 'rent-full-property';
    }
  }

  static BackendListingType? fromUiLabels(
    String transactionType,
    String? listingStyle,
  ) {
    if (transactionType == 'For Sale') return BackendListingType.sale;
    if (transactionType == 'For Rent' && listingStyle == 'Room-by-Room')
      return BackendListingType.rentRoom;
    if (transactionType == 'For Rent')
      return BackendListingType.rentFullProperty;
    return null;
  }
}

enum BackendIntent { sale, longTermRent, shortTermRent, timeBasedRent }

extension BackendIntentExt on BackendIntent {
  String toApiValue() {
    switch (this) {
      case BackendIntent.sale:
        return 'sale';
      case BackendIntent.longTermRent:
        return 'long-term-rent';
      case BackendIntent.shortTermRent:
        return 'short-term-rent';
      case BackendIntent.timeBasedRent:
        return 'time-based-rent';
    }
  }

  static BackendIntent? fromUiLabels(
    String transactionType,
    String? listingStyle,
  ) {
    if (transactionType == 'For Sale') return BackendIntent.sale;
    final style = listingStyle?.toLowerCase() ?? '';
    if (style.contains('daily') || style.contains('short'))
      return BackendIntent.shortTermRent;
    return BackendIntent.longTermRent;
  }
}

enum BackendCategory {
  residential,
  commercial,
  industrial,
  administrative,
  agricultural,
}

extension BackendCategoryExt on BackendCategory {
  String toApiValue() {
    switch (this) {
      case BackendCategory.residential:
        return 'residential';
      case BackendCategory.commercial:
        return 'commercial';
      case BackendCategory.industrial:
        return 'industrial';
      case BackendCategory.administrative:
        return 'administrative';
      case BackendCategory.agricultural:
        return 'agricultural';
    }
  }

  static BackendCategory? fromUiLabel(String label) {
    final lower = label.toLowerCase();
    if (lower.contains('luxury') || lower.contains('residential'))
      return BackendCategory.residential;
    if (lower.contains('commercial')) return BackendCategory.commercial;
    if (lower.contains('industrial')) return BackendCategory.industrial;
    if (lower.contains('administrative')) return BackendCategory.administrative;
    if (lower.contains('agricultural')) return BackendCategory.agricultural;
    return null;
  }
}

enum BackendRentalModel { shortTerm, longTerm }

extension BackendRentalModelExt on BackendRentalModel {
  String toApiValue() {
    switch (this) {
      case BackendRentalModel.shortTerm:
        return 'short-term';
      case BackendRentalModel.longTerm:
        return 'long-term';
    }
  }

  static BackendRentalModel? fromUiLabel(String label) {
    final lower = label.toLowerCase();
    if (lower.contains('daily') || lower.contains('short'))
      return BackendRentalModel.shortTerm;
    if (lower.contains('monthly') ||
        lower.contains('yearly') ||
        lower.contains('long'))
      return BackendRentalModel.longTerm;
    return null;
  }
}

enum BackendFurnishingStatus { furnished, partlyFurnished, unfurnished }

extension BackendFurnishingStatusExt on BackendFurnishingStatus {
  String toApiValue() {
    switch (this) {
      case BackendFurnishingStatus.furnished:
        return 'Furnished';
      case BackendFurnishingStatus.partlyFurnished:
        return 'Semi-Furnished';
      case BackendFurnishingStatus.unfurnished:
        return 'Unfurnished';
    }
  }

  static BackendFurnishingStatus? fromUiLabel(String label) {
    final lower = label.toLowerCase();
    if (lower.contains('semi') || lower.contains('partly'))
      return BackendFurnishingStatus.partlyFurnished;
    if (lower.contains('unfurnished'))
      return BackendFurnishingStatus.unfurnished;
    if (lower.contains('furnished')) return BackendFurnishingStatus.furnished;
    return null;
  }
}

enum BackendRoomType { privateRoom, sharedRoom }

extension BackendRoomTypeExt on BackendRoomType {
  String toApiValue() {
    switch (this) {
      case BackendRoomType.privateRoom:
        return 'private-room';
      case BackendRoomType.sharedRoom:
        return 'shared-room';
    }
  }

  static BackendRoomType? fromUiLabel(String label) {
    if (label.toLowerCase().contains('shared'))
      return BackendRoomType.sharedRoom;
    return BackendRoomType.privateRoom;
  }
}

enum BackendBedType { single, double, queen, king }

extension BackendBedTypeExt on BackendBedType {
  String toApiValue() {
    switch (this) {
      case BackendBedType.single:
        return 'single';
      case BackendBedType.double:
        return 'double';
      case BackendBedType.queen:
        return 'queen';
      case BackendBedType.king:
        return 'king';
    }
  }
}

// ── Models matching the Swagger CreatePropertyDto / CreateRoomDto ─────────────

class CreatePropertyRequestModel {
  final String? title;
  final String? description;
  final String? propertyType;
  final String? listingType;
  final String? category;
  final String? rentalModel;
  final String? intent;
  final double price;
  final String? currency;
  final int? districtId;
  final String? street;
  final String? buildingNumber;
  final int? floorNumber;
  final String? unitNumber;
  final double? latitude;
  final double? longitude;
  final int? bedrooms;
  final int? bathrooms;
  final double? areaSquareMeters;
  final String? furnishingStatus;
  final int? totalRooms;
  // API expects integer IDs from /api/v1/Lookups/* endpoints
  final List<int>? amenityIds;
  final List<int>? nearbyFacilityIds;
  final List<int>? ruleIds;
  // Fallback string arrays for when lookup IDs are unavailable
  final List<String>? customAmenities;
  final List<String>? customRules;
  final List<String>? amenities;
  // Name arrays sent alongside IDs (backend uses these for persistence)
  final List<String>? rules;
  final List<String>? nearbyFacilities;
  final HouseRulesModel? houseRules;
  final double? dailyPrice;
  final int? minStayNights;
  final int? maxStayNights;
  final String? checkInTime;
  final String? checkOutTime;
  final String? rentalStartDate;
  final String? rentalEndDate;
  final SalePricingModel? salePricing;
  final RentalPricingModel? rentalPricing;
  final String? roomType;
  final String? bedType;
  final int? bedCount;
  final int? maxOccupants;
  final bool? hasPrivateBathroom;
  final bool? hasBalcony;
  final PreferencesModel? preferences;

  CreatePropertyRequestModel({
    this.title,
    this.description,
    this.propertyType,
    this.listingType,
    this.category,
    this.rentalModel,
    this.intent,
    required this.price,
    this.currency,
    this.districtId,
    this.street,
    this.buildingNumber,
    this.floorNumber,
    this.unitNumber,
    this.latitude,
    this.longitude,
    this.bedrooms,
    this.bathrooms,
    this.areaSquareMeters,
    this.furnishingStatus,
    this.totalRooms,
    this.amenityIds,
    this.nearbyFacilityIds,
    this.ruleIds,
    this.customAmenities,
    this.customRules,
    this.amenities,
    this.rules,
    this.nearbyFacilities,
    this.houseRules,
    this.dailyPrice,
    this.minStayNights,
    this.maxStayNights,
    this.checkInTime,
    this.checkOutTime,
    this.rentalStartDate,
    this.rentalEndDate,
    this.salePricing,
    this.rentalPricing,
    this.roomType,
    this.bedType,
    this.bedCount,
    this.maxOccupants,
    this.hasPrivateBathroom,
    this.hasBalcony,
    this.preferences,
  });

  Map<String, dynamic> toJson() {
    final payload = {
      'title': title,
      'description': description,
      'propertyType': propertyType,
      'listingType': listingType,
      'category': category,
      'rentalModel': rentalModel,
      'intent': intent,
      'price': price,
      'currency': currency,
      'districtId': districtId,
      'street': street,
      'buildingNumber': buildingNumber,
      'floorNumber': floorNumber,
      'unitNumber': unitNumber,
      'latitude': latitude,
      'longitude': longitude,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'areaSquareMeters': areaSquareMeters,
      'furnishingStatus': furnishingStatus,
      'totalRooms': totalRooms,
      'amenityIds': amenityIds,
      'nearbyFacilityIds': nearbyFacilityIds,
      'ruleIds': ruleIds,
      'customAmenities': customAmenities,
      'customRules': customRules,
      'amenities': amenities,
      'rules': rules,
      'nearbyFacilities': nearbyFacilities,
      'houseRules': houseRules?.toJson(),
      'dailyPrice': dailyPrice,
      'minStayNights': minStayNights,
      'maxStayNights': maxStayNights,
      'checkInTime': checkInTime,
      'checkOutTime': checkOutTime,
      'rentalStartDate': rentalStartDate,
      'rentalEndDate': rentalEndDate,
      'salePricing': salePricing?.toJson(),
      'rentalPricing': rentalPricing?.toJson(),
      'roomType': roomType,
      'bedType': bedType,
      'bedCount': bedCount,
      'maxOccupants': maxOccupants,
      'hasPrivateBathroom': hasPrivateBathroom,
      'hasBalcony': hasBalcony,
      'preferences': preferences?.toJson(),
    }..removeWhere((key, value) => value == null); // Clean payload
    print("=== [CreatePropertyRequestModel] JSON Payload: $payload ===");
    return payload;
  }
}

class HouseRulesModel {
  final bool? noSmoking;
  final bool? noPets;
  final QuietHoursModel? quietHours;
  final String? visitorPolicy;
  final String? custom;

  HouseRulesModel({
    this.noSmoking,
    this.noPets,
    this.quietHours,
    this.visitorPolicy,
    this.custom,
  });

  Map<String, dynamic> toJson() {
    return {
      'noSmoking': noSmoking,
      'noPets': noPets,
      'quietHours': quietHours?.toJson(),
      'visitorPolicy': visitorPolicy,
      'custom': custom,
    }..removeWhere((key, value) => value == null);
  }
}

class QuietHoursModel {
  final String? from;
  final String? to;

  QuietHoursModel({this.from, this.to});

  Map<String, dynamic> toJson() {
    return {'from': from, 'to': to}..removeWhere((key, value) => value == null);
  }
}

class SalePricingModel {
  final bool? isNegotiable;
  final String? paymentMethod;
  final double? downPayment;
  final int? installmentDurationMonths;
  final double? monthlyInstallment;
  final double? securityDeposit;

  SalePricingModel({
    this.isNegotiable,
    this.paymentMethod,
    this.downPayment,
    this.installmentDurationMonths,
    this.monthlyInstallment,
    this.securityDeposit,
  });

  Map<String, dynamic> toJson() {
    return {
      'isNegotiable': isNegotiable,
      'paymentMethod': paymentMethod,
      'downPayment': downPayment,
      'installmentDurationMonths': installmentDurationMonths,
      'monthlyInstallment': monthlyInstallment,
      'securityDeposit': securityDeposit,
    }..removeWhere((key, value) => value == null);
  }
}

class RentalPricingModel {
  final double? securityDeposit;
  final int? minLeaseDurationMonths;
  final String? rentalStartDate;
  final String? rentalEndDate;

  RentalPricingModel({
    this.securityDeposit,
    this.minLeaseDurationMonths,
    this.rentalStartDate,
    this.rentalEndDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'securityDeposit': securityDeposit,
      'minLeaseDurationMonths': minLeaseDurationMonths,
      'rentalStartDate': rentalStartDate,
      'rentalEndDate': rentalEndDate,
    }..removeWhere((key, value) => value == null);
  }
}

class PreferencesModel {
  final String? genderPreference;
  final bool? studentsOnly;
  final bool? professionalsOnly;
  final int? preferredAgeMin;
  final int? preferredAgeMax;
  final String? preferredOccupation;
  final String? preferredNationality;
  final List<String>? customPreferences;

  PreferencesModel({
    this.genderPreference,
    this.studentsOnly,
    this.professionalsOnly,
    this.preferredAgeMin,
    this.preferredAgeMax,
    this.preferredOccupation,
    this.preferredNationality,
    this.customPreferences,
  });

  Map<String, dynamic> toJson() {
    return {
      'genderPreference': genderPreference,
      'studentsOnly': studentsOnly,
      'professionalsOnly': professionalsOnly,
      'preferredAgeMin': preferredAgeMin,
      'preferredAgeMax': preferredAgeMax,
      'preferredOccupation': preferredOccupation,
      'preferredNationality': preferredNationality,
      'customPreferences': customPreferences,
    }..removeWhere((key, value) => value == null);
  }
}

// ── Swagger: CreateRoomDto ────────────────────────────────────────────────────
class CreateRoomRequestModel {
  final String? title;
  final String? description;
  final String? roomType;
  final String? listingType;
  final double price;
  final String? pricePeriod;
  final double? areaSquareMeters;
  final String? furnishingStatus;
  final List<String>? amenities;
  final bool isAvailable;
  final String? availableFrom;
  final String? availableUntil;
  final double? dailyPrice;
  final int? minStayNights;
  final int? maxStayNights;
  final String? checkInTime;
  final String? checkOutTime;
  final bool? hasPrivateBathroom;
  final bool? hasBalcony;
  final int? maxOccupants;

  CreateRoomRequestModel({
    this.title,
    this.description,
    this.roomType,
    this.listingType,
    required this.price,
    this.pricePeriod,
    this.areaSquareMeters,
    this.furnishingStatus,
    this.amenities,
    required this.isAvailable,
    this.availableFrom,
    this.availableUntil,
    this.dailyPrice,
    this.minStayNights,
    this.maxStayNights,
    this.checkInTime,
    this.checkOutTime,
    this.hasPrivateBathroom,
    this.hasBalcony,
    this.maxOccupants,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'roomType': roomType,
      'listingType': listingType,
      'price': price,
      'pricePeriod': pricePeriod,
      'areaSquareMeters': areaSquareMeters,
      'furnishingStatus': furnishingStatus,
      'amenities': amenities,
      'isAvailable': isAvailable,
      'availableFrom': availableFrom,
      'availableUntil': availableUntil,
      'dailyPrice': dailyPrice,
      'minStayNights': minStayNights,
      'maxStayNights': maxStayNights,
      'checkInTime': checkInTime,
      'checkOutTime': checkOutTime,
      'hasPrivateBathroom': hasPrivateBathroom,
      'hasBalcony': hasBalcony,
      'maxOccupants': maxOccupants,
    }..removeWhere((key, value) => value == null);
  }
}

// ── Extension: Map Draft Entity → API Request Model ──────────────────────────
extension PropertyDraftEntityMapper on PropertyDraftEntity {
  CreatePropertyRequestModel toCreatePropertyRequest() {
    // ── ID Pipeline ──────────────────────────────────────────────────────────
    // Amenities, Rules, and Facilities are stored as
    // "id:name:iconCodePoint" pipe-separated (for UI restore).
    // We extract only the first segment (the integer apiId) for the API.
    // selectedCommunityRuleIds and selectedNearbyFacilityIds are stored as
    // "id:name:iconCodePoint" pipe-separated (for UI restore).
    // We extract only the first segment (the integer ID).
    List<int>? _parseApiIds(String raw) {
      if (raw.isEmpty) return null;
      final parts = raw.split(RegExp(r'[|,]'));
      final ids = parts
          .map((part) {
            final segment = part.contains(':') ? part.split(':').first : part;
            return int.tryParse(segment.trim()) ?? 0;
          })
          .where((id) => id > 0)
          .toList();
      return ids.isEmpty ? null : ids;
    }

    List<String>? _parseCustom(String raw) {
      if (raw.isEmpty) return null;
      final parts = raw.split(RegExp(r'[|,]'));
      final custom = parts
          .where((part) {
            final segment = part.contains(':') ? part.split(':').first : part;
            final id = int.tryParse(segment.trim()) ?? 0;
            return id == 0;
          })
          .map((part) {
            if (part.contains(':')) {
              final segments = part.split(':');
              return segments.length > 1 ? segments[1].trim() : part.trim();
            }
            return part.trim();
          })
          .where((name) => name.isNotEmpty)
          .toList();
      return custom.isEmpty ? null : custom;
    }

    List<String>? _parseNames(String raw) {
      if (raw.isEmpty) return null;
      final parts = raw.split(RegExp(r'[|,]'));
      final names = parts
          .map((part) {
            if (part.contains(':')) {
              final segments = part.split(':');
              return segments.length > 1 ? segments[1].trim() : part.trim();
            }
            return part.trim();
          })
          .where((name) => name.isNotEmpty)
          .toList();
      return names.isEmpty ? null : names;
    }

    final amenityApiIds = _parseApiIds(selectedAmenityIds);
    final customAmenitiesList = _parseCustom(selectedAmenityIds);
    final amenityNamesList = _parseNames(selectedAmenityIds);

    final ruleApiIds = _parseApiIds(selectedCommunityRuleIds);
    final customRulesList = _parseCustom(selectedCommunityRuleIds);
    final ruleNamesList = _parseNames(selectedCommunityRuleIds);

    final facilityApiIds = _parseApiIds(selectedNearbyFacilityIds);
    final facilityNamesList = _parseNames(selectedNearbyFacilityIds);

    // ── Safe Parsers ────────────────────────────────────────────────────────
    double? _parseDouble(String? val) {
      if (val == null || val.trim().isEmpty) return null;
      return double.tryParse(val.replaceAll(',', '').replaceAll(' ', ''));
    }

    int? _parseDuration(String? val) {
      if (val == null || val.trim().isEmpty) return null;
      final match = RegExp(r'\d+').firstMatch(val);
      if (match != null) {
        return int.tryParse(match.group(0)!);
      }
      return null;
    }

    int? _parseRooms(String? val) {
      if (val == null || val.trim().isEmpty) return null;
      if (val.toLowerCase() == 'studio') return 0;
      final match = RegExp(r'\d+').firstMatch(val);
      if (match != null) {
        return int.tryParse(match.group(0)!);
      }
      return null;
    }

    // ── Centralized API Serialization Strategy (Kebab-Case Enums) ────────────

    String? _mapCategory(String? val) {
      if (val == null || val.trim().isEmpty) return null;
      final type = BackendCategoryExt.fromUiLabel(val);
      if (type == null) {
        throw Exception("Unsupported category selected: '$val'.");
      }
      return type.toApiValue();
    }

    String? _mapFurnishing(String? val) {
      if (val == null || val.trim().isEmpty) return null;
      final type = BackendFurnishingStatusExt.fromUiLabel(val);
      if (type == null) {
        throw Exception("Unsupported furnishing status: '$val'.");
      }
      return type.toApiValue();
    }

    String? _mapPaymentMethod(String? val) {
      if (val == null || val.trim().isEmpty) return null;
      if (val.toLowerCase().contains('install')) return 'installment';
      return 'cash';
    }

    String? _mapRentalModel() {
      if (listingStyle.trim().isEmpty) return null;
      final type = BackendRentalModelExt.fromUiLabel(listingStyle);
      // Return null instead of throwing, because many valid listing styles
      // (like 'Entire Property', 'Shared Room') do not imply a specific rental model.
      return type?.toApiValue();
    }

    String? _mapRoomType() {
      if (roomPrivacy == null || roomPrivacy!.trim().isEmpty) return null;
      final type = BackendRoomTypeExt.fromUiLabel(roomPrivacy!);
      if (type == null) {
        throw Exception("Unsupported room type from privacy: '$roomPrivacy'.");
      }
      return type.toApiValue();
    }

    String? _mapBedType() {
      if (!listBeds) return null;
      if (kingBeds > 0) return BackendBedType.king.toApiValue();
      if (queenBeds > 0) return BackendBedType.queen.toApiValue();
      if (doubleBeds > 0) return BackendBedType.double.toApiValue();
      if (singleBeds > 0) return BackendBedType.single.toApiValue();
      return null;
    }

    String _mapListingType() {
      final type = BackendListingTypeExt.fromUiLabels(
        transactionType,
        listingStyle,
      );
      if (type == null) {
        throw Exception(
          "Unsupported listing type derived from transaction: '$transactionType' and style: '$listingStyle'.",
        );
      }
      return type.toApiValue();
    }

    String _mapIntent() {
      final type = BackendIntentExt.fromUiLabels(transactionType, listingStyle);
      if (type == null) {
        throw Exception(
          "Unsupported intent derived from transaction: '$transactionType' and style: '$listingStyle'.",
        );
      }
      return type.toApiValue();
    }

    String? _mapPropertyType(String? val) {
      if (val == null) return null;
      final type = BackendPropertyTypeExt.fromUiLabel(val);
      if (type == null) {
        throw Exception(
          "Unsupported property type selected: '$val'. Please choose a valid property type.",
        );
      }
      return type.toApiValue();
    }

    final apiListingType = _mapListingType();
    final isSale = transactionType == 'For Sale';
    final isRentRoom =
        transactionType == 'For Rent' && listingStyle == 'Room-by-Room';
    final isRentFull = transactionType == 'For Rent' && !isRentRoom;

    return CreatePropertyRequestModel(
      title: title,
      description: description,
      propertyType: _mapPropertyType(propertyType),
      listingType: apiListingType,
      category: _mapCategory(collectionCategory),
      rentalModel: _mapRentalModel(),
      intent: _mapIntent(),
      price:
          _parseDouble(
            isRentRoom
                ? (roomPrice ?? roomNightlyRate)
                : (price ?? nightlyRate),
          ) ??
          0.0,
      currency: currency,
      // districtId comes from the location cascade (stored as int in entity)
      districtId: districtId,
      street: address,
      buildingNumber: building,
      floorNumber: int.tryParse(floorNumber ?? ''),
      unitNumber: this.unit,
      latitude: latitude,
      longitude: longitude,
      bedrooms: _parseRooms(bedrooms),
      bathrooms: _parseRooms(bathrooms),
      areaSquareMeters: _parseDouble(isRentRoom ? roomArea : totalArea),
      furnishingStatus: _mapFurnishing(furnishingStatus),
      totalRooms: roomCount > 0 ? roomCount : null,
      roomType: isRentRoom ? _mapRoomType() : null,
      bedType: isRentRoom ? _mapBedType() : null,
      bedCount: isRentRoom
          ? ((singleBeds + doubleBeds + queenBeds + kingBeds) > 0
                ? (singleBeds + doubleBeds + queenBeds + kingBeds)
                : 1)
          : null,
      maxOccupants: isRentRoom ? roomCapacity : null,

      // ── Correct integer ID arrays (fixes the ID pipeline bug) ──
      amenityIds: amenityApiIds,
      ruleIds: ruleApiIds,
      nearbyFacilityIds: facilityApiIds,
      customAmenities: customAmenitiesList,
      customRules: customRulesList,
      amenities: amenityNamesList,
      rules: ruleNamesList,
      nearbyFacilities: facilityNamesList,

      houseRules: HouseRulesModel(
        quietHours: quietHoursEnabled && quietHoursStart != null
            ? QuietHoursModel(from: quietHoursStart, to: quietHoursEnd)
            : null,
      ),

      dailyPrice: _parseDouble(nightlyRate) ?? _parseDouble(roomNightlyRate),
      minStayNights:
          _parseDuration(minimumStay) ?? _parseDuration(roomMinimumStay),
      maxStayNights:
          _parseDuration(maximumStay) ?? _parseDuration(roomMaximumStay),
      checkInTime: checkInTime,
      checkOutTime: checkOutTime,

      // rentalStartDate / rentalEndDate mapped from entity
      rentalStartDate: availableFromDate,
      rentalEndDate: availableUntilDate,

      salePricing: isSale
          ? SalePricingModel(
              isNegotiable: priceNegotiable,
              paymentMethod: _mapPaymentMethod(paymentMethod),
              downPayment: _parseDouble(downPayment),
              installmentDurationMonths: _parseDuration(installmentDuration),
            )
          : null,

      rentalPricing: (isRentFull || isRentRoom)
          ? RentalPricingModel(
              securityDeposit:
                  _parseDouble(deposit) ?? _parseDouble(roomDeposit),
              minLeaseDurationMonths: _parseDuration(minimumLeaseDuration),
              rentalStartDate: availableFromDate,
              rentalEndDate: availableUntilDate,
            )
          : null,
    );
  }
}

class SetAvailabilityRequestModel {
  final String startDate;
  final String endDate;
  final bool isBlocked;
  final String? reason;

  SetAvailabilityRequestModel({
    required this.startDate,
    required this.endDate,
    this.isBlocked = true,
    this.reason,
  });

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate,
      'endDate': endDate,
      'isBlocked': isBlocked,
      'reason': reason,
    };
  }
}
