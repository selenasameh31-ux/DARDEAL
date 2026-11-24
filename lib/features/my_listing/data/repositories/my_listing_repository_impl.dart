import 'package:graduation_project_flutter/features/my_listing/data/datasources/my_listing_remote_data_source.dart';
import 'package:graduation_project_flutter/features/my_listing/data/models/my_property_model.dart';
import 'package:graduation_project_flutter/features/my_listing/domain/repositories/my_listing_repository.dart';

class MyListingRepositoryImpl implements MyListingRepository {
  final MyListingsRemoteDataSource remoteDataSource;

  MyListingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PaginatedMyPropertiesModel> getMyListings({
    required int page,
    required int pageSize,
    String? status,
  }) async {
    return await remoteDataSource.getMyListings(
      page: page,
      pageSize: pageSize,
      status: status,
    );
  }

  @override
  Future<void> deleteProperty(int id) async {
    return await remoteDataSource.deleteProperty(id);
  }
}
