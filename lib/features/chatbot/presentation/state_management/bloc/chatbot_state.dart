import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class ChatbotState {
  final List<ChatMessageEntity> messages;
  final bool isTyping;
  final String? errorMessage;
  final List<String> activeSuggestions;

  const ChatbotState({
    this.messages = const [],
    this.isTyping = false,
    this.errorMessage,
    this.activeSuggestions = const [
      "أحدث العقارات",
      "اتجاهات الأسعار",
      "احجز جولة"
    ],
  });

  ChatbotState copyWith({
    List<ChatMessageEntity>? messages,
    bool? isTyping,
    String? errorMessage,
    List<String>? activeSuggestions,
    bool clearError = false,
  }) {
    return ChatbotState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      activeSuggestions: activeSuggestions ?? this.activeSuggestions,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
