import 'package:graduation_project_flutter/core/routing/routes_export.dart';

/// شاشة "See All" – عرض كل عقارات قسم معين من الـ Home (Recently Added / Featured / ...)
/// تستقبل عنوان القسم وتعرضه في الـ Header
class PropertyListingScreen extends StatefulWidget {
  final String sectionTitle;

  const PropertyListingScreen({
    super.key,
    required this.sectionTitle,
  });

  @override
  State<PropertyListingScreen> createState() => _PropertyListingScreenState();
}

class _PropertyListingScreenState extends State<PropertyListingScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  // بيانات مؤقتة – ستُستبدل بـ API calls لاحقاً
  int _mockItemCount = 6;
  final int _pageSize = 6;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _hasMoreData) {
      _loadMoreItems();
    }
  }

  Future<void> _loadMoreItems() async {
    setState(() {
      _isLoadingMore = true;
    });

    // Mock API delay
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoadingMore = false;
        // Mock appending data. In reality, you'd check if new items were returned.
        _mockItemCount += _pageSize;
        
        // Stop paginating after a certain limit for this mock example.
        if (_mockItemCount >= 30) {
           _hasMoreData = false;
        }
      });
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
    final isDark = context.isDark;
    final mainThemeColor = context.primaryColor;
    final titleColor = context.titleColor;
    final bgColor = context.scaffoldBgColor;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header ─────────────────────────────────────────────────
            _SectionListingHeader(
              title: widget.sectionTitle,
              isDark: isDark,
              mainThemeColor: mainThemeColor,
              titleColor: titleColor,
            ),

            // ─── Content ─────────────────────────────────────────────────
            Expanded(
              child: GridView.builder(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.72,
                ),
                itemCount: _mockItemCount + (_isLoadingMore ? 2 : 0),
                itemBuilder: (context, index) {
                  if (index >= _mockItemCount) {
                    return const _SectionLoadingCard();
                  }
                  // نفس الـ card المستخدمة في Home (مع badge حسب نوع القسم)
                  return _SectionPropertyCard(
                    isDark: isDark,
                    // يمكن تمرير badgeType حسب الـ sectionTitle لاحقاً
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
//  SECTION LISTING HEADER
// ──────────────────────────────────────────────────────────────
class _SectionListingHeader extends StatelessWidget {
  final String title;
  final bool isDark;
  final Color mainThemeColor;
  final Color titleColor;

  const _SectionListingHeader({
    required this.title,
    required this.isDark,
    required this.mainThemeColor,
    required this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () => Navigator.pop(context),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: SvgPicture.asset(
                AppIcons.ArrowIcon,
                width: 26,
                height: 26,
                colorFilter: ColorFilter.mode(titleColor, BlendMode.srcIn),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                  fontFamily: AppFonts.font,
                ),
              ),
            ),
          ),
          // مسافة موازية للـ back button لتوسيط العنوان بدقة
          const SizedBox(width: 38),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
//  SECTION PROPERTY CARD – نفس تصميم الـ Home card كاملاً مع badges
// ──────────────────────────────────────────────────────────────
class _SectionPropertyCard extends StatefulWidget {
  final bool isDark;

  const _SectionPropertyCard({required this.isDark});

  @override
  State<_SectionPropertyCard> createState() => _SectionPropertyCardState();
}

class _SectionPropertyCardState extends State<_SectionPropertyCard> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final cardBgColor =
        widget.isDark ? const Color(0xff2A2A2A) : Colors.white;
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

    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(color: Colors.grey.shade400),
                  // Favorite Button only, badges removed as requested
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => _isFavorite = !_isFavorite),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: widget.isDark
                              ? Colors.black.withOpacity(0.6)
                              : Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: _isFavorite ? attentionColor : hintColor,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(14), // increased padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Modern Family House',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 15, // increased from 14
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.font,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: hintColor, size: 12),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          'Sheikh Zayed, Giza',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: hintColor,
                            fontSize: 13, // increased from 12
                            fontFamily: AppFonts.font,
                          ),
                        ),
                      ),
                    ],
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '15k EGP',
                          style: TextStyle(
                            color: attentionColor,
                            fontSize: 15, // increased from 14
                            fontWeight: FontWeight.bold,
                            fontFamily: AppFonts.font,
                          ),
                        ),
                        TextSpan(
                          text: ' /mo',
                          style: TextStyle(
                            color: hintColor,
                            fontSize: 13, // increased from 12
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
    );
  }
}

class _SectionLoadingCard extends StatelessWidget {
  const _SectionLoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.textFieldBgColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: context.primaryColor,
          strokeWidth: 2,
        ),
      ),
    );
  }
}
