import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class AppCounterWidget extends StatelessWidget {
  final String label;
  final int value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final int minValue;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? width;
  final double? height;

  const AppCounterWidget({
    super.key,
    required this.label,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
    this.minValue = 0,
    this.backgroundColor,
    this.borderColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textColor = isDark
        ? DarkColors.darkBodyColors
        : LightColors.lightBodyColors;

    final defaultBgColor = isDark
        ? DarkColors.darkTextFieldColor
        : LightColors.lightTextFieldColor;

    final finalBgColor = backgroundColor ?? defaultBgColor;
    final finalBorderColor = borderColor ?? const Color(0xffD9D9D9);

    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: finalBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: finalBorderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildButton(
            icon: Icons.remove,
            onTap: value > minValue ? onDecrement : null,
            iconColor: textColor,
          ),
          Text(
            value.toString(),
            style: TextStyle(
              fontFamily: AppFonts.font,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          _buildButton(
            icon: Icons.add,
            onTap: onIncrement,
            iconColor: textColor,
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required VoidCallback? onTap,
    required Color iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent, // Ensures the entire area is clickable
        child: Icon(
          icon,
          size: 20,
          color: onTap == null ? const Color(0xffD9D9D9) : iconColor,
        ),
      ),
    );
  }
}
