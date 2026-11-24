import 'package:graduation_project_flutter/features/my_listing/data/models/my_property_model.dart';

abstract class MyListingRepository {
  Future<PaginatedMyPropertiesModel> getMyListings({
    required int page,
    required int pageSize,
    String? status,
  });
  Future<void> deleteProperty(int id);
}
