import 'package:graduation_project_flutter/core/routing/routes_export.dart';

// abstract class HomeRepository {
//   Future<List<HomePropertyModel>> getFeaturedProperties();
//   Future<List<HomePropertyModel>> getRecentProperties();
//   Future<List<PropertyTypeModel>> getPropertyTypes();
//   Future<List<HomePropertyModel>> searchProperties({String? propertyType, bool? isRent, int page = 1, int limit = 10});
// }


abstract class HomeRepository {
  Future<List<HomePropertyModel>> getFeaturedProperties();
  Future<List<HomePropertyModel>> getRecentProperties();
  Future<List<PropertyTypeModel>> getPropertyTypes();
  Future<List<HomePropertyModel>> searchProperties({String? propertyType, bool? isRent, int page = 1, int limit = 10});
  Future<PropertyDetailsModel> getPropertyDetails(int id);
  Future<List<HomePropertyModel>> getSimilarProperties(int id);
}
