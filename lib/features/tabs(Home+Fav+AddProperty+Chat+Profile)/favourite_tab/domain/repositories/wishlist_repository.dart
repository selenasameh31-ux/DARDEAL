import 'package:graduation_project_flutter/core/routing/routes_export.dart';


abstract class WishlistRepository {
  Future<List<WishlistItemModel>> getWishlist({int page = 1, int pageSize = 20});
  Future<List<WishlistItemModel>> getWishlistDetail({int page = 1, int pageSize = 20});
  List<WishlistItemModel> getCachedWishlist();
  Future<void> cacheWishlist(List<WishlistItemModel> items);
  Future<bool> toggleWishlist(int propertyId);
  Future<bool> checkWishlist(int propertyId);
  Future<Map<int, bool>> batchCheckWishlist(List<int> propertyIds);
  Future<void> addToWishlist(int propertyId);
  Future<void> removeFromWishlist(int propertyId);
  Future<int> getWishlistCount();
  Future<void> updateNote(int propertyId, String notes);
}
