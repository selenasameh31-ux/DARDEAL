import 'package:graduation_project_flutter/core/routing/routes_export.dart';

abstract class ChatbotRepository {
  Future<ChatMessageEntity> sendMessage(String message);
  Future<List<ChatMessageEntity>> getChatHistory();
}
