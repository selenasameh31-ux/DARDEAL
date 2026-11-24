import 'package:graduation_project_flutter/features/offer/domain/entities/offer_entity.dart';
import 'package:graduation_project_flutter/features/offer/data/models/paginated_offers_model.dart';

abstract class OffersState {}

class OffersInitial extends OffersState {}

class OffersLoading extends OffersState {}

class OffersSuccess extends OffersState {
  final PaginatedOffersModel paginatedOffers;
  
  OffersSuccess(this.paginatedOffers);
}

class OffersError extends OffersState {
  final String message;

  OffersError(this.message);
}
