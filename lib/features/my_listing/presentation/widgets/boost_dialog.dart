import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class BoostDialog extends StatefulWidget {
  const BoostDialog({super.key});

  @override
  State<BoostDialog> createState() => _BoostDialogState();
}

class _BoostDialogState extends State<BoostDialog> {
  int _selectedPackage = -1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final bgColor = _selectedPackage != -1
        ? context.primaryColor
        : context.textFieldBgColor;
    final brightness = ThemeData.estimateBrightnessForColor(bgColor);
    final textColor = brightness == Brightness.dark
        ? Colors.white
        : Colors.black87;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: context.textFieldBgColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Boost Listing",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.titleColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Get up to 10x more views by featuring your property at the top of search results.",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: context.hintColor,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // 24 Hours Spotlight
            _packageCard(
              context,
              index: 0,
              title: "24 Hours Spotlight",
              description: "Instant visibility boost for one full day.",
              price: "EGP 150",
              icon: Icons.flash_on,
              color: const Color(0xFF389FA4),
            ),
            const SizedBox(height: 10),

            // 7 Days Featured
            _packageCard(
              context,
              index: 1,
              title: "7 Days Featured",
              description: "Sustained top placement for maximum leads.",
              price: "EGP 600",
              icon: Icons.star,
              color: context.attentionColor,
            ),
            const SizedBox(height: 24),

            // Proceed to Checkout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedPackage != -1
                    ? () {
                        String packageName = _selectedPackage == 0
                            ? "24 Hours Spotlight"
                            : "7 Days Featured";
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Selected: $packageName - Proceeding to checkout',
                            ),
                            duration: const Duration(milliseconds: 800),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: bgColor,
                  foregroundColor: textColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  disabledBackgroundColor: context.textFieldBgColor,
                ),
                child: Text(
                  "Proceed to Checkout",
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _packageCard(
    BuildContext context, {
    required int index,
    required String title,
    required String description,
    required String price,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isSelected = _selectedPackage == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPackage = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.05)
              : context.textFieldBgColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : colors.outline.withOpacity(0.3),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Radio button
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? color : colors.outline,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            // Icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected ? color : context.titleColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: context.hintColor,
                    ),
                  ),
                ],
              ),
            ),
            // Price
            Text(
              price,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
