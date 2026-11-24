import 'package:graduation_project_flutter/core/database/api/api_consumer.dart';
import 'package:graduation_project_flutter/core/database/api/end_points.dart';
import 'package:graduation_project_flutter/features/active_rental/data/models/paginated_rentals_model.dart';
import 'package:graduation_project_flutter/features/active_rental/data/models/rental_model.dart';
import 'package:graduation_project_flutter/features/active_rental/data/models/rental_payment_model.dart';

abstract class ActiveRentalRemoteDataSource {
  Future<PaginatedRentalsModel> getRentals(int page, int pageSize, String? status);
  Future<RentalModel> getRentalById(int id);
  Future<List<RentalPaymentModel>> getRentalPayments(int id);
  Future<void> addRentalPayment(int id, double amount, String paidAt, String notes);
  Future<void> terminateRental(int id, String reason);
  Future<int> getRentalsCount();
}

class ActiveRentalRemoteDataSourceImpl implements ActiveRentalRemoteDataSource {
  final ApiConsumer api;

  ActiveRentalRemoteDataSourceImpl({required this.api});

  @override
  Future<PaginatedRentalsModel> getRentals(int page, int pageSize, String? status) async {
    final Map<String, dynamic> queryParams = {
      'page': page,
      'pageSize': pageSize,
    };
    if (status != null && status.isNotEmpty) {
      queryParams['status'] = status;
    }

    final response = await api.get(
      EndPoints.rentals,
      queryParameters: queryParams,
    );

    return PaginatedRentalsModel.fromJson(response.data);
  }

  @override
  Future<RentalModel> getRentalById(int id) async {
    final response = await api.get(EndPoints.getRentalById(id));
    final data = response.data['data'] ?? response.data; // Fallback in case there is no "data" wrapper
    return RentalModel.fromJson(data);
  }

  @override
  Future<List<RentalPaymentModel>> getRentalPayments(int id) async {
    final response = await api.get(EndPoints.getRentalPayments(id));
    final data = response.data['data'];
    if (data == null) {
      return [];
    }
    if (data is List) {
      return data.map((e) => RentalPaymentModel.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<void> addRentalPayment(int id, double amount, String paidAt, String notes) async {
    await api.post(
      EndPoints.addRentalPayment(id),
      data: {
        "amount": amount,
        "paidAt": paidAt,
        "notes": notes,
      },
    );
  }

  @override
  Future<void> terminateRental(int id, String reason) async {
    await api.put(
      EndPoints.terminateRental(id),
      data: {
        "reason": reason,
      },
    );
  }

  @override
  Future<int> getRentalsCount() async {
    final response = await api.get(EndPoints.getRentalsCount);
    // Depending on the API, count might be in "data" or just directly returned
    final data = response.data['data'] ?? response.data['count'] ?? response.data;
    if (data is int) {
      return data;
    }
    return int.tryParse(data.toString()) ?? 0;
  }
}
