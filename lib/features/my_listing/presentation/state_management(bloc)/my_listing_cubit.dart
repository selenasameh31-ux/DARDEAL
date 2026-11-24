import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_flutter/features/my_listing/data/models/my_property_model.dart';
import 'package:graduation_project_flutter/features/my_listing/domain/repositories/my_listing_repository.dart';

part 'my_listing_state.dart';

class MyListingCubit extends Cubit<MyListingState> {
  final MyListingRepository repository;

  MyListingCubit({required this.repository}) : super(MyListingInitial());

  Future<void> loadListings({String? status, int page = 1, int pageSize = 20}) async {
    emit(MyListingLoading());
    try {
      final data = await repository.getMyListings(
        page: page,
        pageSize: pageSize,
        status: status,
      );
      emit(MyListingLoaded(data));
    } catch (e) {
      if (e is DioException) {
        final statusCode = e.response?.statusCode;
        if (statusCode == 401 || statusCode == 403 || statusCode == 404 || statusCode == 405) {
          emit(MyListingLoaded(PaginatedMyPropertiesModel(
            items: [],
            totalCount: 0,
            page: page,
            pageSize: pageSize,
            totalPages: 1,
          )));
          return;
        }
      }
      emit(MyListingError("Failed to load your listings. Please try again later."));
    }
  }

  Future<void> deleteProperty(int propertyId) async {
    // Snapshot current loaded state so we can restore on error
    final currentState = state;
    try {
      if (currentState is MyListingLoaded) {
        final currentData = currentState.data;
        final updatedItems = currentData.items.where((e) => e.id != propertyId).toList();
        final updatedData = PaginatedMyPropertiesModel(
          items: updatedItems,
          totalCount: currentData.totalCount - 1,
          page: currentData.page,
          pageSize: currentData.pageSize,
          totalPages: currentData.totalPages,
        );
        emit(MyListingLoaded(updatedData));
      } else {
        emit(MyListingDeleting());
      }
      
      await repository.deleteProperty(propertyId);
    } catch (e) {
      // Restore the previous list so the card doesn't disappear on failure
      emit(currentState);
      emit(MyListingError("Failed to delete property. Please try again."));
      if (currentState is MyListingLoaded) {
        await Future.delayed(const Duration(milliseconds: 100));
        emit(currentState);
      }
    }
  }
}
