import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreeState();
}

class _FavouriteScreeState extends State<FavouriteScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _categories = [
    'All',
    'Room',
    'Villa',
    'Apartment',
    'House',
    'Chalet',
    'Studio',
    'Office',
    'Commercial',
    'Land',
    'Warehouse',
  ];

  String _selectedCategory = 'All';
  String _selectedTransactionType = 'All';

  @override
  void initState() {
    super.initState();
    //context.read<WishlistCubit>().loadWishlist();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<WishlistEntity> _applyFilters(List<WishlistEntity> allItems) {
    final String searchQuery = _searchController.text.toLowerCase();
    return allItems.where((item) {
      bool matchCategory = _selectedCategory == 'All';
      if (!matchCategory) {
        if (_selectedCategory.toLowerCase() == 'room') {
          final titleLower = item.displayTitle.toLowerCase();
          final typeLower = item.displayType.toLowerCase();
          final apiTypeLower = item.propertyType?.toLowerCase() ?? '';

          matchCategory =
              titleLower.contains('private room') ||
              titleLower.contains('shared room') ||
              typeLower.contains('room') ||
              apiTypeLower.contains('room');
          // } else {
          //   matchCategory =
          //       item.propertyType?.toLowerCase() ==
          //           _selectedCategory.toLowerCase() ||
          //       item.displayType.toLowerCase() == _selectedCategory.toLowerCase();
          // }
        } else {
          final titleLower = item.displayTitle.toLowerCase();
          final typeLower = item.displayType.toLowerCase();
          final apiTypeLower = item.propertyType?.toLowerCase() ?? '';

          final isRoom =
              titleLower.contains('private room') ||
              titleLower.contains('shared room') ||
              typeLower.contains('room') ||
              apiTypeLower.contains('room');

          matchCategory =
              !isRoom &&
              (item.propertyType?.toLowerCase() ==
                      _selectedCategory.toLowerCase() ||
                  item.displayType.toLowerCase() ==
                      _selectedCategory.toLowerCase());
        }
      }
      final matchTransaction =
          _selectedTransactionType == 'All' ||
          item.transactionTypeLabel == _selectedTransactionType;
      final matchSearch =
          item.displayTitle.toLowerCase().contains(searchQuery) ||
          item.displayLocation.toLowerCase().contains(searchQuery);
      return matchCategory && matchTransaction && matchSearch;
    }).toList();
  }

  void _navigateToDetails(BuildContext context, WishlistEntity item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => BlocProvider.value(
          value: context.read<WishlistCubit>(),
          child: PropertyDetailsWrapperScreen(propertyId: item.propertyId),
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context, bool isDark) {
    final titleColor = isDark
        ? DarkColors.darkTitleAndSubTitleText
        : LightColors.lightTitleAndSubTitleText;
    final mainThemeColor = isDark
        ? DarkColors.darkmainColor
        : LightColors.lightmaincolor;
    final bgColor = isDark ? const Color(0xff2A2A2A) : Colors.white;

    showModalBottomSheet(
      context: context,
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Filter by Transaction Type",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.font,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildFilterOption(
                        "All",
                        Icons.apps,
                        mainThemeColor,
                        titleColor,
                        () {
                          setState(() => _selectedTransactionType = "All");
                          Navigator.pop(context);
                        },
                        _selectedTransactionType == "All",
                        isDark,
                      ),
                      _buildFilterOption(
                        "For Rent",
                        Icons.key,
                        mainThemeColor,
                        titleColor,
                        () {
                          setState(() => _selectedTransactionType = "For Rent");
                          Navigator.pop(context);
                        },
                        _selectedTransactionType == "For Rent",
                        isDark,
                      ),
                      _buildFilterOption(
                        "For Sale",
                        Icons.real_estate_agent,
                        mainThemeColor,
                        titleColor,
                        () {
                          setState(() => _selectedTransactionType = "For Sale");
                          Navigator.pop(context);
                        },
                        _selectedTransactionType == "For Sale",
                        isDark,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterOption(
    String title,
    IconData icon,
    Color mainColor,
    Color textColor,
    VoidCallback onTap,
    bool isSelected,
    bool isDark,
  ) {
    final selectedIconColor = isDark ? DarkColors.darkBackGround : Colors.white;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: isSelected ? mainColor : mainColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isSelected ? selectedIconColor : mainColor,
              size: 26,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontFamily: AppFonts.font,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark
        ? DarkColors.darkTitleAndSubTitleText
        : LightColors.lightTitleAndSubTitleText;
    final mainThemeColor = isDark
        ? DarkColors.darkmainColor
        : LightColors.lightmaincolor;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(titleColor),
            FavouriteSearchBarRent(
              controller: _searchController,
              onFilterTap: () => _showFilterBottomSheet(context, isDark),
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 8),
            FavouriteCategoryFilterRent(
              categories: _categories,
              selectedCategory: _selectedCategory,
              onCategorySelected: (category) =>
                  setState(() => _selectedCategory = category),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: BlocBuilder<WishlistCubit, WishlistState>(
                builder: (context, state) {
                  if (state is WishlistLoading || state is WishlistInitial) {
                    return Center(
                      child: CircularProgressIndicator(color: mainThemeColor),
                    );
                  }

                  if (state is WishlistError) {
                    return _buildErrorState(
                      isDark,
                      mainThemeColor,
                      state.message,
                    );
                  }

                  if (state is WishlistLoaded) {
                    final filtered = _applyFilters(state.items);
                    if (filtered.isEmpty) return _buildEmptyState(isDark);

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final item = filtered[index];
                        return FavouritePropertyCardRent(
                          property: item,
                          onRemove: () {
                            context.read<WishlistCubit>().removeFromWishlist(
                              item.propertyId,
                            );
                          },
                          onTap: () => _navigateToDetails(context, item),
                        );
                      },
                    );
                  }

                  return _buildEmptyState(isDark);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color titleColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 10),
      child: Center(
        child: Text(
          "Favorite",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: AppFonts.font,
            color: titleColor,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Text(
        "No items found for this filter",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isDark
              ? DarkColors.darkHintTextFieldColor
              : LightColors.lightHintTextFieldColor,
          fontFamily: AppFonts.font,
        ),
      ),
    );
  }

  Widget _buildErrorState(bool isDark, Color mainThemeColor, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wifi_off_outlined,
            size: 60,
            color: mainThemeColor.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            "Failed to load wishlist",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? DarkColors.darkHintTextFieldColor
                  : LightColors.lightHintTextFieldColor,
              fontFamily: AppFonts.font,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => context.read<WishlistCubit>().loadWishlist(),
            style: ElevatedButton.styleFrom(backgroundColor: mainThemeColor),
            child: const Text("Retry", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}