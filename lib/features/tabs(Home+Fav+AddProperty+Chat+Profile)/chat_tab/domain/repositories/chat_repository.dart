import 'package:dartz/dartz.dart';
import 'package:graduation_project_flutter/core/errors/failure.dart';
import '../entities/chat_entity.dart';
import '../entities/chat_message_entity.dart';

abstract class ChatRepository {
  Future<Either<Failure, Map<String, dynamic>>> getChats({int page = 1, int pageSize = 20});
  Future<Either<Failure, ChatEntity>> getChatDetails(int chatId);
  Future<Either<Failure, Map<String, dynamic>>> getChatMessages(int chatId, {int page = 1, int pageSize = 50});
  Future<Either<Failure, ChatMessageEntity>> sendMessage(int chatId, {String? text, String? messageType, String? attachmentsJson});
  Future<Either<Failure, ChatMessageEntity>> editMessage(int messageId, String text);
  Future<Either<Failure, void>> markChatAsRead(int chatId);
  Future<Either<Failure, int>> getUnreadCount();
  Future<Either<Failure, ChatEntity>> createOrGetChat(int propertyId, int ownerId);
  Future<Either<Failure, dynamic>> uploadMedia(int chatId, String filePath);
  Future<Either<Failure, void>> blockUser(int userId);
  Future<Either<Failure, void>> unblockUser(int userId);
  Future<Either<Failure, void>> reportUser(int userId, String complaintType, String description);
  Future<Either<Failure, void>> deleteMessage(int messageId);
}
