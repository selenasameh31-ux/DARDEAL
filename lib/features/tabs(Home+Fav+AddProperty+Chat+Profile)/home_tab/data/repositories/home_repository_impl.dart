import 'package:graduation_project_flutter/core/routing/routes_export.dart';

// class HomeRepositoryImpl implements HomeRepository {
//   final HomeRemoteDataSource remoteDataSource;

//   HomeRepositoryImpl({required this.remoteDataSource});

//   @override
//   Future<List<HomePropertyModel>> getFeaturedProperties() {
//     return remoteDataSource.getFeaturedProperties();
//   }

//   @override
//   Future<List<HomePropertyModel>> getRecentProperties() {
//     return remoteDataSource.getRecentProperties();
//   }

//   @override
//   Future<List<PropertyTypeModel>> getPropertyTypes() {
//     return remoteDataSource.getPropertyTypes();
//   }

//   @override
//   Future<List<HomePropertyModel>> searchProperties({String? propertyType, bool? isRent, int page = 1, int limit = 10}) {
//     return remoteDataSource.searchProperties(propertyType: propertyType, isRent: isRent, page: page, limit: limit);
//   }
// }


class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<HomePropertyModel>> getFeaturedProperties() {
    return remoteDataSource.getFeaturedProperties();
  }

  @override
  Future<List<HomePropertyModel>> getRecentProperties() {
    return remoteDataSource.getRecentProperties();
  }

  @override
  Future<List<PropertyTypeModel>> getPropertyTypes() {
    return remoteDataSource.getPropertyTypes();
  }

  @override
  Future<List<HomePropertyModel>> searchProperties({String? propertyType, bool? isRent, int page = 1, int limit = 10}) {
    return remoteDataSource.searchProperties(propertyType: propertyType, isRent: isRent, page: page, limit: limit);
  }

  @override
  Future<PropertyDetailsModel> getPropertyDetails(int id) {
    return remoteDataSource.getPropertyDetails(id);
  }

  @override
  Future<List<HomePropertyModel>> getSimilarProperties(int id) {
    return remoteDataSource.getSimilarProperties(id);
  }
}
