import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class ChatInputArea extends StatefulWidget {
  final int chatId;

  const ChatInputArea({super.key, required this.chatId});

  @override
  State<ChatInputArea> createState() => _ChatInputAreaState();
}

class _ChatInputAreaState extends State<ChatInputArea> {
  final _controller = TextEditingController();
  TextDirection _textDirection = TextDirection.ltr;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged(String value) {
    if (value.isEmpty) {
      if (_textDirection != TextDirection.ltr) {
        setState(() => _textDirection = TextDirection.ltr);
      }
      return;
    }
    final firstChar = value.trim().isEmpty ? '' : value.trim().characters.first;
    if (firstChar.isEmpty) return;

    final isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(firstChar);
    final newDirection = isArabic ? TextDirection.rtl : TextDirection.ltr;

    if (newDirection != _textDirection) {
      setState(() => _textDirection = newDirection);
    }
  }

  void _handleSend(BuildContext context) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    context.read<ChatBloc>().add(
      SendMessageEvent(chatId: widget.chatId, text: text),
    );
    _controller.clear();
    setState(() => _textDirection = TextDirection.ltr);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = context.primaryColor;
    final borderColor = isDark
        ? DarkColors.darkTextFieldColor
        : LightColors.lightTextFieldColor;
    final txtColor = isDark
        ? DarkColors.darkTitleAndSubTitleText
        : LightColors.lightTitleAndSubTitleText;

    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        final isSending = state is MessageSending;

        return Container(
          decoration: BoxDecoration(
            color: context.scaffoldBgColor,
            border: Border(top: BorderSide(color: borderColor, width: 0.5)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Message Input Field
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isDark
                            ? DarkColors.darkTextFieldColor
                            : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: borderColor),
                      ),
                      child: TextField(
                        controller: _controller,
                        textDirection: _textDirection,
                        textAlign: _textDirection == TextDirection.rtl
                            ? TextAlign.right
                            : TextAlign.left,
                        onChanged: _onTextChanged,
                        cursorColor: primary,
                        enabled: !isSending,
                        style: TextStyle(
                          fontFamily: AppFonts.font,
                          color: txtColor,
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Message...',
                          hintTextDirection: _textDirection,
                          hintStyle: TextStyle(
                            fontFamily: AppFonts.font,
                            color: isDark
                                ? DarkColors.darkHintTextFieldColor
                                : LightColors.lightHintTextFieldColor,
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => _handleSend(context),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Send Button
                  GestureDetector(
                    onTap: isSending ? null : () => _handleSend(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isSending
                            ? primary.withValues(alpha: 0.5)
                            : primary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: isSending
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
