import 'package:graduation_project_flutter/core/routing/routes_export.dart';
class PropertySummaryEntity {
  final String id;
  final String title;
  final String location;
  final String imageUrl;
  final double askingPrice;
  final String? listingType;

  const PropertySummaryEntity({
    required this.id,
    required this.title,
    required this.location,
    required this.imageUrl,
    required this.askingPrice,
    this.listingType,
  });

  PropertySummaryEntity copyWith({
    String? id,
    String? title,
    String? location,
    String? imageUrl,
    double? askingPrice,
    String? listingType,
  }) {
    return PropertySummaryEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      askingPrice: askingPrice ?? this.askingPrice,
      listingType: listingType ?? this.listingType,
    );
  }
}
