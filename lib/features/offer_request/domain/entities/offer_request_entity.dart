class OfferRequestEntity {
  final String? id;
  final String propertyId;
  final double offerPrice;
  final String status;
  final DateTime? createdAt;
  final String? currency;
  final String? message;

  OfferRequestEntity({
    this.id,
    required this.propertyId,
    required this.offerPrice,
    required this.status,
    this.createdAt,
    this.currency,
    this.message,
  });
}
