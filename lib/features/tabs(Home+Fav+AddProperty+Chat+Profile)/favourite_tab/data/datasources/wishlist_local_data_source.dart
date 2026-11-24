import 'package:graduation_project_flutter/core/routing/routes_export.dart';

abstract class WishlistLocalDataSource {
  Future<void> cacheWishlist(List<WishlistItemModel> items);
  List<WishlistItemModel> getCachedWishlist();
}

class WishlistLocalDataSourceImpl implements WishlistLocalDataSource {
  final CacheHelper cacheHelper;

  WishlistLocalDataSourceImpl({required this.cacheHelper});

  @override
  Future<void> cacheWishlist(List<WishlistItemModel> items) async {
    try {
      final userId = cacheHelper.getUserId() ?? 'guest';
      final jsonList = items.map((e) => e.toJson()).toList();
      cacheHelper.saveUserWishlist(userId, jsonEncode(jsonList));
    } catch (_) {}
  }

  @override
  List<WishlistItemModel> getCachedWishlist() {
    try {
      final userId = cacheHelper.getUserId() ?? 'guest';
      final cachedJson = cacheHelper.getUserWishlist(userId);
      if (cachedJson != null) {
        final List decoded = jsonDecode(cachedJson);
        return decoded.map((e) => WishlistItemModel.fromJson(e)).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }
}
