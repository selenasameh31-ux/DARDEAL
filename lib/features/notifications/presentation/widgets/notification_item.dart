import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class NotificationItem extends StatelessWidget {
  final NotificationEntity notification;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const NotificationItem({
    super.key,
    required this.notification,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final txtColor = isDark
        ? DarkColors.darkTitleAndSubTitleText
        : LightColors.lightTitleAndSubTitleText;

    final subTxtColor = isDark
        ? DarkColors.darkHintTextFieldColor
        : LightColors.lightHintTextFieldColor;

    Color bgColor = isDark
        ? DarkColors.darkBackGround
        : LightColors.lightBackGround;

    if (isSelected) {
      bgColor = isDark
          ? DarkColors.darkTextFieldColor
          : LightColors.lightmaincolor.withOpacity(0.1);
    }

    final borderColor = isSelected
        ? LightColors.lightmaincolor
        : (isDark ? DarkColors.darkTextFieldColor : LightColors.lightTextFieldColor);

    Color iconBgColor;
    Color iconColor;
    IconData iconData;

    switch (notification.type) {
      case 'offer':
        iconBgColor = const Color(0xFF10B981).withOpacity(0.1);
        iconColor = const Color(0xFF10B981);
        iconData = Icons.check_circle_outline;
        break;
      case 'payment':
        iconBgColor = const Color(0xFF14B8A6).withOpacity(0.1);
        iconColor = const Color(0xFF14B8A6);
        iconData = Icons.shield_outlined;
        break;
      case 'rental':
        iconBgColor = const Color(0xFF8B5CF6).withOpacity(0.1);
        iconColor = const Color(0xFF8B5CF6);
        iconData = Icons.key_outlined;
        break;
      case 'system':
        iconBgColor = const Color(0xFF3B82F6).withOpacity(0.1);
        iconColor = const Color(0xFF3B82F6);
        iconData = Icons.home_outlined;
        break;
      case 'action_required':
        iconBgColor = const Color(0xFFF59E0B).withOpacity(0.1);
        iconColor = const Color(0xFFF59E0B);
        iconData = Icons.account_balance_wallet_outlined;
        break;
      case 'declined':
        iconBgColor = const Color(0xFFEF4444).withOpacity(0.1);
        iconColor = const Color(0xFFEF4444);
        iconData = Icons.cancel_outlined;
        break;
      default:
        iconBgColor = Colors.grey.withOpacity(0.1);
        iconColor = Colors.grey;
        iconData = Icons.notifications_outlined;
    }

    final timeStr =
        "${notification.createdAt.hour}:${notification.createdAt.minute.toString().padLeft(2, '0')} ${notification.createdAt.hour >= 12 ? 'PM' : 'AM'}";

    final unreadDot = Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: LightColors.lightmaincolor,
        shape: BoxShape.circle,
      ),
    );

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: isSelected ? 1.5 : 1),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: iconColor, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Time row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontFamily: AppFonts.font,
                            fontSize: 14,
                            fontWeight: notification.isRead
                                ? FontWeight.w600
                                : FontWeight.bold,
                            color: txtColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        timeStr,
                        style: TextStyle(
                          fontFamily: AppFonts.font,
                          fontSize: 12,
                          color: subTxtColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Message row with unread dot — End of row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          notification.message,
                          style: TextStyle(
                            fontFamily: AppFonts.font,
                            fontSize: 13,
                            color: subTxtColor,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!notification.isRead) ...[
                        const SizedBox(width: 8),
                        unreadDot,
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
