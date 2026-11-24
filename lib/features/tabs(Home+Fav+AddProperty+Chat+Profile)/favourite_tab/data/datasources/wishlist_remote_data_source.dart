import 'package:graduation_project_flutter/core/routing/routes_export.dart';

abstract class WishlistRemoteDataSource {
  Future<List<WishlistItemModel>> getWishlist({
    int page = 1,
    int pageSize = 20,
  });
  Future<List<WishlistItemModel>> getWishlistDetail({
    int page = 1,
    int pageSize = 20,
  });
  Future<bool> toggleWishlist(int propertyId);
  Future<bool> checkWishlist(int propertyId);
  Future<Map<int, bool>> batchCheckWishlist(List<int> propertyIds);
  Future<void> addToWishlist(int propertyId);
  Future<void> removeFromWishlist(int propertyId);
  Future<int> getWishlistCount();
  Future<void> updateNote(int propertyId, String notes);
}

class WishlistRemoteDataSourceImpl implements WishlistRemoteDataSource {
  final ApiConsumer apiConsumer;

  WishlistRemoteDataSourceImpl({required this.apiConsumer});

  List<WishlistItemModel> _parseItemsList(dynamic data) {
    if (data == null) return [];
    List items = [];
    if (data is List) {
      items = data;
    } else if (data is Map) {
      if (data['items'] != null && data['items'] is List) {
        items = data['items'];
      } else if (data['data'] != null && data['data'] is List) {
        items = data['data'];
      } else if (data.containsKey('id') || data.containsKey('propertyId')) {
        items = [data];
      }
    }
    return items
        .map((json) => WishlistItemModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<WishlistItemModel>> getWishlist({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await apiConsumer.get(
        EndPoints.getWishlist,
        queryParameters: {'page': page, 'pageSize': pageSize},
      );
      if (response.data != null) {
        return _parseItemsList(response.data['data']);
      }
      return [];
    } catch (e) {
      throw Exception('Error fetching wishlist: $e');
    }
  }

  @override
  Future<List<WishlistItemModel>> getWishlistDetail({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await apiConsumer.get(
        EndPoints.getWishlistDetail,
        queryParameters: {'page': page, 'pageSize': pageSize},
      );
      if (response.data != null) {
        return _parseItemsList(response.data['data']);
      }
      return [];
    } catch (e) {
      throw Exception('Error fetching wishlist detail: $e');
    }
  }

  @override
  Future<bool> toggleWishlist(int propertyId) async {
    try {
      final response = await apiConsumer.put(
        '${EndPoints.toggleWishlist}$propertyId/toggle',
      );
      if (response.data != null) {
        final data = response.data['data'];
        if (data is bool) return data;
        if (data is Map) {
          return data['isSaved'] ?? data['isAdded'] ?? data['added'] ?? true;
        }
      }
      return true;
    } catch (e) {
      throw Exception('Error toggling wishlist: $e');
    }
  }

  @override
  Future<bool> checkWishlist(int propertyId) async {
    try {
      final response = await apiConsumer.get(
        '${EndPoints.checkWishlist}$propertyId',
      );
      if (response.data != null) {
        final data = response.data['data'];
        if (data is bool) return data;
        if (data is Map) {
          return data['isSaved'] ??
              data['isInWishlist'] ??
              data['inWishlist'] ??
              false;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Map<int, bool>> batchCheckWishlist(List<int> propertyIds) async {
    try {
      final response = await apiConsumer.post(
        EndPoints.batchCheckWishlist,
        data: {'propertyIds': propertyIds},
      );
      if (response.data != null && response.data['data'] is Map) {
        final Map<String, dynamic> raw = response.data['data'];
        return raw.map((k, v) => MapEntry(int.tryParse(k) ?? 0, v as bool));
      }
      return {};
    } catch (e) {
      return {};
    }
  }

  @override
  Future<void> addToWishlist(int propertyId) async {
    try {
      await apiConsumer.post('${EndPoints.toggleWishlist}$propertyId');
    } catch (e) {
      throw Exception('Error adding to wishlist: $e');
    }
  }

  @override
  Future<void> removeFromWishlist(int propertyId) async {
    try {
      await apiConsumer.delete('${EndPoints.toggleWishlist}$propertyId');
    } catch (e) {
      throw Exception('Error removing from wishlist: $e');
    }
  }

  @override
  Future<int> getWishlistCount() async {
    try {
      final response = await apiConsumer.get(EndPoints.getWishlistCount);
      if (response.data != null) {
        final data = response.data['data'];
        if (data is int) return data;
        if (data is Map) return data['count'] ?? 0;
        if (data is String) return int.tryParse(data) ?? 0;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<void> updateNote(int propertyId, String notes) async {
    try {
      await apiConsumer.put(
        '${EndPoints.toggleWishlist}$propertyId/notes',
        data: {'notes': notes},
      );
    } catch (e) {
      throw Exception('Error updating wishlist note: $e');
    }
  }
}
