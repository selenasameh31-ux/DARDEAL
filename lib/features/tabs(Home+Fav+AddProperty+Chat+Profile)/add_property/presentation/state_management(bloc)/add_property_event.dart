// ─────────────────────────────────────────────
// EVENTS
// ─────────────────────────────────────────────
import 'package:graduation_project_flutter/core/routing/routes_export.dart';

abstract class AddPropertyEvent {}

class SubmitPropertyEvent extends AddPropertyEvent {}

// Image & Video Events
class AddPropertyImagesPickedEvent extends AddPropertyEvent {
  final List<File> newImages;
  AddPropertyImagesPickedEvent(this.newImages);
}

class ReorderPropertyImagesEvent extends AddPropertyEvent {
  final int oldIndex;
  final int newIndex;
  ReorderPropertyImagesEvent(this.oldIndex, this.newIndex);
}

class AddPropertyVideoEvent extends AddPropertyEvent {
  final File file;
  final Function(String)? onError;
  AddPropertyVideoEvent(this.file, {this.onError});
}

class RemovePropertyVideoEvent extends AddPropertyEvent {}

class RemovePropertyImageEvent extends AddPropertyEvent {
  final int index;
  RemovePropertyImageEvent(this.index);
}

class EditPropertyImageEvent extends AddPropertyEvent {
  final int index;
  final File newImage;
  EditPropertyImageEvent(this.index, this.newImage);
}

class SetCoverImageEvent extends AddPropertyEvent {
  final int index;
  SetCoverImageEvent(this.index);
}

class UpdateUploadProgressEvent extends AddPropertyEvent {
  final int index;
  final double? progress; // null means remove
  UpdateUploadProgressEvent(this.index, this.progress);
}

// Room Events
class AddRoomEvent extends AddPropertyEvent {
  final RoomModel room;
  AddRoomEvent(this.room);
}

class EditRoomEvent extends AddPropertyEvent {
  final int index;
  final RoomModel updated;
  EditRoomEvent(this.index, this.updated);
}

class DeleteRoomEvent extends AddPropertyEvent {
  final int index;
  DeleteRoomEvent(this.index);
}

// Draft Event
class SaveDraftEvent extends AddPropertyEvent {}

class ResetStateEvent extends AddPropertyEvent {}

class UpdateCurrentStepEvent extends AddPropertyEvent {
  final int step;
  final bool saveDraft;
  UpdateCurrentStepEvent(this.step, {this.saveDraft = true});
}

class LoadDraftEvent extends AddPropertyEvent {
  final String? transactionType;
  final String? listingStyle;
  LoadDraftEvent({this.transactionType, this.listingStyle});
}

class ClearDraftEvent extends AddPropertyEvent {
  final String transactionType;
  final String listingStyle;
  ClearDraftEvent(this.transactionType, this.listingStyle);
}

class SwitchFlowEvent extends AddPropertyEvent {
  final String transactionType;
  final String listingStyle;
  SwitchFlowEvent(this.transactionType, this.listingStyle);
}

// Location Event
class LocationUpdateEvent extends AddPropertyEvent {
  final String? governorate;
  final String? city;
  final String? area;
  final String? address;
  final String? building;
  final String? floor;
  final String? unit;
  // Optional integer IDs from the Lookups cascade
  final int? governorateId;
  final int? cityId;
  final int? districtId;
  final bool clearCityAndDistrict;

  LocationUpdateEvent({
    this.governorate,
    this.city,
    this.area,
    this.address,
    this.building,
    this.floor,
    this.unit,
    this.governorateId,
    this.cityId,
    this.districtId,
    this.clearCityAndDistrict = false,
  });
}

// Lookup Events
class LoadLookupsEvent extends AddPropertyEvent {}

class LoadCitiesEvent extends AddPropertyEvent {
  final int governorateId;
  LoadCitiesEvent(this.governorateId);
}

class LoadDistrictsEvent extends AddPropertyEvent {
  final int cityId;
  LoadDistrictsEvent(this.cityId);
}

// Basic Info Event
class UpdateBasicInfoEvent extends AddPropertyEvent {
  final String? title;
  final String? description;
  final String? transactionType;
  final String? propertyType;
  final String? collectionCategory;
  UpdateBasicInfoEvent({
    this.title,
    this.description,
    this.transactionType,
    this.propertyType,
    this.collectionCategory,
  });
}

// Listing Style Event
class UpdateListingStyleEvent extends AddPropertyEvent {
  final String style;
  UpdateListingStyleEvent(this.style);
}

// Community Rules Event
class UpdateCommunityRulesEvent extends AddPropertyEvent {
  final bool? quietHoursEnabled;
  final TimeOfDay? quietHoursStart;
  final TimeOfDay? quietHoursEnd;
  UpdateCommunityRulesEvent({
    this.quietHoursEnabled,
    this.quietHoursStart,
    this.quietHoursEnd,
  });
}

// Pricing Event
class UpdatePricingEvent extends AddPropertyEvent {
  final String? price;
  final String? deposit;
  final String? secondaryDescription;
  UpdatePricingEvent({this.price, this.deposit, this.secondaryDescription});
}

// Pricing & Specs Event (Step 3)
class UpdatePricingAndSpecsEvent extends AddPropertyEvent {
  final String? currency;
  final String? price;
  final String? deposit;
  final String? maintenance;
  final bool? priceIncludesCommission;
  final String? downPayment;
  final String? installmentDuration;
  final String? totalArea;
  final String? bedrooms;
  final String? bathrooms;
  final String? furnishingStatus;
  final String? paymentMethod;
  final bool? priceNegotiable;

  UpdatePricingAndSpecsEvent({
    this.currency,
    this.price,
    this.deposit,
    this.maintenance,
    this.priceIncludesCommission,
    this.downPayment,
    this.installmentDuration,
    this.totalArea,
    this.bedrooms,
    this.bathrooms,
    this.furnishingStatus,
    this.paymentMethod,
    this.priceNegotiable,
  });
}

// Rental Pricing Event
class UpdateRentalPricingEvent extends AddPropertyEvent {
  final String? currency;
  final String? rentPrice;
  final String? rentalPeriod;
  final String? deposit;
  final String? paymentSchedule;
  final bool? priceIncludesCommission;
  final String? totalArea;
  final String? bedrooms;
  final String? bathrooms;
  final String? furnishingStatus;

  // New fields for Rent Full Property
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

  UpdateRentalPricingEvent({
    this.currency,
    this.rentPrice,
    this.rentalPeriod,
    this.deposit,
    this.paymentSchedule,
    this.priceIncludesCommission,
    this.totalArea,
    this.bedrooms,
    this.bathrooms,
    this.furnishingStatus,
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
  });
}

// Room Pricing Event
class UpdateRoomPricingEvent extends AddPropertyEvent {
  final String? roomRentalPeriod;
  final String? roomPrice;
  final String? roomDeposit;
  final String? roomNightlyRate;
  final String? roomMinimumStay;
  final String? roomMaximumStay;
  final String? roomPrivacy;
  final int? roomCapacity;
  final String? roomArea;
  final String? roomAreaUnit;
  final bool? listBeds;
  final int? singleBeds;
  final int? doubleBeds;
  final int? queenBeds;
  final int? kingBeds;

  UpdateRoomPricingEvent({
    this.roomRentalPeriod,
    this.roomPrice,
    this.roomDeposit,
    this.roomNightlyRate,
    this.roomMinimumStay,
    this.roomMaximumStay,
    this.roomPrivacy,
    this.roomCapacity,
    this.roomArea,
    this.roomAreaUnit,
    this.listBeds,
    this.singleBeds,
    this.doubleBeds,
    this.queenBeds,
    this.kingBeds,
  });
}

// Specs Event (standalone step — used by SpecsStep)
class UpdateSpecsEvent extends AddPropertyEvent {
  final String? totalArea;
  final String? areaUnit; // 'm²' or 'sq ft'
  final String? bedrooms;
  final String? bathrooms;
  final String? floorNumber;
  final String? furnishingStatus;

  UpdateSpecsEvent({
    this.totalArea,
    this.areaUnit,
    this.bedrooms,
    this.bathrooms,
    this.floorNumber,
    this.furnishingStatus,
  });
}

// Map Pin Location Event
class MapLocationUpdateEvent extends AddPropertyEvent {
  final double latitude;
  final double longitude;
  MapLocationUpdateEvent({required this.latitude, required this.longitude});
}

// Amenities Event
class SearchAmenitiesEvent extends AddPropertyEvent {
  final String query;
  SearchAmenitiesEvent(this.query);
}

class UpdateSelectedAmenitiesEvent extends AddPropertyEvent {
  final List<AmenityModel> amenities;
  UpdateSelectedAmenitiesEvent(this.amenities);
}

class UpdateCommunityRulesSelectionEvent extends AddPropertyEvent {
  final List<AmenityModel> rules;
  UpdateCommunityRulesSelectionEvent(this.rules);
}

class UpdateNearbyFacilitiesSelectionEvent extends AddPropertyEvent {
  final List<AmenityModel> facilities;
  UpdateNearbyFacilitiesSelectionEvent(this.facilities);
}

// Calendar Events
class ToggleCalendarDateEvent extends AddPropertyEvent {
  final DateTime date;
  ToggleCalendarDateEvent(this.date);
}

class BlockWeekendsEvent extends AddPropertyEvent {
  final int month;
  final int year;
  BlockWeekendsEvent(this.month, this.year);
}

class ClearMonthEvent extends AddPropertyEvent {
  final int month;
  final int year;
  ClearMonthEvent(this.month, this.year);
}

class BlockSelectedDatesEvent extends AddPropertyEvent {}

class BookSelectedDatesEvent extends AddPropertyEvent {}

class UnblockSelectedDatesEvent extends AddPropertyEvent {}
