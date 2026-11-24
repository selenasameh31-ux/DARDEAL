import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class SendMessageUseCase {
  final ChatbotRepository repository;

  SendMessageUseCase(this.repository);

  Future<ChatMessageEntity> call(String message) async {
    return await repository.sendMessage(message);
  }
}

class GetChatHistoryUseCase {
  final ChatbotRepository repository;

  GetChatHistoryUseCase(this.repository);

  Future<List<ChatMessageEntity>> call() async {
    return await repository.getChatHistory();
  }
}
