import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_flutter/core/errors/exceptions.dart';
import 'package:graduation_project_flutter/features/offer/domain/entities/offer_entity.dart';
import 'package:graduation_project_flutter/features/offer/domain/repositories/offer_repository.dart';

abstract class MyOffersState {}

class MyOffersInitial extends MyOffersState {}

class MyOffersLoading extends MyOffersState {}

class MyOffersLoaded extends MyOffersState {
  final List<OfferEntity> offers;

  MyOffersLoaded(this.offers);
}

class MyOffersError extends MyOffersState {
  final String message;

  MyOffersError(this.message);
}

class MyOffersCubit extends Cubit<MyOffersState> {
  final OfferRepository repository;

  MyOffersCubit({required this.repository}) : super(MyOffersInitial());

  Future<void> fetchMyOffers() async {
    emit(MyOffersLoading());

    print("🔥 START MY OFFERS API CALL");

    try {
      final offers = await repository.getMyOffers();

      print("✅ MY OFFERS API SUCCESS");

      emit(MyOffersLoaded(offers));
    } on UnauthorizedException catch (_) {
      print("❌ MY OFFERS ERROR = UnauthorizedException");
      emit(MyOffersLoaded([]));
    } catch (e) {
      print("❌ MY OFFERS ERROR = $e");
      if (e is DioException) {
        print("❌ MY OFFERS ERROR DATA = ${e.response?.data}");
        final statusCode = e.response?.statusCode;
        if (statusCode == 401 || statusCode == 403 || statusCode == 404 || statusCode == 405) {
          emit(MyOffersLoaded([]));
          return;
        }
      }
      
      emit(MyOffersError("Failed to load offers. Please try again later."));
    }
  }
}
