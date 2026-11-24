import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_flutter/features/offer/domain/entities/offer_entity.dart';
import 'package:graduation_project_flutter/features/offer/domain/repositories/offer_repository.dart';

abstract class SentOffersState {}

class SentOffersInitial extends SentOffersState {}

class SentOffersLoading extends SentOffersState {}

class SentOffersLoaded extends SentOffersState {
  final List<OfferEntity> offers;

  SentOffersLoaded(this.offers);
}

class SentOffersError extends SentOffersState {
  final String message;

  SentOffersError(this.message);
}

class SentOffersCubit extends Cubit<SentOffersState> {
  final OfferRepository repository;

  SentOffersCubit({required this.repository}) : super(SentOffersInitial());

  Future<void> fetchSentOffers() async {
  emit(SentOffersLoading());

  print("🔥 START API CALL");

  try {
    final offers = await repository.getSentOffers();

    print("✅ API SUCCESS");

    emit(SentOffersLoaded(offers));
  } catch (e) {
    print("❌ ERROR = $e");
    emit(SentOffersError(e.toString()));
  }
}
}
