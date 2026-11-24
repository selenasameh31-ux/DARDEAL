
abstract class ChatbotEvent {
  const ChatbotEvent();
}

class LoadChatHistory extends ChatbotEvent {}

class SendMessageRequested extends ChatbotEvent {
  final String message;

  const SendMessageRequested(this.message);
}

class SuggestionChipSelected extends ChatbotEvent {
  final String suggestion;

  const SuggestionChipSelected(this.suggestion);
}



