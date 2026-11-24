import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class PropertySnippet {
  final int id;
  final String title;
  final String address;
  final String price;
  final String imageUrl;

  const PropertySnippet({
    required this.id,
    required this.title,
    required this.address,
    required this.price,
    this.imageUrl = '',
  });
}


class SharedPropertyCard extends StatelessWidget {
  final PropertySnippet property;
  final bool isMe;

  const SharedPropertyCard({
    super.key,
    required this.property,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = context.primaryColor;
    final txtColor = isDark
        ? DarkColors.darkTitleAndSubTitleText
        : LightColors.lightTitleAndSubTitleText;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMe
            ? (isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.white.withOpacity(0.9))
            : (isDark ? Colors.white.withOpacity(0.05) : Colors.white),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isMe ? Colors.white24 : primary.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          // Property Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 60,
              height: 60,
              color: context.titleColor,
              child: property.imageUrl.startsWith('http')
                  ? Image.network(property.imageUrl, fit: BoxFit.cover)
                  : property.imageUrl.isNotEmpty
                  ? Image.asset(property.imageUrl, fit: BoxFit.cover)
                  : Icon(
                      Icons.home_work_outlined,
                      color: isMe ? Colors.white70 : primary.withOpacity(0.5),
                    ),
            ),
          ),
          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.title,
                  style: TextStyle(
                    fontFamily: AppFonts.font,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isMe ? (isDark ? Colors.white : primary) : txtColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  property.address,
                  style: TextStyle(
                    fontFamily: AppFonts.font,
                    fontSize: 11,
                    color: isMe
                        ? (isDark ? Colors.white70 : primary.withOpacity(0.7))
                        : txtColor.withOpacity(0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  property.price,
                  style: TextStyle(
                    fontFamily: AppFonts.font,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: LightColors.lightAttentionText,
                  ),
                ),
              ],
            ),
          ),

          // View Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                debugPrint('Navigating to property: ${property.id}');
                // Here we will add: context.push(Routes.propertyDetails, extra: property.id);
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: LightColors.lightAttentionText.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: LightColors.lightAttentionText.withOpacity(0.2),
                  ),
                ),
                child: const Text(
                  'View',
                  style: TextStyle(
                    fontFamily: AppFonts.font,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: LightColors.lightAttentionText,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
