import 'package:graduation_project_flutter/core/routing/routes_export.dart';

// abstract class HomeRemoteDataSource {
//   Future<List<HomePropertyModel>> getFeaturedProperties();
//   Future<List<HomePropertyModel>> getRecentProperties();
//   Future<List<PropertyTypeModel>> getPropertyTypes();
//   Future<List<HomePropertyModel>> searchProperties({String? propertyType, bool? isRent, int page = 1, int limit = 10});
// }

// class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
//   final ApiConsumer apiConsumer;

//   HomeRemoteDataSourceImpl({required this.apiConsumer});

//   @override
//   Future<List<HomePropertyModel>> getFeaturedProperties() async {
//     try {
//       final response = await apiConsumer.get('/api/v1/Properties/featured');
//       if (response.data['success'] == true) {
//         final List data = response.data['data']['items'] ?? [];
//         return data.map((json) => HomePropertyModel.fromJson(json)).toList();
//       } else {
//         throw Exception(response.data['message'] ?? 'Failed to load featured properties');
//       }
//     } catch (e) {
//       throw Exception('Error fetching featured properties: $e');
//     }
//   }

//   @override
//   Future<List<HomePropertyModel>> getRecentProperties() async {
//     try {
//       final response = await apiConsumer.get('/api/v1/Properties/recent');
//       if (response.data['success'] == true) {
//         final List data = response.data['data']['items'] ?? [];
//         return data.map((json) => HomePropertyModel.fromJson(json)).toList();
//       } else {
//         throw Exception(response.data['message'] ?? 'Failed to load recent properties');
//       }
//     } catch (e) {
//       throw Exception('Error fetching recent properties: $e');
//     }
//   }

//   @override
//   Future<List<PropertyTypeModel>> getPropertyTypes() async {
//     try {
//       final response = await apiConsumer.get('/api/v1/Lookups/property-types');
//       if (response.data['success'] == true) {
//         final List data = response.data['data'] ?? [];
//         return data.map((json) => PropertyTypeModel.fromJson(json)).toList();
//       } else {
//         throw Exception(response.data['message'] ?? 'Failed to load property types');
//       }
//     } catch (e) {
//       throw Exception('Error fetching property types: $e');
//     }
//   }

//   @override
//   Future<List<HomePropertyModel>> searchProperties({String? propertyType, bool? isRent, int page = 1, int limit = 10}) async {
//     try {
//       final queryParams = {
//         if (propertyType != null) 'propertyType': propertyType,
//         if (isRent != null) 'isRent': isRent,
//         'page': page,
//         'limit': limit,
//       };
//       final response = await apiConsumer.get('/api/v1/Properties/search', queryParameters: queryParams);
//       if (response.data['success'] == true) {
//         final List data = response.data['data']['items'] ?? [];
//         return data.map((json) => HomePropertyModel.fromJson(json)).toList();
//       } else {
//         throw Exception(response.data['message'] ?? 'Failed to search properties');
//       }
//     } catch (e) {
//       throw Exception('Error searching properties: $e');
//     }
//   }
// }


abstract class HomeRemoteDataSource {
  Future<List<HomePropertyModel>> getFeaturedProperties();
  Future<List<HomePropertyModel>> getRecentProperties();
  Future<List<PropertyTypeModel>> getPropertyTypes();
  Future<List<HomePropertyModel>> searchProperties({String? propertyType, bool? isRent, int page = 1, int limit = 10});
  Future<PropertyDetailsModel> getPropertyDetails(int id);
  Future<List<HomePropertyModel>> getSimilarProperties(int id);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiConsumer apiConsumer;

  HomeRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<List<HomePropertyModel>> getFeaturedProperties() async {
    try {
      final response = await apiConsumer.get('/api/v1/Properties/featured');
      if (response.data['success'] == true) {
        final List data = response.data['data']['items'] ?? [];
        return data.map((json) => HomePropertyModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load featured properties');
      }
    } catch (e) {
      throw Exception('Error fetching featured properties: $e');
    }
  }

  @override
  Future<List<HomePropertyModel>> getRecentProperties() async {
    try {
      final response = await apiConsumer.get('/api/v1/Properties/recent');
      if (response.data['success'] == true) {
        final List data = response.data['data']['items'] ?? [];
        return data.map((json) => HomePropertyModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load recent properties');
      }
    } catch (e) {
      throw Exception('Error fetching recent properties: $e');
    }
  }

  @override
  Future<List<PropertyTypeModel>> getPropertyTypes() async {
    try {
      final response = await apiConsumer.get('/api/v1/Lookups/property-types');
      if (response.data['success'] == true) {
        final List data = response.data['data'] ?? [];
        return data.map((json) => PropertyTypeModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load property types');
      }
    } catch (e) {
      throw Exception('Error fetching property types: $e');
    }
  }

  @override
  Future<List<HomePropertyModel>> searchProperties({String? propertyType, bool? isRent, int page = 1, int limit = 10}) async {
    try {
      final queryParams = {
        if (propertyType != null) 'propertyType': propertyType,
        if (isRent != null) 'isRent': isRent,
        'page': page,
        'limit': limit,
      };
      final response = await apiConsumer.get('/api/v1/Properties/search', queryParameters: queryParams);
      if (response.data['success'] == true) {
        final List data = response.data['data']['items'] ?? [];
        return data.map((json) => HomePropertyModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to search properties');
      }
    } catch (e) {
      throw Exception('Error searching properties: $e');
    }
  }

  @override
  Future<PropertyDetailsModel> getPropertyDetails(int id) async {
    try {
      final response = await apiConsumer.get('/api/v1/Properties/$id');
      if (response.data['success'] == true) {
        return PropertyDetailsModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load property details');
      }
    } catch (e) {
      throw Exception('Error fetching property details: $e');
    }
  }

  @override
  Future<List<HomePropertyModel>> getSimilarProperties(int id) async {
    try {
      final response = await apiConsumer.get('/api/v1/Properties/$id/similar');
      if (response.data['success'] == true) {
        final List data = response.data['data'] ?? [];
        return data.map((json) => HomePropertyModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load similar properties');
      }
    } catch (e) {
      throw Exception('Error fetching similar properties: $e');
    }
  }
}
