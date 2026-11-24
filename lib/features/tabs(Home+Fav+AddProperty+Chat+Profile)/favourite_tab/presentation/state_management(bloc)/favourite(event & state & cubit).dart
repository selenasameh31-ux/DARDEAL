import 'package:graduation_project_flutter/core/routing/routes_export.dart';

abstract class WishlistState {
  const WishlistState();
}

class WishlistInitial extends WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistLoaded extends WishlistState {
  final List<WishlistItemModel> items;
  const WishlistLoaded(this.items);
}

class WishlistError extends WishlistState {
  final String message;
  const WishlistError(this.message);
}

// ─── Cubit ────────────────────────────────────────────────────────────────────

class WishlistCubit extends Cubit<WishlistState> {
  final WishlistRepository repository;

  final Set<int> _wishedIds = {};

  WishlistCubit({required this.repository}) : super(WishlistInitial());

  bool isWished(int propertyId) => _wishedIds.contains(propertyId);

  void _emitFromCache() {
    try {
      final items = repository.getCachedWishlist();
      if (items.isNotEmpty) {
        _wishedIds.clear();
        for (final item in items) {
          _wishedIds.add(item.propertyId);
        }
        if (!isClosed) emit(WishlistLoaded(items));
      }
    } catch (_) {}
  }

  Future<void> loadWishlist() async {
    if (state is WishlistLoading) return;
    emit(WishlistLoading());

    // 1. عرض الكاش المحلي فوراً — يمنع infinite loading
    _emitFromCache();

    // 2. جلب من الـ API في الخلفية
    try {
      final items = await repository.getWishlist(page: 1, pageSize: 50);
      if (items.isNotEmpty) {
        _wishedIds.clear();
        for (final item in items) {
          _wishedIds.add(item.propertyId);
        }
        // cacheWishlist is already called inside repo.getWishlist
        if (!isClosed) emit(WishlistLoaded(items));
      } else {
        // API رجعت فاضية: لو مفيش state محمّل نعرض قائمة فارغة
        if (state is! WishlistLoaded && !isClosed) {
          emit(WishlistLoaded([]));
        }
      }
    } catch (e) {
      // API فشلت: لو عندنا كاش محمّل نفضل عليه
      if (state is! WishlistLoaded && !isClosed) {
        emit(WishlistError(e.toString()));
      }
    }
  }

  /// Toggle wishlist status for a property.
  /// [newItem] is used for optimistic add when not yet in the list.
  /// Returns true if now in wishlist, false if removed.
  Future<bool> toggleWishlist(int propertyId, {WishlistItemModel? newItem}) async {
    final wasWished = _wishedIds.contains(propertyId);

    // — Optimistic update —
    if (wasWished) {
      _wishedIds.remove(propertyId);
    } else {
      _wishedIds.add(propertyId);
    }

    List<WishlistItemModel> optimisticList;
    if (state is WishlistLoaded) {
      final current = (state as WishlistLoaded).items;
      if (wasWished) {
        optimisticList = current.where((e) => e.propertyId != propertyId).toList();
      } else if (newItem != null && !current.any((e) => e.propertyId == propertyId)) {
        optimisticList = [...current, newItem];
      } else {
        optimisticList = current;
      }
    } else {
      optimisticList = (!wasWished && newItem != null) ? [newItem] : [];
    }

    await repository.cacheWishlist(optimisticList);
    if (!isClosed) emit(WishlistLoaded(optimisticList));

    // — API call —
    try {
      final isAdded = await repository.toggleWishlist(propertyId);
      if (isAdded) {
        _wishedIds.add(propertyId);
      } else {
        _wishedIds.remove(propertyId);
      }

      if (!isClosed && state is WishlistLoaded) {
        final current = (state as WishlistLoaded).items;
        List<WishlistItemModel> reconciled = current;
        if (isAdded && !current.any((e) => e.propertyId == propertyId) && newItem != null) {
          reconciled = [...current, newItem];
        } else if (!isAdded) {
          reconciled = current.where((e) => e.propertyId != propertyId).toList();
        }
        await repository.cacheWishlist(reconciled);
        emit(WishlistLoaded(reconciled));
      }
      return isAdded;
    } catch (e) {
      // API failed → keep optimistic update
      return !wasWished;
    }
  }

  Future<void> removeFromWishlist(int propertyId) async {
    _wishedIds.remove(propertyId);
    if (state is WishlistLoaded) {
      final current = (state as WishlistLoaded).items;
      final updated = current.where((e) => e.propertyId != propertyId).toList();
      await repository.cacheWishlist(updated);
      if (!isClosed) emit(WishlistLoaded(updated));
    }
    try {
      await repository.removeFromWishlist(propertyId);
    } catch (_) {}
  }

  Future<void> batchCheck(List<int> propertyIds) async {
    try {
      final result = await repository.batchCheckWishlist(propertyIds);
      for (final entry in result.entries) {
        if (entry.value) {
          _wishedIds.add(entry.key);
        } else {
          _wishedIds.remove(entry.key);
        }
      }
    } catch (_) {}
  }

  /// Update the rating of a property in the wishlist (called from ReviewsCubit)
  void updatePropertyRating(int propertyId, double newRating) {
    if (state is WishlistLoaded) {
      final current = (state as WishlistLoaded).items;
      final updated = current.map((item) {
        if (item.propertyId == propertyId) {
          return item.copyWith(rating: newRating);
        }
        return item;
      }).toList();
      repository.cacheWishlist(updated);
      if (!isClosed) emit(WishlistLoaded(updated));
    }
  }
}

