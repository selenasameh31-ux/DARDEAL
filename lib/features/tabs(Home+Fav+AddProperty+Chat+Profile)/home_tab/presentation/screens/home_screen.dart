import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomeCubit>()..loadHomeData(),
      child: const _HomeScreenContent(),
    );
  }
}

class _HomeScreenContent extends StatefulWidget {
  const _HomeScreenContent({super.key});

  @override
  State<_HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<_HomeScreenContent> {
  // تعريف متحكم البحث وحالة اختيار (إيجار/بيع)
  final TextEditingController _searchController = TextEditingController();
  bool _isRentSelected = true;

  // النوع المختار افتراضياً من القائمة
  String? _selectedPropertyType;

  // قائمة أنواع العقارات المتوفرة مع الأيقونات الخاصة بها
  final List<Map<String, dynamic>> _propertyTypes = [
    {'title': 'Room', 'icon': Icons.meeting_room},
    {'title': 'Apartment', 'icon': Icons.apartment},
    {'title': 'Villa', 'icon': Icons.villa},
    {'title': 'House', 'icon': Icons.home},
    {'title': 'Chalet', 'icon': Icons.holiday_village},
    {'title': 'Studio', 'icon': Icons.chair},
    {'title': 'Office', 'icon': Icons.corporate_fare},
    {'title': 'Commercial', 'icon': Icons.storefront},
    {'title': 'Land', 'icon': Icons.landscape},
    {'title': 'Warehouse', 'icon': Icons.warehouse},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final mainThemeColor = isDark
        ? DarkColors.darkmainColor
        : LightColors.lightmaincolor;

    return Scaffold(
      backgroundColor: bgColor,
      // زر المساعد العائم أسفل الشاشة
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90.0),
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: mainThemeColor,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.auto_awesome,
            color: isDark
                ? DarkColors.darkBackGround
                : LightColors.lightBackGround,
            size: 28,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildCustomAppBar(context, isDark),
          _buildTitle(isDark),
          _buildSearchBar(context, isDark),

          Expanded(
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (state is HomeLoading) {
                  return Center(
                    child: CircularProgressIndicator(color: mainThemeColor),
                  );
                } else if (state is HomeError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (state is HomeLoaded) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        _buildRentBuyToggle(context, isDark),
                        const SizedBox(height: 15),
                        _buildPropertyTypesList(isDark, state.propertyTypes),

                        const SizedBox(height: 30),
                        HomePaginatedSection(
                          title: "Recently Added",
                          isDark: isDark,
                          itemType: SectionItemType.property,
                          badgeType: 'verified',
                          properties: state.recentProperties,
                        ),

                        const SizedBox(height: 30),
                        HomePaginatedSection(
                          title: "Explore By Area",
                          isDark: isDark,
                          itemType: SectionItemType.area,
                        ),

                        const SizedBox(height: 30),
                        HomePaginatedSection(
                          title: "Featured Properties",
                          isDark: isDark,
                          itemType: SectionItemType.property,
                          badgeType: 'featured',
                          properties: state.featuredProperties,
                        ),

                        const SizedBox(height: 30),
                        HomePaginatedSection(
                          title: "Nearby Properties",
                          isDark: isDark,
                          itemType: SectionItemType.property,
                          badgeType: 'none',
                          properties: state.recentProperties,
                        ),

                        const SizedBox(height: 30),
                        HomePaginatedSection(
                          title: "Recommended For You",
                          isDark: isDark,
                          itemType: SectionItemType.property,
                          badgeType: 'recommended',
                          properties: state.featuredProperties,
                        ),

                        const SizedBox(height: 100),
                      ],
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  // بناء شريط التطبيق العلوي (التعديل الجديد)
  Widget _buildCustomAppBar(BuildContext context, bool isDark) {
    final mainThemeColor = isDark
        ? DarkColors.darkmainColor
        : LightColors.lightmaincolor;
    final titleColor = isDark
        ? DarkColors.darkTitleAndSubTitleText
        : LightColors.lightTitleAndSubTitleText;
    final hintColor = isDark
        ? DarkColors.darkHintTextFieldColor
        : LightColors.lightHintTextFieldColor;

    return Padding(
      padding: const EdgeInsets.only(top: 55, left: 16, right: 16, bottom: 5),
      child: Row(
        children: [
          Expanded(
            child: BlocBuilder<SessionCubit, SessionState>(
              builder: (context, state) {
                String userName = "Guest";
                File? profileImage;
                String? imageUrl;
                bool isGuest = state is SessionGuest;

                if (state is SessionAuthenticated) {
                  userName = state.user.name;
                  profileImage = state.profileImage;
                  imageUrl = state.imageUrl;
                }

                return Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {
                        // Navigate to profile tab if needed, but usually BottomNavigationBar handles this
                        // Wait, the bottom navigation bar manages tabs.
                        // So here we can just switch the tab index.
                      },
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: hintColor.withOpacity(0.15),
                        backgroundImage:
                            imageUrl != null && imageUrl!.isNotEmpty
                            ? NetworkImage(imageUrl!) as ImageProvider
                            : profileImage != null
                            ? FileImage(profileImage!)
                            : null,
                        child:
                            (imageUrl == null || imageUrl!.isEmpty) &&
                                profileImage == null
                            ? Icon(Icons.person, color: hintColor, size: 28)
                            : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isGuest ? "Welcome, Guest" : userName,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: titleColor,
                              fontFamily: AppFonts.font,
                            ),
                          ),
                          if (!isGuest)
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: mainThemeColor,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    (state is SessionAuthenticated)
                                        ? state.user.displayAddress
                                        : 'Your Address',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: hintColor,
                                      fontFamily: AppFonts.font,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          Container(
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: IconButton(
              splashRadius: 20,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationsScreen(),
                  ),
                );
              },
              icon: Icon(
                Icons.notifications_outlined,
                color: mainThemeColor,
                size: 28,
              ),
            ),
          ),

          Container(
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: IconButton(
              splashRadius: 20,
              onPressed: () {
                // Settings action
              },
              icon: Icon(
                Icons.settings_outlined,
                color: mainThemeColor,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //  العنوان
  Widget _buildTitle(bool isDark) {
    final titleColor = isDark
        ? DarkColors.darkTitleAndSubTitleText
        : LightColors.lightTitleAndSubTitleText;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Discover Your New Property",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: titleColor,
            fontFamily: AppFonts.font,
          ),
        ),
      ),
    );
  }

  //  شريط البحث
  Widget _buildSearchBar(BuildContext context, bool isDark) {
    final hintColor = isDark
        ? DarkColors.darkHintTextFieldColor
        : LightColors.lightHintTextFieldColor;
    final mainThemeColor = isDark
        ? DarkColors.darkmainColor
        : LightColors.lightmaincolor;
    final textFieldBgColor = isDark
        ? DarkColors.darkTextFieldColor
        : LightColors.lightTextFieldColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              ),
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: textFieldBgColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: mainThemeColor, size: 22),
                    const SizedBox(width: 12),
                    Text(
                      "Search address , city...",
                      style: TextStyle(
                        color: hintColor,
                        fontSize: 14,
                        fontFamily: AppFonts.font,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FilterScreen()),
            ),
            child: Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: mainThemeColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.tune_rounded,
                color: isDark ? DarkColors.darkBackGround : Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRentBuyToggle(BuildContext context, bool isDark) {
    final mainThemeColor = isDark
        ? DarkColors.darkmainColor
        : LightColors.lightmaincolor;
    final unselectedBgColor = isDark
        ? DarkColors.darkTextFieldColor
        : LightColors.lightTextFieldColor;
    final unselectedTextColor = isDark
        ? DarkColors.darkTitleAndSubTitleText
        : LightColors.lightTitleAndSubTitleText;
    final selectedTextColor = isDark ? DarkColors.darkBackGround : Colors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: 180,
        height: 45,
        decoration: BoxDecoration(
          color: unselectedBgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isRentSelected = true),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 2),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _isRentSelected
                        ? mainThemeColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Rent",
                    style: TextStyle(
                      color: _isRentSelected
                          ? selectedTextColor
                          : unselectedTextColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.font,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isRentSelected = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 2),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: !_isRentSelected
                        ? mainThemeColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Buy",
                    style: TextStyle(
                      color: !_isRentSelected
                          ? selectedTextColor
                          : unselectedTextColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.font,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'meeting_room':
        return Icons.meeting_room;
      case 'apartment':
        return Icons.apartment;
      case 'villa':
        return Icons.villa;
      case 'home':
        return Icons.home;
      case 'chalet':
        return Icons.holiday_village;
      case 'deck':
        return Icons.deck;
      case 'holiday_village':
        return Icons.holiday_village;
      case 'stacked_bar_chart':
        return Icons.stacked_bar_chart;
      case 'penthouse':
        return Icons.apartment;
      case 'corporate_fare':
        return Icons.corporate_fare;
      case 'storefront':
        return Icons.storefront;
      case 'store':
        return Icons.store;
      case 'warehouse':
        return Icons.warehouse;
      case 'domain':
        return Icons.domain;
      case 'landscape':
        return Icons.landscape;
      default:
        return Icons.home;
    }
  }

  Widget _buildPropertyTypesList(
    bool isDark,
    List<PropertyTypeModel> propertyTypes,
  ) {
    final mainThemeColor = isDark
        ? DarkColors.darkmainColor
        : LightColors.lightmaincolor;
    final titleColor = isDark
        ? DarkColors.darkTitleAndSubTitleText
        : LightColors.lightTitleAndSubTitleText;
    final hintColor = isDark
        ? DarkColors.darkHintTextFieldColor
        : LightColors.lightHintTextFieldColor;
    final cardBgColor = isDark ? const Color(0xff2A2A2A) : Colors.white;

    // Filter out "Room" if Buy is selected
    final List<PropertyTypeModel> displayedTypes = _isRentSelected
        ? propertyTypes
        : propertyTypes
              .where((type) => type.nameEn.toLowerCase() != 'room')
              .toList();

    return SizedBox(
      height: 75,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: displayedTypes.length,
        itemBuilder: (context, index) {
          final type = displayedTypes[index];
          final isSelected = _selectedPropertyType == type.nameEn;
          final iconData = _getIconData(type.iconName);

          return GestureDetector(
            onTap: () {
              setState(() => _selectedPropertyType = type.nameEn);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => BlocProvider.value(
                    value: context.read<WishlistCubit>(),
                    child: PropertyTypeListingScreen(
                      propertyType: type.nameEn,
                      propertyIcon: iconData,
                      isRent: _isRentSelected,
                    ),
                  ),
                ),
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 70,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected
                      ? mainThemeColor
                      : hintColor.withOpacity(0.2),
                  width: isSelected ? 1.5 : 1.0,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    iconData,
                    color: isSelected ? mainThemeColor : hintColor,
                    size: 24,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    type.nameEn,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: isSelected ? mainThemeColor : titleColor,
                      fontFamily: AppFonts.font,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  // _buildSectionHeader, _buildPropertiesList, and _buildAreaList have been replaced by HomePaginatedSection

  Widget _buildAreaListOld() {
    // Kept temporarily for reference
    final List<Map<String, String>> areas = [
      {
        'title': 'Marine Drive',
        'image':
            'https://images.unsplash.com/photo-1548013146-72479768bada?auto=format&fit=crop&q=80&w=600',
      },
      {
        'title': 'Kakkanad',
        'image':
            'https://images.unsplash.com/photo-1596422846543-75c6fc197f07?auto=format&fit=crop&q=80&w=600',
      },
      {
        'title': 'Fort Kochi',
        'image':
            'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&q=80&w=600',
      },
      {
        'title': 'Edappally',
        'image':
            'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&q=80&w=600',
      },
    ];
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: areas.length,
        itemBuilder: (context, index) {
          return Container(
            width: 140,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage(areas[index]['image']!),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black.withOpacity(0.3),
              ),
              alignment: Alignment.center,
              child: Text(
                areas[index]['title']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFonts.font,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class HomePropertyCardItem extends StatefulWidget {
  final bool isDark;
  final String badgeType;
  final HomePropertyModel property;

  const HomePropertyCardItem({
    super.key,
    required this.isDark,
    required this.badgeType,
    required this.property,
  });
  @override
  State<HomePropertyCardItem> createState() => _HomePropertyCardItemState();
}

class _HomePropertyCardItemState extends State<HomePropertyCardItem> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final cardBgColor = widget.isDark ? const Color(0xff2A2A2A) : Colors.white;
    final titleColor = widget.isDark
        ? DarkColors.darkTitleAndSubTitleText
        : LightColors.lightTitleAndSubTitleText;
    final hintColor = widget.isDark
        ? DarkColors.darkHintTextFieldColor
        : LightColors.lightHintTextFieldColor;
    final attentionColor = widget.isDark
        ? DarkColors.darkAttentionText
        : LightColors.lightAttentionText;
    final mainThemeColor = widget.isDark
        ? DarkColors.darkmainColor
        : LightColors.lightmaincolor;
    return GestureDetector(
      onTap: () {
        final propId = widget.property.id ?? 0;
        if (propId > 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => BlocProvider.value(
                value: context.read<WishlistCubit>(),
                child: PropertyDetailsWrapperScreen(propertyId: propId),
              ),
            ),
          );
        }
      },
      child: Container(
        width: 180,
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              child: SizedBox(
                height: 140,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(color: Colors.grey.shade400),
                    if (widget.property.imageUrl != null &&
                        widget.property.imageUrl!.isNotEmpty)
                      Image.network(
                        widget.property.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) =>
                            Container(color: Colors.grey.shade400),
                      ),
                    if (widget.badgeType != 'none')
                      Positioned(
                        top: 10,
                        left: 10,
                        child: _buildBadge(
                          widget.badgeType,
                          attentionColor,
                          mainThemeColor,
                          widget.isDark,
                        ),
                      ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: BlocBuilder<WishlistCubit, WishlistState>(
                        builder: (context, state) {
                          final propertyId = widget.property.id ?? 0;
                          final isFavorite = context
                              .read<WishlistCubit>()
                              .isWished(propertyId);
                          return GestureDetector(
                            onTap: () {
                              if (propertyId > 0) {
                                final newItem = WishlistItemModel(
                                  propertyId: propertyId,
                                  title: widget.property.title,
                                  location: widget.property.address,
                                  price: widget.property.price.toDouble(),
                                  imageUrl: widget.property.imageUrl,
                                  propertyType: widget.property.propertyType,
                                  // listingType: widget
                                  //     .property
                                  //     .listingType, // ✅ تمرير listingType
                                  listingType: widget.property.listingType,
                                );
                                context.read<WishlistCubit>().toggleWishlist(
                                  propertyId,
                                  newItem: newItem,
                                );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: widget.isDark
                                    ? Colors.black.withOpacity(0.6)
                                    : Colors.white.withOpacity(0.9),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite ? attentionColor : hintColor,
                                size: 18,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.property.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 15.5,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.font,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: mainThemeColor,
                          size: 12,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            widget.property.address,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: hintColor,
                              fontSize: 12,
                              fontFamily: AppFonts.font,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "${widget.property.price} EGP",
                            style: TextStyle(
                              color: attentionColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppFonts.font,
                            ),
                          ),
                          TextSpan(
                            text: " /mo",
                            style: TextStyle(
                              color: hintColor,
                              fontSize: 12,
                              fontFamily: AppFonts.font,
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildBadge(
    String type,
    Color attentionColor,
    Color mainColor,
    bool isDark,
  ) {
    if (type == 'recent') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xff3A3A3A) : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          "Recently Added",
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: mainColor,
            fontFamily: AppFonts.font,
          ),
        ),
      );
    } else if (type == 'featured') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: attentionColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text(
          "FEATURED",
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: AppFonts.font,
          ),
        ),
      );
    } else if (type == 'recommended') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: attentionColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text(
          "98% MATCH",
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: AppFonts.font,
          ),
        ),
      );
    }
    return const SizedBox();
  }
}

// ──────────────────────────────────────────────────────────────
// NEW PAGINATED SECTION WIDGETS
// ──────────────────────────────────────────────────────────────

enum SectionItemType { property, area }

class HomePaginatedSection extends StatefulWidget {
  final String title;
  final bool isDark;
  final SectionItemType itemType;
  final String? badgeType;
  final List<HomePropertyModel>? properties;

  const HomePaginatedSection({
    super.key,
    required this.title,
    required this.isDark,
    required this.itemType,
    this.badgeType,
    this.properties,
  });

  @override
  State<HomePaginatedSection> createState() => _HomePaginatedSectionState();
}

class _HomePaginatedSectionState extends State<HomePaginatedSection> {
  final ScrollController _scrollController = ScrollController();
  int _itemCount = 4;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;

  final List<Map<String, String>> _areas = [
    {
      'title': 'Marine Drive',
      'image':
          'https://images.unsplash.com/photo-1548013146-72479768bada?auto=format&fit=crop&q=80&w=600',
    },
    {
      'title': 'Kakkanad',
      'image':
          'https://images.unsplash.com/photo-1596422846543-75c6fc197f07?auto=format&fit=crop&q=80&w=600',
    },
    {
      'title': 'Fort Kochi',
      'image':
          'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&q=80&w=600',
    },
    {
      'title': 'Edappally',
      'image':
          'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&q=80&w=600',
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.itemType == SectionItemType.area) {
      _itemCount = _areas.length;
      _hasMoreData = false; // Areas are static
    } else {
      final total = widget.properties?.length ?? 0;
      _itemCount = total > 4 ? 4 : total;
      _hasMoreData = total > _itemCount;
    }
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 50 &&
        !_isLoadingMore &&
        _hasMoreData) {
      _loadMoreItems();
    }
  }

  Future<void> _loadMoreItems() async {
    if (_isLoadingMore || !_hasMoreData) return;
    setState(() {
      _isLoadingMore = true;
    });

    await Future.delayed(const Duration(milliseconds: 600)); // Mock fetch

    if (mounted) {
      setState(() {
        _isLoadingMore = false;
        if (widget.itemType == SectionItemType.area) {
          // No more areas to load
        } else {
          final total = widget.properties?.length ?? 0;
          final nextCount = _itemCount + 4;
          _itemCount = nextCount > total ? total : nextCount;
          _hasMoreData = _itemCount < total;
        }
      });
      // Scroll slightly to show new items smoothly
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.pixels + 60,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildHeader(), _buildList()],
    );
  }

  Widget _buildHeader() {
    final titleColor = widget.isDark
        ? DarkColors.darkTitleAndSubTitleText
        : LightColors.lightTitleAndSubTitleText;
    final mainThemeColor = widget.isDark
        ? DarkColors.darkmainColor
        : LightColors.lightmaincolor;

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: titleColor,
              fontFamily: AppFonts.font,
            ),
          ),
          InkWell(
            onTap: _loadMoreItems, // Loads more in-place instead of navigating
            child: Text(
              "See All",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: mainThemeColor,
                fontFamily: AppFonts.font,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    final bool isProperty = widget.itemType == SectionItemType.property;
    final double listHeight = isProperty ? 260 : 120;

    return SizedBox(
      height: listHeight,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: _itemCount + (_isLoadingMore ? 1 : 0) == 0
            ? 1
            : _itemCount + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (_itemCount == 0 && isProperty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "No properties found",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            );
          }

          if (index >= _itemCount) {
            // Loading indicator at the end
            return _buildLoadingIndicator();
          }

          if (isProperty) {
            final props = widget.properties ?? [];
            if (props.isEmpty) return const SizedBox();
            return HomePropertyCardItem(
              isDark: widget.isDark,
              badgeType: widget.badgeType ?? 'none',
              property: props[index],
            );
          } else {
            return _buildAreaCard(index);
          }
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      width: 60,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: CircularProgressIndicator(
          color: widget.isDark
              ? DarkColors.darkmainColor
              : LightColors.lightmaincolor,
          strokeWidth: 3,
        ),
      ),
    );
  }

  Widget _buildAreaCard(int index) {
    return Container(
      width: 140,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(_areas[index]['image']!),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.8), Colors.transparent],
          ),
        ),
        padding: const EdgeInsets.all(12),
        alignment: Alignment.bottomLeft,
        child: Text(
          _areas[index]['title']!,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: AppFonts.font,
          ),
        ),
      ),
    );
  }
}