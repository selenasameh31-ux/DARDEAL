part of 'my_listing_cubit.dart';

abstract class MyListingState {}

class MyListingInitial extends MyListingState {}

class MyListingLoading extends MyListingState {}

class MyListingDeleting extends MyListingState {}

class MyListingLoaded extends MyListingState {
  final PaginatedMyPropertiesModel data;

  MyListingLoaded(this.data);
}

class MyListingError extends MyListingState {
  final String message;

  MyListingError(this.message);
}
