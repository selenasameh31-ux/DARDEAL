import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class ChatbotPropertyCard extends StatelessWidget {
  final ChatbotProperty property;

  const ChatbotPropertyCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark ? DarkColors.darkTextFieldColor : Colors.white;

    final formattedPrice = NumberFormat.currency(
      locale: 'en_US',
      symbol: 'EGP ',
      decimalDigits: 0,
    ).format(property.price);

    // Translate property type to Arabic
    String typeLabel = property.propertyType;
    switch (property.propertyType.toLowerCase()) {
      case 'apartment':
        typeLabel = 'شقة';
        break;
      case 'villa':
        typeLabel = 'فيلا';
        break;
      case 'studio':
        typeLabel = 'استوديو';
        break;
      case 'room':
        typeLabel = 'غرفة';
        break;
      case 'chalet':
        typeLabel = 'شاليه';
        break;
      case 'duplex':
        typeLabel = 'دوبلكس';
        break;
      case 'townhouse':
        typeLabel = 'تاون هاوس';
        break;
    }

    return GestureDetector(
      onTap: () => _navigateToDetails(context),
      child: Container(
        margin: const EdgeInsets.only(top: 12.0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Image section with overlay ──────────────────────────────
            SizedBox(
              height: 155,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Property image
                  property.imageUrl.isNotEmpty
                      ? Image.network(
                          property.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildPlaceholder(),
                        )
                      : _buildPlaceholder(),

                  // Dark gradient overlay at bottom for price readability
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.55),
                          ],
                          stops: const [0.4, 1.0],
                        ),
                      ),
                    ),
                  ),

                  // Property Type Badge — top right
                  if (property.propertyType.isNotEmpty)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          typeLabel.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                            fontFamily: AppFonts.font,
                          ),
                        ),
                      ),
                    ),

                  // Price — bottom left over image
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Text(
                      formattedPrice,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.font,
                        shadows: [
                          Shadow(
                            color: Colors.black45,
                            blurRadius: 6,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Info section ────────────────────────────────────────────
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    property.title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? DarkColors.darkTitleAndSubTitleText
                          : LightColors.lightTitleAndSubTitleText,
                      fontFamily: AppFonts.font,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Location
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 13, color: Colors.grey),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          property.location,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            fontFamily: AppFonts.font,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Bedrooms / Bathrooms / Area
                  Row(
                    children: [
                      if (property.bedrooms > 0) ...[
                        const Icon(Icons.bed_outlined,
                            size: 13, color: Colors.grey),
                        const SizedBox(width: 3),
                        Text(
                          '${property.bedrooms}',
                          style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                              fontFamily: AppFonts.font),
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (property.bathrooms > 0) ...[
                        const Icon(Icons.bathtub_outlined,
                            size: 13, color: Colors.grey),
                        const SizedBox(width: 3),
                        Text(
                          '${property.bathrooms}',
                          style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                              fontFamily: AppFonts.font),
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (property.area > 0) ...[
                        const Icon(Icons.straighten,
                            size: 13, color: Colors.grey),
                        const SizedBox(width: 3),
                        Text(
                          '${property.area.toInt()} م²',
                          style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                              fontFamily: AppFonts.font),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetails(BuildContext context) {
    final realId = property.realId;
    debugPrint('[CHATBOT_CARD] _navigateToDetails: property.id=${property.id}, property.realId=$realId');
    
    if (realId == null || realId <= 0) {
      AppSnackBar.error(context, 'تفاصيل العقار غير متاحة حالياً.');
      return;
    }

    Navigator.pushNamed(
      context,
      Routes.propertyDetailsRent,
      arguments: realId,
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 155,
      color: Colors.grey.withValues(alpha: 0.2),
      child: const Center(
        child: Icon(Icons.home_outlined, color: Colors.grey, size: 40),
      ),
    );
  }
}
