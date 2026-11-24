import 'package:graduation_project_flutter/core/routing/routes_export.dart';
import 'package:graduation_project_flutter/core/localization/app_strings.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(FetchChatsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final txtColor = isDark ? DarkColors.darkTitleAndSubTitleText : LightColors.lightTitleAndSubTitleText;
    final borderColor = isDark
        ? DarkColors.darkTextFieldColor
        : LightColors.lightTextFieldColor;

    return Scaffold(
      backgroundColor: context.scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: context.scaffoldBgColor,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
            AppStrings.of(context).messages,
            style: TextStyle(
              fontFamily: AppFonts.font,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: txtColor,
            ),
          ),
          actions: [
            const SizedBox(width: 8),
          ],
        ),
        body: Builder(
          builder: (context) {
            return Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 48,
                    decoration: BoxDecoration(
                      color: isDark
                          ? DarkColors.darkTextFieldColor
                          : LightColors.lightTextFieldColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: isDark
                              ? DarkColors.darkHintTextFieldColor
                              : LightColors.lightHintTextFieldColor,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            style: TextStyle(
                              fontFamily: AppFonts.font,
                              color: txtColor,
                              fontSize: 15,
                            ),
                            decoration: InputDecoration(
                             hintText: AppStrings.of(context).searchConversations,
                              hintStyle: TextStyle(
                                fontFamily: AppFonts.font,
                                color: isDark
                                  ? DarkColors.darkHintTextFieldColor
                                  : LightColors.lightHintTextFieldColor,
                                fontSize: 15,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            onChanged: (query) {
                              context.read<ChatBloc>().add(
                                SearchChatsEvent(query),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Chat List
                Expanded(
                  child: BlocBuilder<ChatBloc, ChatState>(
                    builder: (context, state) {
                      if (state is ChatLoading || state is ChatInitial) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: context.primaryColor,
                          ),
                        );
                      }
                      
                      if (state is ChatError) {
                        return Center(
                          child: Text(
                            state.message,
                            style: TextStyle(color: txtColor, fontFamily: AppFonts.font),
                          ),
                        );
                      }

                      if (state is ChatLoaded) {
                        if (state.chats.isEmpty) {
                          return Center(
                            child: Text(
                               AppStrings.of(context).noConversations,
                              style: TextStyle(color: txtColor, fontFamily: AppFonts.font),
                            ),
                          );
                        }

                        return ListView.separated(
                          itemCount: state.chats.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            color: borderColor,
                            indent: 82, // Align with text
                          ),
                          itemBuilder: (context, index) {
                            final chat = state.chats[index];
                            return ChatItemWidget(
                              chat: chat,
                              onTap: () {
                                Navigator.pushNamed(
                                  context, 
                                  Routes.chatDetails,
                                  arguments: chat.id,
                                );
                              },
                            );
                          },
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            );
          },
        ),
      );
  }
}
