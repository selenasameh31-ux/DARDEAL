import 'package:graduation_project_flutter/features/active_rental/data/models/rental_model.dart';

class PaginatedRentalsModel {
  final List<RentalModel> rentals;
  final int currentPage;
  final int totalPages;
  final int totalCount;

  const PaginatedRentalsModel({
    required this.rentals,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
  });

  factory PaginatedRentalsModel.fromJson(Map<String, dynamic> json) {
    List<RentalModel> parsedRentals = [];
    
    // Safely extract data array
    final data = json['data'];
    if (data != null && data is List) {
      parsedRentals = data.map((e) => RentalModel.fromJson(e)).toList();
    } else if (json['items'] != null && json['items'] is List) {
      parsedRentals = (json['items'] as List).map((e) => RentalModel.fromJson(e)).toList();
    } else if (data != null && data['items'] != null && data['items'] is List) {
      parsedRentals = (data['items'] as List).map((e) => RentalModel.fromJson(e)).toList();
    }

    return PaginatedRentalsModel(
      rentals: parsedRentals,
      currentPage: json['currentPage'] as int? ?? json['page'] as int? ?? 1,
      totalPages: json['totalPages'] as int? ?? 1,
      totalCount: json['totalCount'] as int? ?? 0,
    );
  }
}
