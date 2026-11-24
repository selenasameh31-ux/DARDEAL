import 'package:graduation_project_flutter/core/routing/routes_export.dart';
// ─────────────────────────────────────────────────────────
// Offer State
// ─────────────────────────────────────────────────────────

enum OfferFlowStatus { initial, loading, success, failure, paymentInitiated }

class OfferState {
  // ── Flow tracking ──
  final OfferFlowStatus status;
  final String? errorMessage;
  final String? offerId; // Track the real ID from the server

  // ── Property details (loaded dynamically) ──
  final double propertyPrice;
  final String propertyTitle;
  final String propertyLocation;
  final String propertyImageUrl;
  final bool isPropertyLoaded;

  // ── Make Offer screen ──
  final double offerPrice;
  final bool isTermsAccepted;

  // ── New Sale fields ──
  final String? listingType;
  final double saleDownPayment;
  final String salePaymentMethod; // 'Cash', 'Installments', 'Both'
  final String saleInstallmentDuration; // '12 months', '24 months', etc.

  // ── Payment screen ──
  final String? selectedPaymentMethod;
  final String? clientSecret;
  final int? paymentId;

  // ── Handover screen ──
  final Map<String, bool> checklistMap;

  // ── Internal guard — prevents duplicate submissions ──
  final bool isSubmitting;

  const OfferState({
    this.status = OfferFlowStatus.initial,
    this.errorMessage,
    this.offerId,
    this.propertyPrice = 0.0,
    this.propertyTitle = '',
    this.propertyLocation = '',
    this.propertyImageUrl = '',
    this.isPropertyLoaded = false,
    this.offerPrice = 0.0,
    this.isTermsAccepted = false,
    this.listingType,
    this.saleDownPayment = 0.0,
    this.salePaymentMethod = 'Cash',
    this.saleInstallmentDuration = '12 months',
    this.selectedPaymentMethod = 'credit_card',
    this.clientSecret,
    this.paymentId,
    this.checklistMap = const {
      'keys_received': false,
      'utilities_working': false,
      'no_damages': false,
    },
    this.isSubmitting = false,
  });

  // ── Derived getters for validation ──

  /// Make Offer screen: price must be > 0 and if installment sale, down payment must be > 0
  bool get isOfferValid {
    if (offerPrice <= 0) return false;
    if (listingType?.toLowerCase() == 'sale') {
      final needsDownPayment = salePaymentMethod == 'Installments';
      if (needsDownPayment && saleDownPayment <= 0) return false;
    }
    return true;
  }

  /// Payment screen: a payment method must be selected
  bool get isPaymentValid =>
      selectedPaymentMethod != null && selectedPaymentMethod!.isNotEmpty;

  /// Handover screen: all checklist items must be true
  bool get isHandoverValid =>
      checklistMap.isNotEmpty && checklistMap.values.every((v) => v);

  OfferState copyWith({
    OfferFlowStatus? status,
    String? errorMessage,
    String? offerId,
    double? propertyPrice,
    String? propertyTitle,
    String? propertyLocation,
    String? propertyImageUrl,
    bool? isPropertyLoaded,
    double? offerPrice,
    bool? isTermsAccepted,
    String? listingType,
    double? saleDownPayment,
    String? salePaymentMethod,
    String? saleInstallmentDuration,
    String? selectedPaymentMethod,
    String? clientSecret,
    int? paymentId,
    Map<String, bool>? checklistMap,
    bool? isSubmitting,
    bool clearError = false,
  }) {
    return OfferState(
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      offerId: offerId ?? this.offerId,
      propertyPrice: propertyPrice ?? this.propertyPrice,
      propertyTitle: propertyTitle ?? this.propertyTitle,
      propertyLocation: propertyLocation ?? this.propertyLocation,
      propertyImageUrl: propertyImageUrl ?? this.propertyImageUrl,
      isPropertyLoaded: isPropertyLoaded ?? this.isPropertyLoaded,
      offerPrice: offerPrice ?? this.offerPrice,
      isTermsAccepted: isTermsAccepted ?? this.isTermsAccepted,
      listingType: listingType ?? this.listingType,
      saleDownPayment: saleDownPayment ?? this.saleDownPayment,
      salePaymentMethod: salePaymentMethod ?? this.salePaymentMethod,
      saleInstallmentDuration:
          saleInstallmentDuration ?? this.saleInstallmentDuration,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
      clientSecret: clientSecret ?? this.clientSecret,
      paymentId: paymentId ?? this.paymentId,
      checklistMap: checklistMap ?? this.checklistMap,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}
