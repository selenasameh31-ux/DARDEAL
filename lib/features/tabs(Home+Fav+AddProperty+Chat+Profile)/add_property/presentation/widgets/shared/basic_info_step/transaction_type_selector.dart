
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
class TransactionTypeSelector extends StatelessWidget {
  final String selectedValue;
  final Function(String) onChanged;

  final List<String> options;

  const TransactionTypeSelector({
    super.key,
    required this.selectedValue,
    required this.onChanged,
    this.options = const ["Rent", "Sale"],
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final containerColor = isDark
        ? DarkColors.darkTextFieldColor
        : const Color(0xFFF5F6F8);

    final selectedBgColor = isDark ? DarkColors.darkmainColor : Colors.white;
    final selectedTextColor = isDark ? Colors.white : LightColors.lightmaincolor;
    final unselectedTextColor = isDark
        ? Colors.white54
        : const Color(0xFF6B7280);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: options.map((option) {
          final bool isSelected = option == selectedValue;

          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(option),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected ? selectedBgColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isSelected && !isDark
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    option,
                    style: TextStyle(
                      fontFamily: AppFonts.font,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: isSelected
                          ? selectedTextColor
                          : unselectedTextColor,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
