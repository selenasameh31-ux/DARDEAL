import 'package:graduation_project_flutter/core/routing/routes_export.dart';

/// OfferPropertyModel maps the API response for a property summary
/// to the domain [PropertySummaryEntity].
class OfferPropertyModel {
  final String id;
  final int? ownerId;
  final String title;
  final String location;
  final String imageUrl;
  final double askingPrice;
  final String? listingType;

  OfferPropertyModel({
    required this.id,
    this.ownerId,
    required this.title,
    required this.location,
    required this.imageUrl,
    required this.askingPrice,
    this.listingType,
  });

  factory OfferPropertyModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return OfferPropertyModel(
      id: data['id']?.toString() ?? '',
      ownerId: data['ownerId'] != null ? int.tryParse(data['ownerId'].toString()) : null,
      title: data['title']?.toString() ?? '',
      location: data['location']?.toString() ?? data['address']?.toString() ?? data['city']?.toString() ?? data['region']?.toString() ?? '',
      imageUrl: data['imageUrl']?.toString() ?? '',
      askingPrice: (data['price'] as num?)?.toDouble() ?? 0.0,
      listingType: data['listingType']?.toString(),
    );
  }

  PropertySummaryEntity toEntity() {
    return PropertySummaryEntity(
      id: id,
      title: title,
      location: location,
      imageUrl: imageUrl,
      askingPrice: askingPrice,
      listingType: listingType,
    );
  }
}
