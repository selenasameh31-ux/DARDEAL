import 'package:graduation_project_flutter/features/active_rental/domain/entities/rental_entity.dart';

class RentalModel extends RentalEntity {
  const RentalModel({
    super.id,
    super.propertyId,
    super.propertyTitle,
    super.status,
    super.startDate,
    super.endDate,
    super.monthlyRent,
  });

  factory RentalModel.fromJson(Map<String, dynamic> json) {
    return RentalModel(
      id: json['id'] as int?,
      propertyId: json['propertyId'] as int?,
      propertyTitle: json['propertyTitle'] as String?,
      status: json['status'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      monthlyRent: (json['monthlyRent'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'propertyId': propertyId,
      'propertyTitle': propertyTitle,
      'status': status,
      'startDate': startDate,
      'endDate': endDate,
      'monthlyRent': monthlyRent,
    };
  }
}
