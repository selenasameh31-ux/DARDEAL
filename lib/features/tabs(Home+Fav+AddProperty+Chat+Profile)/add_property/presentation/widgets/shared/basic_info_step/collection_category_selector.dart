
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
class CollectionCategorySelector extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onChanged;

  const CollectionCategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      {"title": "Luxury", "icon": Icons.star},
      {"title": "Budget", "icon": Icons.savings},
      {"title": "Standard", "icon": Icons.verified},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          final title = category["title"] as String;
          final icon = category["icon"] as IconData;
          final isSelected = selectedCategory == title;

          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () => onChanged(title),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFF2994A) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFF2994A)
                        : const Color(0xFFE0E0E0),
                    width: 1.2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: 18,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF4F4F4F),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: AppFonts.font,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF4F4F4F),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
