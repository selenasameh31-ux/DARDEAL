import 'package:equatable/equatable.dart';

class ContractEntity extends Equatable {
  final int id;
  final int? offerId;
  final String? contractType;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? contractDurationMonths;
  final double? depositAmount;
  final DateTime? handoverDeadline;
  final String status;
  
  // Extra display fields commonly returned in lists
  final int? propertyId;
  final String? propertyTitle;
  final String? propertyImage;
  final double? price;

  const ContractEntity({
    required this.id,
    this.offerId,
    this.contractType,
    this.startDate,
    this.endDate,
    this.contractDurationMonths,
    this.depositAmount,
    this.handoverDeadline,
    required this.status,
    this.propertyId,
    this.propertyTitle,
    this.propertyImage,
    this.price,
  });

  @override
  List<Object?> get props => [
        id,
        offerId,
        contractType,
        startDate,
        endDate,
        contractDurationMonths,
        depositAmount,
        handoverDeadline,
        status,
        propertyId,
        propertyTitle,
        propertyImage,
        price,
      ];
}
