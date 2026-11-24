import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class PaymentModel {
  final String? transactionId;
  final String offerId;
  final double amount;
  final String paymentMethod;
  final String? paymentDate;
  final bool isSuccessful;

  PaymentModel({
    this.transactionId,
    required this.offerId,
    required this.amount,
    required this.paymentMethod,
    this.paymentDate,
    this.isSuccessful = false,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return PaymentModel(
      transactionId: data['transactionId']?.toString(),
      offerId: data['offerId']?.toString() ?? '',
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: data['paymentMethod']?.toString() ?? '',
      paymentDate: data['paymentDate']?.toString(),
      isSuccessful: data['isSuccessful'] == true, // strict boolean check
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offerId': offerId,
      'amount': amount,
      'paymentMethod': paymentMethod,
    };
  }

  PaymentEntity toEntity() {
    return PaymentEntity(
      transactionId: transactionId,
      offerId: offerId,
      amount: amount,
      paymentMethod: paymentMethod,
      paymentDate: paymentDate != null ? DateTime.tryParse(paymentDate!) : null,
      isSuccessful: isSuccessful,
    );
  }
}
