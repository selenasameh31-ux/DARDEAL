import 'package:graduation_project_flutter/core/routing/routes_export.dart';

// class GetFeaturedPropertiesUseCase {
//   final HomeRepository repository;
//   GetFeaturedPropertiesUseCase(this.repository);

//   Future<List<HomePropertyModel>> call() {
//     return repository.getFeaturedProperties();
//   }
// }

// class GetRecentPropertiesUseCase {
//   final HomeRepository repository;
//   GetRecentPropertiesUseCase(this.repository);

//   Future<List<HomePropertyModel>> call() {
//     return repository.getRecentProperties();
//   }
// }

// class GetPropertyTypesUseCase {
//   final HomeRepository repository;
//   GetPropertyTypesUseCase(this.repository);

//   Future<List<PropertyTypeModel>> call() {
//     return repository.getPropertyTypes();
//   }
// }

// class SearchPropertiesUseCase {
//   final HomeRepository repository;
//   SearchPropertiesUseCase(this.repository);

//   Future<List<HomePropertyModel>> call({String? propertyType, bool? isRent, int page = 1, int limit = 10}) {
//     return repository.searchProperties(propertyType: propertyType, isRent: isRent, page: page, limit: limit);
//   }
// }



class GetFeaturedPropertiesUseCase {
  final HomeRepository repository;
  GetFeaturedPropertiesUseCase(this.repository);

  Future<List<HomePropertyModel>> call() {
    return repository.getFeaturedProperties();
  }
}

class GetRecentPropertiesUseCase {
  final HomeRepository repository;
  GetRecentPropertiesUseCase(this.repository);

  Future<List<HomePropertyModel>> call() {
    return repository.getRecentProperties();
  }
}

class GetPropertyTypesUseCase {
  final HomeRepository repository;
  GetPropertyTypesUseCase(this.repository);

  Future<List<PropertyTypeModel>> call() {
    return repository.getPropertyTypes();
  }
}

class SearchPropertiesUseCase {
  final HomeRepository repository;
  SearchPropertiesUseCase(this.repository);

  Future<List<HomePropertyModel>> call({String? propertyType, bool? isRent, int page = 1, int limit = 10}) {
    return repository.searchProperties(propertyType: propertyType, isRent: isRent, page: page, limit: limit);
  }
}

class GetPropertyDetailsUseCase {
  final HomeRepository repository;
  GetPropertyDetailsUseCase(this.repository);

  Future<PropertyDetailsModel> call(int id) {
    return repository.getPropertyDetails(id);
  }
}

class GetSimilarPropertiesUseCase {
  final HomeRepository repository;
  GetSimilarPropertiesUseCase(this.repository);

  Future<List<HomePropertyModel>> call(int id) {
    return repository.getSimilarProperties(id);
  }
}
