import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_flutter/features/my_contracts/domain/entities/contract_entity.dart';
import 'package:graduation_project_flutter/features/my_contracts/domain/repositories/contracts_repository.dart';

part 'contracts_state.dart';

class ContractsCubit extends Cubit<ContractsState> {
  final ContractsRepository repository;

  ContractsCubit({required this.repository}) : super(ContractsInitial());

  Future<void> loadContracts({
    String? status,
    String? role,
    int page = 1,
    int pageSize = 20,
  }) async {
    emit(ContractsLoading());
    final result = await repository.getMyContracts(
      status: status,
      role: role,
      page: page,
      pageSize: pageSize,
    );

    result.fold(
      (failure) {
        emit(ContractsError(failure.message));
      },
      (data) {
        final items = data['items'] as List<dynamic>? ?? [];
        final contracts = items.cast<ContractEntity>();
        emit(ContractsLoaded(
          contracts: contracts,
          totalCount: data['totalCount'] ?? contracts.length,
          currentPage: data['page'] ?? page,
          totalPages: data['totalPages'] ?? 1,
        ));
      },
    );
  }

  Future<void> loadContractDetails(int contractId) async {
    emit(ContractDetailsLoading());
    final result = await repository.getContractDetails(contractId);

    result.fold(
      (failure) => emit(ContractDetailsError(failure.message)),
      (contract) => emit(ContractDetailsLoaded(contract as ContractEntity)),
    );
  }
}
