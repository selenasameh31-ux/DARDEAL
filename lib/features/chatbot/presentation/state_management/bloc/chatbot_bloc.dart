import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class ChatbotBloc extends Bloc<ChatbotEvent, ChatbotState> {
  final SendMessageUseCase sendMessageUseCase;
  final GetChatHistoryUseCase getChatHistoryUseCase;

  ChatbotBloc({
    required this.sendMessageUseCase,
    required this.getChatHistoryUseCase,
  }) : super(const ChatbotState()) {
    on<LoadChatHistory>(_onLoadChatHistory);
    on<SendMessageRequested>(_onSendMessage);
    on<SuggestionChipSelected>(_onSuggestionChipSelected);
  }

  Future<void> _onLoadChatHistory(LoadChatHistory event, Emitter<ChatbotState> emit) async {
    emit(state.copyWith(isTyping: true, clearError: true));
    try {
      final history = await getChatHistoryUseCase();
      if (history.isEmpty) {
        emit(state.copyWith(
          messages: [],
          isTyping: false,
          activeSuggestions: [],
        ));
      } else {
        final suggestions = history.isNotEmpty && history.last.suggestions != null
            ? history.last.suggestions!
            : state.activeSuggestions;
        emit(state.copyWith(messages: history, isTyping: false, activeSuggestions: suggestions));
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isTyping: false));
    }
  }

  Future<void> _onSendMessage(SendMessageRequested event, Emitter<ChatbotState> emit) async {
    if (event.message.trim().isEmpty) return;

    final userMessage = ChatMessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: event.message,
      isUserMessage: true,
      timestamp: DateTime.now(),
    );

    final currentMessages = List<ChatMessageEntity>.from(state.messages)..add(userMessage);
    
    // Optimistic UI update
    emit(state.copyWith(messages: currentMessages, isTyping: true, clearError: true));

    try {
      final botMessage = await sendMessageUseCase(event.message);
      final newMessages = List<ChatMessageEntity>.from(state.messages)..add(botMessage);
      final suggestions = botMessage.suggestions ?? state.activeSuggestions;
      emit(state.copyWith(messages: newMessages, isTyping: false, activeSuggestions: suggestions));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isTyping: false));
    }
  }

  void _onSuggestionChipSelected(SuggestionChipSelected event, Emitter<ChatbotState> emit) {
    add(SendMessageRequested(event.suggestion));
  }

}

