import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class ChecklistItem extends StatelessWidget {
  final String title;
  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  const ChecklistItem({
    super.key,
    required this.title,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = context.primaryColor;
    final textColor = isDark ? DarkColors.darkTitleAndSubTitleText : LightColors.lightTitleAndSubTitleText;
    final bgColor = isDark ? DarkColors.darkTextFieldColor : LightColors.lightTextFieldColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: CheckboxListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: textColor,
            fontFamily: AppFonts.font,
            fontWeight: isChecked ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        value: isChecked,
        onChanged: onChanged,
        activeColor: activeColor,
        checkColor: Colors.white,
        controlAffinity: ListTileControlAffinity.leading,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
