import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class AppDropdownField extends StatelessWidget {
  final String? label;
  final String? value;
  final List<String> items;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;

  // Variant
  final AppInputVariant variant;
  final Widget? icon;

  const AppDropdownField({
    super.key,
    this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    this.variant = AppInputVariant.standard,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final dropdownBg = isDark ? const Color(0xFF1E2A2E) : Colors.white;

    final uniqueItems = items.toSet().toList();
    return Container(
      margin: AppInputStyles.getMargin(variant),
      decoration: AppInputStyles.getContainerDecoration(
        context,
        variant: variant,
      ),
      child: DropdownButtonFormField<String>(
        value: (value != null && uniqueItems.contains(value)) ? value : null,
        validator: validator,
        dropdownColor: dropdownBg,
        borderRadius: BorderRadius.circular(16),
        menuMaxHeight: 250,
        icon: icon,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: AppInputStyles.contentPadding,
        ),
        hint: label != null
            ? Text(label!, style: AppInputStyles.getHintStyle(context))
            : null,
        style: AppInputStyles.getTextStyle(context),
        items: uniqueItems
            .map(
              (item) => DropdownMenuItem(
                value: item,
                child: Text(item, style: AppInputStyles.getTextStyle(context)),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
