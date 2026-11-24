import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class RentalCard extends StatelessWidget {
  final String name;
  final String property;
  final String price;
  final String status;
  final String date;
  final bool isOverdue;
  final bool isHighlighted;
  final VoidCallback? onSendReminder;
  final VoidCallback? onChat;

  const RentalCard({
    super.key,
    required this.name,
    required this.property,
    required this.price,
    required this.status,
    required this.date,
    this.isOverdue = false,
    this.isHighlighted = false,
    this.onSendReminder,
    this.onChat,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isHighlighted
            ? context.primaryColor.withOpacity(0.05)
            : context.textFieldBgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isOverdue
              ? colors.error.withOpacity(0.3)
              : colors.outlineVariant,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isOverdue
                            ? colors.error.withOpacity(0.1)
                            : context.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isOverdue
                            ? Icons.warning_amber_rounded
                            : Icons.check_circle,
                        size: 18,
                        color: isOverdue ? colors.error : context.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: context.titleColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            property,
                            style: textTheme.bodySmall?.copyWith(
                              color: context.hintColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      price,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isOverdue ? colors.error : context.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                if (!isOverdue)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      date,
                      style: textTheme.bodySmall?.copyWith(
                        color: context.hintColor,
                      ),
                    ),
                  ),
                if (isOverdue) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "PROPERTY",
                              style: textTheme.labelSmall?.copyWith(
                                color: context.hintColor,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              property,
                              style: textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: context.titleColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "DUE DATE",
                              style: textTheme.labelSmall?.copyWith(
                                color: context.hintColor,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              date,
                              style: textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colors.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onSendReminder,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.primaryColor,
                            foregroundColor: Theme.of(context).brightness == Brightness.dark 
                                ? Colors.black 
                                : Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.send, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                "Send Reminder",
                                style: TextStyle(
                                  fontFamily: AppFonts.font,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: onChat,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: colors.outlineVariant),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.chat_bubble_outline,
                            size: 18,
                            color: context.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
