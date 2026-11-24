
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
class PropertyTypeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final bool isDashed;
  final VoidCallback onTap;

  const PropertyTypeCard({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.isDashed = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color teal = isDark
        ? DarkColors.darkmainColor
        : const Color(0xFF0C6B6B);
    final Color lightGreyBorder = isDark
        ? const Color(0xFF4A4A4A)
        : const Color(0xFFE8E8E8);
    final Color unselectedIconText = isDark
        ? Colors.white54
        : const Color(0xFF7B8794);

    // Background colors
    final Color unselectedBg = isDark
        ? DarkColors.darkTextFieldColor
        : Colors.white;
    final Color selectedBg = isDark
        ? teal.withOpacity(0.15)
        : const Color(0xFFF2F8F8); // Very light teal

    final Widget content = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: isSelected ? teal : (isDashed ? teal : unselectedIconText),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                title.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.font,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: isSelected
                      ? teal
                      : (isDashed ? teal : unselectedIconText),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (isDashed) {
      return AppDashedContainer(
        color: teal.withOpacity(0.5),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF2F8F8), // Match design
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            child: content,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: isSelected ? 0.96 : 1,
        duration: const Duration(milliseconds: 150),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected ? selectedBg : unselectedBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? teal : lightGreyBorder,
              width: 1.2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            child: content,
          ),
        ),
      ),
    );
  }
}
