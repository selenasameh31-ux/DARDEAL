import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class AppCustomDropdown extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;

  const AppCustomDropdown({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Deduplicate items to prevent DropdownButton assertion errors when the API returns duplicates
    final uniqueItems = items.toSet().toList();

    // Ensure value is valid
    final safeValue = (value != null && uniqueItems.contains(value)) ? value : null;

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        filled: true,
        fillColor: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF7FDF9),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF4A4A4A) : const Color(0xFFDFE6E9),
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF4A4A4A) : const Color(0xFFDFE6E9),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: isDark ? Colors.white54 : const Color(0xFF0C6B6B),
            width: 1.5,
          ),
        ),
        errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 12),
      ),
      isExpanded: true,
      menuMaxHeight: 250,
      borderRadius: BorderRadius.circular(16),
      value: safeValue,
      icon: Icon(
        Icons.unfold_more,
        color: isDark ? Colors.white54 : const Color(0xFF0C6B6B),
      ),
      hint: Text(
        hint,
        style: TextStyle(
          color: isDark ? Colors.white38 : const Color(0xFF718096),
          fontSize: 14,
          fontFamily: AppFonts.font,
        ),
      ),
      dropdownColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
      validator: validator,
      items: uniqueItems.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF2D3748),
              fontSize: 15,
              fontFamily: AppFonts.font,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
