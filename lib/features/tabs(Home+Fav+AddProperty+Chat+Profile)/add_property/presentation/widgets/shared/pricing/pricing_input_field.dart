
/// A labeled price input field with EGP currency badge.
///
/// Renders: Label → Row(EGP badge + TextFormField)
/// Optionally shows a subtitle below the input (e.g. "Refundable amount...").
///
/// UI-only — receives data and callbacks.
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
class PricingInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final String? initialValue;
  final bool isRequired;
  final String? subtitleText;
  final String? Function(String?)? validator;
  final ValueChanged<String> onChanged;

  const PricingInputField({
    super.key,
    required this.label,
    required this.hintText,
    this.initialValue,
    this.isRequired = true,
    this.subtitleText,
    this.validator,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary =
        context.primaryColor;
    final txtColor = context.titleColor;
    final labelColor = isDark ? Colors.white70 : const Color(0xFF0F172A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              fontFamily: AppFonts.font,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: labelColor,
            ),
            children: isRequired
                ? const [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]
                : !isRequired
                    ? [
                        TextSpan(
                          text: ' (optional)',
                          style: TextStyle(
                            fontFamily: AppFonts.font,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                            color: isDark
                                ? Colors.white38
                                : const Color(0xFF94A3B8),
                          ),
                        ),
                      ]
                    : [],
          ),
        ),
        const SizedBox(height: 12),

        // EGP badge + Input
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 52,
              width: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E2A2E)
                    : const Color(0xFFF2F8F8), // Faint Teal
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFD6E4E4), // Subtle Teal
                ),
              ),
              child: Text(
                'EGP',
                style: TextStyle(
                  fontFamily: AppFonts.font,
                  fontWeight: FontWeight.w700,
                  fontSize: 15, // Same as text field text
                  color: isDark ? Colors.white : primary, // Bold Teal
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                initialValue: initialValue,
                keyboardType: TextInputType.number,
                cursorColor: primary,
                style: TextStyle(
                  color: txtColor,
                  fontFamily: AppFonts.font,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                    fontFamily: AppFonts.font,
                    color: isDark
                        ? Colors.white38
                        : const Color(0xFF94A3B8),
                    fontSize: 16,
                  ),
                  filled: true,
                  fillColor: isDark
                      ? const Color(0xFF1A2428)
                      : const Color(0xFFF8FAFB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: context.buttonBorderColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: context.buttonBorderColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: primary, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 15,
                  ),
                ),
                onChanged: onChanged,
                validator: validator,
              ),
            ),
          ],
        ),

        // Optional subtitle
        if (subtitleText != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              subtitleText!,
              style: TextStyle(
                fontFamily: AppFonts.font,
                fontSize: 11,
                fontStyle: FontStyle.italic,
                color: isDark ? context.hintColor : context.hintColor,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
