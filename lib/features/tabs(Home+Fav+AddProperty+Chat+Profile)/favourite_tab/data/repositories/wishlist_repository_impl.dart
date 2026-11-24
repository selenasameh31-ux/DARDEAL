import 'package:graduation_project_flutter/core/routing/routes_export.dart';


class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistRemoteDataSource remoteDataSource;
  final WishlistLocalDataSource localDataSource;

  WishlistRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<WishlistItemModel>> getWishlist({
    int page = 1,
    int pageSize = 20,
  }) async {
    final items = await remoteDataSource.getWishlist(page: page, pageSize: pageSize);
    final cachedItems = localDataSource.getCachedWishlist();
    final cachedMap = {for (var item in cachedItems) item.propertyId: item};

    final mergedItems = items.map((item) {
      final cachedItem = cachedMap[item.propertyId];
      if (cachedItem != null && (item.rating == null || item.rating == 0.0) && (cachedItem.rating != null && cachedItem.rating! > 0)) {
        return item.copyWith(rating: cachedItem.rating);
      }
      return item;
    }).toList();

    await localDataSource.cacheWishlist(mergedItems);
    return mergedItems;
  }

  @override
  Future<List<WishlistItemModel>> getWishlistDetail({
    int page = 1,
    int pageSize = 20,
  }) async {
    final items = await remoteDataSource.getWishlistDetail(page: page, pageSize: pageSize);
    final cachedItems = localDataSource.getCachedWishlist();
    final cachedMap = {for (var item in cachedItems) item.propertyId: item};

    final mergedItems = items.map((item) {
      final cachedItem = cachedMap[item.propertyId];
      if (cachedItem != null && (item.rating == null || item.rating == 0.0) && (cachedItem.rating != null && cachedItem.rating! > 0)) {
        return item.copyWith(rating: cachedItem.rating);
      }
      return item;
    }).toList();

    return mergedItems;
  }

  @override
  List<WishlistItemModel> getCachedWishlist() {
    return localDataSource.getCachedWishlist();
  }

  @override
  Future<void> cacheWishlist(List<WishlistItemModel> items) {
    return localDataSource.cacheWishlist(items);
  }

  @override
  Future<bool> toggleWishlist(int propertyId) {
    return remoteDataSource.toggleWishlist(propertyId);
  }

  @override
  Future<bool> checkWishlist(int propertyId) {
    return remoteDataSource.checkWishlist(propertyId);
  }

  @override
  Future<Map<int, bool>> batchCheckWishlist(List<int> propertyIds) {
    return remoteDataSource.batchCheckWishlist(propertyIds);
  }

  @override
  Future<void> addToWishlist(int propertyId) {
    return remoteDataSource.addToWishlist(propertyId);
  }

  @override
  Future<void> removeFromWishlist(int propertyId) {
    return remoteDataSource.removeFromWishlist(propertyId);
  }

  @override
  Future<int> getWishlistCount() {
    return remoteDataSource.getWishlistCount();
  }

  @override
  Future<void> updateNote(int propertyId, String notes) {
    return remoteDataSource.updateNote(propertyId, notes);
  }
}
