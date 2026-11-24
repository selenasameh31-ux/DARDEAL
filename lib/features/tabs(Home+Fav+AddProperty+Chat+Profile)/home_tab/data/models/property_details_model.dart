import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class PropertyDetailsModel {
  final int id;
  final String? title;
  final String? description;
  final String? propertyType;
  final String? listingType;
  final String? category;
  final String? rentalModel;
  final String? intent;
  final double? price;
  final String? currency;
  final int? districtId;
  final String? governorate;
  final String? city;
  final String? district;
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
  final List<String>? customAmenities;
  final List<String>? customRules;
  final List<String>? amenities;
  final double? dailyPrice;
  final int? minStayNights;
  final int? maxStayNights;
  final String? checkInTime;
  final String? checkOutTime;
  final String? rentalStartDate;
  final String? rentalEndDate;
  final Map<String, dynamic>? salePricing;
  final Map<String, dynamic>? rentalPricing;
  final String? roomType;
  final String? bedType;
  final int? bedCount;
  final int? maxOccupants;
  final bool? hasPrivateBathroom;
  final bool? hasBalcony;
  final Map<String, dynamic>? preferences;
  final Map<String, dynamic>? owner;
  final List<String>? mediaUrls;
  final List<dynamic>? nearbyFacilities;

  PropertyDetailsModel({
    required this.id,
    this.title,
    this.description,
    this.propertyType,
    this.listingType,
    this.category,
    this.rentalModel,
    this.intent,
    this.price,
    this.currency,
    this.districtId,
    this.governorate,
    this.city,
    this.district,
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
    this.customAmenities,
    this.customRules,
    this.amenities,
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
    this.owner,
    this.mediaUrls,
    this.nearbyFacilities,
  });

  factory PropertyDetailsModel.fromJson(Map<String, dynamic> json) {
    final location = json['location'] as Map<String, dynamic>?;
    final specs = json['specs'] as Map<String, dynamic>?;

    List<String>? parsedMediaUrls;
    final dynamic rawMedia = json['media'] ?? json['mediaUrls'] ?? json['images'] ?? json['imageUrls'];
    if (rawMedia is List) {
      parsedMediaUrls = rawMedia.map((e) => _getFullImageUrl(e)).toList();
    }

    Map<String, dynamic>? parsedOwner;
    if (json['owner'] != null) {
      parsedOwner = Map<String, dynamic>.from(json['owner']);
      final String? photoUrl = parsedOwner['profilePhoto'] ?? parsedOwner['avatar'] ?? parsedOwner['photo'];
      if (photoUrl != null) {
        parsedOwner['profilePhoto'] = _getFullImageUrl(photoUrl);
      }
    }

    return PropertyDetailsModel(
      id: json['id'] ?? 0,
      title: json['title'],
      description: json['description'],
      propertyType: json['propertyType'],
      listingType: json['listingType'],
      category: json['category'],
      rentalModel: json['rentalModel'],
      intent: json['intent'],
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      currency: json['currency'],
      districtId: location?['districtId'] ?? json['districtId'],
      governorate: location?['governorate'] ?? json['governorate'],
      city: location?['city'] ?? json['city'],
      district: location?['district'] ?? json['district'],
      street: location?['street'] ?? json['street'],
      buildingNumber: location?['buildingNumber'] ?? json['buildingNumber'],
      floorNumber: _parseInt(specs?['floorNumber'] ?? json['floorNumber']),
      unitNumber: location?['unitNumber'] ?? json['unitNumber'],
      latitude: _parseDouble(location?['latitude'] ?? json['latitude']),
      longitude: _parseDouble(location?['longitude'] ?? json['longitude']),
      bedrooms: _parseInt(specs?['bedrooms'] ?? json['bedrooms'] ?? json['beds']),
      bathrooms: _parseInt(specs?['bathrooms'] ?? json['bathrooms'] ?? json['baths']),
      areaSquareMeters: _parseDouble(specs?['areaSquareMeters'] ?? json['areaSquareMeters'] ?? json['totalArea'] ?? json['area']),
      furnishingStatus: specs?['furnishingStatus'] ?? json['furnishingStatus'],
      totalRooms: _parseInt(json['totalRooms']),
      customAmenities: json['customAmenities'] != null ? List<String>.from(json['customAmenities']) : null,
      customRules: json['customRules'] != null ? List<String>.from(json['customRules']) : null,
      amenities: json['amenities'] != null ? List<String>.from(json['amenities']) : null,
      dailyPrice: json['dailyPrice'] != null ? (json['dailyPrice'] as num).toDouble() : null,
      minStayNights: _parseInt(json['minStayNights']),
      maxStayNights: _parseInt(json['maxStayNights']),
      checkInTime: json['checkInTime'],
      checkOutTime: json['checkOutTime'],
      rentalStartDate: json['rentalStartDate'],
      rentalEndDate: json['rentalEndDate'],
      salePricing: json['salePricing'],
      rentalPricing: json['rentalPricing'],
      roomType: json['roomType'],
      bedType: json['bedType'],
      bedCount: _parseInt(json['bedCount']),
      maxOccupants: _parseInt(json['maxOccupants']),
      hasPrivateBathroom: json['hasPrivateBathroom'],
      hasBalcony: json['hasBalcony'],
      preferences: json['preferences'],
      owner: parsedOwner,
      mediaUrls: parsedMediaUrls,
      nearbyFacilities: location?['nearbyFacilities'] ?? json['nearbyFacilities'],
    );
  }

  static String _getFullImageUrl(dynamic path) {
    if (path == null || path.toString().isEmpty) return '';
    String url = path.toString();
    if (url.startsWith('http')) return url;
    if (!url.startsWith('/')) url = '/$url';
    return '${EndPoints.baseUrl}$url';
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
