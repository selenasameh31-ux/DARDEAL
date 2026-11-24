import '../../domain/entities/contract_entity.dart';

class ContractModel extends ContractEntity {
  const ContractModel({
    required super.id,
    super.offerId,
    super.contractType,
    super.startDate,
    super.endDate,
    super.contractDurationMonths,
    super.depositAmount,
    super.handoverDeadline,
    required super.status,
    super.propertyId,
    super.propertyTitle,
    super.propertyImage,
    super.price,
  });

  factory ContractModel.fromJson(Map<String, dynamic> json) {
    return ContractModel(
      id: json['id'] ?? json['contractId'] ?? 0,
      offerId: json['offerId'],
      contractType: json['contractType'],
      startDate: json['startDate'] != null ? DateTime.tryParse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.tryParse(json['endDate']) : null,
      contractDurationMonths: json['contractDurationMonths'],
      depositAmount: json['depositAmount'] != null ? (json['depositAmount'] as num).toDouble() : null,
      handoverDeadline: json['handoverDeadline'] != null ? DateTime.tryParse(json['handoverDeadline']) : null,
      status: json['status'] ?? 'pending',
      propertyId: json['propertyId'],
      propertyTitle: json['propertyTitle'] ?? json['propertyName'],
      propertyImage: json['propertyImage'] ?? json['imageUrl'],
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
    );
  }
}
