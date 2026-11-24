import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class OfferModel {
  final String? id;
  final String propertyId;
  final double offerPrice;
  final bool isTermsAccepted;
  final String status;
  final String? createdAt;

  // New fields
  final String? currency;
  final String? message;
  final String? seekerNotes;
  final String? proposedMoveInDate;
  final String? proposedEndDate;
  final String? paymentTerms;
  final String? roomId;
  final List<dynamic>? contracts;

  OfferModel({
    this.id,
    required this.propertyId,
    required this.offerPrice,
    required this.isTermsAccepted,
    this.status = 'pending',
    this.createdAt,
    this.currency,
    this.message,
    this.seekerNotes,
    this.proposedMoveInDate,
    this.proposedEndDate,
    this.paymentTerms,
    this.roomId,
    this.contracts,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return OfferModel(
      id: data['id']?.toString(),
      propertyId: data['propertyId']?.toString() ?? 
                  (data['property'] != null ? data['property']['id']?.toString() : '') ?? '',
      // Swagger returns 'offeredPrice'; fall back to 'offerPrice' for safety
      offerPrice:
          (data['offeredPrice'] as num?)?.toDouble() ??
          (data['offerPrice'] as num?)?.toDouble() ??
          0.0,
      isTermsAccepted: data['isTermsAccepted'] == true,
      status: data['status']?.toString() ?? 'pending',
      createdAt: data['createdAt']?.toString(),
      currency: data['currency']?.toString(),
      message: data['message']?.toString(),
      seekerNotes: data['seekerNotes']?.toString(),
      proposedMoveInDate: data['proposedMoveInDate']?.toString(),
      proposedEndDate: data['proposedEndDate']?.toString(),
      paymentTerms: data['paymentTerms']?.toString(),
      roomId: data['roomId']?.toString(),
      contracts: data['contracts'] as List<dynamic>?,
    );
  }

  /// Helper to safely extract the contractId
  int? get contractId {
    if (contracts != null && contracts!.isNotEmpty) {
      return contracts!.first['id'] as int?;
    }
    return null;
  }

  /// API controls status — do NOT send it in the request body.
  Map<String, dynamic> toJson() {
    return {
      'propertyId': int.tryParse(propertyId) ?? 0,
      if (roomId != null && int.tryParse(roomId!) != null)
        'roomId': int.tryParse(roomId!),
      'offeredPrice': offerPrice,
      'currency': currency ?? 'EGP',
      'message': message ?? '',
      'seekerNotes': seekerNotes ?? '',
      'proposedMoveInDate': proposedMoveInDate,
      'proposedEndDate': proposedEndDate,
    };
  }

  OfferEntity toEntity() {
    return OfferEntity(
      id: id,
      propertyId: propertyId,
      offerPrice: offerPrice,
      isTermsAccepted: isTermsAccepted,
      status: _parseStatus(status),
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
    );
  }

  static OfferStatusType _parseStatus(String raw) {
    switch (raw.toLowerCase()) {
      case 'accepted':
        return OfferStatusType.accepted;
      case 'rejected':
        return OfferStatusType.rejected;
      case 'completed':
        return OfferStatusType.completed;
      default:
        return OfferStatusType.pending;
    }
  }
}
