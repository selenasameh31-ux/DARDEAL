import 'participant_entity.dart';

class ChatMessageEntity {
  final int id;
  final int chatId;
  final ParticipantEntity sender;
  final String messageText;
  final String messageType;
  final bool isEdited;
  final DateTime? editedAt;
  final bool isDeleted;
  final bool isSystem;
  final String? attachmentsJson;
  final DateTime timestamp;

  const ChatMessageEntity({
    required this.id,
    required this.chatId,
    required this.sender,
    required this.messageText,
    this.messageType = 'text',
    required this.isEdited,
    this.editedAt,
    required this.isDeleted,
    required this.isSystem,
    this.attachmentsJson,
    required this.timestamp,
  });
}
