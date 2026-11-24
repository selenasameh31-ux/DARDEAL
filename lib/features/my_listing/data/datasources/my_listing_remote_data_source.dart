import 'package:graduation_project_flutter/core/database/api/api_consumer.dart';
import 'package:graduation_project_flutter/core/database/api/end_points.dart';
import 'package:graduation_project_flutter/core/database/cache/cache_helper.dart';
import 'package:graduation_project_flutter/features/my_listing/data/models/my_property_model.dart';

abstract class MyListingsRemoteDataSource {
  Future<PaginatedMyPropertiesModel> getMyListings({
    required int page,
    required int pageSize,
    String? status,
  });
  Future<void> deleteProperty(int id);
}

class MyListingsRemoteDataSourceImpl implements MyListingsRemoteDataSource {
  final ApiConsumer api;
  final CacheHelper cacheHelper;

  MyListingsRemoteDataSourceImpl({
    required this.api,
    required this.cacheHelper,
  });

  String get _token => cacheHelper.getToken() ?? '';

  @override
  Future<PaginatedMyPropertiesModel> getMyListings({
    required int page,
    required int pageSize,
    String? status,
  }) async {
    final Map<String, dynamic> queryParameters = {
      'page': page,
      'pageSize': pageSize,
    };
    if (status != null && status.isNotEmpty && status.toLowerCase() != 'all') {
      queryParameters['status'] = status;
    }

    final response = await api.get(
      EndPoints.myProperties,
      token: _token,
      queryParameters: queryParameters,
    );

    final data = response.data;
    if (data is Map<String, dynamic>) {
      if (data.containsKey('data')) {
        final innerData = data['data'];
        if (innerData is List) {
          return PaginatedMyPropertiesModel(
            items: innerData.map((e) => MyPropertyModel.fromJson(e)).toList(),
            totalCount: innerData.length,
            page: page,
            pageSize: pageSize,
            totalPages: 1,
          );
        } else if (innerData is Map<String, dynamic>) {
          return PaginatedMyPropertiesModel.fromJson(innerData);
        }
      } else if (data.containsKey('items')) {
        return PaginatedMyPropertiesModel.fromJson(data);
      } else {
        // Fallback for maps without 'data' or 'items'
        return PaginatedMyPropertiesModel.fromJson(data);
      }
    } else if (data is List) {
      return PaginatedMyPropertiesModel(
        items: data.map((e) => MyPropertyModel.fromJson(e)).toList(),
        totalCount: data.length,
        page: page,
        pageSize: pageSize,
        totalPages: 1,
      );
    }
    
    throw Exception('Invalid API response format: ${data.runtimeType}');
  }

  @override
  Future<void> deleteProperty(int id) async {
    await api.delete(
      EndPoints.property(id),
      token: _token,
    );
  }
}
