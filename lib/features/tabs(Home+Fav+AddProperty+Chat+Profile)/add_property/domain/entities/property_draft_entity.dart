/// A pure Domain-layer data class representing the serializable state of a
/// property draft. This is intentionally decoupled from [AddPropertyState]
/// (Presentation layer) and from any storage/API model (Data layer).
///
/// The Bloc converts [AddPropertyState] → [PropertyDraftEntity] before saving,
/// and converts [PropertyDraftEntity] → [AddPropertyState] after loading.
import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class PropertyDraftEntity {
  final int currentStep;
  final String transactionType;
  final String listingStyle;

  // ── Location ───────────────────────────────────────────────
  final String? governorate;
  final String? city;
  final String? area;
  final String? address;
  final String? building;
  final String? floor;
  final String? unit;
  final double? latitude;
  final double? longitude;

  // ── Location IDs (from Lookups cascade) ───────────────────
  // These are the integer IDs from /api/v1/Lookups/* endpoints.
  // Used to correctly populate districtId in CreatePropertyDto.
  final int? governorateId;
  final int? cityId;
  final int? districtId;

  // ── Basic Info ─────────────────────────────────────────────
  final String? title;
  final String? description;
  final String? propertyType;
  final String? collectionCategory;

  // ── Community Rules ────────────────────────────────────────
  final bool quietHoursEnabled;
  final String? quietHoursStart; // Stored as "HH:mm" string
  final String? quietHoursEnd; // Stored as "HH:mm" string

  // ── Pricing ────────────────────────────────────────────────
  final String? price;
  final String? deposit;
  final String? secondaryDescription;
  final String? currency;
  final String? maintenance;
  final bool priceIncludesCommission;
  final String? totalArea;
  final String? areaUnit;
  final String? bedrooms;
  final String? bathrooms;
  final String? floorNumber;
  final String? furnishingStatus;

  // ── Sale specific ──────────────────────────────────────────
  final String? paymentMethod;
  final bool priceNegotiable;
  final String? downPayment;
  final String? installmentDuration;

  // ── Rent Full specific ─────────────────────────────────────
  final String? rentalPeriod;
  final String? paymentSchedule;
  final String? minimumLeaseDuration;
  final String? availableFromDate; // Stored as ISO-8601 string
  final String? availableUntilDate;
  final List<String> blockedDates;
  final String? nightlyRate;
  final String? weeklyRate;
  final String? monthlyRate;
  final String? minimumStay;
  final String? maximumStay;
  final String? checkInTime;
  final String? checkOutTime;

  // ── Room specific ──────────────────────────────────────────
  final String roomRentalPeriod;
  final String? roomPrice;
  final String? roomDeposit;
  final String? roomNightlyRate;
  final String? roomMinimumStay;
  final String? roomMaximumStay;
  final String? roomPrivacy;
  final int roomCapacity;
  final String? roomArea;
  final String? roomAreaUnit;
  final bool listBeds;
  final int singleBeds;
  final int doubleBeds;
  final int queenBeds;
  final int kingBeds;

  // ── Amenities / Rules / Facilities ────────────────────────
  // Amenities: stored as comma-separated INTEGER API IDs (e.g. "5,12,8")
  // Rules/Facilities: stored as pipe-separated "id:name:codePoint" tuples
  // This format enables both UI restore AND correct API mapping.
  final String selectedAmenityIds;
  final String selectedCommunityRuleIds;
  final String selectedNearbyFacilityIds;

  // ── Media paths ─────────────────────────────────────────────
  // File paths only — validation that files still exist happens in DataSource
  final String? coverImagePath;
  final List<String> propertyImagePaths;
  final String? propertyVideoPath;

  // ── Rooms ──────────────────────────────────────────────────
  final int roomCount;
  // Each map stores the FULL API-aligned room data.
  // Keys match what addproperty_usecase.dart expects:
  // title, description, roomType, price, pricePeriod, size,
  // furnishingStatus, amenities, hasPrivateBathroom, hasBalcony,
  // capacity (maxOccupants), icon, imagePath
  final List<Map<String, dynamic>> roomsData;

  const PropertyDraftEntity({
    required this.currentStep,
    required this.transactionType,
    required this.listingStyle,
    this.governorate,
    this.city,
    this.area,
    this.address,
    this.building,
    this.floor,
    this.unit,
    this.latitude,
    this.longitude,
    this.governorateId,
    this.cityId,
    this.districtId,
    this.title,
    this.description,
    this.propertyType,
    this.collectionCategory,
    this.quietHoursEnabled = false,
    this.quietHoursStart,
    this.quietHoursEnd,
    this.price,
    this.deposit,
    this.secondaryDescription,
    this.currency = 'EGP',
    this.maintenance,
    this.priceIncludesCommission = false,
    this.totalArea,
    this.areaUnit = 'm²',
    this.bedrooms,
    this.bathrooms,
    this.floorNumber,
    this.furnishingStatus,
    this.paymentMethod = 'Cash',
    this.priceNegotiable = false,
    this.downPayment,
    this.installmentDuration,
    this.rentalPeriod,
    this.paymentSchedule,
    this.minimumLeaseDuration,
    this.availableFromDate,
    this.availableUntilDate,
    this.blockedDates = const [],
    this.nightlyRate,
    this.weeklyRate,
    this.monthlyRate,
    this.minimumStay,
    this.maximumStay,
    this.checkInTime,
    this.checkOutTime,
    this.roomRentalPeriod = 'Long-Term',
    this.roomPrice,
    this.roomDeposit,
    this.roomNightlyRate,
    this.roomMinimumStay,
    this.roomMaximumStay,
    this.roomPrivacy = 'Private Room',
    this.roomCapacity = 1,
    this.roomArea,
    this.roomAreaUnit = 'm²',
    this.listBeds = false,
    this.singleBeds = 0,
    this.doubleBeds = 0,
    this.queenBeds = 0,
    this.kingBeds = 0,
    this.selectedAmenityIds = '',
    this.selectedCommunityRuleIds = '',
    this.selectedNearbyFacilityIds = '',
    this.coverImagePath,
    this.propertyImagePaths = const [],
    this.propertyVideoPath,
    this.roomCount = 0,
    this.roomsData = const [],
  });
}
