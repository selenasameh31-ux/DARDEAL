/*import 'package:flutter_test/flutter_test.dart';
import 'package:graduation_project_flutter/core/routing/routes_export.dart';

void main() {
  test('Test chatbot bloc loading history', () async {
    final bloc = ChatbotBloc(
      sendMessageUseCase: SendMessageUseCase(
        ChatbotRepositoryImpl(remoteDataSource: ChatbotRemoteDataSourceImpl()),
      ),
      getChatHistoryUseCase: GetChatHistoryUseCase(
        ChatbotRepositoryImpl(remoteDataSource: ChatbotRemoteDataSourceImpl()),
      ),
    );

    bloc.add(LoadChatHistory());

    // Wait for the async events to complete
    await Future.delayed(const Duration(seconds: 2));

    print('Messages count: ${bloc.state.messages.length}');
    print('Suggestions: ${bloc.state.activeSuggestions}');
  });

  test('Test chatbot bloc sending message', () async {
    final bloc = ChatbotBloc(
      sendMessageUseCase: SendMessageUseCase(
        ChatbotRepositoryImpl(remoteDataSource: ChatbotRemoteDataSourceImpl()),
      ),
      getChatHistoryUseCase: GetChatHistoryUseCase(
        ChatbotRepositoryImpl(remoteDataSource: ChatbotRemoteDataSourceImpl()),
      ),
    );

    bloc.add(const SendMessageRequested("latest properties"));

    // Wait for the async events to complete
    await Future.delayed(const Duration(seconds: 2));

    print('Messages count after sending: ${bloc.state.messages.length}');
    print('Suggestions after sending: ${bloc.state.activeSuggestions}');
  });
}
*/
