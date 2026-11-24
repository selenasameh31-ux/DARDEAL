import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class PropertyDetailsRentScreen extends StatefulWidget {
  final PropertyDetailsModel property;
  const PropertyDetailsRentScreen({super.key, required this.property});

  @override
  State<PropertyDetailsRentScreen> createState() =>
      _PropertyDetailsRentScreenState();
}

class _PropertyDetailsRentScreenState extends State<PropertyDetailsRentScreen> {
  // --- Controllers ---
  final PageController _imagePageController = PageController();
  final ScrollController _mainScrollController = ScrollController();

  // --- State Variables ---
  int _currentImageIndex = 0;
  bool _isFavorite = false;

  String _selectedTab = 'Overview';

  // --- Tabs and Sections Data ---
  final List<String> _tabs = [
    'Overview',
    'Pricing',
    'Amenities',
    'Rules',
    'Location',
    'Owner',
    'Reviews',
  ];
  final List<GlobalKey> _sectionKeys = List.generate(7, (index) => GlobalKey());
  bool _isManualTabSelection = false;

  @override
  void initState() {
    super.initState();
    _mainScrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _imagePageController.dispose();
    _mainScrollController.removeListener(_onScroll);
    _mainScrollController.dispose();
    super.dispose();
  }

  // --- Helper methods for dynamic data ---
  String _formatPrice(dynamic price) {
    if (price == null) return "0";
    final p = (price is int) ? price.toDouble() : (price as double);
    if (p >= 1000000) return "${(p / 1000000).toStringAsFixed(1)}M";
    if (p >= 1000) {
      final formatted = NumberFormat('#,###', 'en_US').format(p.toInt());
      return formatted;
    }
    return p.toStringAsFixed(0);
  }

  String _ordinalSuffix(int n) {
    if (n >= 11 && n <= 13) return "th";
    switch (n % 10) {
      case 1:
        return "st";
      case 2:
        return "nd";
      case 3:
        return "rd";
      default:
        return "th";
    }
  }

  static const Map<String, IconData> _amenityIcons = {
    'balcony': Icons.balcony,
    'security': Icons.security,
    'elevator': Icons.elevator,
    'air conditioning': Icons.ac_unit,
    'ac': Icons.ac_unit,
    'parking': Icons.local_parking,
    'pool': Icons.pool,
    'gym': Icons.fitness_center,
    'garden': Icons.park,
    'water': Icons.water_drop,
    'wifi': Icons.wifi,
    'internet': Icons.wifi,
    'laundry': Icons.local_laundry_service,
    'pets': Icons.pets,
    'kitchen': Icons.kitchen,
    'furnished': Icons.chair,
  };

  List<Map<String, dynamic>> _buildAmenityChips() {
    final allAmenities = <String>[
      ...?widget.property.amenities,
      ...?widget.property.customAmenities,
    ];
    if (allAmenities.isEmpty) {
      return [
        {'icon': Icons.info_outline, 'label': 'No amenities listed'},
      ];
    }
    return allAmenities.map((a) {
      final key = a.toLowerCase();
      IconData icon = Icons.check_circle_outline;
      for (final entry in _amenityIcons.entries) {
        if (key.contains(entry.key)) {
          icon = entry.value;
          break;
        }
      }
      return {'icon': icon, 'label': a};
    }).toList();
  }

  List<Map<String, dynamic>> _buildRuleChips() {
    final rules = widget.property.customRules;
    if (rules == null || rules.isEmpty) {
      return [
        {'icon': Icons.info_outline, 'label': 'No rules listed'},
      ];
    }
    return rules.map((r) {
      IconData icon = Icons.rule;
      final key = r.toLowerCase();
      if (key.contains('pet')) icon = Icons.pets;
      if (key.contains('smok')) icon = Icons.smoke_free;
      if (key.contains('party') || key.contains('drink'))
        icon = Icons.no_drinks;
      if (key.contains('music') ||
          key.contains('noise') ||
          key.contains('loud'))
        icon = Icons.volume_off;
      if (key.contains('child')) icon = Icons.child_care;
      return {'icon': icon, 'label': r};
    }).toList();
  }

  // --- Scroll Logic ---
  void _onScroll() {
    if (_isManualTabSelection) return;
    for (int i = 0; i < _sectionKeys.length; i++) {
      final context = _sectionKeys[i].currentContext;
      if (context != null) {
        final renderBox = context.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero).dy;
        if (position <= 150 && position > 0) {
          if (_selectedTab != _tabs[i]) {
            setState(() {
              _selectedTab = _tabs[i];
            });
          }
          break;
        }
      }
    }
  }

  void _scrollToSection(int index) {
    _isManualTabSelection = true;
    setState(() {
      _selectedTab = _tabs[index];
    });
    final context = _sectionKeys[index].currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      ).then((_) => _isManualTabSelection = false);
    } else {
      _isManualTabSelection = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = isDark
        ? DarkColors.darkTitleAndSubTitleText
        : LightColors.lightTitleAndSubTitleText;
    final bodyTextColor = isDark
        ? DarkColors.darkBodyColors
        : LightColors.lightBodyColors;
    final mainColor = isDark
        ? DarkColors.darkmainColor
        : LightColors.lightmaincolor;
    final attentionColor = isDark
        ? DarkColors.darkAttentionText
        : LightColors.lightAttentionText;
    final verifiedColor = const Color(0xff4CAF50);
    final hintColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                controller: _mainScrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // ØªØ«Ø¨ÙŠØª AppBar ÙÙŠ Ø§Ù„Ø£Ø¹Ù„Ù‰
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: PropertyStickyHeaderDelegate(
                      minHeight: 55,
                      maxHeight: 55,
                      child: Container(
                        color: bgColor,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BlocBuilder<WishlistCubit, WishlistState>(
                              builder: (context, state) {
                                final isFavorite = context
                                    .read<WishlistCubit>()
                                    .isWished(widget.property.id);
                                return PropertyCustomAppBar(
                                  isFavorite: isFavorite,
                                  onFavoritePressed: () {
                                    final _reviewsState = context
                                        .read<ReviewsCubit>()
                                        .state;
                                    final _currentRating =
                                        (_reviewsState is ReviewsLoaded &&
                                            _reviewsState.summary.totalReviews >
                                                0)
                                        ? _reviewsState.summary.averageRating
                                        : null;
                                    final wishlistItem = WishlistItemModel(
                                      propertyId: widget.property.id,
                                      title: widget.property.title,
                                      location:
                                          [
                                                widget.property.street,
                                                widget.property.district,
                                                widget.property.city,
                                                widget.property.governorate,
                                              ]
                                              .where(
                                                (e) =>
                                                    e != null && e.isNotEmpty,
                                              )
                                              .join(', '),
                                      price: widget.property.price,
                                      dailyPrice: widget.property.dailyPrice,
                                      imageUrl:
                                          (widget
                                                  .property
                                                  .mediaUrls
                                                  ?.isNotEmpty ??
                                              false)
                                          ? widget.property.mediaUrls![0]
                                          : null,
                                      propertyType:
                                          widget.property.propertyType,
                                      listingType: 'Rent',
                                      rentalModel: 'Long-term',
                                      roomType: widget.property.roomType,
                                      rating: _currentRating,
                                    );
                                    context
                                        .read<WishlistCubit>()
                                        .toggleWishlist(
                                          widget.property.id,
                                          newItem: wishlistItem,
                                        );
                                  },
                                  onBackPressed: () => Navigator.pop(context),
                                  textColor: textColor,
                                  attentionColor: attentionColor,
                                );
                              },
                            ),
                            const Divider(height: 0.1, thickness: 1),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PropertyImageGallery(
                            imageUrls: widget.property.mediaUrls,
                            imagePageController: _imagePageController,
                            totalImages:
                                widget.property.mediaUrls != null &&
                                    widget.property.mediaUrls!.isNotEmpty
                                ? (widget.property.mediaUrls!.length > 8
                                      ? 8
                                      : widget.property.mediaUrls!.length)
                                : 1,
                            currentImageIndex: _currentImageIndex,
                            onPageChanged: (index) =>
                                setState(() => _currentImageIndex = index),
                            badgeText: "FOR RENT",
                            mainColor: mainColor,
                            attentionColor: attentionColor,
                            isDark: isDark,
                          ),
                          const SizedBox(height: 20),
                          _buildBasicInfo(
                            textColor,
                            bodyTextColor,
                            mainColor,
                            attentionColor,
                            hintColor,
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  // ØªØ«Ø¨ÙŠØª Ø§Ù„Ù€ Tabs Ø¹Ù†Ø¯ Ø§Ù„Ù†Ø²ÙˆÙ„
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: PropertyStickyHeaderDelegate(
                      minHeight: 45,
                      maxHeight: 45,
                      child: Container(
                        color: bgColor,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: _buildTabs(isDark, mainColor, textColor),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          // Sections
                          _buildOverviewSection(
                            isDark,
                            textColor,
                            bodyTextColor,
                            mainColor,
                            hintColor,
                          ),
                          const SizedBox(height: 30),
                          _buildPricingSection(
                            isDark,
                            textColor,
                            mainColor,
                            verifiedColor,
                          ),
                          const SizedBox(height: 30),
                          _buildAmenitiesSection(isDark, textColor, mainColor),
                          const SizedBox(height: 30),
                          _buildRulesSection(
                            isDark,
                            textColor,
                            mainColor,
                            hintColor,
                          ),
                          const SizedBox(height: 30),
                          Container(
                            key: _sectionKeys[4],
                            child: SharedLocationSection(
                              isDark: isDark,
                              textColor: textColor,
                              mainColor: mainColor,
                              hintColor: hintColor,
                              governorate: widget.property.governorate,
                              city: widget.property.city,
                              district: widget.property.district,
                              street: widget.property.street,
                              buildingNumber: widget.property.buildingNumber,
                              floorNumber: widget.property.floorNumber,
                              unitNumber: widget.property.unitNumber,
                              latitude: widget.property.latitude,
                              longitude: widget.property.longitude,
                              nearbyFacilities:
                                  widget.property.nearbyFacilities,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            key: _sectionKeys[5],
                            child: SharedOwnerSection(
                              isDark: isDark,
                              textColor: textColor,
                              mainColor: mainColor,
                              hintColor: hintColor,
                              verifiedColor: verifiedColor,
                              ownerData: widget.property.owner,
                            ),
                          ),
                          const SizedBox(height: 30),
                          _buildReviewsSection(
                            isDark,
                            textColor,
                            bodyTextColor,
                            mainColor,
                            hintColor,
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Ø§Ù„Ø¨Ø§Ø± Ø§Ù„Ù„ÙŠ ØªØ­Øª Ø«Ø§Ø¨Øª Ù…Ø´ Ø¨ÙŠØªØ­Ø±Ùƒ Ø²ÙŠ Ù…Ø§ Ø·Ù„Ø¨ØªÙŠ
            PropertyBottomBar(
              label: "Monthly Rent",
              price: "EGP ${_formatPrice(widget.property.price)}",
              priceSuffix: " / month",
              buttonText: "Rent Now",
              onChatPressed: () {},
              onButtonPressed: () {},
              textColor: textColor,
              bodyTextColor: bodyTextColor,
              mainColor: mainColor,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }

  // ===================== Basic Info =====================
  Widget _buildBasicInfo(
    Color textColor,
    Color bodyTextColor,
    Color mainColor,
    Color attentionColor,
    Color hintColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                (widget.property.propertyType ?? "Property").toUpperCase(),
                style: TextStyle(
                  fontFamily: AppFonts.font,
                  color: mainColor,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            BlocBuilder<ReviewsCubit, ReviewsState>(
              builder: (context, state) {
                double avgRating = 0.0;
                int totalReviews = 0;
                if (state is ReviewsLoaded) {
                  avgRating = state.summary.averageRating;
                  totalReviews = state.summary.totalReviews;
                }
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: attentionColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, color: attentionColor, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        avgRating.toStringAsFixed(1),
                        style: TextStyle(
                          fontFamily: AppFonts.font,
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        totalReviews == 0
                            ? "No reviews"
                            : "($totalReviews reviews)",
                        style: TextStyle(
                          fontFamily: AppFonts.font,
                          color: hintColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          widget.property.title ?? "Untitled Property",
          style: TextStyle(
            fontFamily: AppFonts.font,
            color: textColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          spacing: 6,
          runSpacing: 4,
          children: [
            Text(
              "EGP ${_formatPrice(widget.property.price)}",
              style: TextStyle(
                fontFamily: AppFonts.font,
                color: mainColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              " / month",
              style: TextStyle(
                fontFamily: AppFonts.font,
                color: bodyTextColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: hintColor.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              Icon(Icons.location_on_outlined, color: hintColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: AppFonts.font,
                      color: textColor,
                      fontSize: 15,
                    ),
                    children: [
                      TextSpan(
                        text:
                            [
                                  widget.property.street,
                                  widget.property.district,
                                  widget.property.city,
                                  widget.property.governorate,
                                ]
                                .where((e) => e != null && e!.isNotEmpty)
                                .join(', ')
                                .isNotEmpty
                            ? [
                                    widget.property.street,
                                    widget.property.district,
                                    widget.property.city,
                                    widget.property.governorate,
                                  ]
                                  .where((e) => e != null && e!.isNotEmpty)
                                  .join(', ')
                            : "Address not available",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ===================== Tabs =====================
  Widget _buildTabs(bool isDark, Color mainColor, Color textColor) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        // Ø§Ù„Ø®Ø· Ø§Ù„ÙØ§ØµÙ„ Ø§Ù„Ø±Ù…Ø§Ø¯ÙŠ Ø§Ù„Ø°ÙŠ ÙŠÙ…ØªØ¯ Ø¹Ù„Ù‰ Ø·ÙˆÙ„ Ø§Ù„Ø´Ø§Ø´Ø© Ù…Ù† Ø§Ù„Ø£Ø³ÙÙ„
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: 1,
            color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
          ),
        ),
        // Ø§Ù„ØªØ§Ø¨Ø³ Ø§Ù„ØªÙŠ ØªÙ…Ø±Ø± Ø£ÙÙ‚ÙŠØ§Ù‹ Ù…Ø¹ Ø®Ø·ÙˆØ·Ù‡Ø§ Ø§Ù„Ø³ÙÙ„ÙŠØ© Ø§Ù„Ù…Ù„ÙˆÙ†Ø© ÙÙˆÙ‚ Ø§Ù„Ø®Ø· Ø§Ù„Ø±Ù…Ø§Ø¯ÙŠ
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: List.generate(_tabs.length, (index) {
              final tab = _tabs[index];
              bool isSelected = _selectedTab == tab;
              return GestureDetector(
                onTap: () => _scrollToSection(index),
                child: Container(
                  margin: const EdgeInsets.only(right: 20),
                  padding: const EdgeInsets.only(
                    bottom: 12,
                  ), // Ø§Ù„Ù…Ø³Ø§ÙØ© Ø£Ø³ÙÙ„ Ø§Ù„ØªÙŠÙƒØ³Øª
                  decoration: BoxDecoration(
                    border: isSelected
                        ? Border(bottom: BorderSide(color: mainColor, width: 2))
                        : const Border(
                            bottom: BorderSide(
                              color: Colors.transparent,
                              width: 2,
                            ),
                          ),
                  ),
                  child: Text(
                    tab,
                    style: TextStyle(
                      fontFamily: AppFonts.font,
                      color: isSelected ? mainColor : textColor,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 15,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  // ===================== Sections =====================

  Widget _buildOverviewSection(
    bool isDark,
    Color textColor,
    Color bodyTextColor,
    Color mainColor,
    Color hintColor,
  ) {
    Color cardColor = isDark ? const Color(0xff2A2A2A) : Colors.white;
    Color borderColor = isDark ? Colors.transparent : Colors.grey[200]!;

    return Column(
      key: _sectionKeys[0],
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Property Information",
          style: TextStyle(
            fontFamily: AppFonts.font,
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            double cardWidth = (constraints.maxWidth - 20) / 3;
            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                if (widget.property.areaSquareMeters != null &&
                    widget.property.areaSquareMeters! > 0)
                  _detailCard(
                    Icons.square_foot_outlined,
                    "Area",
                    "${widget.property.areaSquareMeters!.toStringAsFixed(0)} m²",
                    cardWidth,
                    cardColor,
                    borderColor,
                    textColor,
                    hintColor,
                    mainColor,
                  ),
                if (widget.property.bedrooms != null)
                  _detailCard(
                    Icons.bed_outlined,
                    "Bedrooms",
                    widget.property.bedrooms.toString(),
                    cardWidth,
                    cardColor,
                    borderColor,
                    textColor,
                    hintColor,
                    mainColor,
                  ),
                if (widget.property.bathrooms != null)
                  _detailCard(
                    Icons.bathtub_outlined,
                    "Bathrooms",
                    widget.property.bathrooms.toString(),
                    cardWidth,
                    cardColor,
                    borderColor,
                    textColor,
                    hintColor,
                    mainColor,
                  ),
                if (widget.property.floorNumber != null)
                  _detailCard(
                    Icons.elevator_outlined,
                    "Floor",
                    "${widget.property.floorNumber}${_ordinalSuffix(widget.property.floorNumber!)}",
                    cardWidth,
                    cardColor,
                    borderColor,
                    textColor,
                    hintColor,
                    mainColor,
                  ),
                if (widget.property.furnishingStatus != null &&
                    widget.property.furnishingStatus!.isNotEmpty)
                  _detailCard(
                    Icons.chair_outlined,
                    "Furnished",
                    widget.property.furnishingStatus!,
                    cardWidth,
                    cardColor,
                    borderColor,
                    textColor,
                    hintColor,
                    mainColor,
                  ),
                if (widget.property.propertyType != null &&
                    widget.property.propertyType!.isNotEmpty)
                  _detailCard(
                    Icons.apartment_outlined,
                    "Type",
                    widget.property.propertyType!,
                    cardWidth,
                    cardColor,
                    borderColor,
                    textColor,
                    hintColor,
                    mainColor,
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        Text(
          "About this property",
          style: TextStyle(
            fontFamily: AppFonts.font,
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        RentExpandableTextWidget(
          text: widget.property.description ?? "No description available.",
          textColor: bodyTextColor,
          mainColor: mainColor,
        ),
      ],
    );
  }

  Widget _buildPricingSection(
    bool isDark,
    Color textColor,
    Color mainColor,
    Color verifiedColor,
  ) {
    Color borderColor = isDark ? Colors.transparent : Colors.grey[200]!;
    return Column(
      key: _sectionKeys[1],
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Move-in Breakdown",
          style: TextStyle(
            fontFamily: AppFonts.font,
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xff1E1E1E) : Colors.grey[50],
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            children: [
              _priceRow(
                "Monthly Rent",
                "EGP ${_formatPrice(widget.property.price)}",
                textColor,
                textColor,
                false,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Security Deposit",
                        style: TextStyle(
                          fontFamily: AppFonts.font,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.info_outline, size: 16, color: textColor),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "EGP ${_formatPrice((widget.property.price ?? 0) * 2)}",
                        style: TextStyle(
                          fontFamily: AppFonts.font,
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: mainColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "Refundable",
                          style: TextStyle(
                            fontFamily: AppFonts.font,
                            color: mainColor,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _priceRow(
                "1st Month Advance",
                "EGP ${_formatPrice(widget.property.price)}",
                textColor,
                textColor,
                false,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(),
              ),
              _priceRow(
                "Move-in Total",
                "EGP ${_formatPrice((widget.property.price ?? 0) * 3)}",
                textColor,
                mainColor,
                true,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: verifiedColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: verifiedColor.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: verifiedColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.shield_outlined, color: verifiedColor),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "SAFETY GUIDELINES",
                            style: TextStyle(
                              fontFamily: AppFonts.font,
                              color: verifiedColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Your money is held in secure escrow until you successfully move in. No risks attached.",
                            style: TextStyle(
                              fontFamily: AppFonts.font,
                              color: verifiedColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAmenitiesSection(bool isDark, Color textColor, Color mainColor) {
    return Column(
      key: _sectionKeys[2],
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Amenities",
          style: TextStyle(
            fontFamily: AppFonts.font,
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        RentExpandableChipsWidget(
          items: _buildAmenityChips(),
          mainColor: mainColor,
          textColor: textColor,
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildRulesSection(
    bool isDark,
    Color textColor,
    Color mainColor,
    Color hintColor,
  ) {
    return Column(
      key: _sectionKeys[3],
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "House Rules",
          style: TextStyle(
            fontFamily: AppFonts.font,
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        RentExpandableChipsWidget(
          items: _buildRuleChips(),
          mainColor: mainColor,
          textColor: textColor,
          isDark: isDark,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xff1E1E1E) : Colors.grey[50],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? Colors.transparent : Colors.grey[200]!,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Min. Lease",
                      style: TextStyle(
                        fontFamily: AppFonts.font,
                        color: hintColor,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.calendar_month, color: textColor, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          widget.property.minStayNights != null
                              ? "${widget.property.minStayNights} Nights"
                              : "Flexible",
                          style: TextStyle(
                            fontFamily: AppFonts.font,
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: 40,
                width: 1,
                color: isDark ? Colors.grey[700] : Colors.grey[300],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Available From",
                      style: TextStyle(
                        fontFamily: AppFonts.font,
                        color: hintColor,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.access_time, color: textColor, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          widget.property.rentalStartDate ?? "Immediately",
                          style: TextStyle(
                            fontFamily: AppFonts.font,
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ===================== Reviews Section =====================
  Widget _buildReviewsSection(
    bool isDark,
    Color textColor,
    Color bodyTextColor,
    Color mainColor,
    Color hintColor,
  ) {
    return SharedReviewsSectionManager(
      propertyId: widget.property.id,
      mainColor: mainColor,
      isDark: isDark,
      textColor: textColor,
      bodyTextColor: bodyTextColor,
      hintColor: hintColor,
    );
  }

  // ===================== Helpers =====================
  Widget _detailCard(
    IconData icon,
    String title,
    String value,
    double width,
    Color bgColor,
    Color borderColor,
    Color textColor,
    Color hintColor,
    Color mainColor,
  ) {
    return Container(
      width: width,
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: mainColor, size: 28),
          const SizedBox(height: 6),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppFonts.font,
              color: hintColor,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppFonts.font,
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(
    String title,
    String price,
    Color titleColor,
    Color priceColor,
    bool isTotal,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontFamily: AppFonts.font,
              color: titleColor,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 17 : 14,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          price,
          style: TextStyle(
            fontFamily: AppFonts.font,
            color: priceColor,
            fontWeight: FontWeight.bold,
            fontSize: isTotal ? 20 : 15,
          ),
        ),
      ],
    );
  }

  Widget _addressItem(
    String title,
    String value,
    Color hintColor,
    Color textColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: AppFonts.font,
            color: hintColor,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontFamily: AppFonts.font,
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}

// ===================== Custom Widgets (Extracted for better state management) =====================

class RentExpandableTextWidget extends StatefulWidget {
  final String text;
  final Color textColor;
  final Color mainColor;

  const RentExpandableTextWidget({
    super.key,
    required this.text,
    required this.textColor,
    required this.mainColor,
  });

  @override
  State<RentExpandableTextWidget> createState() =>
      _RentExpandableTextWidgetState();
}

class _RentExpandableTextWidgetState extends State<RentExpandableTextWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          maxLines: isExpanded ? null : 3,
          overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: AppFonts.font,
            color: widget.textColor,
            height: 1.5,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => setState(() => isExpanded = !isExpanded),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isExpanded ? "See less" : "Read more",
                style: TextStyle(
                  fontFamily: AppFonts.font,
                  color: widget.mainColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: widget.mainColor,
                size: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class RentExpandableChipsWidget extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final Color mainColor;
  final Color textColor;
  final bool isDark;
  final Color? hintColor;

  const RentExpandableChipsWidget({
    super.key,
    required this.items,
    required this.mainColor,
    required this.textColor,
    required this.isDark,
    this.hintColor,
  });

  @override
  State<RentExpandableChipsWidget> createState() =>
      _RentExpandableChipsWidgetState();
}

class _RentExpandableChipsWidgetState extends State<RentExpandableChipsWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    int displayCount = isExpanded
        ? widget.items.length
        : (widget.items.length > 3 ? 3 : widget.items.length);
    Color bgColor = widget.isDark ? const Color(0xff2A2A2A) : Colors.grey[100]!;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        ...widget.items
            .take(displayCount)
            .map(
              (e) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(e['icon'], color: widget.mainColor, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      e['label'],
                      style: TextStyle(
                        fontFamily: AppFonts.font,
                        color: widget.textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    if (e['unit'] != null) ...[
                      const SizedBox(width: 4),
                      Text(
                        e['unit'],
                        style: TextStyle(
                          fontFamily: AppFonts.font,
                          color: widget.hintColor,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
        if (widget.items.length > 3)
          GestureDetector(
            onTap: () => setState(() => isExpanded = !isExpanded),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: widget.mainColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isExpanded ? "See less" : "See more",
                    style: TextStyle(
                      fontFamily: AppFonts.font,
                      color: widget.mainColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: widget.mainColor,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class RentAnimatedLocationIconWidget extends StatefulWidget {
  final Color mainColor;
  const RentAnimatedLocationIconWidget({super.key, required this.mainColor});

  @override
  State<RentAnimatedLocationIconWidget> createState() =>
      _RentAnimatedLocationIconWidgetState();
}

class _RentAnimatedLocationIconWidgetState
    extends State<RentAnimatedLocationIconWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.0,
      end: -10.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: widget.mainColor.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.location_on, color: widget.mainColor, size: 36),
          ),
        );
      },
    );
  }
}

class RentAnimatedAddReviewButton extends StatefulWidget {
  final Color mainColor;
  final Color bgColor;
  final bool isDark;
  final VoidCallback onTap;

  const RentAnimatedAddReviewButton({
    super.key,
    required this.mainColor,
    required this.bgColor,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<RentAnimatedAddReviewButton> createState() =>
      _RentAnimatedAddReviewButtonState();
}

class _RentAnimatedAddReviewButtonState
    extends State<RentAnimatedAddReviewButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),

      onTapUp: (_) {
        setState(() => isPressed = false);

        widget.onTap(); // ØªØ´ØºÙŠÙ„ Ø§Ù„ÙØ§Ù†ÙƒØ´Ù†
      },

      onTapCancel: () => setState(() => isPressed = false),

      child: AnimatedScale(
        scale: isPressed ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 100),

        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),

          decoration: BoxDecoration(
            color: widget.bgColor,
            borderRadius: BorderRadius.circular(15),

            border: Border.all(color: widget.mainColor.withOpacity(0.5)),
          ),

          child: Row(
            children: [
              Icon(Icons.edit, color: widget.mainColor, size: 14),

              const SizedBox(width: 4),

              Text(
                "Add Review",
                style: TextStyle(
                  fontFamily: AppFonts.font,
                  color: widget.mainColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}