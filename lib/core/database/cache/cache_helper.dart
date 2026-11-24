import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class CacheHelper {
  final SharedPreferences sharedPreferences;

  CacheHelper(this.sharedPreferences);

  static const String _tokenKey = 'TOKEN';
  static const String _refreshTokenKey = 'REFRESH_TOKEN';
  static const String _userIdKey = 'USER_ID';
  static const String _userDataKey = 'USER_DATA';
  static const String _isGuestKey = 'IS_GUEST';
  static const String _onboardingKey = 'ONBOARDING_DONE';

  Future<void> saveToken(String token) async {
    await sharedPreferences.setString(_tokenKey, token);
  }

  String? getToken() {
    return sharedPreferences.getString(_tokenKey);
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    await sharedPreferences.setString(_refreshTokenKey, refreshToken);
  }

  String? getRefreshToken() {
    return sharedPreferences.getString(_refreshTokenKey);
  }

  Future<void> saveUserId(String userId) async {
    await sharedPreferences.setString(_userIdKey, userId);
  }

  String? getUserId() {
    return sharedPreferences.getString(_userIdKey);
  }

  Future<void> saveUserData(String userDataJson) async {
    await sharedPreferences.setString(_userDataKey, userDataJson);
  }

  String? getUserData() {
    return sharedPreferences.getString(_userDataKey);
  }

  Future<void> setGuestMode(bool isGuest) async {
    await sharedPreferences.setBool(_isGuestKey, isGuest);
  }

  bool isGuestMode() {
    return sharedPreferences.getBool(_isGuestKey) ?? false;
  }

  Future<void> setOnboardingDone() async {
    await sharedPreferences.setBool(_onboardingKey, true);
  }

  bool isOnboardingDone() {
    return sharedPreferences.getBool(_onboardingKey) ?? false;
  }

  /// Clears only authentication related data (token, refresh token, user info).
  Future<void> clearAuthData() async {
    await sharedPreferences.remove(_tokenKey);
    await sharedPreferences.remove(_refreshTokenKey);
    await sharedPreferences.remove(_userIdKey);
    await sharedPreferences.remove(_userDataKey);
    // Preserve onboarding and guest mode flags.
  }

  Future<void> saveUserWishlist(String userId, String wishlistJson) async {
    await sharedPreferences.setString('WISHLIST_$userId', wishlistJson);
  }

  String? getUserWishlist(String userId) {
    return sharedPreferences.getString('WISHLIST_$userId');
  }

  static const String _recentSearchesKey = 'RECENT_SEARCHES';
  static const String _filterStateKey = 'FILTER_STATE';

  // حفظ واسترجاع عمليات البحث الأخيرة
  Future<void> saveRecentSearches(List<String> searches) async {
    await sharedPreferences.setStringList(_recentSearchesKey, searches);
  }

  List<String> getRecentSearches() {
    return sharedPreferences.getStringList(_recentSearchesKey) ?? [];
  }

  static const String _searchCountsKey = 'SEARCH_COUNTS';

  Future<void> recordSearchQuery(String query) async {
    if (query.trim().isEmpty) return;
    
    // Update Recent
    List<String> recent = getRecentSearches();
    recent.remove(query);
    recent.insert(0, query);
    if (recent.length > 5) {
      recent = recent.sublist(0, 5);
    }
    await saveRecentSearches(recent);

    // Update Popular (Frequency Map)
    String countsStr = sharedPreferences.getString(_searchCountsKey) ?? '{}';
    Map<String, dynamic> counts = {};
    try {
      counts = jsonDecode(countsStr);
    } catch (_) {}
    
    counts[query] = (counts[query] as int? ?? 0) + 1;
    await sharedPreferences.setString(_searchCountsKey, jsonEncode(counts));
  }

  List<String> getPopularSearches() {
    String countsStr = sharedPreferences.getString(_searchCountsKey) ?? '{}';
    Map<String, dynamic> counts = {};
    try {
      counts = jsonDecode(countsStr);
    } catch (_) {}

    var sortedKeys = counts.keys.toList(growable: false)
      ..sort((k1, k2) => (counts[k2] as int).compareTo(counts[k1] as int));

    return sortedKeys.take(4).toList();
  }

  // حفظ واسترجاع حالة الفلتر
  Future<void> saveFilterState(String filterJson) async {
    await sharedPreferences.setString(_filterStateKey, filterJson);
  }

  String? getFilterState() {
    return sharedPreferences.getString(_filterStateKey);
  }
}


