import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessageEntity message;
  final bool isLatest;

  const ChatBubble({
    super.key,
    required this.message,
    this.isLatest = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final botBgColor = isDark
        ? const Color(0xFF1A3B44)
        : const Color(0xFFF2F2F2);
    final botTextColor = isDark ? Colors.white : Colors.black87;

    final userBgColor = isDark
        ? const Color(0xFF0C4D50)
        : const Color(0xFF235265);
    final userTextColor = Colors.white;

    final bgColor = message.isUserMessage ? userBgColor : botBgColor;
    final textColor = message.isUserMessage ? userTextColor : botTextColor;

    TextDirection getDirection(String text) {
      if (text.isEmpty) return TextDirection.rtl;
      final firstChar = text.trimLeft();
      if (firstChar.isNotEmpty) {
        final codeUnit = firstChar.codeUnitAt(0);
        if ((codeUnit >= 0x0041 && codeUnit <= 0x005A) ||
            (codeUnit >= 0x0061 && codeUnit <= 0x007A)) {
          return TextDirection.ltr;
        }
      }
      return TextDirection.rtl;
    }

    final textDir = getDirection(message.text);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      child: Column(
        crossAxisAlignment:
            message.isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment:
                message.isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Bot avatar
              if (!message.isUserMessage)
                Container(
                  margin: const EdgeInsets.only(right: 8, bottom: 4),
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/icons/chatbot/darbot_bot_icon.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

              // Message bubble
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft:
                          Radius.circular(message.isUserMessage ? 16 : 4),
                      bottomRight:
                          Radius.circular(message.isUserMessage ? 4 : 16),
                    ),
                  ),
                  child: Directionality(
                    textDirection: textDir,
                    child: message.isUserMessage
                        ? Text(
                            message.text,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 14,
                              height: 1.5,
                              fontFamily: AppFonts.font,
                            ),
                          )
                        : MarkdownBody(
                            data: message.text,
                            styleSheet: MarkdownStyleSheet(
                              p: TextStyle(
                                color: textColor,
                                fontSize: 14,
                                height: 1.6,
                                fontFamily: AppFonts.font,
                              ),
                              h1: TextStyle(
                                color: textColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                fontFamily: AppFonts.font,
                              ),
                              h2: TextStyle(
                                color: textColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                fontFamily: AppFonts.font,
                              ),
                              h3: TextStyle(
                                color: textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                fontFamily: AppFonts.font,
                              ),
                              listBullet: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              listIndent: 24.0,
                              blockSpacing: 12.0,
                              strong: TextStyle(
                                color: isDark
                                    ? const Color(0xFF4DB6AC)
                                    : const Color(0xFF235265),
                                fontWeight: FontWeight.w800,
                              ),
                              pPadding: const EdgeInsets.only(bottom: 4.0),
                            ),
                          ),
                  ),
                ),
              ),

              // User avatar
              if (message.isUserMessage)
                Container(
                  margin: const EdgeInsets.only(left: 8, bottom: 4),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF17C21),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                      Icons.person_outline, color: Colors.white, size: 18),
                ),
            ],
          ),

          // Property cards — OUTSIDE the Row, full-width scrollable
          if (message.properties != null && message.properties!.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(
                top: 8.0,
                left: message.isUserMessage ? 0 : 42,
                right: message.isUserMessage ? 42 : 0,
              ),
              child: SizedBox(
                height: 265,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: message.properties!.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) => SizedBox(
                    width: 220,
                    child: ChatbotPropertyCard(
                        property: message.properties![index]),
                  ),
                ),
              ),
            ),

          // Suggestions (only for the latest bot message)
          if (!message.isUserMessage &&
              isLatest &&
              message.suggestions != null &&
              message.suggestions!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 42.0, right: 8.0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  alignment: WrapAlignment.start,
                  children: message.suggestions!.map((suggestion) {
                    return InkWell(
                      onTap: () {
                        context.read<ChatbotBloc>().add(
                          SendMessageRequested(suggestion),
                        );
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14.0, vertical: 9.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: const Color(0xFF235265).withValues(alpha: 0.35)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.chat_bubble_outline_rounded,
                              color: Color(0xFF235265),
                              size: 13,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              suggestion,
                              style: const TextStyle(
                                color: Color(0xFF235265),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontFamily: AppFonts.font,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
