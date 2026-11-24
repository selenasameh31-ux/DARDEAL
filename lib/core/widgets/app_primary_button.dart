import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class AppPrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool loading;
  final bool isPrimary;
  final Color? textColor;
  final Color? buttonColor;
  final Color? borderColor;
  final double? borderRadius;
  final IconData? leadingIcon;
  final IconData? trailingIcon;

  const AppPrimaryButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.loading = false,
    this.isPrimary = true,
    this.textColor,
    this.buttonColor,
    this.borderColor,
    this.borderRadius,
    this.leadingIcon,
    this.trailingIcon,
  });

  @override
  State<AppPrimaryButton> createState() => _AppPrimaryButtonState();
}

class _AppPrimaryButtonState extends State<AppPrimaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primaryColor = context.primaryColor;
    final secondaryColor = context.buttonBgColor;

    final defaultTextColor = widget.isPrimary
        ? context.tagTextColor
        : context.buttonTextColor;

    final buttonColor =
        widget.buttonColor ??
        (widget.isPrimary ? primaryColor : secondaryColor);

    final textColor = widget.textColor ?? defaultTextColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
        onTap: widget.loading ? null : widget.onPressed,
        onHighlightChanged: (value) {
          setState(() {
            _pressed = value;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
            color: _pressed ? buttonColor.withOpacity(0.8) : buttonColor,
            border: widget.borderColor != null
                ? Border.all(color: widget.borderColor!)
                : null,
            boxShadow: widget.isPrimary && !isDark
                ? [
                    BoxShadow(
                      color: buttonColor.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: widget.loading
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(textColor),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.leadingIcon != null) ...[
                        Icon(widget.leadingIcon, color: textColor, size: 20),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        widget.text,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFonts.font,
                          color: textColor,
                        ),
                      ),
                      if (widget.trailingIcon != null) ...[
                        const SizedBox(width: 8),
                        Icon(widget.trailingIcon, color: textColor, size: 20),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
