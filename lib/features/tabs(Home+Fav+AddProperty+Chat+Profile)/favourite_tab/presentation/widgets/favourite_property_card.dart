import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class FavouritePropertyCard extends StatefulWidget {
  final WishlistItemModel property;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  const FavouritePropertyCard({
    super.key,
    required this.property,
    required this.onRemove,
    required this.onTap,
  });

  @override
  State<FavouritePropertyCard> createState() => _FavouritePropertyCardState();
}

class _FavouritePropertyCardState extends State<FavouritePropertyCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBgColor = isDark ? const Color(0xff2A2A2A) : Colors.white;
    final mainColor = isDark ? DarkColors.darkmainColor : LightColors.lightmaincolor;
    final titleColor = isDark ? DarkColors.darkTitleAndSubTitleText : LightColors.lightTitleAndSubTitleText;
    final subTitleColor = isDark ? DarkColors.darkHintTextFieldColor : LightColors.lightHintTextFieldColor;
    final attentionColor = isDark ? DarkColors.darkAttentionText : LightColors.lightAttentionText;
    final typeBgColor = isDark ? DarkColors.darkTextFieldColor : LightColors.lightTextFieldColor;
    final tagTextColor = isDark ? DarkColors.darkBackGround : Colors.white;

    final badgeText = widget.property.transactionTypeLabel.toUpperCase();
    final isSale = widget.property.transactionTypeLabel == 'For Sale';

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isDark
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
          ),
          child: Row(
            children: [
              _buildImageSection(attentionColor, mainColor, tagTextColor, badgeText),
              const SizedBox(width: 15),
              _buildDetailsSection(titleColor, subTitleColor, typeBgColor, mainColor, attentionColor, isSale),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(Color attentionColor, Color mainColor, Color tagTextColor, String badgeText) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: SizedBox(
        width: 105,
        height: 105,
        child: Stack(
          children: [
            Positioned.fill(
              child: widget.property.imageUrl != null && widget.property.imageUrl!.isNotEmpty
                  ? Image.network(
                      widget.property.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[350],
                        child: const Icon(Icons.home_outlined, color: Colors.grey, size: 32),
                      ),
                      loadingBuilder: (_, child, progress) =>
                          progress == null ? child : Container(color: Colors.grey[350]),
                    )
                  : Container(
                      color: Colors.grey[350],
                      child: const Icon(Icons.home_outlined, color: Colors.grey, size: 32),
                    ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: widget.onRemove,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.favorite, color: attentionColor, size: 18),
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: mainColor.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    color: tagTextColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.font,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsSection(
    Color title,
    Color sub,
    Color typeBg,
    Color mainColor,
    Color attention,
    bool isSale,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.star_rounded,
                color: widget.property.displayRating > 0 ? Colors.amber : sub,
                size: 18,
              ),
              const SizedBox(width: 2),
              Expanded(
                child: Text(
                  widget.property.displayRatingLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: widget.property.displayRating > 0 ? FontWeight.bold : FontWeight.normal,
                    fontSize: widget.property.displayRating > 0 ? 13 : 11,
                    fontFamily: AppFonts.font,
                    color: widget.property.displayRating > 0 ? title : sub,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: typeBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  widget.property.displayType,
                  style: TextStyle(
                    color: mainColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.font,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            widget.property.displayTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: title,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.font,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.location_on, color: sub, size: 14),
              const SizedBox(width: 3),
              Expanded(
                child: Text(
                  widget.property.displayLocation,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: sub, fontSize: 13, fontFamily: AppFonts.font),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomRight,
            child: isSale
                ? Text(
                    widget.property.displayPrice,
                    style: TextStyle(
                      color: attention,
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.font,
                    ),
                  )
                : RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.property.displayPriceOnly,
                          style: TextStyle(
                            color: attention,
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppFonts.font,
                          ),
                        ),
                        TextSpan(
                          text: widget.property.isMonthlyRent ? ' /mo' : ' /night',
                          style: TextStyle(
                            color: sub,
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            fontFamily: AppFonts.font,
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

// ── Alias for backward-compat ─────────────────────────────────────────────────
typedef FavouritePropertyCardRent = FavouritePropertyCard;
