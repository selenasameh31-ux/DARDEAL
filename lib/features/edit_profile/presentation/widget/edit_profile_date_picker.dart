import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class EditProfileDatePicker extends StatelessWidget {
  final String label;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  const EditProfileDatePicker({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onDateChanged,
  });

  Future<void> _selectDate(BuildContext context) async {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: colors,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: context.primaryColor),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) onDateChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w500,
            color: context.hintColor,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: () => _selectDate(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: context.textFieldBgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.hintColor.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${selectedDate.day.toString().padLeft(2, '0')} / ${selectedDate.month.toString().padLeft(2, '0')} / ${selectedDate.year}",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: context.titleColor,
                  ),
                ),
                Icon(Icons.calendar_today, size: 18, color: context.primaryColor),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
