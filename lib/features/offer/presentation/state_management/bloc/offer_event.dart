import 'package:graduation_project_flutter/core/routing/routes_export.dart';
// ─────────────────────────────────────────────────────────
// Offer Events
// ─────────────────────────────────────────────────────────

abstract class OfferEvent {}

/// Load property details (price, title, etc.) when the offer screen opens
class LoadPropertyForOffer extends OfferEvent {
  final String propertyId;
  LoadPropertyForOffer(this.propertyId);
}

/// User typed or changed the offer price
class OfferPriceChanged extends OfferEvent {
  final double price;
  OfferPriceChanged(this.price);
}

/// User toggled the terms & conditions checkbox
class TermsToggled extends OfferEvent {
  final bool accepted;
  TermsToggled(this.accepted);
}

/// User pressed the "Submit Offer" button
class SubmitOfferRequested extends OfferEvent {
  final String propertyId;
  final String? message;
  final String? seekerNotes;
  final DateTime? leaseStart;
  final DateTime? leaseEnd;

  SubmitOfferRequested({
    required this.propertyId,
    this.message,
    this.seekerNotes,
    this.leaseStart,
    this.leaseEnd,
  });
}

/// User selected a payment method
class PaymentMethodSelected extends OfferEvent {
  final String method;
  PaymentMethodSelected(this.method);
}

/// User pressed the "Pay Now" button
class ProcessPaymentRequested extends OfferEvent {
  final String offerId;
  final double amount;
  ProcessPaymentRequested({required this.offerId, required this.amount});
}

/// Poll backend for payment status after SDK closes
class CheckPaymentStatusRequested extends OfferEvent {
  final int paymentId;
  CheckPaymentStatusRequested(this.paymentId);
}

/// User toggled a handover checklist item
class ChecklistItemToggled extends OfferEvent {
  final String key;
  final bool value;
  ChecklistItemToggled(this.key, this.value);
}

/// User pressed the "Confirm Handover" button
class ConfirmHandoverRequested extends OfferEvent {
  final String offerId;
  final File? contractFile;
  ConfirmHandoverRequested({
    required this.offerId,
    this.contractFile,
  });
}

/// Reset status to initial to prevent re-triggering navigation listeners
class ResetOfferStatus extends OfferEvent {}

/// User changed the downpayment on Sale offer
class SaleDownPaymentChanged extends OfferEvent {
  final double downPayment;
  SaleDownPaymentChanged(this.downPayment);
}

/// User changed the payment method on Sale offer
class SalePaymentMethodChanged extends OfferEvent {
  final String method;
  SalePaymentMethodChanged(this.method);
}

/// User changed the installment duration on Sale offer
class SaleInstallmentDurationChanged extends OfferEvent {
  final String duration;
  SaleInstallmentDurationChanged(this.duration);
}
