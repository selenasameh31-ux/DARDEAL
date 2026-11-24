import 'package:graduation_project_flutter/features/offer_request/data/models/paginated_offer_requests_model.dart';

abstract class OfferRequestState {}

class OfferRequestInitial extends OfferRequestState {}

class OfferRequestLoading extends OfferRequestState {}

class OfferRequestSuccess extends OfferRequestState {
  final PaginatedOfferRequestsModel paginatedOfferRequests;

  OfferRequestSuccess(this.paginatedOfferRequests);
}

class OfferRequestError extends OfferRequestState {
  final String message;

  OfferRequestError(this.message);
}
