import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_flutter/core/database/cache/cache_helper.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final CacheHelper _cacheHelper;

  static const String _themeKey = 'APP_THEME_MODE';

  ThemeCubit(this._cacheHelper) : super(ThemeMode.system) {
    _loadTheme();
  }

  void _loadTheme() {
    final savedTheme = _cacheHelper.sharedPreferences.getString(_themeKey);
    if (savedTheme != null) {
      if (savedTheme == 'light') {
        emit(ThemeMode.light);
      } else if (savedTheme == 'dark') {
        emit(ThemeMode.dark);
      } else {
        emit(ThemeMode.system);
      }
    }
  }

  Future<void> setTheme(ThemeMode themeMode) async {
    String themeStr = 'system';
    if (themeMode == ThemeMode.light) {
      themeStr = 'light';
    } else if (themeMode == ThemeMode.dark) {
      themeStr = 'dark';
    }
    await _cacheHelper.sharedPreferences.setString(_themeKey, themeStr);
    emit(themeMode);
  }
}
