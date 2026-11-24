import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class WishlistItemModel {
  final int propertyId;
  final String? title;
  final String? location;
  final String? propertyType;
  final String? listingType; // Sale / Rent / ShortTermRent / RentRoom
  final String? rentalModel;
  final String? roomType;
  final double? price;
  final double? dailyPrice;
  final double? rating;
  final String? imageUrl;
  final Map<String, dynamic>? salePricing;
  final Map<String, dynamic>? rentalPricing;
  final int? minStayNights;
  final String? note;

  WishlistItemModel({
    required this.propertyId,
    this.title,
    this.location,
    this.propertyType,
    this.listingType,
    this.rentalModel,
    this.roomType,
    this.price,
    this.dailyPrice,
    this.rating,
    this.imageUrl,
    this.salePricing,
    this.rentalPricing,
    this.minStayNights,
    this.note,
  });

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    final property = json['property'] as Map<String, dynamic>? ?? json;

    String? safeString(String key1, [String? key2, String? key3]) {
      for (final key in [key1, if (key2 != null) key2, if (key3 != null) key3]) {
        final v = property[key] ?? json[key];
        if (v != null && v.toString().trim().isNotEmpty) return v.toString().trim();
      }
      return null;
    }

    // Location: may come as String or Map
    String? parsedLocation;
    final loc = property['location'] ?? json['location'];
    if (loc is String && loc.trim().isNotEmpty) {
      parsedLocation = loc.trim();
    } else if (loc is Map) {
      final parts = [loc['district'], loc['city']].where((e) => e != null && e.toString().trim().isNotEmpty).join(', ');
      if (parts.isNotEmpty) parsedLocation = parts;
    }

    // Smart listingType resolution
    String? resolvedListingType = safeString('listingType', 'intent', 'transactionType');
    if (resolvedListingType == null || resolvedListingType.isEmpty) {
      final hasSale = property['salePricing'] != null || json['salePricing'] != null;
      final hasDaily = _parseDouble(property['dailyPrice'] ?? json['dailyPrice']) != null;
      final rm = (property['rentalModel'] ?? json['rentalModel'])?.toString().toLowerCase() ?? '';
      if (hasSale) {
        resolvedListingType = 'Sale';
      } else if (hasDaily) {
        resolvedListingType = 'ShortTermRent';
      } else if (rm.contains('room')) {
        resolvedListingType = 'RentRoom';
      }
    }

    return WishlistItemModel(
      propertyId: json['propertyId'] ?? json['id'] ?? property['id'] ?? 0,
      title: safeString('title'),
      location: parsedLocation ?? safeString('address', 'street'),
      propertyType: safeString('propertyType', 'category'),
      listingType: resolvedListingType,
      rentalModel: safeString('rentalModel'),
      roomType: safeString('roomType'),
      price: _parseDouble(property['price'] ?? json['price']),
      dailyPrice: _parseDouble(property['dailyPrice'] ?? json['dailyPrice']),
      rating: _parseDouble(
        property['rating'] ?? json['rating'] ??
        property['averageRating'] ?? json['averageRating'] ??
        (property['reviews'] is Map ? property['reviews']['averageRating'] : null) ??
        (json['reviews'] is Map ? json['reviews']['averageRating'] : null),
      ),
      imageUrl: _getFullImageUrl(
        property['coverPhoto'] ??
            json['coverPhoto'] ??
            property['imageUrl'] ??
            json['imageUrl'] ??
            property['mainImage'] ??
            json['mainImage'] ??
            property['image'] ??
            json['image'] ??
            ((property['images'] != null && property['images'] is List && (property['images'] as List).isNotEmpty)
                ? property['images'][0]
                : null) ??
            ((json['images'] != null && json['images'] is List && (json['images'] as List).isNotEmpty)
                ? json['images'][0]
                : null) ??
            ((property['media'] != null && property['media'] is List && (property['media'] as List).isNotEmpty)
                ? property['media'][0]
                : null) ??
            ((json['media'] != null && json['media'] is List && (json['media'] as List).isNotEmpty)
                ? json['media'][0]
                : null),
      ),
      salePricing: property['salePricing'] as Map<String, dynamic>?,
      rentalPricing: property['rentalPricing'] as Map<String, dynamic>?,
      minStayNights: property['minStayNights'] ?? json['minStayNights'],
      note: safeString('note', 'description'),
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static String? _getFullImageUrl(dynamic path) {
    if (path == null) return null;
    String url = path.toString().trim();
    if (url.isEmpty) return null;
    
    // Check if the string itself resembles a map or list, avoid returning "Map<...>" or "[...]"
    if (url.startsWith('{') || url.startsWith('[')) return null;

    if (url.startsWith('http')) return url;
    if (!url.startsWith('/')) url = '/$url';
    return '${EndPoints.baseUrl}$url';
  }

  // ─── Computed getters ────────────────────────────────────────────────────────

  /// For Sale / For Rent badge label
  String get transactionTypeLabel {
    if (listingType == null || listingType!.trim().isEmpty) {
      return salePricing != null ? 'For Sale' : 'For Rent';
    }
    switch (listingType!.toLowerCase().trim()) {
      case 'sale':
      case 'buy':
      case 'forsale':
        return 'For Sale';
      case 'rent':
      case 'forrent':
      case 'shorttermrent':
      case 'rentroom':
      case 'rentfullproperty':
      default:
        if (listingType!.toLowerCase().contains('sale') ||
            listingType!.toLowerCase().contains('buy')) {
          return 'For Sale';
        }
        return 'For Rent';
    }
  }

  /// Price string shown in the card
  String get displayPrice {
    final isSale = transactionTypeLabel == 'For Sale';
    if (isSale) return '${_formatNum(price ?? 0)} EGP';
    if (dailyPrice != null && dailyPrice! > 0) return '${_formatNum(dailyPrice!)} EGP / night';
    return '${_formatNum(price ?? 0)} EGP';
  }

  /// Price without unit suffix (used with separate /mo or /night widget)
  String get displayPriceOnly {
    final p = dailyPrice ?? price ?? 0.0;
    return '${_formatNum(p)} EGP';
  }

  /// True → show /mo suffix. False → sale or nightly
  bool get isMonthlyRent {
    if (transactionTypeLabel == 'For Sale') return false;
    if (dailyPrice != null && dailyPrice! > 0) return false;
    return true;
  }

  String get displayTitle => title ?? 'Unknown Property';
  String get displayLocation => location ?? 'Unknown Location';
  double get displayRating => rating ?? 0.0;
  String get displayRatingLabel {
    if (rating != null && rating! > 0) return rating!.toStringAsFixed(1);
    return 'Unrated';
  }

  String get displayType {
    final pt = propertyType?.toLowerCase().trim() ?? '';
    if (pt == 'room' || pt == 'rooms') {
      final rt = roomType?.toLowerCase().trim() ?? '';
      if (rt.contains('shared')) return 'Shared Room';
      if (rt.contains('private')) return 'Private Room';
      if (rt.isNotEmpty) return roomType!;
      return 'Room';
    }
    if (propertyType != null && propertyType!.trim().isNotEmpty) return propertyType!;
    if (roomType != null && roomType!.trim().isNotEmpty) {
      final rt = roomType!.toLowerCase().trim();
      if (rt.contains('shared')) return 'Shared Room';
      if (rt.contains('private')) return 'Private Room';
      return roomType!;
    }
    if (rentalModel != null && rentalModel!.trim().isNotEmpty) return rentalModel!;
    return 'Property';
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────────

  static String _formatNum(double value) {
    final intVal = value.truncate();
    if (value == intVal.toDouble()) {
      final s = intVal.toString();
      final buf = StringBuffer();
      for (int i = 0; i < s.length; i++) {
        if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
        buf.write(s[i]);
      }
      return buf.toString();
    }
    return value.toStringAsFixed(2);
  }

  WishlistItemModel copyWith({
    int? propertyId,
    String? title,
    String? location,
    double? price,
    double? dailyPrice,
    String? imageUrl,
    String? propertyType,
    String? listingType,
    String? rentalModel,
    String? roomType,
    double? rating,
    String? note,
    Map<String, dynamic>? salePricing,
    Map<String, dynamic>? rentalPricing,
    int? minStayNights,
  }) {
    return WishlistItemModel(
      propertyId: propertyId ?? this.propertyId,
      title: title ?? this.title,
      location: location ?? this.location,
      price: price ?? this.price,
      dailyPrice: dailyPrice ?? this.dailyPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      propertyType: propertyType ?? this.propertyType,
      listingType: listingType ?? this.listingType,
      rentalModel: rentalModel ?? this.rentalModel,
      roomType: roomType ?? this.roomType,
      rating: rating ?? this.rating,
      note: note ?? this.note,
      salePricing: salePricing ?? this.salePricing,
      rentalPricing: rentalPricing ?? this.rentalPricing,
      minStayNights: minStayNights ?? this.minStayNights,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'propertyId': propertyId,
      'title': title,
      'location': location,
      'propertyType': propertyType,
      'listingType': listingType,
      'rentalModel': rentalModel,
      'roomType': roomType,
      'price': price,
      'dailyPrice': dailyPrice,
      'rating': rating,
      'imageUrl': imageUrl,
      'salePricing': salePricing,
      'rentalPricing': rentalPricing,
      'minStayNights': minStayNights,
      'note': note,
    };
  }
}
