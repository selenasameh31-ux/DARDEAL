import 'package:graduation_project_flutter/features/active_rental/domain/entities/rental_payment_entity.dart';

class RentalPaymentModel extends RentalPaymentEntity {
  const RentalPaymentModel({
    super.id,
    required super.amount,
    super.paidAt,
    super.notes,
  });

  factory RentalPaymentModel.fromJson(Map<String, dynamic> json) {
    return RentalPaymentModel(
      id: json['id'] as int?,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      paidAt: json['paidAt'] as String?,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'paidAt': paidAt,
      'notes': notes,
    };
  }
}
