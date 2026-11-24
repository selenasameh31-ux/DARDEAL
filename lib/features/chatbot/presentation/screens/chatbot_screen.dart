import 'package:graduation_project_flutter/core/routing/routes_export.dart';
import 'package:graduation_project_flutter/features/chatbot/presentation/widgets/chatbot_welcome_widget.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.hasClients) {
      final isNearBottom =
          _scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 80;
      if (!isNearBottom) {
        if (!_showScrollToBottom) {
          setState(() => _showScrollToBottom = true);
        }
      } else {
        if (_showScrollToBottom) {
          setState(() => _showScrollToBottom = false);
        }
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/icons/chatbot/darbot_bot_icon.png',
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFF26A69A),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'DarBot',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.font,
                  ),
                ),
                Text(
                  'متصل الآن',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF26A69A),
                    letterSpacing: 1.2,
                    fontFamily: AppFonts.font,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey.withValues(alpha: 0.2),
            height: 1.0,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Center(
            child: Text(
              'اليوم',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                letterSpacing: 1.5,
                fontFamily: AppFonts.font,
              ),
            ),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: Stack(
              children: [
                BlocConsumer<ChatbotBloc, ChatbotState>(
                  listener: (context, state) {
                    if (state.errorMessage != null) {
                      AppSnackBar.error(context, state.errorMessage!);
                    }
                    // Auto scroll to bottom when new messages arrive if user is already near bottom
                    if (state.messages.isNotEmpty || state.isTyping) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (_scrollController.hasClients) {
                          final isNearBottom =
                              _scrollController.position.pixels >=
                              _scrollController.position.maxScrollExtent - 100;

                          if (isNearBottom) {
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                            setState(() => _showScrollToBottom = false);
                          } else {
                            // If they are scrolled up, show the FAB to alert them of new messages
                            setState(() => _showScrollToBottom = true);
                          }
                        }
                      });
                    }
                  },
                  builder: (context, state) {
                    return ListView.builder(
                      controller: _scrollController,
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 16),
                      // +1 for WelcomeWidget at top, +1 for typing indicator if active
                      itemCount:
                          state.messages.length + 1 + (state.isTyping ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return ChatbotWelcomeWidget(
                            onSuggestionSelected: (suggestion) {
                              context.read<ChatbotBloc>().add(
                                SendMessageRequested(suggestion),
                              );
                            },
                          );
                        }

                        final messageIndex = index - 1;

                        if (messageIndex == state.messages.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TypingIndicator(),
                            ),
                          );
                        }

                        final message = state.messages[messageIndex];
                        final isLatest =
                            messageIndex == state.messages.length - 1;
                        return ChatBubble(message: message, isLatest: isLatest);
                      },
                    );
                  },
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: AnimatedScale(
                    scale: _showScrollToBottom ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    child: IgnorePointer(
                      ignoring: !_showScrollToBottom,
                      child: FloatingActionButton(
                        heroTag: 'chatbot_scroll_to_bottom',
                        mini: true,
                        onPressed: () {
                          _scrollToBottom();
                          setState(() => _showScrollToBottom = false);
                        },
                        backgroundColor: const Color(0xFFF17C21),
                        child: const Icon(
                          Icons.arrow_downward,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          ChatbotInputArea(
            onSend: (text) {
              context.read<ChatbotBloc>().add(SendMessageRequested(text));
            },
          ),
        ],
      ),
    );
  }
}
