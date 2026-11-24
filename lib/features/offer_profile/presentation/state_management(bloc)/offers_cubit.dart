import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_flutter/features/offer/domain/repositories/offers_repository.dart';
import 'package:graduation_project_flutter/features/offer_profile/presentation/state_management(bloc)/offers_state.dart';

class OffersCubit extends Cubit<OffersState> {
  final OffersRepository repository;

  OffersCubit({required this.repository}) : super(OffersInitial());

  Future<void> fetchOffers({int page = 1, int pageSize = 20}) async {
    emit(OffersLoading());
    final result = await repository.getOffers(page: page, pageSize: pageSize);
    result.fold(
      (failure) => emit(OffersError(failure.message)),
      (paginatedOffers) => emit(OffersSuccess(paginatedOffers)),
    );
  }
}
