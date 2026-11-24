import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class AuthButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool loading;

  const AuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.loading = false,
  });

  @override
  State<AuthButton> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    /// لون الزرار حسب الثيم
    final normalBgColor = context.buttonBgColor;
    final pressedBgColor = context.buttonPressedBgColor;
    final borderColor = context.buttonBorderColor;
    final pressedBorderColor = context.buttonPressedBgColor;
    final textColor = context.buttonTextColor;
    final pressedTextColor = context.buttonPressedTextColor;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        if (!widget.loading) widget.onPressed();
      },
      onTapCancel: () => setState(() => _pressed = false),

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),

        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),

          color: _pressed ? pressedBgColor : normalBgColor,

          border: Border.all(
            color: _pressed ? pressedBorderColor : borderColor,
            width: 2,
          ),
        ),

        child: Center(
          child: widget.loading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(pressedTextColor),
                  ),
                )
              : Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: AppFonts.font,
                    fontWeight: FontWeight.bold,
                    color: _pressed ? pressedTextColor : textColor,
                    letterSpacing: 0.5,
                  ),
                ),
        ),
      ),
    );
  }
}
