import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class RentalSummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final String period;

  const RentalSummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    // 👇 زودهم هنا
    final brightness = ThemeData.estimateBrightnessForColor(context.primaryColor);
    final textColor = brightness == Brightness.dark
        ? Colors.white
        : Colors.black87;
    final textColorFaded = textColor.withOpacity(0.7);
    final textColorMore = textColor.withOpacity(0.6);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.primaryColor,
            context.primaryColor.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: textColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.attach_money, size: 28, color: textColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: textColorFaded,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  amount,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 12, color: textColorMore),
                    const SizedBox(width: 4),
                    Text(
                      period,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: textColorMore,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
