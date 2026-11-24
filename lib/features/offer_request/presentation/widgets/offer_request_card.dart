import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class OfferRequestCard extends StatelessWidget {
  final String name;
  final String time;
  final String title;
  final String price;
  final String location;
  final bool isNew;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const OfferRequestCard({
    super.key,
    required this.name,
    required this.time,
    required this.title,
    required this.price,
    required this.location,
    this.isNew = false,
    this.onAccept,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    // حساب لون نص زر Accept تلقائياً بناءً على سطوع خلفيته
    final primaryBrightness = ThemeData.estimateBrightnessForColor(
      context.primaryColor,
    );
    final primaryTextColor = primaryBrightness == Brightness.dark
        ? Colors.white
        : Colors.black87;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.textFieldBgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: context.primaryColor.withOpacity(0.1),
                child: Icon(Icons.person, size: 28, color: context.primaryColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.titleColor,
                          ),
                        ),
                        if (isNew) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: context.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'NEW',
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: context.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color: context.hintColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          time,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: context.hintColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: context.titleColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            price,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.secondary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 14,
                color: context.hintColor,
              ),
              const SizedBox(width: 4),
              Text(
                location,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: context.hintColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // الأزرار
          Row(
            children: [
              // زر Accept (يتبع الثيم)
              Expanded(
                child: ElevatedButton(
                  onPressed: onAccept,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.primaryColor,
                    foregroundColor: primaryTextColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check, size: 18, color: primaryTextColor),
                      const SizedBox(width: 6),
                      Text('Accept', style: TextStyle(color: primaryTextColor)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // زر Reject (برتقالي ثابت)
              Expanded(
                child: ElevatedButton(
                  onPressed: onReject,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.attentionColor, // ✅ برتقالي ثابت
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.close, size: 18, color: Colors.white),
                      SizedBox(width: 6),
                      Text('Reject', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
