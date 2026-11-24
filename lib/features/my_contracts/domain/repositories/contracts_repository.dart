import 'package:dartz/dartz.dart';
import 'package:graduation_project_flutter/core/errors/failure.dart';
import '../entities/contract_entity.dart';

abstract class ContractsRepository {
  Future<Either<Failure, Map<String, dynamic>>> getMyContracts({
    String? status,
    String? role,
    int page = 1,
    int pageSize = 20,
  });

  Future<Either<Failure, ContractEntity>> getContractDetails(int contractId);
}
