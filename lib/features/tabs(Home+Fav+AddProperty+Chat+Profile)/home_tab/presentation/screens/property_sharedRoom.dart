import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class SharedRoomDetailsScreen extends StatefulWidget {
  final PropertyDetailsModel property;
  const SharedRoomDetailsScreen({super.key, required this.property});

  @override
  State<SharedRoomDetailsScreen> createState() =>
      _SharedRoomDetailsScreenState();
}

class _SharedRoomDetailsScreenState extends State<SharedRoomDetailsScreen> {
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
    'Amenities',
    'Preferences',
    'Pricing',
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
                                      dailyPrice: null,
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
                                      rentalModel: 'Shared Room',
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
                            badgeText: "ROOM FOR RENT",
                            mainColor: mainColor,
                            attentionColor: attentionColor,
                            isDark: isDark,
                          ),
                          const SizedBox(height: 20),
                          _buildBasicInfo(
                            isDark,
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
                          Container(
                            key: _sectionKeys[0],
                            child: _buildOverviewSection(
                              isDark,
                              textColor,
                              bodyTextColor,
                              mainColor,
                              hintColor,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            key: _sectionKeys[1],
                            child: _buildAmenitiesSection(
                              isDark,
                              textColor,
                              bodyTextColor,
                              mainColor,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            key: _sectionKeys[2],
                            child: _buildPreferencesSection(
                              isDark,
                              textColor,
                              bodyTextColor,
                              mainColor,
                              hintColor,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            key: _sectionKeys[3],
                            child: _buildPricingSection(
                              isDark,
                              textColor,
                              mainColor,
                              hintColor,
                              bodyTextColor,
                            ),
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
                          Container(
                            key: _sectionKeys[6],
                            child: _buildReviewsSection(
                              isDark,
                              textColor,
                              bodyTextColor,
                              mainColor,
                              hintColor,
                            ),
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            PropertyBottomBar(
              label: "MONTHLY RENT",
              price: "EGP ${_formatPrice(widget.property.price)}",
              priceSuffix: "/mo",
              buttonText: "Make an Offer",
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
    bool isDark,
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
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                (widget.property.propertyType ?? "Shared Room").toUpperCase(),
                style: TextStyle(
                  fontFamily: AppFonts.font,
                  color: mainColor,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                ),
              ),
              child: Text(
                "in Shared Apartment",
                style: TextStyle(
                  fontFamily: AppFonts.font,
                  color: hintColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          spacing: 4,
          runSpacing: 4,
          children: [
            Text(
              "EGP ${_formatPrice(widget.property.price)}",
              style: TextStyle(
                fontFamily: AppFonts.font,
                color: mainColor,
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "/ month",
              style: TextStyle(
                fontFamily: AppFonts.font,
                color: hintColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: mainColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_on_outlined,
                  color: mainColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
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
                      style: TextStyle(
                        fontFamily: AppFonts.font,
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      (widget.property.buildingNumber != null &&
                              widget.property.buildingNumber!.isNotEmpty)
                          ? widget.property.buildingNumber!
                          : "Address details",
                      style: TextStyle(
                        fontFamily: AppFonts.font,
                        color: hintColor,
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
    );
  }

  // ===================== Tabs Widget =====================
  // Widget _buildTabs(bool isDark, Color mainColor, Color textColor) {
  //   return SizedBox(
  //     height: 45,
  //     child: ListView.builder(
  //       scrollDirection: Axis.horizontal,
  //       itemCount: _tabs.length,
  //       itemBuilder: (context, index) {
  //         bool isSelected = _selectedTab == _tabs[index];
  //         return GestureDetector(
  //           onTap: () => _scrollToSection(index),
  //           child: Container(
  //             margin: const EdgeInsets.only(right: 24),
  //             decoration: BoxDecoration(
  //               border: Border(
  //                 bottom: BorderSide(
  //                   color: isSelected ? mainColor : Colors.transparent,
  //                   width: 2,
  //                 ),
  //               ),
  //             ),
  //             child: Center(
  //               child: Text(
  //                 _tabs[index],
  //                 style: TextStyle(
  //                   fontFamily: AppFonts.font,
  //                   color: isSelected
  //                       ? mainColor
  //                       : (isDark ? Colors.grey[400] : Colors.grey[600]),
  //                   fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
  //                   fontSize: 15,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
  Widget _buildTabs(bool isDark, Color mainColor, Color textColor) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        // الخط الرمادي الثابت
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: 1,
            color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
          ),
        ),

        // التابات
        SizedBox(
          height: 45,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _tabs.length,
            itemBuilder: (context, index) {
              bool isSelected = _selectedTab == _tabs[index];

              return GestureDetector(
                onTap: () => _scrollToSection(index),
                child: Container(
                  margin: const EdgeInsets.only(right: 24),
                  padding: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isSelected ? mainColor : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _tabs[index],
                      style: TextStyle(
                        fontFamily: AppFonts.font,
                        color: isSelected
                            ? mainColor
                            : (isDark ? Colors.grey[400] : Colors.grey[600]),
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ===================== Overview Section =====================
  Widget _buildOverviewSection(
    bool isDark,
    Color textColor,
    Color bodyTextColor,
    Color mainColor,
    Color hintColor,
  ) {
    // Ø¨Ù†Ø§Ø¡ Ø§Ù„Ù…Ø±Ø¨Ø¹Ø§Øª Ø¨Ø´ÙƒÙ„ ÙØ±Ø¯ÙŠ Ù„ÙŠØªÙ†Ø§Ø³Ø¨ Ù…Ø¹ ØªØµÙ…ÙŠÙ… (col-span-2) ÙƒÙ…Ø§ ÙÙŠ HTML
    Widget buildInfoCard(
      IconData icon,
      String title,
      String value,
      double cardWidth,
    ) {
      return Container(
        width: cardWidth,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: mainColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppFonts.font,
                      color: hintColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      fontFamily: AppFonts.font,
                      color: textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "About the Room",
          style: TextStyle(
            fontFamily: AppFonts.font,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 16),
        SharedExpandableTextWidget(
          text: widget.property.description ?? "No description available.",
          textColor: bodyTextColor,
          mainColor: mainColor,
        ),
        const SizedBox(height: 24),

        // Custom Grid Layout to support col-span-2, fully responsive via LayoutBuilder
        LayoutBuilder(
          builder: (context, constraints) {
            final double halfWidth = (constraints.maxWidth - 12) / 2;
            final double fullWidth = constraints.maxWidth;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                buildInfoCard(
                  Icons.meeting_room,
                  "Room Type",
                  widget.property.propertyType != null &&
                          widget.property.propertyType!.isNotEmpty
                      ? widget.property.propertyType!
                      : "Shared Room",
                  halfWidth,
                ),
                if (widget.property.maxOccupants != null)
                  buildInfoCard(
                    Icons.group,
                    "Capacity",
                    "${widget.property.maxOccupants} Persons",
                    halfWidth,
                  ),
                if (widget.property.preferences != null &&
                    widget.property.preferences!['gender'] != null)
                  buildInfoCard(
                    Icons.wc,
                    "Gender Pref",
                    widget.property.preferences!['gender'],
                    halfWidth,
                  ),
                if (widget.property.bedrooms != null)
                  buildInfoCard(
                    Icons.bed,
                    "Bed Type",
                    widget.property.bedrooms!.toString(),
                    halfWidth,
                  ),
                if (widget.property.areaSquareMeters != null &&
                    widget.property.areaSquareMeters! > 0)
                  buildInfoCard(
                    Icons.aspect_ratio,
                    "Room Size",
                    "${widget.property.areaSquareMeters!.toStringAsFixed(0)} m²",
                    halfWidth,
                  ),
                if (widget.property.rentalStartDate != null &&
                    widget.property.rentalStartDate!.isNotEmpty)
                  buildInfoCard(
                    Icons.event_available,
                    "Available From",
                    widget.property.rentalStartDate!,
                    halfWidth,
                  ),
                if (widget.property.furnishingStatus != null &&
                    widget.property.furnishingStatus!.isNotEmpty)
                  buildInfoCard(
                    Icons.weekend,
                    "Furnished",
                    widget.property.furnishingStatus!,
                    fullWidth,
                  ),
                if (widget.property.minStayNights != null)
                  buildInfoCard(
                    Icons.update,
                    "Min. Lease",
                    "${widget.property.minStayNights} Nights",
                    fullWidth,
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  // ===================== Amenities Section =====================
  Widget _buildAmenitiesSection(
    bool isDark,
    Color textColor,
    Color bodyTextColor,
    Color mainColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Space & Amenities",
          style: TextStyle(
            fontFamily: AppFonts.font,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 16),
        SharedExpandableChipsWidget(
          items: _buildAmenityChips(),
          mainColor: mainColor,
          textColor: textColor,
          isDark: isDark,
        ),
      ],
    );
  }

  // ===================== Preferences Section =====================
  Widget _buildPreferencesSection(
    bool isDark,
    Color textColor,
    Color bodyTextColor,
    Color mainColor,
    Color hintColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Rules & Preferences",
          style: TextStyle(
            fontFamily: AppFonts.font,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 16),
        SharedExpandableChipsWidget(
          items: _buildRuleChips(),
          mainColor: mainColor,
          textColor: textColor,
          isDark: isDark,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[850] : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.family_restroom, color: textColor, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Ideal for students & professionals",
                  style: TextStyle(
                    fontFamily: AppFonts.font,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ===================== Pricing Section =====================
  Widget _buildPricingSection(
    bool isDark,
    Color textColor,
    Color mainColor,
    Color hintColor,
    Color bodyTextColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Initial Costs",
          style: TextStyle(
            fontFamily: AppFonts.font,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xff232323) : Colors.grey[50],
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPricingRow(
                isDark,
                Icons.account_balance_wallet,
                "Monthly Rent",
                "EGP ${_formatPrice(widget.property.price)}",
                mainColor,
                textColor,
                hintColor,
              ),
              const SizedBox(height: 16),
              _buildPricingRow(
                isDark,
                Icons.security,
                "Security Deposit",
                "EGP ${_formatPrice(widget.property.price)}",
                context.attentionColor,
                textColor,
                hintColor,
                showTag: true,
                tagText: "Refundable",
              ),
              const SizedBox(height: 16),
              _buildPricingRow(
                isDark,
                Icons.receipt_long,
                "Bills",
                "Divided equally (approx. EGP 400/mo)",
                Colors.teal,
                textColor,
                hintColor,
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Total Move-in Cost",
                    style: TextStyle(
                      fontFamily: AppFonts.font,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  Text(
                    "EGP ${_formatPrice((widget.property.price ?? 0) * 2)}",
                    style: TextStyle(
                      fontFamily: AppFonts.font,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: mainColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPricingRow(
    bool isDark,
    IconData icon,
    String title,
    String value,
    Color iconColor,
    Color textColor,
    Color hintColor, {
    bool showTag = false,
    String tagText = "Required",
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: AppFonts.font,
                  fontSize: 14,
                  color: hintColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontFamily: AppFonts.font,
                  fontSize: 16,
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        if (showTag)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              tagText,
              style: TextStyle(
                fontFamily: AppFonts.font,
                fontSize: 10,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
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
}

// ===================== Custom Widgets =====================

class SharedExpandableTextWidget extends StatefulWidget {
  final String text;
  final Color textColor;
  final Color mainColor;

  const SharedExpandableTextWidget({
    super.key,
    required this.text,
    required this.textColor,
    required this.mainColor,
  });

  @override
  State<SharedExpandableTextWidget> createState() =>
      _SharedExpandableTextWidgetState();
}

class _SharedExpandableTextWidgetState
    extends State<SharedExpandableTextWidget> {
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

class SharedExpandableChipsWidget extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final Color mainColor;
  final Color textColor;
  final bool isDark;
  final Color? hintColor;

  const SharedExpandableChipsWidget({
    super.key,
    required this.items,
    required this.mainColor,
    required this.textColor,
    required this.isDark,
    this.hintColor,
  });

  @override
  State<SharedExpandableChipsWidget> createState() =>
      _SharedExpandableChipsWidgetState();
}

class _SharedExpandableChipsWidgetState
    extends State<SharedExpandableChipsWidget> {
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
                  border: Border.all(
                    color: widget.isDark
                        ? Colors.transparent
                        : Colors.grey[300]!,
                  ),
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

class SharedAnimatedLocationIconWidget extends StatefulWidget {
  final Color mainColor;
  const SharedAnimatedLocationIconWidget({super.key, required this.mainColor});

  @override
  State<SharedAnimatedLocationIconWidget> createState() =>
      _SharedAnimatedLocationIconWidgetState();
}

class _SharedAnimatedLocationIconWidgetState
    extends State<SharedAnimatedLocationIconWidget>
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
