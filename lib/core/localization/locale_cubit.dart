import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_flutter/core/database/cache/cache_helper.dart';

class LocaleCubit extends Cubit<Locale> {
  final CacheHelper _cacheHelper;

  static const String _langKey = 'APP_LANGUAGE';

  LocaleCubit(this._cacheHelper) : super(const Locale('en')) {
    _loadLanguage();
  }

  void _loadLanguage() {
    final savedLang = _cacheHelper.sharedPreferences.getString(_langKey);
    if (savedLang != null) {
      emit(Locale(savedLang));
    }
  }

  Future<void> setLanguage(String languageCode) async {
    await _cacheHelper.sharedPreferences.setString(_langKey, languageCode);
    emit(Locale(languageCode));
  }

  void toggleLanguage() {
    final newLang = state.languageCode == 'en' ? 'ar' : 'en';
    setLanguage(newLang);
  }
}
