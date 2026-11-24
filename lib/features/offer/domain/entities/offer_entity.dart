import 'package:graduation_project_flutter/core/routing/routes_export.dart';
enum OfferStatusType { pending, accepted, rejected, completed }

class OfferEntity {
  final String? id;
  final String propertyId;
  final double offerPrice;
  final bool isTermsAccepted;
  final OfferStatusType status;
  final DateTime? createdAt;

  const OfferEntity({
    this.id,
    required this.propertyId,
    required this.offerPrice,
    required this.isTermsAccepted,
    this.status = OfferStatusType.pending,
    this.createdAt,
  });

  OfferEntity copyWith({
    String? id,
    String? propertyId,
    double? offerPrice,
    bool? isTermsAccepted,
    OfferStatusType? status,
    DateTime? createdAt,
  }) {
    return OfferEntity(
      id: id ?? this.id,
      propertyId: propertyId ?? this.propertyId,
      offerPrice: offerPrice ?? this.offerPrice,
      isTermsAccepted: isTermsAccepted ?? this.isTermsAccepted,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
