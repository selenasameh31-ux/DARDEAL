import 'package:graduation_project_flutter/core/routing/routes_export.dart';


// ─── States ───────────────────────────────────────────────────────────────────

// abstract class WishlistState {
//   const WishlistState();
// }

// class WishlistInitial extends WishlistState {}

// class WishlistLoading extends WishlistState {}

// class WishlistLoaded extends WishlistState {
//   final List<WishlistItemModel> items;
//   const WishlistLoaded(this.items);
// }

// class WishlistError extends WishlistState {
//   final String message;
//   const WishlistError(this.message);
// }

// // ─── Cubit ────────────────────────────────────────────────────────────────────

// class WishlistCubit extends Cubit<WishlistState> {
//   final WishlistRepository repository;

//   // Local cache for sync across screens
//   final Set<int> _wishedIds = {};

//   WishlistCubit({required this.repository}) : super(WishlistInitial());

//   bool isWished(int propertyId) => _wishedIds.contains(propertyId);

//   Future<void> loadWishlist() async {
//     if (state is WishlistLoading) return;
//     emit(WishlistLoading());
//     try {
//       final items = await repository.getWishlist();
//       _wishedIds.clear();
//       for (final item in items) {
//         _wishedIds.add(item.propertyId);
//       }
//       if (!isClosed) emit(WishlistLoaded(items));
//     } catch (e) {
//       if (!isClosed) emit(WishlistError(e.toString()));
//     }
//   }

//   /// Toggle: add or remove. Returns new state (true = added).
//   Future<bool> toggleWishlist(int propertyId) async {
//     try {
//       final isAdded = await repository.toggleWishlist(propertyId);
//       if (isAdded) {
//         _wishedIds.add(propertyId);
//       } else {
//         _wishedIds.remove(propertyId);
//         // Update list if loaded
//         if (state is WishlistLoaded) {
//           final updated = (state as WishlistLoaded)
//               .items
//               .where((e) => e.propertyId != propertyId)
//               .toList();
//           if (!isClosed) emit(WishlistLoaded(updated));
//         }
//       }
//       return isAdded;
//     } catch (e) {
//       return _wishedIds.contains(propertyId); // keep old state on error
//     }
//   }

//   Future<void> removeFromWishlist(int propertyId) async {
//     try {
//       await repository.removeFromWishlist(propertyId);
//       _wishedIds.remove(propertyId);
//       if (state is WishlistLoaded) {
//         final updated = (state as WishlistLoaded)
//             .items
//             .where((e) => e.propertyId != propertyId)
//             .toList();
//         if (!isClosed) emit(WishlistLoaded(updated));
//       }
//     } catch (e) {
//       // Silently fail — UI stays optimistic
//     }
//   }

//   Future<void> batchCheck(List<int> propertyIds) async {
//     try {
//       final result = await repository.batchCheckWishlist(propertyIds);
//       for (final entry in result.entries) {
//         if (entry.value) {
//           _wishedIds.add(entry.key);
//         } else {
//           _wishedIds.remove(entry.key);
//         }
//       }
//     } catch (_) {}
//   }
// }







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
  late final CacheHelper _cacheHelper;

  // Local cache for sync across screens
  final Set<int> _wishedIds = {};

  WishlistCubit({required this.repository}) : super(WishlistInitial()) {
    _cacheHelper = sl<CacheHelper>();
  }

  bool isWished(int propertyId) => _wishedIds.contains(propertyId);

  void _saveLocalCache(List<WishlistItemModel> items) {
    try {
      final userId = _cacheHelper.getUserId() ?? 'guest';
      final jsonList = items.map((e) => e.toJson()).toList();
      _cacheHelper.saveUserWishlist(userId, jsonEncode(jsonList));
    } catch (_) {}
  }

  void _loadLocalCache() {
    try {
      final userId = _cacheHelper.getUserId() ?? 'guest';
      final cachedJson = _cacheHelper.getUserWishlist(userId);
      if (cachedJson != null) {
        final List decoded = jsonDecode(cachedJson);
        final items = decoded
            .map((e) => WishlistItemModel.fromJson(e))
            .toList();
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

    // 1. Load from local cache immediately
    _loadLocalCache();

    // 2. Fetch from API and merge
    try {
      final items = await repository.getWishlist();
      // If the API returns empty, it means the optimistic toggles failed on backend.
      // We trust our local cache more than an empty API response in this case.
      if (items.isNotEmpty) {
        _wishedIds.clear();
        for (final item in items) {
          _wishedIds.add(item.propertyId);
        }
        _saveLocalCache(items); // Sync cache with backend
        if (!isClosed) emit(WishlistLoaded(items));
      }
    } catch (e) {
      // If API fails, we already have local cache loaded, just emit it if available
      if (state is! WishlistLoaded && !isClosed) {
        emit(WishlistError(e.toString()));
      }
    }
  }

  /// Toggle: add or remove. Returns new state (true = added).
  Future<bool> toggleWishlist(
    int propertyId, {
    WishlistItemModel? newItem,
  }) async {
    // Optimistic local update first so UI responds instantly
    final wasWished = _wishedIds.contains(propertyId);
    if (wasWished) {
      _wishedIds.remove(propertyId);
    } else {
      _wishedIds.add(propertyId);
    }

    // Build the optimistic list and ALWAYS save to cache immediately
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
      // State not loaded yet — bootstrap from newItem if adding
      if (!wasWished && newItem != null) {
        optimisticList = [newItem];
      } else {
        optimisticList = [];
      }
    }

    // Save to local cache IMMEDIATELY (this is what makes it persist across restarts)
    _saveLocalCache(optimisticList);
    if (!isClosed) emit(WishlistLoaded(optimisticList));

    // Fire-and-forget API call — cache is already saved
    try {
      final isAdded = await repository.toggleWishlist(propertyId);
      // Reconcile with server response
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
        _saveLocalCache(reconciled);
        emit(WishlistLoaded(reconciled));
      }
      return isAdded;
    } catch (e) {
      // Cache was already saved during optimistic update — favorites persist
      return !wasWished;
    }
  }

  Future<void> removeFromWishlist(int propertyId) async {
    // Optimistic local remove first
    _wishedIds.remove(propertyId);
    if (state is WishlistLoaded) {
      final current = (state as WishlistLoaded).items;
      final updated = current.where((e) => e.propertyId != propertyId).toList();
      _saveLocalCache(updated);
      if (!isClosed) emit(WishlistLoaded(updated));
    }

    try {
      await repository.removeFromWishlist(propertyId);
    } catch (e) {
      // Keep optimistic update even if API fails
    }
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

  void updatePropertyRating(int propertyId, double newRating) {
    if (state is WishlistLoaded) {
      final current = (state as WishlistLoaded).items;
      final updated = current.map((item) {
        if (item.propertyId == propertyId) {
          return item.copyWith(rating: newRating);
        }
        return item;
      }).toList();
      _saveLocalCache(updated);
      emit(WishlistLoaded(updated));
    }
  }
}

