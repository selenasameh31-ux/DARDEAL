import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class PropertyDetailsRoomScreen extends StatefulWidget {
  final PropertyDetailsModel property;
  const PropertyDetailsRoomScreen({super.key, required this.property});

  @override
  State<PropertyDetailsRoomScreen> createState() =>
      _PropertyDetailsRoomScreenState();
}

class _PropertyDetailsRoomScreenState extends State<PropertyDetailsRoomScreen> {
  // --- Controllers ---
  final PageController _imagePageController = PageController();
  final ScrollController _mainScrollController = ScrollController();

  // --- State Variables ---
  int _currentImageIndex = 0;
  bool _isFavorite = false;

  String _selectedTab = 'Overview';

  // --- Tabs and Sections Data ---
  // ØªÙ… Ø¥Ø¶Ø§ÙØ© 'Rules' Ø¨Ù†Ø§Ø¡ Ø¹Ù„Ù‰ Ø§Ù„Ù€ HTML
  final List<String> _tabs = [
    'Overview',
    'Pricing',
    'Amenities',
    'Rules',
    'Location',
    'Owner',
    'Reviews',
  ];
  // 7 Ø£Ù‚Ø³Ø§Ù… Ø¨Ø¯Ù„Ø§Ù‹ Ù…Ù† 6
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

  void _roomScrollToSection(int index) {
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
                                      rentalModel: 'Room',
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
                          _roomBuildBasicInfo(
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
                        child: _roomBuildTabs(isDark, mainColor, textColor),
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
                            child: _roomBuildOverviewSection(
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
                            child: _roomBuildPricingSection(
                              isDark,
                              textColor,
                              mainColor,
                              hintColor,
                              bodyTextColor,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            key: _sectionKeys[2],
                            child: _roomBuildAmenitiesSection(
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
                            child: _roomBuildRulesSection(
                              isDark,
                              textColor,
                              bodyTextColor,
                              mainColor,
                              hintColor,
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
                            child: _roomBuildReviewsSection(
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
  Widget _roomBuildBasicInfo(
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
                (widget.property.propertyType ?? "Room").toUpperCase(),
                style: TextStyle(
                  fontFamily: AppFonts.font,
                  color: mainColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: hintColor.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "in Shared Apartment",
                style: TextStyle(
                  fontFamily: AppFonts.font,
                  color: hintColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
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
          spacing: 6,
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
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Text(
                "/ month",
                style: TextStyle(
                  fontFamily: AppFonts.font,
                  color: hintColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
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
  // Widget _roomBuildTabs(bool isDark, Color mainColor, Color textColor) {
  //   return SizedBox(
  //     height: 45,
  //     child: ListView.builder(
  //       scrollDirection: Axis.horizontal,
  //       itemCount: _tabs.length,
  //       itemBuilder: (context, index) {
  //         bool isSelected = _selectedTab == _tabs[index];
  //         return GestureDetector(
  //           onTap: () => _roomScrollToSection(index),
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
  Widget _roomBuildTabs(bool isDark, Color mainColor, Color textColor) {
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
                onTap: () => _roomScrollToSection(index),
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
  Widget _roomBuildOverviewSection(
    bool isDark,
    Color textColor,
    Color bodyTextColor,
    Color mainColor,
    Color hintColor,
  ) {
    List<Map<String, dynamic>> info = [];
    if (widget.property.propertyType != null &&
        widget.property.propertyType!.isNotEmpty) {
      info.add({
        "icon": Icons.meeting_room,
        "title": "Room Type",
        "value": widget.property.propertyType,
      });
    } else {
      info.add({
        "icon": Icons.meeting_room,
        "title": "Room Type",
        "value": "Private Room",
      });
    }
    if (widget.property.bathrooms != null) {
      info.add({
        "icon": Icons.bathtub,
        "title": "Bathroom",
        "value": widget.property.bathrooms.toString(),
      });
    }
    if (widget.property.bedrooms != null) {
      info.add({
        "icon": Icons.bed,
        "title": "Bed Type",
        "value": widget.property.bedrooms.toString(),
      });
    }
    if (widget.property.areaSquareMeters != null &&
        widget.property.areaSquareMeters! > 0) {
      info.add({
        "icon": Icons.aspect_ratio,
        "title": "Room Size",
        "value": "${widget.property.areaSquareMeters!.toStringAsFixed(0)} m²",
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
        const SizedBox(height: 12),
        RoomExpandableTextWidget(
          text: widget.property.description ?? "No description available.",
          textColor: bodyTextColor,
          mainColor: mainColor,
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.2,
          ),
          itemCount: info.length,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(12),
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
                    child: Icon(
                      info[index]["icon"],
                      color: mainColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          info[index]["title"].toUpperCase(),
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
                          info[index]["value"],
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
          },
        ),
      ],
    );
  }

  // ===================== Pricing Section =====================
  Widget _roomBuildPricingSection(
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
              _roomBuildPricingRow(
                isDark,
                Icons.account_balance_wallet,
                "Monthly Rent",
                "EGP ${_formatPrice(widget.property.price)}",
                mainColor,
                textColor,
                hintColor,
              ),
              const SizedBox(height: 16),
              _roomBuildPricingRow(
                isDark,
                Icons.security,
                "Security Deposit",
                "EGP ${_formatPrice(widget.property.price)}",
                context.attentionColor,
                textColor,
                hintColor,
                subTag: "Refundable",
                tagColor: Colors.green,
              ),
              const SizedBox(height: 16),
              _roomBuildPricingRow(
                isDark,
                Icons.receipt,
                "Bills",
                "Divided equally",
                Colors.teal,
                textColor,
                hintColor,
                subText: "(approx. EGP 400/mo)",
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
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "EGP ${_formatPrice((widget.property.price ?? 0) * 2)}",
                    style: TextStyle(
                      fontFamily: AppFonts.font,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
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

  Widget _roomBuildPricingRow(
    bool isDark,
    IconData icon,
    String title,
    String value,
    Color iconColor,
    Color textColor,
    Color hintColor, {
    String? subTag,
    Color? tagColor,
    String? subText,
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
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
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
                  if (subText != null) ...[
                    const SizedBox(width: 4),
                    Text(
                      subText,
                      style: TextStyle(
                        fontFamily: AppFonts.font,
                        fontSize: 12,
                        color: hintColor,
                      ),
                    ),
                  ],
                ],
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
        if (subTag != null && tagColor != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: tagColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              subTag,
              style: TextStyle(
                fontFamily: AppFonts.font,
                fontSize: 10,
                color: tagColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  // ===================== Amenities Section =====================
  Widget _roomBuildAmenitiesSection(
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
          "Space & Amenities",
          style: TextStyle(
            fontFamily: AppFonts.font,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 16),
        RoomExpandableChipsWidget(
          items: _buildAmenityChips(),
          mainColor: mainColor,
          textColor: textColor,
          isDark: isDark,
        ),
      ],
    );
  }

  // ===================== Rules Section (NEW based on HTML) =====================
  Widget _roomBuildRulesSection(
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
        RoomExpandableChipsWidget(
          items: _buildRuleChips(),
          mainColor: mainColor,
          textColor: textColor,
          isDark: isDark,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[850] : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double halfWidth = (constraints.maxWidth - 12) / 2;
              return Wrap(
                spacing: 12,
                runSpacing: 10,
                children: [
                  SizedBox(
                    width: halfWidth,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.event_available, color: hintColor, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "AVAILABLE FROM",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
                                "Immediately",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: AppFonts.font,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: halfWidth,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.update, color: hintColor, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "MIN. LEASE",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
                                "6 Months",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: AppFonts.font,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
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
            },
          ),
        ),
      ],
    );
  }

  // ===================== Reviews Section =====================
  Widget _roomBuildReviewsSection(
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

class RoomExpandableTextWidget extends StatefulWidget {
  final String text;
  final Color textColor;
  final Color mainColor;

  const RoomExpandableTextWidget({
    super.key,
    required this.text,
    required this.textColor,
    required this.mainColor,
  });

  @override
  State<RoomExpandableTextWidget> createState() =>
      _RoomExpandableTextWidgetState();
}

class _RoomExpandableTextWidgetState extends State<RoomExpandableTextWidget> {
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

class RoomExpandableChipsWidget extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final Color mainColor;
  final Color textColor;
  final bool isDark;
  final Color? hintColor;

  const RoomExpandableChipsWidget({
    super.key,
    required this.items,
    required this.mainColor,
    required this.textColor,
    required this.isDark,
    this.hintColor,
  });

  @override
  State<RoomExpandableChipsWidget> createState() =>
      _RoomExpandableChipsWidgetState();
}

class _RoomExpandableChipsWidgetState extends State<RoomExpandableChipsWidget> {
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
                        : Colors.grey[200]!,
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
                          color: widget.hintColor ?? Colors.grey,
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

class RoomAnimatedLocationIconWidget extends StatefulWidget {
  final Color mainColor;
  const RoomAnimatedLocationIconWidget({super.key, required this.mainColor});

  @override
  State<RoomAnimatedLocationIconWidget> createState() =>
      _RoomAnimatedLocationIconWidgetState();
}

class _RoomAnimatedLocationIconWidgetState
    extends State<RoomAnimatedLocationIconWidget>
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

class RoomAnimatedAddReviewButton extends StatefulWidget {
  final Color mainColor;
  final Color bgColor;
  final VoidCallback onTap;
  const RoomAnimatedAddReviewButton({
    super.key,
    required this.mainColor,
    required this.bgColor,
    required this.onTap,
  });

  @override
  State<RoomAnimatedAddReviewButton> createState() =>
      _RoomAnimatedAddReviewButtonState();
}

class _RoomAnimatedAddReviewButtonState
    extends State<RoomAnimatedAddReviewButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) {
        setState(() => isPressed = false);
      },
      onTapCancel: () => setState(() => isPressed = false),
      onTap: widget.onTap,
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