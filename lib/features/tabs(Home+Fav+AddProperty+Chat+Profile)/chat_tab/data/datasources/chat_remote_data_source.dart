import 'package:graduation_project_flutter/core/database/api/api_consumer.dart';
import 'package:graduation_project_flutter/core/database/api/end_points.dart';
import 'package:dio/dio.dart';
import 'package:graduation_project_flutter/core/utils/api_response_helper.dart';
import '../models/chat_models.dart';

abstract class ChatRemoteDataSource {
  Future<Map<String, dynamic>> getChats({int page = 1, int pageSize = 20});
  Future<ChatModel> getChatDetails(int chatId);
  Future<Map<String, dynamic>> getChatMessages(int chatId, {int page = 1, int pageSize = 50});
  Future<ChatMessageModel> sendMessage(int chatId, {String? text, String? messageType, String? attachmentsJson});
  Future<ChatMessageModel> editMessage(int messageId, String text);
  Future<void> markChatAsRead(int chatId);
  Future<int> getUnreadCount();
  Future<ChatModel> createOrGetChat(int propertyId, int ownerId);
  Future<dynamic> uploadMedia(int chatId, String filePath);
  Future<void> blockUser(int userId);
  Future<void> unblockUser(int userId);
  Future<void> reportUser(int userId, String complaintType, String description);
  Future<void> deleteMessage(int messageId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final ApiConsumer api;

  ChatRemoteDataSourceImpl({required this.api});

  @override
  Future<Map<String, dynamic>> getChats({int page = 1, int pageSize = 20}) async {
    final response = await api.get(
      EndPoints.chats,
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
      },
    );
    final data = ApiDataExtractor.extract(response.data);
    final items = (data['items'] as List).map((e) => ChatModel.fromJson(e)).toList();
    return {
      'items': items,
      'totalCount': data['totalCount'],
      'page': data['page'],
      'pageSize': data['pageSize'],
      'totalPages': data['totalPages'],
    };
  }

  @override
  Future<ChatModel> getChatDetails(int chatId) async {
    final response = await api.get(EndPoints.chatDetails(chatId));
    return ChatModel.fromJson(ApiDataExtractor.extract(response.data));
  }

  @override
  Future<Map<String, dynamic>> getChatMessages(int chatId, {int page = 1, int pageSize = 50}) async {
    final response = await api.get(
      EndPoints.chatMessages(chatId),
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
      },
    );
    final data = ApiDataExtractor.extract(response.data);
    final items = (data['items'] as List).map((e) => ChatMessageModel.fromJson(e)).toList();
    return {
      'items': items,
      'totalCount': data['totalCount'],
      'page': data['page'],
      'pageSize': data['pageSize'],
      'totalPages': data['totalPages'],
    };
  }

  @override
  Future<ChatMessageModel> sendMessage(int chatId, {String? text, String? messageType, String? attachmentsJson}) async {
    final body = {
      "messageText": text ?? "",
      "messageType": messageType ?? "text",
      "attachmentsJson": attachmentsJson ?? ""
    };
    print('========= SEND MESSAGE REQUEST =========');
    print('URL: ${EndPoints.chatMessages(chatId)}');
    print('BODY: $body');
    print('========================================');
    
    final response = await api.post(
      EndPoints.chatMessages(chatId),
      data: body,
    );
    return ChatMessageModel.fromJson(ApiDataExtractor.extract(response.data));
  }

  @override
  Future<ChatMessageModel> editMessage(int messageId, String text) async {
    final response = await api.put(
      EndPoints.editMessage(messageId),
      data: {"messageText": text},
    );
    return ChatMessageModel.fromJson(ApiDataExtractor.extract(response.data));
  }

  @override
  Future<void> markChatAsRead(int chatId) async {
    final response = await api.post(EndPoints.markChatRead(chatId));
    ApiDataExtractor.extract(response.data); // check for errors
  }

  @override
  Future<int> getUnreadCount() async {
    final response = await api.get(EndPoints.unreadCount);
    final data = ApiDataExtractor.extract(response.data);
    return data['unreadCount'] ?? 0;
  }

  @override
  Future<ChatModel> createOrGetChat(int propertyId, int ownerId) async {
    final response = await api.post(
      EndPoints.chats,
      data: {
        "propertyId": propertyId,
        "ownerId": ownerId
      },
    );
    return ChatModel.fromJson(ApiDataExtractor.extract(response.data));
  }

  @override
  Future<dynamic> uploadMedia(int chatId, String filePath) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    final response = await api.post(
      EndPoints.chatMedia(chatId),
      data: formData,
    );
    print('========= MEDIA UPLOAD RESPONSE =========');
    print(response.data);
    print('=========================================');
    return ApiDataExtractor.extract(response.data);
  }

  @override
  Future<void> blockUser(int userId) async {
    final response = await api.post(EndPoints.blockUser(userId));
    ApiDataExtractor.extract(response.data);
  }

  @override
  Future<void> unblockUser(int userId) async {
    final response = await api.post(EndPoints.unblockUser(userId));
    ApiDataExtractor.extract(response.data);
  }

  @override
  Future<void> reportUser(int userId, String complaintType, String description) async {
    final response = await api.post(
      EndPoints.createComplaint,
      data: {
        "targetType": "User",
        "targetId": userId,
        "complaintType": complaintType,
        "description": description
      },
    );
    ApiDataExtractor.extract(response.data);
  }

  @override
  Future<void> deleteMessage(int messageId) async {
    await api.delete(EndPoints.deleteMessage(messageId));
  }
}
