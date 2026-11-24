import 'package:graduation_project_flutter/core/routing/routes_export.dart';

// abstract class PropertyTypeListingState {}

// class PropertyTypeListingInitial extends PropertyTypeListingState {}

// class PropertyTypeListingLoading extends PropertyTypeListingState {}

// class PropertyTypeListingLoaded extends PropertyTypeListingState {
//   final List<HomePropertyModel> properties;
//   final bool hasReachedMax;

//   PropertyTypeListingLoaded({
//     required this.properties,
//     required this.hasReachedMax,
//   });
// }

// class PropertyTypeListingError extends PropertyTypeListingState {
//   final String message;

//   PropertyTypeListingError(this.message);
// }

// class PropertyTypeListingCubit extends Cubit<PropertyTypeListingState> {
//   final SearchPropertiesUseCase searchPropertiesUseCase;

//   PropertyTypeListingCubit({required this.searchPropertiesUseCase})
//       : super(PropertyTypeListingInitial());

//   int _currentPage = 1;
//   final int _pageSize = 10;
//   bool _isFetching = false;
  
//   String? _currentPropertyType;
//   bool? _currentIsRent;

//   Future<void> loadProperties({required String propertyType, required bool isRent}) async {
//     _currentPropertyType = propertyType;
//     _currentIsRent = isRent;
//     _currentPage = 1;

//     emit(PropertyTypeListingLoading());

//     try {
//       final properties = await searchPropertiesUseCase(
//         propertyType: _currentPropertyType,
//         isRent: _currentIsRent,
//         page: _currentPage,
//         limit: _pageSize,
//       );

//       if (isClosed) return;

//       emit(PropertyTypeListingLoaded(
//         properties: properties,
//         hasReachedMax: properties.length < _pageSize,
//       ));
//     } catch (e) {
//       if (isClosed) return;
//       emit(PropertyTypeListingError(e.toString()));
//     }
//   }

//   Future<void> loadMoreProperties() async {
//     if (state is PropertyTypeListingLoaded) {
//       final currentState = state as PropertyTypeListingLoaded;
//       if (currentState.hasReachedMax || _isFetching) return;

//       _isFetching = true;
//       _currentPage++;

//       try {
//         final newProperties = await searchPropertiesUseCase(
//           propertyType: _currentPropertyType,
//           isRent: _currentIsRent,
//           page: _currentPage,
//           limit: _pageSize,
//         );

//         if (isClosed) return;

//         emit(PropertyTypeListingLoaded(
//           properties: List.from(currentState.properties)..addAll(newProperties),
//           hasReachedMax: newProperties.length < _pageSize,
//         ));
//       } catch (e) {
//         // Fallback to previous state or show error
//         _currentPage--;
//       } finally {
//         _isFetching = false;
//       }
//     }
//   }
// }





abstract class PropertyTypeListingState {}

class PropertyTypeListingInitial extends PropertyTypeListingState {}

class PropertyTypeListingLoading extends PropertyTypeListingState {}

class PropertyTypeListingLoaded extends PropertyTypeListingState {
  final List<HomePropertyModel> properties;
  final bool hasReachedMax;

  PropertyTypeListingLoaded({
    required this.properties,
    required this.hasReachedMax,
  });
}

class PropertyTypeListingError extends PropertyTypeListingState {
  final String message;

  PropertyTypeListingError(this.message);
}

class PropertyTypeListingCubit extends Cubit<PropertyTypeListingState> {
  final SearchPropertiesUseCase searchPropertiesUseCase;

  PropertyTypeListingCubit({required this.searchPropertiesUseCase})
    : super(PropertyTypeListingInitial());

  int _currentPage = 1;
  final int _pageSize = 10;
  bool _isFetching = false;

  String? _currentPropertyType;
  bool? _currentIsRent;

  Future<void> loadProperties({
    required String propertyType,
    required bool isRent,
  }) async {
    _currentPropertyType = propertyType;
    _currentIsRent = isRent;
    _currentPage = 1;

    emit(PropertyTypeListingLoading());

    try {
      final properties = await searchPropertiesUseCase(
        propertyType: _currentPropertyType,
        isRent: _currentIsRent,
        page: _currentPage,
        limit: _pageSize,
      );

      if (isClosed) return;

      emit(
        PropertyTypeListingLoaded(
          properties: properties,
          hasReachedMax: properties.length < _pageSize,
        ),
      );
    } catch (e) {
      if (isClosed) return;
      emit(PropertyTypeListingError(e.toString()));
    }
  }

  int _levenshtein(String a, String b) {
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;
    var v0 = List<int>.filled(b.length + 1, 0);
    var v1 = List<int>.filled(b.length + 1, 0);
    for (var i = 0; i <= b.length; i++) v0[i] = i;
    for (var i = 0; i < a.length; i++) {
      v1[0] = i + 1;
      for (var j = 0; j < b.length; j++) {
        var cost = (a[i] == b[j]) ? 0 : 1;
        var min = v1[j] + 1;
        if (v0[j + 1] + 1 < min) min = v0[j + 1] + 1;
        if (v0[j] + cost < min) min = v0[j] + cost;
        v1[j + 1] = min;
      }
      for (var j = 0; j <= b.length; j++) v0[j] = v1[j];
    }
    return v1[b.length];
  }

  bool _isFuzzyMatch(String text, String term) {
    if (text.contains(term)) return true;
    if (term.length < 4) return false; // Exact match required for very short words
    
    // Split by non-word characters to get words
    final words = text.split(RegExp(r'[^a-zA-Z0-9\u0600-\u06FF]+'));
    for (final word in words) {
      if (word.length >= term.length - 1 && word.length <= term.length + 1) {
        if (_levenshtein(word, term) <= 1) {
          return true;
        }
      }
    }
    return false;
  }

  Future<void> searchWithQuery(String query) async {
    if (query.trim().isEmpty) return;
    _currentPropertyType = null;
    _currentIsRent = null;
    _currentPage = 1;

    emit(PropertyTypeListingLoading());

    try {
      // Fetch a large chunk for local filtering
      final allProperties = await searchPropertiesUseCase(
        propertyType: null,
        isRent: null,
        page: 1,
        limit: 100, 
      );

      if (isClosed) return;

      final lowerQuery = query.toLowerCase().trim();
      
      // Extended Arabic to English mapping for common real estate terms and governorates
      final Map<String, String> arToEn = {
        'شقة': 'apartment', 'شقق': 'apartment', 'فيلا': 'villa', 'فلل': 'villa',
        'شاليه': 'chalet', 'تجاري': 'commercial', 'محل': 'commercial', 'مكتب': 'commercial',
        'ايجار': 'rent', 'للايجار': 'rent', 'للإيجار': 'rent', 'مفروش': 'furnished', 'مفروشة': 'furnished',
        'بيع': 'sale', 'للبيع': 'sale', 'غرفة': 'room', 'غرف': 'room', 'اوضة': 'room', 'اوضتين': '2',
        'القاهرة': 'cairo', 'الجيزة': 'giza', 'اسكندرية': 'alexandria', 'الاسكندرية': 'alexandria',
        'الساحل': 'north coast', 'مطروح': 'matrouh', 'مرسى مطروح': 'matrouh', 'شرم': 'sharm',
        'الغردقة': 'hurghada', 'الجونة': 'el gouna', 'العين السخنة': 'sokhna', 'السخنة': 'sokhna',
        'اكتوبر': 'october', 'أكتوبر': 'october', 'زايد': 'zayed', 'الشيخ زايد': 'sheikh zayed',
        'تجمع': 'new cairo', 'التجمع': 'new cairo', 'الخامس': 'fifth settlement',
        'المعادي': 'maadi', 'معادي': 'maadi', 'الزمالك': 'zamalek', 'زمالك': 'zamalek',
        'مدينة نصر': 'nasr city', 'مصر الجديدة': 'heliopolis', 'المهندسين': 'mohandeseen',
        'الدقي': 'dokki', 'العاصمة': 'new capital', 'الرحاب': 'rehab', 'مدينتي': 'madinaty',
        'الشروق': 'shourouk', 'العبور': 'obour', 'المنصورة': 'mansoura', 'طنطا': 'tanta',
        'الزقازيق': 'zagazig', 'بنها': 'banha', 'اسيوط': 'assiut', 'سوهاج': 'sohag',
        'المنيا': 'minya', 'الاقصر': 'luxor', 'اسوان': 'aswan', 'بورسعيد': 'port said',
        'الاسماعيلية': 'ismailia', 'السويس': 'suez', 'دمياط': 'damietta',
      };

      final stopWords = ['و', 'في', 'من', 'على', 'مساحة', 'متر', 'بتاع', 'ال', 'in', 'of', 'for', 'with', 'and'];

      String mappedQuery = lowerQuery;
      // Sort keys by length descending to match longer phrases first (e.g. "الشيخ زايد" before "زايد")
      final sortedKeys = arToEn.keys.toList()..sort((a, b) => b.length.compareTo(a.length));
      for (final ar in sortedKeys) {
        if (mappedQuery.contains(ar)) {
          mappedQuery = mappedQuery.replaceAll(ar, arToEn[ar]!);
        }
      }

      final queryTerms = mappedQuery
          .split(RegExp(r'\s+'))
          .where((e) => e.isNotEmpty && !stopWords.contains(e))
          .toList();

      // Extract numbers to guess user intent
      int? inferredBedrooms;
      double? inferredArea;
      double? inferredPrice;

      for (final term in queryTerms) {
        final numValue = double.tryParse(term);
        if (numValue != null) {
          if (numValue > 0 && numValue <= 10) {
            inferredBedrooms = numValue.toInt();
          } else if (numValue > 20 && numValue <= 500) {
            inferredArea = numValue;
          } else if (numValue > 1000) {
            inferredPrice = numValue;
          }
        }
      }

      List<Map<String, dynamic>> scoredProperties = [];

      for (final p in allProperties) {
        final title = p.title.toLowerCase();
        final address = p.address.toLowerCase();
        final type = p.propertyType.toLowerCase();
        final listing = p.listingType?.toLowerCase() ?? '';
        final desc = p.description?.toLowerCase() ?? '';
        final furnish = p.furnishingStatus?.toLowerCase() ?? '';

        int matchScore = 0;
        int numericScore = 0;

        for (final term in queryTerms) {
          if (double.tryParse(term) != null) continue; // Skip raw numbers for text match

          if (_isFuzzyMatch(title, term)) matchScore += 3;
          else if (_isFuzzyMatch(type, term)) matchScore += 3;
          else if (_isFuzzyMatch(listing, term)) matchScore += 3;
          else if (_isFuzzyMatch(address, term)) matchScore += 2;
          else if (_isFuzzyMatch(furnish, term)) matchScore += 2;
          else if (_isFuzzyMatch(desc, term)) matchScore += 1;
        }

        // Numerical Matching (Fuzzy)
        if (inferredBedrooms != null && p.bedrooms != null) {
          if (p.bedrooms == inferredBedrooms) numericScore += 5;
          else if ((p.bedrooms! - inferredBedrooms).abs() <= 1) numericScore += 2;
        }

        if (inferredArea != null && p.areaSquareMeters != null) {
          final diff = (p.areaSquareMeters! - inferredArea).abs();
          if (diff <= 20) numericScore += 5; // Close to 20 sqm
          else if (diff <= 50) numericScore += 2;
        }

        if (inferredPrice != null && p.price > 0) {
          final diffRatio = (p.price - inferredPrice).abs() / inferredPrice;
          if (diffRatio <= 0.2) numericScore += 5; // Within 20% price
          else if (diffRatio <= 0.5) numericScore += 2;
        }

        final totalScore = matchScore + numericScore;

        if (totalScore > 0) {
          scoredProperties.add({'property': p, 'score': totalScore});
        }
      }

      // Sort by best match (highest score first)
      scoredProperties.sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));

      final filtered = scoredProperties.map((e) => e['property'] as HomePropertyModel).toList();

      emit(
        PropertyTypeListingLoaded(
          properties: filtered,
          hasReachedMax: true,
        ),
      );
    } catch (e) {
      if (isClosed) return;
      emit(PropertyTypeListingError(e.toString()));
    }
  }

  Future<void> searchWithFilters(Map<String, dynamic> filters) async {
    _currentPage = 1;

    emit(PropertyTypeListingLoading());

    try {
      final allProperties = await searchPropertiesUseCase(
        propertyType: null,
        isRent: null,
        page: 1,
        limit: 100,
      );

      if (isClosed) return;

      final listingTypeFilter = (filters['listingType'] as String?)?.toLowerCase();
      final propertyTypesFilter = (filters['propertyTypes'] as List<String>?)?.map((e) => e.toLowerCase()).toList();

      List<Map<String, dynamic>> scoredProperties = [];

      for (final p in allProperties) {
        int matchScore = 0;

        if (listingTypeFilter != null && listingTypeFilter.isNotEmpty) {
          final pListing = p.listingType?.toLowerCase() ?? '';
          if (pListing.contains(listingTypeFilter) || (listingTypeFilter == 'rent' && pListing == 'shorttermrent')) {
            matchScore += 5; // High weight for exact listing match
          }
        }

        if (propertyTypesFilter != null && propertyTypesFilter.isNotEmpty) {
          final pType = p.propertyType.toLowerCase();
          if (propertyTypesFilter.any((type) => pType.contains(type) || type.contains(pType))) {
            matchScore += 5; // High weight for property type match
          }
        }

        // Even if score is 0, we can include them at the bottom as "similar" or fallback,
        // but it's better to show at least those with some score. 
        // If filters are empty, show all.
        if (listingTypeFilter == null && (propertyTypesFilter == null || propertyTypesFilter.isEmpty)) {
          matchScore = 1; 
        }

        if (matchScore > 0) {
          scoredProperties.add({'property': p, 'score': matchScore});
        }
      }

      // If no perfect match found, we still return the partial matches (score > 0) sorted
      scoredProperties.sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));

      // If absolutely no matches, fallback to showing all to avoid "No results"
      if (scoredProperties.isEmpty) {
        scoredProperties = allProperties.map((p) => {'property': p, 'score': 0}).toList();
      }

      final filtered = scoredProperties.map((e) => e['property'] as HomePropertyModel).toList();

      emit(
        PropertyTypeListingLoaded(
          properties: filtered,
          hasReachedMax: true,
        ),
      );
    } catch (e) {
      if (isClosed) return;
      emit(PropertyTypeListingError(e.toString()));
    }
  }

  Future<void> loadMoreProperties() async {
    if (state is PropertyTypeListingLoaded) {
      final currentState = state as PropertyTypeListingLoaded;
      if (currentState.hasReachedMax || _isFetching) return;

      _isFetching = true;
      _currentPage++;

      try {
        final newProperties = await searchPropertiesUseCase(
          propertyType: _currentPropertyType,
          isRent: _currentIsRent,
          page: _currentPage,
          limit: _pageSize,
        );

        if (isClosed) return;

        emit(
          PropertyTypeListingLoaded(
            properties: List.from(currentState.properties)
              ..addAll(newProperties),
            hasReachedMax: newProperties.length < _pageSize,
          ),
        );
      } catch (e) {
        // Fallback to previous state or show error
        _currentPage--;
      } finally {
        _isFetching = false;
      }
    }
  }
}
