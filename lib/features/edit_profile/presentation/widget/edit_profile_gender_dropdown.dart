import 'package:graduation_project_flutter/core/routing/routes_export.dart';
class EditProfileGenderDropdown extends StatelessWidget {
  final String selectedGender;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String>? validator;

  const EditProfileGenderDropdown({
    super.key,
    required this.selectedGender,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Gender",
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w500,
            color: context.hintColor,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField2<String>(
          value: selectedGender,
          isExpanded: true,
          dropdownStyleData: DropdownStyleData(
            maxHeight: 120,
            offset: const Offset(0, -4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: context.textFieldBgColor,
            ),
          ),
          iconStyleData: IconStyleData(
            icon: Icon(Icons.keyboard_arrow_down, color: context.titleColor),
          ),
          style: theme.textTheme.bodyMedium?.copyWith(color: context.titleColor),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: context.hintColor.withValues(alpha: 0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: context.hintColor.withValues(alpha: 0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: context.primaryColor, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
          items: [
            DropdownMenuItem(
              value: "Male",
              child: Text(
                "Male",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: context.titleColor,
                ),
              ),
            ),
            DropdownMenuItem(
              value: "Female",
              child: Text(
                "Female",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: context.titleColor,
                ),
              ),
            ),
          ],
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
          validator: validator,
        ),
      ],
    );
  }
}
