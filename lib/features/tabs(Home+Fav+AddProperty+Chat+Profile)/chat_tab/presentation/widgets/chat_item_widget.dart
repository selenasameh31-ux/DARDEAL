import 'package:graduation_project_flutter/core/routing/routes_export.dart';

import '../../domain/entities/chat_entity.dart';

class ChatItemWidget extends StatelessWidget {
  final ChatEntity chat;
  final VoidCallback onTap;

  const ChatItemWidget({
    super.key,
    required this.chat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary =
        context.primaryColor;
    final txtColor = isDark ? DarkColors.darkTitleAndSubTitleText : LightColors.lightTitleAndSubTitleText;
    final subtitleColor = isDark ? DarkColors.darkHintTextFieldColor : LightColors.lightHintTextFieldColor;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar with Online Status
            ChatAvatar(
              name: chat.otherParticipant?.name ?? 'User',
              radius: 26,
              showOnlineIndicator: chat.isActive,
            ),
            const SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          chat.otherParticipant?.name ?? 'User',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: AppFonts.font,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: txtColor,
                          ),
                        ),
                      ),
                      if (chat.propertyTitle.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: LightColors.lightAttentionText.withOpacity(0.1), // Light orange background
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              chat.propertyTitle,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: AppFonts.font,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: LightColors.lightAttentionText, // Orange text
                              ),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(width: 4),
                      Text(
                        chat.lastMessageAt != null
                            ? '${chat.lastMessageAt!.hour}:${chat.lastMessageAt!.minute.toString().padLeft(2, '0')}'
                            : '',
                        style: TextStyle(
                          fontFamily: AppFonts.font,
                          fontSize: 12,
                          color: (chat.unreadCount ?? 0) > 0 ? primary : subtitleColor,
                          fontWeight: (chat.unreadCount ?? 0) > 0 ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.lastMessagePreview ?? 'No messages yet',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: AppFonts.font,
                            fontSize: 14,
                            color: (chat.unreadCount ?? 0) > 0 ? txtColor : subtitleColor,
                            fontWeight: (chat.unreadCount ?? 0) > 0 ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                      if ((chat.unreadCount ?? 0) > 0) ...[
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: primary,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          child: Center(
                            child: Text(
                              '${chat.unreadCount}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                fontFamily: AppFonts.font,
                              ),
                            ),
                          ),
                        ),
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
