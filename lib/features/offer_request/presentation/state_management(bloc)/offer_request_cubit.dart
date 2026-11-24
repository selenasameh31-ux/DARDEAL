import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_flutter/features/offer_request/domain/repositories/offer_request_repository.dart';
import 'package:graduation_project_flutter/features/offer_request/presentation/state_management(bloc)/offer_request_state.dart';

class OfferRequestCubit extends Cubit<OfferRequestState> {
  final OfferRequestRepository repository;

  OfferRequestCubit({required this.repository}) : super(OfferRequestInitial());

  Future<void> fetchOfferRequests({int page = 1, int pageSize = 20}) async {
    emit(OfferRequestLoading());
    final result = await repository.getOfferRequests(page: page, pageSize: pageSize);
    result.fold(
      (failure) => emit(OfferRequestError(failure.message)),
      (paginatedRequests) => emit(OfferRequestSuccess(paginatedRequests)),
    );
  }
}
