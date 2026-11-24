import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class EditProfileTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final int maxLines;
  final bool isOptional;
  final bool readOnly;
  final IconData? prefixIcon;
  final FormFieldValidator<String>? validator;
  final bool isRtl;

  const EditProfileTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.isOptional = false,
    this.readOnly = false,
    this.prefixIcon,
    this.validator,
    this.isRtl = false,
  });

  @override
  State<EditProfileTextField> createState() => _EditProfileTextFieldState();
}

class _EditProfileTextFieldState extends State<EditProfileTextField> {
  TextDirection _textDirection = TextDirection.ltr;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_detectDirection);
  }

  void _detectDirection() {
    final text = widget.controller.text;
    if (text.isEmpty) return;
    final firstChar = text.trimLeft();
    if (firstChar.isEmpty) return;
    final isRtl = RegExp(r'[\u0600-\u06FF]').hasMatch(firstChar[0]);
    setState(() {
      _textDirection = isRtl ? TextDirection.rtl : TextDirection.ltr;
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_detectDirection);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.label,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: context.hintColor,
                fontSize: 13,
              ),
            ),
            if (widget.isOptional) ...[
              const SizedBox(width: 8),
              Text(
                "(Optional)",
                style: theme.textTheme.labelSmall?.copyWith(
                  color: context.hintColor.withValues(alpha: 0.7),
                  fontSize: 11,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          readOnly: widget.readOnly,
          maxLines: widget.maxLines,
          validator: widget.validator,
          textDirection: _textDirection,
          textAlign: _textDirection == TextDirection.rtl
              ? TextAlign.right
              : TextAlign.left,
          textAlignVertical: TextAlignVertical.center,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, size: 20, color: context.primaryColor)
                : null,
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: context.hintColor.withValues(alpha: 0.5),
              fontFamily: AppFonts.font,
            ),
          ),
          style: theme.textTheme.bodyMedium?.copyWith(color: context.titleColor),
        ),
      ],
    );
  }
}
