import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetFeaturedPropertiesUseCase getFeaturedPropertiesUseCase;
  final GetRecentPropertiesUseCase getRecentPropertiesUseCase;
  final GetPropertyTypesUseCase getPropertyTypesUseCase;

  HomeCubit({
    required this.getFeaturedPropertiesUseCase,
    required this.getRecentPropertiesUseCase,
    required this.getPropertyTypesUseCase,
  }) : super(HomeInitial());

  Future<void> loadHomeData() async {
    // Avoid redundant calls and race conditions
    if (state is HomeLoading) return;

    emit(HomeLoading());

    try {
      // Execute all futures concurrently for performance
      final featuredFuture = getFeaturedPropertiesUseCase();
      final recentFuture = getRecentPropertiesUseCase();
      final typesFuture = getPropertyTypesUseCase();

      final results = await Future.wait([
        featuredFuture,
        recentFuture,
        typesFuture,
      ]);

      if (isClosed) return;

      emit(HomeLoaded(
        featuredProperties: List.from(results[0] as List),
        recentProperties: List.from(results[1] as List),
        propertyTypes: List.from(results[2] as List),
      ));
    } catch (e) {
      if (isClosed) return;
      emit(HomeError(e.toString()));
    }
  }
}


abstract class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<HomePropertyModel> featuredProperties;
  final List<HomePropertyModel> recentProperties;
  final List<PropertyTypeModel> propertyTypes;

  const HomeLoaded({
    required this.featuredProperties,
    required this.recentProperties,
    required this.propertyTypes,
  });
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);
}
