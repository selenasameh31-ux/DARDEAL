import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class OfferCard extends StatelessWidget {
  final String status;
  final Color statusColor;
  final String title;
  final String price;
  final String image;
  final String? buttonText;
  final bool showAction;
  final int currentStep;
  final bool isPastOffer;
  final VoidCallback? onTap;
  final VoidCallback? onViewDetails;

  const OfferCard({
    super.key,
    required this.status,
    required this.statusColor,
    required this.title,
    required this.price,
    required this.image,
    this.buttonText,
    this.showAction = false,
    this.currentStep = 1,
    this.isPastOffer = false,
    this.onTap,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;



    final Color activeStepColor = context.primaryColor;
    final Color inactiveCircleColor = colors.outlineVariant.withOpacity(0.5);
    final Color inactiveTextColor = context.hintColor.withOpacity(0.6);
    final Color activeTextColor = context.titleColor;

    final brightness = ThemeData.estimateBrightnessForColor(context.attentionColor);
    final btnTextColor = brightness == Brightness.dark
        ? Colors.white
        : Colors.black87;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.textFieldBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outlineVariant.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  image,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 72,
                    height: 72,
                    color: context.textFieldBgColor,
                    child: Icon(
                      Icons.apartment,
                      color: context.hintColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: context.titleColor,
                        fontSize: 18,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      price,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isPastOffer
                            ? context.hintColor
                            : context.primaryColor,
                        fontSize: 14,
                        decoration: isPastOffer
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
              if (isPastOffer)
                TextButton(
                  onPressed: onViewDetails,
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    'View Details',
                    style: TextStyle(
                      fontSize: 13,
                      color: context.attentionColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),

          if (showAction) ...[
            const SizedBox(height: 20),
            _buildStepper(
              activeStepColor,
              inactiveCircleColor,
              activeTextColor,
              inactiveTextColor,
            ),
          ],

          if (buttonText != null && !isPastOffer) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.attentionColor,
                  foregroundColor: btnTextColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  buttonText!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: btnTextColor,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStepper(
    Color activeCol,
    Color inactiveCol,
    Color activeText,
    Color inactiveText,
  ) {
    final checkBrightness = ThemeData.estimateBrightnessForColor(activeCol);
    final checkColor = checkBrightness == Brightness.dark
        ? Colors.white
        : Colors.black87;

    return Row(
      children: [
        _stepItem(
          currentStep >= 1,
          "Offer",
          activeCol,
          inactiveCol,
          activeText,
          inactiveText,
          checkColor,
        ),
        _stepDivider(currentStep >= 2, activeCol, inactiveCol),
        _stepItem(
          currentStep >= 2,
          "Review",
          activeCol,
          inactiveCol,
          activeText,
          inactiveText,
          checkColor,
        ),
        _stepDivider(currentStep >= 3, activeCol, inactiveCol),
        _stepItem(
          currentStep >= 3,
          "Payment",
          activeCol,
          inactiveCol,
          activeText,
          inactiveText,
          checkColor,
          number: "3",
        ),
        _stepDivider(currentStep >= 4, activeCol, inactiveCol),
        _stepItem(
          currentStep >= 4,
          "Move-in",
          activeCol,
          inactiveCol,
          activeText,
          inactiveText,
          checkColor,
          number: "4",
        ),
      ],
    );
  }

  Widget _stepItem(
    bool done,
    String label,
    Color activeCol,
    Color inactiveCol,
    Color activeText,
    Color inactiveText,
    Color checkColor, {
    String? number,
  }) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: done ? activeCol : inactiveCol,
            shape: BoxShape.circle,
          ),
          child: done
              ? Icon(Icons.check, size: 14, color: checkColor)
              : Text(
                  number ?? "1",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: inactiveText,
                  ),
                ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: done ? activeText : inactiveText,
            fontWeight: done ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _stepDivider(bool active, Color activeCol, Color inactiveCol) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 16, left: 4, right: 4),
        decoration: BoxDecoration(
          color: active ? activeCol : inactiveCol,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
