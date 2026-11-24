// ─────────────────────────────────────────────
// STATE
// ─────────────────────────────────────────────
import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class AddPropertyState {
  final File? coverImage;
  final List<File> propertyImages;
  final File? propertyVideo;
  final Map<int, double> uploadProgress;
  final List<RoomModel> rooms;
  final bool draftSaved;
  // Location fields
  final String? governorate;
  final String? city;
  final String? area;
  final String? address;
  final String? building;
  final String? floor;
  final String? unit;
  // Basic Info fields
  final String? title;
  final String? description;
  final String? transactionType;
  final String? propertyType;
  final String? collectionCategory;
  // Step 6: Listing Style
  final String listingStyle;
  // Step 4: Community Rules
  final bool quietHoursEnabled;
  final TimeOfDay? quietHoursStart;
  final TimeOfDay? quietHoursEnd;
  // Step 5: Pricing (Legacy, some fields moved to Step 3)
  final String? price;
  final String? deposit;
  final String? secondaryDescription;
  // Step 3: Pricing & Specs
  final String? currency;
  final String? maintenance;
  final bool priceIncludesCommission;
  final String? totalArea;
  final String? areaUnit; // 'm²' or 'sq ft'
  final String? bedrooms;
  final String? bathrooms;
  final String? floorNumber;
  final String? furnishingStatus;
  // Sale specific
  final String? paymentMethod;
  final bool priceNegotiable;
  final String? downPayment;
  final String? installmentDuration;
  // Rent specific
  final String? rentalPeriod;
  final String? paymentSchedule;
  final String? minimumLeaseDuration;
  final DateTime? availableFromDate;
  final DateTime? availableUntilDate;
  final String? nightlyRate;
  final String? weeklyRate;
  final String? monthlyRate;
  final String? minimumStay;
  final String? maximumStay;
  final String? checkInTime;
  final String? checkOutTime;
  // Room specific — Isolated from Full Property
  final String roomRentalPeriod;
  final String? roomPrice;
  final String? roomDeposit;
  final String? roomNightlyRate;
  final String? roomMinimumStay;
  final String? roomMaximumStay;
  final String? roomPrivacy;
  final int? roomCapacity;
  final String? roomArea;
  final String? roomAreaUnit;
  final bool listBeds;
  final int singleBeds;
  final int doubleBeds;
  final int queenBeds;
  final int kingBeds;
  // Map pin coordinates
  final double? latitude;
  final double? longitude;
  // Location IDs from Lookups cascade — used to build districtId
  final int? governorateId;
  final int? cityId;
  final int? districtId;
  // Step 4: Amenities & Generic Features
  final List<AmenityModel> selectedAmenities;
  final String amenitiesSearchQuery;
  final List<AmenityModel> selectedCommunityRules;
  final List<AmenityModel> selectedNearbyFacilities;
  // API-backed lookup lists (loaded on Bloc init from /api/v1/Lookups/*)
  final List<AmenityModel> availableAmenities;
  final List<AmenityModel> availableRules;
  final List<AmenityModel> availableNearbyFacilities;
  final List<String> availablePropertyTypes;
  // Location cascade lists
  final List<GovernorateModel> availableGovernorates;
  final List<CityModel> availableCities;
  final List<DistrictModel> availableDistricts;
  // Step 8: Availability Calendar
  final Set<DateTime> selectedDates;
  final Set<DateTime> blockedDates;
  final Set<DateTime> bookedDates;

  final int currentStep;
  final bool isPublished;
  final bool isSubmitting;
  final String? submitErrorMessage;
  final bool isLoadingLookups;

  const AddPropertyState({
    this.currentStep = 0,
    this.isPublished = false,
    this.isSubmitting = false,
    this.isLoadingLookups = false,
    this.submitErrorMessage,
    this.coverImage,
    this.propertyImages = const [],
    this.propertyVideo,
    this.uploadProgress = const {},
    this.rooms = const [],
    this.draftSaved = false,
    this.governorate,
    this.city,
    this.area,
    this.address,
    this.building,
    this.floor,
    this.unit,
    // Step 1 defaults
    this.title,
    this.description,
    this.transactionType = "For Sale",
    this.propertyType,
    this.collectionCategory = "Luxury",
    this.listingStyle = "Entire Property",
    this.quietHoursEnabled = false,
    this.quietHoursStart,
    this.quietHoursEnd,
    this.price,
    this.deposit,
    this.secondaryDescription,
    this.currency = "EGP",
    this.maintenance,
    this.priceIncludesCommission = false,
    this.totalArea,
    this.areaUnit = 'm²',
    this.bedrooms,
    this.bathrooms,
    this.floorNumber,
    this.furnishingStatus,
    this.paymentMethod = "Cash",
    this.priceNegotiable = false,
    this.downPayment,
    this.installmentDuration,
    this.rentalPeriod = "Long-Term",
    this.paymentSchedule,
    this.minimumLeaseDuration,
    this.availableFromDate,
    this.availableUntilDate,
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
    this.singleBeds = 1,
    this.doubleBeds = 0,
    this.queenBeds = 0,
    this.kingBeds = 0,
    this.latitude,
    this.longitude,
    this.governorateId,
    this.cityId,
    this.districtId,
    this.selectedAmenities = const [],
    this.amenitiesSearchQuery = '',
    this.selectedCommunityRules = const [],
    this.selectedNearbyFacilities = const [],
    this.availableAmenities = const [],
    this.availableRules = const [],
    this.availableNearbyFacilities = const [],
    this.availablePropertyTypes = const [],
    this.availableGovernorates = const [],
    this.availableCities = const [],
    this.availableDistricts = const [],
    this.selectedDates = const {},
    this.blockedDates = const {},
    this.bookedDates = const {},
  });

  bool get isLocationValid =>
      governorate != null &&
      governorate!.isNotEmpty &&
      city != null &&
      city!.isNotEmpty &&
      area != null &&
      area!.isNotEmpty &&
      latitude != null &&
      longitude != null;

  /// True if the user selected at least one Nearby Facility.
  bool get isNearbyFacilitiesValid => selectedNearbyFacilities.isNotEmpty;

  /// True if the user selected at least one Amenity AND one Community Rule.
  bool get isAmenitiesStepValid {
    // Basic validation: at least one amenity and one rule (or quiet hours)
    final hasRules = selectedCommunityRules.isNotEmpty || quietHoursEnabled;
    final quietHoursValid =
        !quietHoursEnabled ||
        (quietHoursStart != null && quietHoursEnd != null);

    return selectedAmenities.isNotEmpty && hasRules && quietHoursValid;
  }

  List<AmenityModel> get filteredAmenities {
    // Prefer API-backed list; fall back to AmenitiesData static list if not yet loaded.
    final source = availableAmenities.isNotEmpty
        ? availableAmenities
        : AmenitiesData.availableAmenities;
    if (amenitiesSearchQuery.trim().isEmpty) return source;
    return source
        .where(
          (a) => a.name.toLowerCase().contains(
            amenitiesSearchQuery.trim().toLowerCase(),
          ),
        )
        .toList();
  }

  AddPropertyState copyWith({
    int? currentStep,
    bool? isPublished,
    bool? isSubmitting,
    bool? isLoadingLookups,
    String? submitErrorMessage,
    File? coverImage,
    List<File>? propertyImages,
    File? propertyVideo,
    Map<int, double>? uploadProgress,
    List<RoomModel>? rooms,
    bool? draftSaved,
    String? governorate,
    String? city,
    String? area,
    String? address,
    String? building,
    String? floor,
    String? unit,
    String? title,
    String? description,
    String? transactionType,
    String? propertyType,
    String? collectionCategory,
    String? listingStyle,
    bool? quietHoursEnabled,
    TimeOfDay? quietHoursStart,
    TimeOfDay? quietHoursEnd,
    String? price,
    String? deposit,
    String? secondaryDescription,
    String? currency,
    String? maintenance,
    bool? priceIncludesCommission,
    String? totalArea,
    String? areaUnit,
    String? bedrooms,
    String? bathrooms,
    String? floorNumber,
    String? furnishingStatus,
    String? paymentMethod,
    bool? priceNegotiable,
    String? downPayment,
    String? installmentDuration,
    String? rentalPeriod,
    String? paymentSchedule,
    String? minimumLeaseDuration,
    DateTime? availableFromDate,
    DateTime? availableUntilDate,
    String? nightlyRate,
    String? weeklyRate,
    String? monthlyRate,
    String? minimumStay,
    String? maximumStay,
    String? checkInTime,
    String? checkOutTime,
    String? roomRentalPeriod,
    String? roomPrice,
    String? roomDeposit,
    String? roomNightlyRate,
    String? roomMinimumStay,
    String? roomMaximumStay,
    String? roomPrivacy,
    int? roomCapacity,
    String? roomArea,
    String? roomAreaUnit,
    bool? listBeds,
    int? singleBeds,
    int? doubleBeds,
    int? queenBeds,
    int? kingBeds,
    double? latitude,
    double? longitude,
    int? governorateId,
    int? cityId,
    int? districtId,
    List<AmenityModel>? selectedAmenities,
    String? amenitiesSearchQuery,
    List<AmenityModel>? selectedCommunityRules,
    List<AmenityModel>? selectedNearbyFacilities,
    List<AmenityModel>? availableAmenities,
    List<AmenityModel>? availableRules,
    List<AmenityModel>? availableNearbyFacilities,
    List<String>? availablePropertyTypes,
    List<GovernorateModel>? availableGovernorates,
    List<CityModel>? availableCities,
    List<DistrictModel>? availableDistricts,
    Set<DateTime>? selectedDates,
    Set<DateTime>? blockedDates,
    Set<DateTime>? bookedDates,
    bool clearCoverImage = false,
    bool clearPropertyVideo = false,
    bool clearGovernorate = false,
    bool clearQuietHours = false,
    bool clearCityAndDistrict = false,
  }) {
    return AddPropertyState(
      currentStep: currentStep ?? this.currentStep,
      isPublished: isPublished ?? this.isPublished,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isLoadingLookups: isLoadingLookups ?? this.isLoadingLookups,
      submitErrorMessage: submitErrorMessage ?? this.submitErrorMessage,
      coverImage: clearCoverImage ? null : (coverImage ?? this.coverImage),
      propertyImages: propertyImages ?? this.propertyImages,
      propertyVideo: clearPropertyVideo
          ? null
          : (propertyVideo ?? this.propertyVideo),
      uploadProgress: uploadProgress ?? this.uploadProgress,
      rooms: rooms ?? this.rooms,
      draftSaved: draftSaved ?? this.draftSaved,
      governorate: clearGovernorate ? null : (governorate ?? this.governorate),
      city: clearCityAndDistrict ? null : (city ?? this.city),
      area: clearCityAndDistrict ? null : (area ?? this.area),
      address: address ?? this.address,
      building: building ?? this.building,
      floor: floor ?? this.floor,
      unit: unit ?? this.unit,
      title: title ?? this.title,
      description: description ?? this.description,
      transactionType: transactionType ?? this.transactionType,
      propertyType: propertyType ?? this.propertyType,
      collectionCategory: collectionCategory ?? this.collectionCategory,
      listingStyle: listingStyle ?? this.listingStyle,
      quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
      quietHoursStart: clearQuietHours
          ? null
          : (quietHoursStart ?? this.quietHoursStart),
      quietHoursEnd: clearQuietHours
          ? null
          : (quietHoursEnd ?? this.quietHoursEnd),
      price: price ?? this.price,
      deposit: deposit ?? this.deposit,
      secondaryDescription: secondaryDescription ?? this.secondaryDescription,
      currency: currency ?? this.currency,
      maintenance: maintenance ?? this.maintenance,
      priceIncludesCommission:
          priceIncludesCommission ?? this.priceIncludesCommission,
      totalArea: totalArea ?? this.totalArea,
      areaUnit: areaUnit ?? this.areaUnit,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      floorNumber: floorNumber ?? this.floorNumber,
      furnishingStatus: furnishingStatus ?? this.furnishingStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      priceNegotiable: priceNegotiable ?? this.priceNegotiable,
      downPayment: downPayment ?? this.downPayment,
      installmentDuration: installmentDuration ?? this.installmentDuration,
      rentalPeriod: rentalPeriod ?? this.rentalPeriod,
      paymentSchedule: paymentSchedule ?? this.paymentSchedule,
      minimumLeaseDuration: minimumLeaseDuration ?? this.minimumLeaseDuration,
      availableFromDate: availableFromDate ?? this.availableFromDate,
      availableUntilDate: availableUntilDate ?? this.availableUntilDate,
      nightlyRate: nightlyRate ?? this.nightlyRate,
      weeklyRate: weeklyRate ?? this.weeklyRate,
      monthlyRate: monthlyRate ?? this.monthlyRate,
      minimumStay: minimumStay ?? this.minimumStay,
      maximumStay: maximumStay ?? this.maximumStay,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      roomRentalPeriod: roomRentalPeriod ?? this.roomRentalPeriod,
      roomPrice: roomPrice ?? this.roomPrice,
      roomDeposit: roomDeposit ?? this.roomDeposit,
      roomNightlyRate: roomNightlyRate ?? this.roomNightlyRate,
      roomMinimumStay: roomMinimumStay ?? this.roomMinimumStay,
      roomMaximumStay: roomMaximumStay ?? this.roomMaximumStay,
      roomPrivacy: roomPrivacy ?? this.roomPrivacy,
      roomCapacity: roomCapacity ?? this.roomCapacity,
      roomArea: roomArea ?? this.roomArea,
      roomAreaUnit: roomAreaUnit ?? this.roomAreaUnit,
      listBeds: listBeds ?? this.listBeds,
      singleBeds: singleBeds ?? this.singleBeds,
      doubleBeds: doubleBeds ?? this.doubleBeds,
      queenBeds: queenBeds ?? this.queenBeds,
      kingBeds: kingBeds ?? this.kingBeds,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      governorateId: clearGovernorate
          ? null
          : (governorateId ?? this.governorateId),
      cityId: clearCityAndDistrict ? null : (cityId ?? this.cityId),
      districtId: clearCityAndDistrict ? null : (districtId ?? this.districtId),
      selectedAmenities: selectedAmenities ?? this.selectedAmenities,
      amenitiesSearchQuery: amenitiesSearchQuery ?? this.amenitiesSearchQuery,
      selectedCommunityRules:
          selectedCommunityRules ?? this.selectedCommunityRules,
      selectedNearbyFacilities:
          selectedNearbyFacilities ?? this.selectedNearbyFacilities,
      availableAmenities: availableAmenities ?? this.availableAmenities,
      availableRules: availableRules ?? this.availableRules,
      availableNearbyFacilities:
          availableNearbyFacilities ?? this.availableNearbyFacilities,
      availablePropertyTypes:
          availablePropertyTypes ?? this.availablePropertyTypes,
      availableGovernorates:
          availableGovernorates ?? this.availableGovernorates,
      availableCities: availableCities ?? this.availableCities,
      availableDistricts: availableDistricts ?? this.availableDistricts,
      selectedDates: selectedDates ?? this.selectedDates,
      blockedDates: blockedDates ?? this.blockedDates,
      bookedDates: bookedDates ?? this.bookedDates,
    );
  }
}
