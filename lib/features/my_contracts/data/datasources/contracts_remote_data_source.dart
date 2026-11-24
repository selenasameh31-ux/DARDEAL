import 'package:graduation_project_flutter/core/database/api/api_consumer.dart';
import 'package:graduation_project_flutter/core/database/api/end_points.dart';
import 'package:graduation_project_flutter/core/utils/api_response_helper.dart';
import '../models/contract_model.dart';

abstract class ContractsRemoteDataSource {
  Future<Map<String, dynamic>> getMyContracts({
    String? status,
    String? role,
    int page = 1,
    int pageSize = 20,
  });

  Future<ContractModel> getContractDetails(int contractId);
}

class ContractsRemoteDataSourceImpl implements ContractsRemoteDataSource {
  final ApiConsumer api;

  ContractsRemoteDataSourceImpl({required this.api});

  @override
  Future<Map<String, dynamic>> getMyContracts({
    String? status,
    String? role,
    int page = 1,
    int pageSize = 20,
  }) async {
    final Map<String, dynamic> queryParams = {
      'page': page,
      'pageSize': pageSize,
    };
    if (status != null && status.isNotEmpty) queryParams['status'] = status;
    if (role != null && role.isNotEmpty) queryParams['role'] = role;

    final response = await api.get(
      EndPoints.myContracts,
      queryParameters: queryParams,
    );

    final data = ApiDataExtractor.extract(response.data);
    
    // In case the response is just a list
    if (data is List) {
      return {
        'items': data.map((e) => ContractModel.fromJson(e)).toList(),
        'totalCount': data.length,
      };
    }

    final items = (data['items'] as List?)?.map((e) => ContractModel.fromJson(e)).toList() ?? [];
    return {
      'items': items,
      'totalCount': data['totalCount'] ?? items.length,
      'page': data['page'] ?? page,
      'pageSize': data['pageSize'] ?? pageSize,
      'totalPages': data['totalPages'] ?? 1,
    };
  }

  @override
  Future<ContractModel> getContractDetails(int contractId) async {
    final response = await api.get(EndPoints.contractDetails(contractId));
    final data = ApiDataExtractor.extract(response.data);
    return ContractModel.fromJson(data);
  }
}
