import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class ShortTermDetailsScreen extends StatefulWidget {
  final PropertyDetailsModel property;
  const ShortTermDetailsScreen({super.key, required this.property});

  @override
  State<ShortTermDetailsScreen> createState() => _ShortTermDetailsScreenState();
}

class _ShortTermDetailsScreenState extends State<ShortTermDetailsScreen> {
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
    'Availability',
    'Pricing',
    'Amenities',
    'Rules',
    'Location',
    'Owner',
    'Reviews',
  ];
  final List<GlobalKey> _sectionKeys = List.generate(8, (index) => GlobalKey());
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
                                      rentalModel: 'Short-term',
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
                            badgeText: "SHORT-TERM",
                            badgeIcon: Icons.luggage,
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
                            child: _buildAvailabilitySection(
                              isDark,
                              textColor,
                              mainColor,
                              hintColor,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            key: _sectionKeys[2],
                            child: _buildPricingSection(
                              isDark,
                              textColor,
                              mainColor,
                              attentionColor,
                              hintColor,
                              bodyTextColor,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            key: _sectionKeys[3],
                            child: _buildAmenitiesSection(
                              isDark,
                              textColor,
                              bodyTextColor,
                              mainColor,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            key: _sectionKeys[4],
                            child: _buildRulesSection(
                              isDark,
                              textColor,
                              bodyTextColor,
                              mainColor,
                              hintColor,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            key: _sectionKeys[5],
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
                            key: _sectionKeys[6],
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
                            key: _sectionKeys[7],
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
              label: "PRICE",
              price: "EGP ${_formatPrice(widget.property.price)}",
              priceSuffix: "/night",
              buttonText: "Check Availability",
              onChatPressed: () {},
              onButtonPressed: () {},
              textColor: hintColor,
              bodyTextColor: bodyTextColor,
              mainColor: mainColor,
              isDark: isDark,
              buttonFlex: 11,
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
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.property.propertyType?.toUpperCase() ?? "APARTMENT",
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
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: attentionColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, color: attentionColor, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        avgRating.toStringAsFixed(1),
                        style: TextStyle(
                          fontFamily: AppFonts.font,
                          color: textColor,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        totalReviews == 0
                            ? "No reviews"
                            : "($totalReviews Reviews)",
                        style: TextStyle(
                          fontFamily: AppFonts.font,
                          color: hintColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
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
            height: 1.3,
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
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              "/ night",
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
                        fontSize: 11,
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
    List<Map<String, dynamic>> info = [];
    if (widget.property.areaSquareMeters != null &&
        widget.property.areaSquareMeters! > 0) {
      info.add({
        "icon": Icons.crop_free,
        "title": "Area",
        "value": "${widget.property.areaSquareMeters!.toStringAsFixed(0)} m²",
      });
    }
    if (widget.property.bedrooms != null) {
      info.add({
        "icon": Icons.bed,
        "title": "Bedrooms",
        "value": widget.property.bedrooms.toString(),
      });
    }
    if (widget.property.bathrooms != null) {
      info.add({
        "icon": Icons.bathtub,
        "title": "Baths",
        "value": widget.property.bathrooms.toString(),
      });
    }
    if (widget.property.furnishingStatus != null &&
        widget.property.furnishingStatus!.isNotEmpty) {
      info.add({
        "icon": Icons.weekend,
        "title": "Furnished",
        "value": widget.property.furnishingStatus,
      });
    }
    if (widget.property.propertyType != null &&
        widget.property.propertyType!.isNotEmpty) {
      info.add({
        "icon": Icons.home,
        "title": "Type",
        "value": widget.property.propertyType,
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "About this stay",
          style: TextStyle(
            fontFamily: AppFonts.font,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.0,
          ),
          itemCount: info.length,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(info[index]["icon"], color: mainColor, size: 24),
                  const SizedBox(height: 6),
                  Text(
                    info[index]["title"].toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppFonts.font,
                      color: hintColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    info[index]["value"],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppFonts.font,
                      color: textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        ShortExpandableTextWidget(
          text: widget.property.description ?? "No description available.",
          textColor: bodyTextColor,
          mainColor: mainColor,
        ),
      ],
    );
  }

  // ===================== Modal Calendar Selection =====================
  void _showCalendarAndGuestsModal(
    BuildContext context,
    bool isDark,
    Color textColor,
    Color mainColor,
    Color hintColor,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xff1E1E1E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        int guestCount = 1;
        DateTime now = DateTime.now();
        DateTime today = DateTime(now.year, now.month, now.day);
        DateTime focusedMonth = DateTime(now.year, now.month, 1);
        DateTime? checkIn;
        DateTime? checkOut;

        List<String> monthNames = [
          "January",
          "February",
          "March",
          "April",
          "May",
          "June",
          "July",
          "August",
          "September",
          "October",
          "November",
          "December",
        ];

        return StatefulBuilder(
          builder: (context, setModalState) {
            int daysInMonth = DateUtils.getDaysInMonth(
              focusedMonth.year,
              focusedMonth.month,
            );
            int firstWeekday = DateTime(
              focusedMonth.year,
              focusedMonth.month,
              1,
            ).weekday;
            int firstDayOffset = firstWeekday == 7 ? 0 : firstWeekday;
            int totalSlots = daysInMonth + firstDayOffset;
            bool isCurrentMonth =
                (focusedMonth.year == now.year &&
                focusedMonth.month == now.month);

            String checkInTxt = checkIn != null
                ? "${monthNames[checkIn!.month - 1].substring(0, 3)} ${checkIn!.day}, ${checkIn!.year}"
                : "Select date";
            String checkOutTxt = checkOut != null
                ? "${monthNames[checkOut!.month - 1].substring(0, 3)} ${checkOut!.day}, ${checkOut!.year}"
                : "Select date";

            return DraggableScrollableSheet(
              initialChildSize: 0.85,
              maxChildSize: 0.95,
              minChildSize: 0.5,
              expand: false,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Select Dates",
                              style: TextStyle(
                                fontFamily: AppFonts.font,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.close,
                                color: textColor,
                                size: 22,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                        Text(
                          "Min. 2 nights Â· Check-in after 2 PM Â· Check-out before 11 AM",
                          style: TextStyle(
                            fontFamily: AppFonts.font,
                            fontSize: 12,
                            color: hintColor,
                          ),
                        ),
                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: isCurrentMonth
                                  ? null
                                  : () {
                                      setModalState(() {
                                        focusedMonth = DateTime(
                                          focusedMonth.year,
                                          focusedMonth.month - 1,
                                          1,
                                        );
                                      });
                                    },
                              icon: Icon(
                                Icons.chevron_left,
                                color: isCurrentMonth
                                    ? hintColor.withOpacity(0.3)
                                    : textColor,
                              ),
                            ),
                            Text(
                              "${monthNames[focusedMonth.month - 1]} ${focusedMonth.year}",
                              style: TextStyle(
                                fontFamily: AppFonts.font,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setModalState(() {
                                  focusedMonth = DateTime(
                                    focusedMonth.year,
                                    focusedMonth.month + 1,
                                    1,
                                  );
                                });
                              },
                              icon: Icon(Icons.chevron_right, color: textColor),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']
                              .map(
                                (day) => SizedBox(
                                  width: 30,
                                  child: Center(
                                    child: Text(
                                      day,
                                      style: TextStyle(
                                        fontFamily: AppFonts.font,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: hintColor,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 10),

                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: totalSlots,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 7,
                                childAspectRatio: 1.0,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                              ),
                          itemBuilder: (context, index) {
                            if (index < firstDayOffset) return const SizedBox();

                            int day = index - firstDayOffset + 1;
                            DateTime thisDate = DateTime(
                              focusedMonth.year,
                              focusedMonth.month,
                              day,
                            );
                            bool isPast = thisDate.isBefore(today);
                            bool isSelectCheckIn =
                                checkIn != null &&
                                thisDate.year == checkIn!.year &&
                                thisDate.month == checkIn!.month &&
                                thisDate.day == checkIn!.day;
                            bool isSelectCheckOut =
                                checkOut != null &&
                                thisDate.year == checkOut!.year &&
                                thisDate.month == checkOut!.month &&
                                thisDate.day == checkOut!.day;
                            bool isBetween =
                                checkIn != null &&
                                checkOut != null &&
                                thisDate.isAfter(checkIn!) &&
                                thisDate.isBefore(checkOut!);

                            Color gridBgColor = Colors.transparent;
                            Color gridTxtColor = textColor;

                            if (isPast) {
                              gridTxtColor = hintColor.withOpacity(0.4);
                            } else if (isSelectCheckIn || isSelectCheckOut) {
                              gridBgColor = mainColor;
                              gridTxtColor = isDark
                                  ? Colors.black
                                  : Colors.white;
                            } else if (isBetween) {
                              gridBgColor = mainColor.withOpacity(0.15);
                              gridTxtColor = mainColor;
                            } else {
                              gridTxtColor = textColor;
                            }

                            return GestureDetector(
                              onTap: isPast
                                  ? null
                                  : () {
                                      setModalState(() {
                                        if (checkIn == null) {
                                          checkIn = thisDate;
                                        } else if (checkOut == null) {
                                          if (thisDate.isBefore(checkIn!)) {
                                            checkIn = thisDate;
                                          } else {
                                            checkOut = thisDate;
                                          }
                                        } else {
                                          checkIn = thisDate;
                                          checkOut = null;
                                        }
                                      });
                                    },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: gridBgColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      (!isPast &&
                                          !isSelectCheckIn &&
                                          !isSelectCheckOut &&
                                          !isBetween)
                                      ? Border.all(
                                          color: isDark
                                              ? Colors.grey[800]!
                                              : Colors.grey[200]!,
                                        )
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    "$day",
                                    style: TextStyle(
                                      fontFamily: AppFonts.font,
                                      color: gridTxtColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[850] : Colors.grey[50],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark
                                  ? Colors.grey[700]!
                                  : Colors.grey[200]!,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "CHECK-IN",
                                      style: TextStyle(
                                        fontFamily: AppFonts.font,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: hintColor,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      checkInTxt,
                                      style: TextStyle(
                                        fontFamily: AppFonts.font,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: checkIn != null
                                            ? textColor
                                            : hintColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 30,
                                color: hintColor.withOpacity(0.3),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "CHECK-OUT",
                                      style: TextStyle(
                                        fontFamily: AppFonts.font,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: hintColor,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      checkOutTxt,
                                      style: TextStyle(
                                        fontFamily: AppFonts.font,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: checkOut != null
                                            ? textColor
                                            : hintColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[850] : Colors.grey[50],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark
                                  ? Colors.grey[700]!
                                  : Colors.grey[200]!,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "GUESTS",
                                    style: TextStyle(
                                      fontFamily: AppFonts.font,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Max 6 guests",
                                    style: TextStyle(
                                      fontFamily: AppFonts.font,
                                      fontSize: 13,
                                      color: hintColor,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => setModalState(() {
                                      if (guestCount > 1) guestCount--;
                                    }),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: hintColor.withOpacity(0.5),
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.remove,
                                        color: hintColor,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    "$guestCount",
                                    style: TextStyle(
                                      fontFamily: AppFonts.font,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  GestureDetector(
                                    onTap: () => setModalState(() {
                                      if (guestCount < 6) guestCount++;
                                    }),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: hintColor.withOpacity(0.5),
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: hintColor,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mainColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check,
                                  color: isDark ? Colors.black : Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Apply Dates",
                                  style: TextStyle(
                                    fontFamily: AppFonts.font,
                                    color: isDark ? Colors.black : Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
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
              },
            );
          },
        );
      },
    );
  }

  // ===================== Availability Section =====================
  Widget _buildAvailabilitySection(
    bool isDark,
    Color textColor,
    Color mainColor,
    Color hintColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Select Dates",
              style: TextStyle(
                fontFamily: AppFonts.font,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Text(
              "Min. 2 nights",
              style: TextStyle(
                fontFamily: AppFonts.font,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: hintColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[850] : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "CHECK-IN",
                            style: TextStyle(
                              fontFamily: AppFonts.font,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Add date",
                            style: TextStyle(
                              fontFamily: AppFonts.font,
                              fontSize: 14,
                              color: hintColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 50,
                    color: isDark ? Colors.grey[700] : Colors.grey[300],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "CHECK-OUT",
                            style: TextStyle(
                              fontFamily: AppFonts.font,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Add date",
                            style: TextStyle(
                              fontFamily: AppFonts.font,
                              fontSize: 14,
                              color: hintColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                height: 1,
                color: isDark ? Colors.grey[700] : Colors.grey[300],
              ),
              GestureDetector(
                onTap: () => _showCalendarAndGuestsModal(
                  context,
                  isDark,
                  textColor,
                  mainColor,
                  hintColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "GUESTS",
                            style: TextStyle(
                              fontFamily: AppFonts.font,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "1 guest",
                            style: TextStyle(
                              fontFamily: AppFonts.font,
                              fontSize: 14,
                              color: hintColor,
                            ),
                          ),
                        ],
                      ),
                      Icon(Icons.expand_more, color: hintColor),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => _showCalendarAndGuestsModal(
            context,
            isDark,
            textColor,
            mainColor,
            hintColor,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_month, color: mainColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  "Select dates to see exact pricing",
                  style: TextStyle(
                    fontFamily: AppFonts.font,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: hintColor,
                  ),
                ),
              ],
            ),
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
    Color attentionColor,
    Color hintColor,
    Color bodyTextColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Price Breakdown",
          style: TextStyle(
            fontFamily: AppFonts.font,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xff232323) : Colors.grey[50],
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: -24,
                right: -24,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: mainColor.withOpacity(0.1),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Text(
                    "ESTIMATE: 1 NIGHT",
                    style: TextStyle(
                      fontFamily: AppFonts.font,
                      color: mainColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  _buildPricingRowText(
                    "EGP ${_formatPrice(widget.property.price)} x 1 night",
                    "EGP ${_formatPrice((widget.property.price ?? 0) * 1)}",
                    hintColor,
                    textColor,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Security Deposit",
                        style: TextStyle(
                          fontFamily: AppFonts.font,
                          fontSize: 14,
                          color: hintColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "EGP ${_formatPrice((widget.property.rentalPricing != null && widget.property.rentalPricing!['securityDeposit'] != null) ? widget.property.rentalPricing!['securityDeposit'].toDouble() : 0)}",
                            style: TextStyle(
                              fontFamily: AppFonts.font,
                              fontSize: 15,
                              color: textColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              "Refundable",
                              style: TextStyle(
                                fontFamily: AppFonts.font,
                                fontSize: 10,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(
                    color: isDark ? Colors.grey[700] : Colors.grey[300],
                    thickness: 1,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Total Estimate",
                        style: TextStyle(
                          fontFamily: AppFonts.font,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Text(
                        "EGP ${_formatPrice((widget.property.price ?? 0) + ((widget.property.rentalPricing != null && widget.property.rentalPricing!['securityDeposit'] != null) ? widget.property.rentalPricing!['securityDeposit'].toDouble() : 0))}",
                        style: TextStyle(
                          fontFamily: AppFonts.font,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: mainColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPricingRowText(
    String title,
    String value,
    Color titleColor,
    Color valueColor,
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
              fontSize: 14,
              color: titleColor,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
              decorationColor: titleColor.withOpacity(0.5),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: TextStyle(
            fontFamily: AppFonts.font,
            fontSize: 15,
            color: valueColor,
            fontWeight: FontWeight.bold,
          ),
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
          "Amenities",
          style: TextStyle(
            fontFamily: AppFonts.font,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 16),
        ShortExpandableChipsWidget(
          items: _buildAmenityChips(),
          mainColor: mainColor,
          textColor: textColor,
          isDark: isDark,
        ),
      ],
    );
  }

  // ===================== Rules Section =====================
  Widget _buildRulesSection(
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
          "House Rules",
          style: TextStyle(
            fontFamily: AppFonts.font,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 16),
        ShortExpandableChipsWidget(
          items: _buildRuleChips(),
          mainColor: mainColor,
          textColor: textColor,
          isDark: isDark,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[850] : Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.login, color: hintColor, size: 24),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "CHECK-IN",
                          style: TextStyle(
                            fontFamily: AppFonts.font,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: hintColor,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.property.checkInTime ?? "Flexible",
                          style: TextStyle(
                            fontFamily: AppFonts.font,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.logout, color: hintColor, size: 24),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "CHECK-OUT",
                          style: TextStyle(
                            fontFamily: AppFonts.font,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: hintColor,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.property.checkOutTime ?? "Flexible",
                          style: TextStyle(
                            fontFamily: AppFonts.font,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: textColor,
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
}

// ===================== Custom Widgets =====================

class ShortExpandableTextWidget extends StatefulWidget {
  final String text;
  final Color textColor;
  final Color mainColor;

  const ShortExpandableTextWidget({
    super.key,
    required this.text,
    required this.textColor,
    required this.mainColor,
  });

  @override
  State<ShortExpandableTextWidget> createState() =>
      _ShortExpandableTextWidgetState();
}

class _ShortExpandableTextWidgetState extends State<ShortExpandableTextWidget> {
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
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => setState(() => isExpanded = !isExpanded),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isExpanded ? "Show less" : "Read more",
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

class ShortExpandableChipsWidget extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final Color mainColor;
  final Color textColor;
  final bool isDark;
  final Color? hintColor;

  const ShortExpandableChipsWidget({
    super.key,
    required this.items,
    required this.mainColor,
    required this.textColor,
    required this.isDark,
    this.hintColor,
  });

  @override
  State<ShortExpandableChipsWidget> createState() =>
      _ShortExpandableChipsWidgetState();
}

class _ShortExpandableChipsWidgetState
    extends State<ShortExpandableChipsWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    int displayCount = isExpanded
        ? widget.items.length
        : (widget.items.length > 3 ? 3 : widget.items.length);
    Color bgColor = widget.isDark ? const Color(0xff2A2A2A) : Colors.white;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        ...widget.items
            .take(displayCount)
            .map(
              (e) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: widget.isDark
                        ? Colors.grey[700]!
                        : Colors.grey[200]!,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(e['icon'], color: widget.mainColor, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      e['label'],
                      style: TextStyle(
                        fontFamily: AppFonts.font,
                        color: widget.textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    if (e['unit'] != null) ...[
                      const SizedBox(width: 4),
                      Text(
                        e['unit'],
                        style: TextStyle(
                          fontFamily: AppFonts.font,
                          color: widget.hintColor,
                          fontSize: 12,
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: widget.mainColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: widget.mainColor.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: widget.mainColor,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isExpanded ? "See Less" : "See More",
                    style: TextStyle(
                      fontFamily: AppFonts.font,
                      color: widget.mainColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class ShortAnimatedLocationIconWidget extends StatefulWidget {
  final Color mainColor;
  const ShortAnimatedLocationIconWidget({super.key, required this.mainColor});

  @override
  State<ShortAnimatedLocationIconWidget> createState() =>
      _ShortAnimatedLocationIconWidgetState();
}

class _ShortAnimatedLocationIconWidgetState
    extends State<ShortAnimatedLocationIconWidget>
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
              color: widget.mainColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.location_on, color: widget.mainColor, size: 40),
          ),
        );
      },
    );
  }
}












