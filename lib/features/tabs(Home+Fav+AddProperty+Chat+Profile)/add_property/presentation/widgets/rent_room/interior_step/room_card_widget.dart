
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
class RoomCardWidget extends StatelessWidget {
  final RoomModel model;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const RoomCardWidget({
    super.key,
    required this.model,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final turquoise = isDark
        ? DarkColors.darkmainColor
        : const Color(0xFF0C6B6B);

    final bgColor = isDark
        ? turquoise.withOpacity(0.05)
        : const Color(0xFFF2F9F9); // Match "Add" section fill color

    final iconBgColor = turquoise.withOpacity(0.12);
    final titleColor = context.primaryColor;
    final hintColor = LightColors.lightHintTextFieldColor;
    final priceColor = LightColors.lightmaincolor;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Leading          // Image or Icon placeholder
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
              image: model.imagePath != null
                  ? DecorationImage(
                      image: FileImage(File(model.imagePath!)),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: model.imagePath == null
                ? Icon(model.icon, color: turquoise, size: 24)
                : null,
          ),
          const SizedBox(width: 16),
          // Texts & Actions
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  model.title,
                  style: TextStyle(
                    fontFamily: AppFonts.font,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 4),
                // Subtitle
                Text(
                  '${model.sizeLabel} • ${model.capacityLabel}',
                  style: TextStyle(
                    fontFamily: AppFonts.font,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: hintColor,
                  ),
                ),
                const SizedBox(height: 4),
                // Price
                Text(
                  model.priceLabel,
                  style: TextStyle(
                    fontFamily: AppFonts.font,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: priceColor,
                  ),
                ),
                const SizedBox(height: 12),
                // Action Buttons
                Row(
                  children: [
                    GestureDetector(
                      onTap: onEdit,
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: turquoise,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: onDelete,
                      child: Text(
                        'Remove',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: priceColor, // Orange
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
