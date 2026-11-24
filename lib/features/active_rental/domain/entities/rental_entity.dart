class RentalEntity {
  final int? id;
  final int? propertyId;
  final String? propertyTitle;
  final String? status;
  final String? startDate;
  final String? endDate;
  final double? monthlyRent;

  const RentalEntity({
    this.id,
    this.propertyId,
    this.propertyTitle,
    this.status,
    this.startDate,
    this.endDate,
    this.monthlyRent,
  });
}
