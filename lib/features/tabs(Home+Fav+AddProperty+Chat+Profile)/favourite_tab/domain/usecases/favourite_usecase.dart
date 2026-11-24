import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class GetWishlistUseCase {
  final WishlistRepository repository;
  GetWishlistUseCase(this.repository);

  Future<List<WishlistItemModel>> call({int page = 1, int pageSize = 20}) {
    return repository.getWishlist(page: page, pageSize: pageSize);
  }
}

class GetCachedWishlistUseCase {
  final WishlistRepository repository;
  GetCachedWishlistUseCase(this.repository);

  List<WishlistItemModel> call() {
    return repository.getCachedWishlist();
  }
}

class CacheWishlistUseCase {
  final WishlistRepository repository;
  CacheWishlistUseCase(this.repository);

  Future<void> call(List<WishlistItemModel> items) {
    return repository.cacheWishlist(items);
  }
}

class ToggleWishlistUseCase {
  final WishlistRepository repository;
  ToggleWishlistUseCase(this.repository);

  Future<bool> call(int propertyId) {
    return repository.toggleWishlist(propertyId);
  }
}

class RemoveFromWishlistUseCase {
  final WishlistRepository repository;
  RemoveFromWishlistUseCase(this.repository);

  Future<void> call(int propertyId) {
    return repository.removeFromWishlist(propertyId);
  }
}

