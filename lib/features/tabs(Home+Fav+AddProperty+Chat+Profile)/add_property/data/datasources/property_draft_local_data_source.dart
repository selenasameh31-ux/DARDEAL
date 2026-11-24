
// ─────────────────────────────────────────────────────────────────────────────
// CONTRACT
// ─────────────────────────────────────────────────────────────────────────────
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
abstract class PropertyDraftLocalDataSource {
  Future<void> saveDraft(String prefix, PropertyDraftEntity entity);
  Future<PropertyDraftEntity?> loadDraft(String prefix);
  Future<void> clearDraft(String prefix);
  Future<String?> getLastActiveFlow();
  Future<void> setLastActiveFlow(String prefix);
}

// ─────────────────────────────────────────────────────────────────────────────
// IMPLEMENTATION
// All SharedPreferences keys and serialization logic live ONLY here.
// The Bloc and Repository are completely unaware of key names or storage format.
// ─────────────────────────────────────────────────────────────────────────────
class PropertyDraftLocalDataSourceImpl implements PropertyDraftLocalDataSource {
  final SharedPreferences _prefs;

  static const String _lastActiveFlowKey = 'last_active_flow';

  PropertyDraftLocalDataSourceImpl(this._prefs);

  // ── Save ──────────────────────────────────────────────────────────────────
  @override
  Future<void> saveDraft(String prefix, PropertyDraftEntity entity) async {
    await _prefs.setInt('${prefix}current_step', entity.currentStep);
    await _prefs.setString('${prefix}transaction_type', entity.transactionType);
    await _prefs.setString('${prefix}listing_style', entity.listingStyle);

    // Location — text labels
    await _prefs.setString('${prefix}governorate', entity.governorate ?? '');
    await _prefs.setString('${prefix}city', entity.city ?? '');
    await _prefs.setString('${prefix}area', entity.area ?? '');
    await _prefs.setString('${prefix}address', entity.address ?? '');
    await _prefs.setString('${prefix}building', entity.building ?? '');
    await _prefs.setString('${prefix}floor', entity.floor ?? '');
    await _prefs.setString('${prefix}unit', entity.unit ?? '');
    if (entity.latitude != null) {
      await _prefs.setDouble('${prefix}latitude', entity.latitude!);
    } else {
      await _prefs.remove('${prefix}latitude');
    }
    if (entity.longitude != null) {
      await _prefs.setDouble('${prefix}longitude', entity.longitude!);
    } else {
      await _prefs.remove('${prefix}longitude');
    }
    // Location — API integer IDs (for districtId in CreatePropertyDto)
    if (entity.governorateId != null) {
      await _prefs.setInt('${prefix}governorate_id', entity.governorateId!);
    } else {
      await _prefs.remove('${prefix}governorate_id');
    }
    if (entity.cityId != null) {
      await _prefs.setInt('${prefix}city_id', entity.cityId!);
    } else {
      await _prefs.remove('${prefix}city_id');
    }
    if (entity.districtId != null) {
      await _prefs.setInt('${prefix}district_id', entity.districtId!);
    } else {
      await _prefs.remove('${prefix}district_id');
    }

    // Basic Info
    await _prefs.setString('${prefix}title', entity.title ?? '');
    await _prefs.setString('${prefix}description', entity.description ?? '');
    await _prefs.setString('${prefix}property_type', entity.propertyType ?? '');
    await _prefs.setString(
      '${prefix}collection_category',
      entity.collectionCategory ?? '',
    );

    // Community Rules
    await _prefs.setBool('${prefix}quiet_hours_enabled', entity.quietHoursEnabled);
    await _prefs.setString('${prefix}quiet_hours_start', entity.quietHoursStart ?? '');
    await _prefs.setString('${prefix}quiet_hours_end', entity.quietHoursEnd ?? '');

    // Pricing
    await _prefs.setString('${prefix}price', entity.price ?? '');
    await _prefs.setString('${prefix}deposit', entity.deposit ?? '');
    await _prefs.setString(
      '${prefix}secondary_description',
      entity.secondaryDescription ?? '',
    );
    await _prefs.setString('${prefix}currency', entity.currency ?? 'EGP');
    await _prefs.setString('${prefix}maintenance', entity.maintenance ?? '');
    await _prefs.setBool(
      '${prefix}price_includes_commission',
      entity.priceIncludesCommission,
    );
    await _prefs.setString('${prefix}total_area', entity.totalArea ?? '');
    await _prefs.setString('${prefix}area_unit', entity.areaUnit ?? 'm²');
    await _prefs.setString('${prefix}bedrooms', entity.bedrooms ?? '');
    await _prefs.setString('${prefix}bathrooms', entity.bathrooms ?? '');
    await _prefs.setString('${prefix}floor_number', entity.floorNumber ?? '');
    await _prefs.setString(
      '${prefix}furnishing_status',
      entity.furnishingStatus ?? '',
    );

    // Sale-specific
    await _prefs.setString('${prefix}payment_method', entity.paymentMethod ?? 'Cash');
    await _prefs.setBool('${prefix}price_negotiable', entity.priceNegotiable);
    await _prefs.setString('${prefix}down_payment', entity.downPayment ?? '');
    await _prefs.setString(
      '${prefix}installment_duration',
      entity.installmentDuration ?? '',
    );

    // Rent-specific
    await _prefs.setString('${prefix}rental_period', entity.rentalPeriod ?? '');
    await _prefs.setString('${prefix}payment_schedule', entity.paymentSchedule ?? '');
    await _prefs.setString(
      '${prefix}minimum_lease_duration',
      entity.minimumLeaseDuration ?? '',
    );
    await _prefs.setString(
      '${prefix}available_from_date',
      entity.availableFromDate ?? '',
    );
    await _prefs.setString(
      '${prefix}available_until_date',
      entity.availableUntilDate ?? '',
    );
    await _prefs.setStringList('${prefix}blocked_dates', entity.blockedDates);
    await _prefs.setString('${prefix}nightly_rate', entity.nightlyRate ?? '');
    await _prefs.setString('${prefix}weekly_rate', entity.weeklyRate ?? '');
    await _prefs.setString('${prefix}monthly_rate', entity.monthlyRate ?? '');
    await _prefs.setString('${prefix}minimum_stay', entity.minimumStay ?? '');
    await _prefs.setString('${prefix}maximum_stay', entity.maximumStay ?? '');
    await _prefs.setString('${prefix}check_in_time', entity.checkInTime ?? '');
    await _prefs.setString('${prefix}check_out_time', entity.checkOutTime ?? '');

    // Room-specific
    await _prefs.setString('${prefix}room_rental_period', entity.roomRentalPeriod);
    await _prefs.setString('${prefix}room_price', entity.roomPrice ?? '');
    await _prefs.setString('${prefix}room_deposit', entity.roomDeposit ?? '');
    await _prefs.setString('${prefix}room_nightly_rate', entity.roomNightlyRate ?? '');
    await _prefs.setString('${prefix}room_minimum_stay', entity.roomMinimumStay ?? '');
    await _prefs.setString('${prefix}room_maximum_stay', entity.roomMaximumStay ?? '');
    await _prefs.setString(
      '${prefix}room_privacy',
      entity.roomPrivacy ?? 'Private Room',
    );
    await _prefs.setInt('${prefix}room_capacity', entity.roomCapacity);
    await _prefs.setString('${prefix}room_area', entity.roomArea ?? '');
    await _prefs.setString('${prefix}room_area_unit', entity.roomAreaUnit ?? 'm²');
    await _prefs.setBool('${prefix}list_beds', entity.listBeds);
    await _prefs.setInt('${prefix}single_beds', entity.singleBeds);
    await _prefs.setInt('${prefix}double_beds', entity.doubleBeds);
    await _prefs.setInt('${prefix}queen_beds', entity.queenBeds);
    await _prefs.setInt('${prefix}king_beds', entity.kingBeds);

    // Amenities / Rules / Facilities
    await _prefs.setString(
      '${prefix}selected_amenities',
      entity.selectedAmenityIds,
    );
    await _prefs.setString(
      '${prefix}selected_community_rules',
      entity.selectedCommunityRuleIds,
    );
    await _prefs.setString(
      '${prefix}selected_nearby_facilities',
      entity.selectedNearbyFacilityIds,
    );

    // Media paths
    await _prefs.setStringList(
      '${prefix}property_images',
      entity.propertyImagePaths,
    );
    if (entity.coverImagePath != null) {
      await _prefs.setString('${prefix}cover_image', entity.coverImagePath!);
    } else {
      await _prefs.remove('${prefix}cover_image');
    }
    if (entity.propertyVideoPath != null) {
      await _prefs.setString('${prefix}property_video', entity.propertyVideoPath!);
    } else {
      await _prefs.remove('${prefix}property_video');
    }

    // Rooms
    await _prefs.setInt('${prefix}room_count', entity.roomCount);
    for (int i = 0; i < entity.roomsData.length; i++) {
      final r = entity.roomsData[i];
      await _prefs.setString('${prefix}room_${i}_id', r['id'] ?? '');
      await _prefs.setString('${prefix}room_${i}_title', r['title'] ?? '');
      await _prefs.setInt('${prefix}room_${i}_capacity', (r['capacity'] as int?) ?? 1);
      await _prefs.setDouble('${prefix}room_${i}_size', (r['size'] as double?) ?? 0.0);
      await _prefs.setDouble('${prefix}room_${i}_price', (r['price'] as double?) ?? 0.0);
      await _prefs.setInt('${prefix}room_${i}_icon', (r['icon'] as int?) ?? Icons.room.codePoint);
      final imagePath = r['imagePath'] as String?;
      if (imagePath != null) {
        await _prefs.setString('${prefix}room_${i}_imagePath', imagePath);
      } else {
        await _prefs.remove('${prefix}room_${i}_imagePath');
      }
    }

    await _prefs.setBool('${prefix}saved', true);
  }

  // ── Load ──────────────────────────────────────────────────────────────────
  @override
  Future<PropertyDraftEntity?> loadDraft(String prefix) async {
    final hasDraft = _prefs.getBool('${prefix}saved') ?? false;
    if (!hasDraft) return null;

    // Rooms
    final roomCount = _prefs.getInt('${prefix}room_count') ?? 0;
    final roomsData = <Map<String, dynamic>>[];
    for (int i = 0; i < roomCount; i++) {
      roomsData.add({
        'id': _prefs.getString('${prefix}room_${i}_id') ?? '',
        'title': _prefs.getString('${prefix}room_${i}_title') ?? '',
        'capacity': _prefs.getInt('${prefix}room_${i}_capacity') ?? 1,
        'size': _prefs.getDouble('${prefix}room_${i}_size') ?? 0.0,
        'price': _prefs.getDouble('${prefix}room_${i}_price') ?? 0.0,
        'icon': _prefs.getInt('${prefix}room_${i}_icon') ?? Icons.room.codePoint,
        'imagePath': _prefs.getString('${prefix}room_${i}_imagePath'),
      });
    }

    return PropertyDraftEntity(
      currentStep: _prefs.getInt('${prefix}current_step') ?? 0,
      transactionType:
          _prefs.getString('${prefix}transaction_type') ?? 'For Sale',
      listingStyle:
          _prefs.getString('${prefix}listing_style') ?? 'Entire Property',
      governorate: _string('${prefix}governorate'),
      city: _string('${prefix}city'),
      area: _string('${prefix}area'),
      address: _string('${prefix}address'),
      building: _string('${prefix}building'),
      floor: _string('${prefix}floor'),
      unit: _string('${prefix}unit'),
      latitude: _prefs.getDouble('${prefix}latitude'),
      longitude: _prefs.getDouble('${prefix}longitude'),
      governorateId: _prefs.getInt('${prefix}governorate_id'),
      cityId: _prefs.getInt('${prefix}city_id'),
      districtId: _prefs.getInt('${prefix}district_id'),
      title: _string('${prefix}title'),
      description: _string('${prefix}description'),
      propertyType: _string('${prefix}property_type'),
      collectionCategory: _string('${prefix}collection_category'),
      quietHoursEnabled: _prefs.getBool('${prefix}quiet_hours_enabled') ?? false,
      quietHoursStart: _string('${prefix}quiet_hours_start'),
      quietHoursEnd: _string('${prefix}quiet_hours_end'),
      price: _string('${prefix}price'),
      deposit: _string('${prefix}deposit'),
      secondaryDescription: _string('${prefix}secondary_description'),
      currency: _prefs.getString('${prefix}currency') ?? 'EGP',
      maintenance: _string('${prefix}maintenance'),
      priceIncludesCommission:
          _prefs.getBool('${prefix}price_includes_commission') ?? false,
      totalArea: _string('${prefix}total_area'),
      areaUnit: _prefs.getString('${prefix}area_unit') ?? 'm²',
      bedrooms: _string('${prefix}bedrooms'),
      bathrooms: _string('${prefix}bathrooms'),
      floorNumber: _string('${prefix}floor_number'),
      furnishingStatus: _string('${prefix}furnishing_status'),
      paymentMethod: _prefs.getString('${prefix}payment_method') ?? 'Cash',
      priceNegotiable: _prefs.getBool('${prefix}price_negotiable') ?? false,
      downPayment: _string('${prefix}down_payment'),
      installmentDuration: _string('${prefix}installment_duration'),
      rentalPeriod: _string('${prefix}rental_period'),
      paymentSchedule: _string('${prefix}payment_schedule'),
      minimumLeaseDuration: _string('${prefix}minimum_lease_duration'),
      availableFromDate: _string('${prefix}available_from_date'),
      availableUntilDate: _string('${prefix}available_until_date'),
      blockedDates: _prefs.getStringList('${prefix}blocked_dates') ?? [],
      nightlyRate: _string('${prefix}nightly_rate'),
      weeklyRate: _string('${prefix}weekly_rate'),
      monthlyRate: _string('${prefix}monthly_rate'),
      minimumStay: _string('${prefix}minimum_stay'),
      maximumStay: _string('${prefix}maximum_stay'),
      checkInTime: _string('${prefix}check_in_time'),
      checkOutTime: _string('${prefix}check_out_time'),
      roomRentalPeriod:
          _prefs.getString('${prefix}room_rental_period') ?? 'Long-Term',
      roomPrice: _string('${prefix}room_price'),
      roomDeposit: _string('${prefix}room_deposit'),
      roomNightlyRate: _string('${prefix}room_nightly_rate'),
      roomMinimumStay: _string('${prefix}room_minimum_stay'),
      roomMaximumStay: _string('${prefix}room_maximum_stay'),
      roomPrivacy: _prefs.getString('${prefix}room_privacy') ?? 'Private Room',
      roomCapacity: _prefs.getInt('${prefix}room_capacity') ?? 1,
      roomArea: _string('${prefix}room_area'),
      roomAreaUnit: _prefs.getString('${prefix}room_area_unit') ?? 'm²',
      listBeds: _prefs.getBool('${prefix}list_beds') ?? false,
      singleBeds: _prefs.getInt('${prefix}single_beds') ?? 0,
      doubleBeds: _prefs.getInt('${prefix}double_beds') ?? 0,
      queenBeds: _prefs.getInt('${prefix}queen_beds') ?? 0,
      kingBeds: _prefs.getInt('${prefix}king_beds') ?? 0,
      selectedAmenityIds: _prefs.getString('${prefix}selected_amenities') ?? '',
      selectedCommunityRuleIds:
          _prefs.getString('${prefix}selected_community_rules') ?? '',
      selectedNearbyFacilityIds:
          _prefs.getString('${prefix}selected_nearby_facilities') ?? '',
      coverImagePath: _prefs.getString('${prefix}cover_image'),
      propertyImagePaths:
          _prefs.getStringList('${prefix}property_images') ?? [],
      propertyVideoPath: _prefs.getString('${prefix}property_video'),
      roomCount: roomCount,
      roomsData: roomsData,
    );
  }

  // ── Clear ─────────────────────────────────────────────────────────────────
  @override
  Future<void> clearDraft(String prefix) async {
    final keys = _prefs.getKeys().where((k) => k.startsWith(prefix)).toList();
    for (final key in keys) {
      await _prefs.remove(key);
    }
  }

  // ── Last Active Flow ──────────────────────────────────────────────────────
  @override
  Future<String?> getLastActiveFlow() async {
    return _prefs.getString(_lastActiveFlowKey);
  }

  @override
  Future<void> setLastActiveFlow(String prefix) async {
    await _prefs.setString(_lastActiveFlowKey, prefix);
  }

  // ── Private helpers ───────────────────────────────────────────────────────
  /// Returns null for empty strings so nullable fields remain null in state.
  String? _string(String key) {
    final val = _prefs.getString(key);
    return (val == null || val.isEmpty) ? null : val;
  }
}
