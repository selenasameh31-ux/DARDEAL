class RentalPaymentEntity {
  final int? id;
  final double amount;
  final String? paidAt;
  final String? notes;

  const RentalPaymentEntity({
    this.id,
    required this.amount,
    this.paidAt,
    this.notes,
  });
}
