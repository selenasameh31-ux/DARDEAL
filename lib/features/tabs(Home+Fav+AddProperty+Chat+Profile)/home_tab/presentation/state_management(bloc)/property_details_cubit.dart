import 'package:graduation_project_flutter/core/routing/routes_export.dart';


class PropertyDetailsCubit extends Cubit<PropertyDetailsState> {
  final GetPropertyDetailsUseCase getPropertyDetailsUseCase;
  final GetSimilarPropertiesUseCase getSimilarPropertiesUseCase;

  PropertyDetailsCubit({
    required this.getPropertyDetailsUseCase,
    required this.getSimilarPropertiesUseCase,
  }) : super(PropertyDetailsInitial());

  Future<void> loadPropertyDetails(int id) async {
    if (state is PropertyDetailsLoading) return;

    emit(PropertyDetailsLoading());

    try {
      final detailsFuture = getPropertyDetailsUseCase(id);
      final similarFuture = getSimilarPropertiesUseCase(id);

      final results = await Future.wait([detailsFuture, similarFuture]);

      if (isClosed) return;

      emit(PropertyDetailsLoaded(
        property: results[0] as PropertyDetailsModel,
        similarProperties: List.from(results[1] as List),
      ));
    } catch (e) {
      if (isClosed) return;
      emit(PropertyDetailsError(e.toString()));
    }
  }
}
