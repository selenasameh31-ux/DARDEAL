import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_flutter/features/offer/domain/entities/offer_entity.dart';
import 'package:graduation_project_flutter/features/offer/domain/repositories/offer_repository.dart';

abstract class ReceivedOffersState {}

class ReceivedOffersInitial extends ReceivedOffersState {}

class ReceivedOffersLoading extends ReceivedOffersState {}

class ReceivedOffersLoaded extends ReceivedOffersState {
  final List<OfferEntity> offers;

  ReceivedOffersLoaded(this.offers);
}

class ReceivedOffersError extends ReceivedOffersState {
  final String message;

  ReceivedOffersError(this.message);
}

class ReceivedOffersCubit extends Cubit<ReceivedOffersState> {
  final OfferRepository repository;

  ReceivedOffersCubit({required this.repository}) : super(ReceivedOffersInitial());

  Future<void> fetchReceivedOffers() async {
    emit(ReceivedOffersLoading());
    try {
      final offers = await repository.getReceivedOffers();
      emit(ReceivedOffersLoaded(offers));
    } catch (e) {
      emit(ReceivedOffersError(e.toString()));
    }
  }
}
