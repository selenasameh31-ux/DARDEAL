import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class ChatbotRepositoryImpl implements ChatbotRepository {
  final ChatbotRemoteDataSource remoteDataSource;

  ChatbotRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ChatMessageEntity> sendMessage(String message) async {
    return await remoteDataSource.sendMessage(message);
  }

  @override
  Future<List<ChatMessageEntity>> getChatHistory() async {
    return await remoteDataSource.getChatHistory();
  }
}
