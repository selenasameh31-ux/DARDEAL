import 'package:graduation_project_flutter/core/routing/routes_export.dart';

enum ListingStatus { draft, review, live, active, pending, sold, rejected }

class ListingCard extends StatelessWidget {
  final String title;
  final String location;
  final String price;
  final String views;
  final String messages;
  final String saves;
  final String imageUrl;
  final ListingStatus status;
  final String? expDate;
  final String? listingId;
  final double? completionPercent;
  final String? reviewMessage;
  final VoidCallback? onEdit;
  final VoidCallback? onBoost;
  final VoidCallback? onInsights;
  final VoidCallback? onPreview;
  final VoidCallback? onChat;
  final VoidCallback? onFixIssues;
  final VoidCallback? onAppeal;
  final VoidCallback? onResume;
  final VoidCallback? onDelete;

  const ListingCard({
    super.key,
    required this.title,
    required this.location,
    required this.price,
    required this.views,
    required this.messages,
    required this.saves,
    required this.imageUrl,
    required this.status,
    this.expDate,
    this.listingId,
    this.completionPercent,
    this.reviewMessage,
    this.onEdit,
    this.onBoost,
    this.onInsights,
    this.onPreview,
    this.onChat,
    this.onFixIssues,
    this.onAppeal,
    this.onResume,
    this.onDelete,
  });

  int get _currentStep {
    switch (status) {
      case ListingStatus.draft:
        return 1;
      case ListingStatus.review:
        return 2;
      case ListingStatus.live:
        return 3;
      case ListingStatus.rejected:
        return 2;
      default:
        return 0;
    }
  }

  bool get _isRejected => status == ListingStatus.rejected;

  // ✅ دالة تأكيد الحذف المعدلة (إزالة زر "Yes, Delete" وإضافة أيقونة X حمراء)
  void _confirmDelete(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: theme.dialogBackgroundColor,
        title: Text(
          "Delete Listing?",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        content: Text(
          "This action cannot be undone. Are you sure you want to permanently delete this listing?",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        actions: [
          // زر "Keep" (إلغاء)
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Keep",
              style: TextStyle(color: theme.colorScheme.primary),
            ),
          ),
          // ✅ أيقونة X حمراء (تأكيد الحذف)
          IconButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete?.call();
            },
            icon: Icon(Icons.close, color: Colors.red, size: 32),
            tooltip: "Delete",
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final bool showImage = status != ListingStatus.draft;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          if (showImage)
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 180,
                  color: context.textFieldBgColor,
                  child: Icon(
                    Icons.image_not_supported,
                    color: context.primaryColor,
                    size: 50,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: context.titleColor,
                    fontSize: 16,
                    fontFamily: AppFonts.font,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (status != ListingStatus.draft)
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: context.primaryColor,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: TextStyle(
                            color: context.hintColor,
                            fontSize: 13,
                            fontFamily: AppFonts.font,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                if (status != ListingStatus.draft) const SizedBox(height: 8),
                if (status != ListingStatus.draft)
                  Text(
                    price,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: context.primaryColor,
                      fontSize: 18,
                      fontFamily: AppFonts.font,
                    ),
                  ),
                const SizedBox(height: 12),
                if (status == ListingStatus.live &&
                    (views != "0" || messages != "0" || saves != "0"))
                  Row(
                    children: [
                      _statItem(context, Icons.visibility, views),
                      const SizedBox(width: 16),
                      _statItem(context, Icons.message, messages),
                      const SizedBox(width: 16),
                      _statItem(context, Icons.favorite_border, saves),
                    ],
                  ),
                const SizedBox(height: 16),
                // Steps line
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _step(context, _currentStep >= 1, "Draft"),
                    _line(context, _currentStep >= 2),
                    _step(context, _currentStep >= 2, "Review"),
                    _line(
                      context,
                      _isRejected ? true : _currentStep >= 3,
                      isRejectedLine: _isRejected,
                    ),
                    // بعد
                    _step(
                      context,
                      _isRejected ? false : _currentStep >= 3,
                      _isRejected ? "Rejected" : "Live",
                      isRejected: _isRejected,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (expDate != null && listingId != null)
                  Text(
                    "EXP: $expDate · ID: $listingId",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.outline,
                    ),
                  ),
                if (reviewMessage != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 18),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Action Required",
                                style: theme.textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                reviewMessage!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (completionPercent != null) ...[
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: completionPercent! / 100,
                    backgroundColor: context.textFieldBgColor,
                    color: context.primaryColor,
                    minHeight: 4,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${completionPercent!.toInt()}% · Step 3 of 6",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.outline,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Completed up to Pricing Step.",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: context.hintColor,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                // Buttons based on status
                if (status == ListingStatus.draft && completionPercent != null)
                  Row(
                    children: [
                      Expanded(
                        child: _actionButton(
                          context,
                          "Resume Listing",
                          Icons.play_arrow,
                          onResume,
                          context.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        // بعد
                        child: _actionButton(
                          context,
                          "Delete",
                          Icons.delete_outline,
                          onDelete,
                          Colors.red,
                        ),
                      ),
                    ],
                  )
                else if (status == ListingStatus.review)
                  Row(
                    children: [
                      Expanded(
                        child: _actionButton(
                          context,
                          "Preview",
                          Icons.remove_red_eye,
                          onPreview,
                          context.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _actionButton(
                          context,
                          "Edit",
                          Icons.edit,
                          onEdit,
                          context.textFieldBgColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _actionButton(
                          context,
                          "Chat",
                          Icons.chat_bubble_outline,
                          onChat,
                          context.textFieldBgColor,
                        ),
                      ),
                    ],
                  )
                else if (status == ListingStatus.rejected)
                  Row(
                    children: [
                      Expanded(
                        child: _actionButton(
                          context,
                          "Fix Issues",
                          Icons.build,
                          onFixIssues,
                          context.attentionColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _actionButton(
                          context,
                          "Appeal",
                          Icons.gavel,
                          onAppeal,
                          context.textFieldBgColor,
                        ),
                      ),
                    ],
                  )
                else if (status == ListingStatus.live)
                  Row(
                    children: [
                      Expanded(
                        child: _actionButton(
                          context,
                          "Boost",
                          Icons.trending_up,
                          onBoost,
                          context.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _actionButton(
                          context,
                          "Insights",
                          Icons.insights,
                          onInsights,
                          context.textFieldBgColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _actionButton(
                          context,
                          "Edit",
                          Icons.edit,
                          onEdit,
                          context.textFieldBgColor,
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: _actionButton(
                          context,
                          "Boost",
                          Icons.trending_up,
                          onBoost,
                          context.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _actionButton(
                          context,
                          "Insights",
                          Icons.insights,
                          onInsights,
                          context.textFieldBgColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _actionButton(
                          context,
                          "Edit",
                          Icons.edit,
                          onEdit,
                          context.textFieldBgColor,
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

  Widget _statItem(BuildContext context, IconData icon, String value) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _step(
    BuildContext context,
    bool done,
    String label, {
    bool isRejected = false,
  }) {
    final colors = Theme.of(context).colorScheme;
    Color bgColor;
    if (isRejected) {
      bgColor = colors.errorContainer;
    } else if (done) {
      bgColor = context.primaryColor;
    } else {
      bgColor = context.textFieldBgColor;
    }

    Widget? child;
    if (done && !isRejected) {
      final brightness = ThemeData.estimateBrightnessForColor(bgColor);
      final iconColor = brightness == Brightness.dark
          ? Colors.white
          : Colors.black87;
      child = Icon(Icons.check, size: 14, color: iconColor);
    } else if (isRejected) {
      child = Icon(Icons.close, size: 14, color: Colors.red);
    }

    // ✅ تحديد لون النص بناءً على سطوع خلفية الحاوية الأصلية (context.textFieldBgColor)
    final cardBg = Theme.of(context).cardColor;
    final isCardDark =
        ThemeData.estimateBrightnessForColor(cardBg) == Brightness.dark;
    final textColor = isRejected
        ? Colors.red
        : (done
              ? (isCardDark ? Colors.white : Colors.black87)
              : context.hintColor);

    return Column(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            border: isRejected && !done
                ? Border.all(color: Colors.red, width: 1.5)
                : null,
          ),
          child: child,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: textColor,
            fontWeight: isRejected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _line(
    BuildContext context,
    bool active, {
    bool isRejectedLine = false,
  }) {
    final colors = Theme.of(context).colorScheme;
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        color: isRejectedLine
            ? Colors.red
            : (active ? context.primaryColor : context.textFieldBgColor),
      ),
    );
  }

  Widget _actionButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback? onTap,
    Color bgColor,
  ) {
    // بيحسب تلقائي لو الخلفية فاتحة ولا غامقة
    final brightness = ThemeData.estimateBrightnessForColor(bgColor);
    final textColor = brightness == Brightness.dark
        ? Colors.white
        : Colors.black87;

    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: textColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
