import 'package:graduation_project_flutter/core/routing/routes_export.dart';
class PaymentEntity {
  final String? transactionId;
  final String offerId;
  final double amount;
  final String paymentMethod;
  final DateTime? paymentDate;
  final bool isSuccessful;

  const PaymentEntity({
    this.transactionId,
    required this.offerId,
    required this.amount,
    required this.paymentMethod,
    this.paymentDate,
    this.isSuccessful = false,
  });

  PaymentEntity copyWith({
    String? transactionId,
    String? offerId,
    double? amount,
    String? paymentMethod,
    DateTime? paymentDate,
    bool? isSuccessful,
  }) {
    return PaymentEntity(
      transactionId: transactionId ?? this.transactionId,
      offerId: offerId ?? this.offerId,
      amount: amount ?? this.amount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentDate: paymentDate ?? this.paymentDate,
      isSuccessful: isSuccessful ?? this.isSuccessful,
    );
  }
}
