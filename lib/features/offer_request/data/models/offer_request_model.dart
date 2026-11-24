import 'package:graduation_project_flutter/features/offer_request/domain/entities/offer_request_entity.dart';

class OfferRequestModel extends OfferRequestEntity {
  OfferRequestModel({
    super.id,
    required super.propertyId,
    required super.offerPrice,
    required super.status,
    super.createdAt,
    super.currency,
    super.message,
  });

  factory OfferRequestModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return OfferRequestModel(
      id: data['id']?.toString(),
      propertyId: data['propertyId']?.toString() ?? '',
      offerPrice: (data['offerPrice'] as num?)?.toDouble() ?? 0.0,
      status: data['status']?.toString() ?? 'pending',
      createdAt: data['createdAt'] != null ? DateTime.tryParse(data['createdAt'].toString()) : null,
      currency: data['currency']?.toString(),
      message: data['message']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'propertyId': propertyId,
      'offerPrice': offerPrice,
      'status': status,
      'currency': currency ?? 'EGP',
      'message': message ?? '',
    };
  }

  OfferRequestEntity toEntity() {
    return OfferRequestEntity(
      id: id,
      propertyId: propertyId,
      offerPrice: offerPrice,
      status: status,
      createdAt: createdAt,
      currency: currency,
      message: message,
    );
  }
}
