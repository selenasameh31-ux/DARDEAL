
/// A generic, theme-aware selection card used for toggle choices
/// (Long-Term / Short-Term, Private Room / Shared Room, etc.).
///
/// UI-only — receives data and callbacks, contains no business logic.
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
class SelectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectionCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary =
        context.primaryColor;

    final borderColor = isSelected
        ? primary
        : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1));
    final bgColor = isSelected
        ? primary.withOpacity(0.05)
        : (isDark ? const Color(0xFF1E2A2E) : Colors.white);
    final iconColor = isSelected
        ? primary
        : (isDark ? Colors.white54 : const Color(0xFF64748B));
    final titleColor = isSelected
        ? primary
        : (isDark ? Colors.white : const Color(0xFF0F172A));

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: iconColor),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFonts.font,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: titleColor,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.font,
                  fontSize: 12,
                  color: isDark ? Colors.white54 : const Color(0xFF64748B),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
