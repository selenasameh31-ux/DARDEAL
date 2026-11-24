part of 'contracts_cubit.dart';

abstract class ContractsState {}

class ContractsInitial extends ContractsState {}

class ContractsLoading extends ContractsState {}

class ContractsLoaded extends ContractsState {
  final List<ContractEntity> contracts;
  final int totalCount;
  final int currentPage;
  final int totalPages;

  ContractsLoaded({
    required this.contracts,
    this.totalCount = 0,
    this.currentPage = 1,
    this.totalPages = 1,
  });
}

class ContractsError extends ContractsState {
  final String message;

  ContractsError(this.message);
}

class ContractDetailsLoading extends ContractsState {}

class ContractDetailsLoaded extends ContractsState {
  final ContractEntity contract;

  ContractDetailsLoaded(this.contract);
}

class ContractDetailsError extends ContractsState {
  final String message;

  ContractDetailsError(this.message);
}
