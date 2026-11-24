import 'package:dartz/dartz.dart';
import 'package:graduation_project_flutter/core/errors/exceptions.dart';
import 'package:graduation_project_flutter/core/errors/failure.dart';
import 'package:graduation_project_flutter/features/my_contracts/data/datasources/contracts_remote_data_source.dart';
import 'package:graduation_project_flutter/features/my_contracts/domain/entities/contract_entity.dart';
import 'package:graduation_project_flutter/features/my_contracts/domain/repositories/contracts_repository.dart';

class ContractsRepositoryImpl implements ContractsRepository {
  final ContractsRemoteDataSource remoteDataSource;

  ContractsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Map<String, dynamic>>> getMyContracts({
    String? status,
    String? role,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await remoteDataSource.getMyContracts(
        status: status,
        role: role,
        page: page,
        pageSize: pageSize,
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ContractEntity>> getContractDetails(int contractId) async {
    try {
      final response = await remoteDataSource.getContractDetails(contractId);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
