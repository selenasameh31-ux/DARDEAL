 import 'package:graduation_project_flutter/core/routing/routes_export.dart';

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});

//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   final TextEditingController _searchController = TextEditingController();
  
//   // بيانات تجريبية للـ Recent Searches (أقصى عدد 5)
//   List<String> _recentSearches = [
//     "Apartment for rent in Maadi",
//     "3 Bedroom in Sheikh Zayed",
//     "Villa in New Cairo",
//   ];

//   // أطقم الاختيار المتعدد (Multi-select)
//   final Set<String> _selectedCities = {};
//   final Set<String> _selectedTypes = {};

//   final List<Map<String, dynamic>> _popularCities = [
//     {'title': 'Downtown Cairo', 'icon': Icons.location_on},
//     {'title': 'Zamalek', 'icon': Icons.location_on},
//     {'title': 'New Cairo', 'icon': Icons.location_on},
//     {'title': 'North Coast', 'icon': Icons.waves},
//   ];

//   final List<Map<String, dynamic>> _propertyCategories = [
//     {'title': 'Apartments', 'icon': Icons.apartment},
//     {'title': 'Villas', 'icon': Icons.villa},
//     {'title': 'Chalets', 'icon': Icons.home_work},
//     {'title': 'Commercial', 'icon': Icons.storefront},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final mainThemeColor = isDark ? DarkColors.darkmainColor : LightColors.lightmaincolor;
//     final titleColor = isDark ? DarkColors.darkTitleAndSubTitleText : LightColors.lightTitleAndSubTitleText;
//     final hintColor = isDark ? DarkColors.darkHintTextFieldColor : LightColors.lightHintTextFieldColor;
//     final textFieldBgColor = isDark ? DarkColors.darkTextFieldColor : LightColors.lightTextFieldColor;

//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Header: Back Button + Search Bar + Filter
//             Padding(
//               padding: const EdgeInsets.only(top: 15, left: 1, right: 14),
//               child: Row(
//                 children: [
//                   IconButton(
//                     onPressed: () => Navigator.pop(context),
//                     icon: Container(
//                       padding: const EdgeInsets.all(6),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(color: hintColor),
//                       ),
//                       child: Icon(Icons.arrow_back_ios_new, size: 10, color: titleColor),
//                     ),
//                   ),
//                   Expanded(
//                     child: Container(
//                       height: 48,
//                       decoration: BoxDecoration(
//                         color: textFieldBgColor,
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: TextField(
//                         controller: _searchController,
//                         autofocus: true, // تم تعديل الـ f لتكون lowercase
//                         cursorColor: mainThemeColor,
//                         // إضافة الـ textDirection بناءً على اللغة و onChanged لتحديث الحالة
//                         textDirection: RegExp(r'[\u0600-\u06FF]').hasMatch(_searchController.text) 
//                             ? TextDirection.rtl 
//                             : TextDirection.ltr,
//                         onChanged: (value) {
//                           setState(() {}); 
//                         },
//                         style: TextStyle(color: titleColor, fontFamily: AppFonts.font),
//                         decoration: InputDecoration(
//                           hintText: "Search address , city...",
//                           hintStyle: TextStyle(color: hintColor, fontSize: 14, fontFamily: AppFonts.font),
//                           prefixIcon: Icon(Icons.search, color: mainThemeColor, size: 22),
//                           border: InputBorder.none,
//                           contentPadding: const EdgeInsets.symmetric(vertical: 12),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   _buildFilterIcon(mainThemeColor, isDark),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 15),
//             const Divider(thickness: 0.5),

//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Recent Searches Section
//                     if (_recentSearches.isNotEmpty) ...[
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text("Recent Searches", 
//                             style: TextStyle(color: mainThemeColor, fontWeight: FontWeight.bold, fontSize: 17, fontFamily: AppFonts.font)),
//                           TextButton(
//                             onPressed: () => setState(() => _recentSearches.clear()),
//                             child: Text("Clear", style: TextStyle(color: const Color.fromARGB(255, 249, 73, 73), fontWeight: FontWeight.bold, fontFamily: AppFonts.font)),
//                           ),
//                         ],
//                       ),
//                       ..._recentSearches.take(5).map((search) => _buildRecentItem(search, titleColor, hintColor)),
//                       const SizedBox(height: 10),
//                       const Divider(thickness: 0.5),
//                     ],

//                     const SizedBox(height: 15),
//                     // Popular Searches Section
//                     Text("Popular Searches", 
//                         style: TextStyle(color: mainThemeColor, fontWeight: FontWeight.bold, fontSize: 17, fontFamily: AppFonts.font)),
//                     const SizedBox(height: 15),
                    
//                     // Cities Chips
//                     Wrap(
//                       spacing: 10,
//                       runSpacing: 10,
//                       children: _popularCities.map((city) => _buildSelectionChip(
//                         city['title'], 
//                         city['icon'], 
//                         mainThemeColor, 
//                         _selectedCities.contains(city['title']),
//                         () => setState(() {
//                           _selectedCities.contains(city['title']) 
//                               ? _selectedCities.remove(city['title']) 
//                               : _selectedCities.add(city['title']);
//                         })
//                       )).toList(),
//                     ),
                    
//                     const SizedBox(height: 20),
//                     // Property Types Chips
//                     Wrap(
//                       spacing: 10,
//                       runSpacing: 10,
//                       children: _propertyCategories.map((type) => _buildSelectionChip(
//                         type['title'], 
//                         type['icon'], 
//                         mainThemeColor, 
//                         _selectedTypes.contains(type['title']),
//                         () => setState(() {
//                           _selectedTypes.contains(type['title']) 
//                               ? _selectedTypes.remove(type['title']) 
//                               : _selectedTypes.add(type['title']);
//                         })
//                       )).toList(),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFilterIcon(Color mainColor, bool isDark) {
//     return InkWell(
//       onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FilterScreen())),
//       child: Container(
//         height: 45,
//         width: 45,
//         decoration: BoxDecoration(
//           color: mainColor,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Icon(Icons.tune_rounded, color: isDark ? DarkColors.darkBackGround : Colors.white, size: 22),
//       ),
//     );
//   }

//   Widget _buildRecentItem(String text, Color titleColor, Color hintColor) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       decoration: BoxDecoration(
//         color: titleColor.withOpacity(0.03),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: ListTile(
//         onTap: () {},
//         leading: Icon(Icons.access_time, color: hintColor, size: 20),
//         title: Text(text, style: TextStyle(color: titleColor, fontSize: 15, fontFamily: AppFonts.font)),
//         trailing: Icon(Icons.arrow_forward_ios, color: hintColor, size: 14),
//       ),
//     );
//   }

//   Widget _buildSelectionChip(String label, IconData icon, Color mainColor, bool isSelected, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//         decoration: BoxDecoration(
//           color: isSelected ? mainColor.withOpacity(0.2) : mainColor.withOpacity(0.08),
//           borderRadius: BorderRadius.circular(30),
//           border: Border.all(color: isSelected ? mainColor : Colors.transparent, width: 1),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(icon, color: mainColor, size: 18),
//             const SizedBox(width: 8),
//             Text(label, style: TextStyle(color: mainColor, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, fontFamily: AppFonts.font)),
//           ],
//         ),
//       ),
//     );
//   }
// }




class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<String> _recentSearches = [];
  List<String> _popularSearches = [];

  // أطقم الاختيار المتعدد (Multi-select)
  final Set<String> _selectedTypes = {};

  final List<Map<String, dynamic>> _propertyCategories = [
    {'title': 'Apartments', 'icon': Icons.apartment},
    {'title': 'Villas', 'icon': Icons.villa},
    {'title': 'Chalets', 'icon': Icons.home_work},
    {'title': 'Commercial', 'icon': Icons.storefront},
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final cache = sl<CacheHelper>();
    setState(() {
      _recentSearches = cache.getRecentSearches();
      _popularSearches = cache.getPopularSearches();
      if (_popularSearches.isEmpty) {
        _popularSearches = ['New Cairo', 'Apartment', 'Maadi', 'Zamalek'];
      }
    });
  }

  void _submitSearch(String query) {
    if (query.trim().isEmpty) return;
    sl<CacheHelper>().recordSearchQuery(query.trim()).then((_) {
      if (mounted) _loadData();
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchFilterResultsScreen(
          title: "Search Results",
          query: query.trim(),
        ),
      ),
    ).then((_) {
      if (mounted) _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mainThemeColor = isDark
        ? DarkColors.darkmainColor
        : LightColors.lightmaincolor;
    final titleColor = isDark
        ? DarkColors.darkTitleAndSubTitleText
        : LightColors.lightTitleAndSubTitleText;
    final hintColor = isDark
        ? DarkColors.darkHintTextFieldColor
        : LightColors.lightHintTextFieldColor;
    final textFieldBgColor = isDark
        ? DarkColors.darkTextFieldColor
        : LightColors.lightTextFieldColor;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header: Back Button + Search Bar + Filter
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 1, right: 14),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: hintColor),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 10,
                        color: titleColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: textFieldBgColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        cursorColor: mainThemeColor,
                        textDirection:
                            RegExp(
                              r'[\u0600-\u06FF]',
                            ).hasMatch(_searchController.text)
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        onChanged: (value) {
                          setState(() {});
                        },
                        onSubmitted: _submitSearch,
                        style: TextStyle(
                          color: titleColor,
                          fontFamily: AppFonts.font,
                        ),
                        decoration: InputDecoration(
                          hintText: "Search address , city...",
                          hintStyle: TextStyle(
                            color: hintColor,
                            fontSize: 14,
                            fontFamily: AppFonts.font,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: mainThemeColor,
                            size: 22,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildFilterIcon(mainThemeColor, isDark),
                ],
              ),
            ),

            const SizedBox(height: 15),
            const Divider(thickness: 0.5),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Recent Searches Section
                    if (_recentSearches.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Recent Searches",
                            style: TextStyle(
                              color: mainThemeColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              fontFamily: AppFonts.font,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              sl<CacheHelper>()
                                  .saveRecentSearches([])
                                  .then((_) => _loadData());
                            },
                            child: const Text(
                              "Clear",
                              style: TextStyle(
                                color: Color.fromARGB(255, 249, 73, 73),
                                fontWeight: FontWeight.bold,
                                fontFamily: AppFonts.font,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ..._recentSearches
                          .take(5)
                          .map(
                            (search) =>
                                _buildRecentItem(search, titleColor, hintColor),
                          ),
                      const SizedBox(height: 10),
                      const Divider(thickness: 0.5),
                    ],

                    const SizedBox(height: 15),
                    // Popular Searches Section
                    Text(
                      "Popular Searches",
                      style: TextStyle(
                        color: mainThemeColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        fontFamily: AppFonts.font,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Popular Chips
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _popularSearches
                          .map(
                            (query) => _buildSelectionChip(
                              query,
                              Icons.trending_up,
                              mainThemeColor,
                              false,
                              () {
                                _searchController.text = query;
                                _submitSearch(query);
                              },
                            ),
                          )
                          .toList(),
                    ),

                    const SizedBox(height: 20),
                    // Property Types Chips
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _propertyCategories
                          .map(
                            (type) => _buildSelectionChip(
                              type['title'],
                              type['icon'],
                              mainThemeColor,
                              _selectedTypes.contains(type['title']),
                              () => setState(() {
                                _selectedTypes.contains(type['title'])
                                    ? _selectedTypes.remove(type['title'])
                                    : _selectedTypes.add(type['title']);
                              }),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterIcon(Color mainColor, bool isDark) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FilterScreen()),
      ),
      child: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          color: mainColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.tune_rounded,
          color: isDark ? DarkColors.darkBackGround : Colors.white,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildRecentItem(String text, Color titleColor, Color hintColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: titleColor.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: () {
          _searchController.text = text;
          _submitSearch(text);
        },
        leading: Icon(Icons.access_time, color: hintColor, size: 20),
        title: Text(
          text,
          style: TextStyle(
            color: titleColor,
            fontSize: 15,
            fontFamily: AppFonts.font,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: hintColor, size: 14),
      ),
    );
  }

  Widget _buildSelectionChip(
    String label,
    IconData icon,
    Color mainColor,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? mainColor.withOpacity(0.2)
              : mainColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? mainColor : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: mainColor, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: mainColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontFamily: AppFonts.font,
              ),
            ),
          ],
        ),
      ),
    );
  }
}