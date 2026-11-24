import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class FetchChatsEvent extends ChatEvent {}

class SearchChatsEvent extends ChatEvent {
  final String query;

  const SearchChatsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class FetchMessagesEvent extends ChatEvent {
  final int chatId;
  final bool isPolling;

  const FetchMessagesEvent(this.chatId, {this.isPolling = false});

  @override
  List<Object?> get props => [chatId, isPolling];
}

class StartPollingEvent extends ChatEvent {
  final int chatId;

  const StartPollingEvent(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class StopPollingEvent extends ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final int chatId;
  final String? text;
  final String? messageType;
  final String? attachmentsJson;

  const SendMessageEvent({required this.chatId, this.text, this.messageType, this.attachmentsJson});

  @override
  List<Object?> get props => [chatId, text, messageType, attachmentsJson];
}

class MarkChatReadEvent extends ChatEvent {
  final int chatId;

  const MarkChatReadEvent(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class LoadUnreadCountEvent extends ChatEvent {}

class StartChatWithOwnerEvent extends ChatEvent {
  final int propertyId;
  final int ownerId;

  const StartChatWithOwnerEvent({required this.propertyId, required this.ownerId});

  @override
  List<Object?> get props => [propertyId, ownerId];
}

class UploadMediaEvent extends ChatEvent {
  final int chatId;
  final String filePath;
  final String messageType;

  const UploadMediaEvent({required this.chatId, required this.filePath, required this.messageType});

  @override
  List<Object?> get props => [chatId, filePath, messageType];
}

class BlockUserEvent extends ChatEvent {
  final int userId;

  const BlockUserEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UnblockUserEvent extends ChatEvent {
  final int userId;

  const UnblockUserEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class ReportUserEvent extends ChatEvent {
  final int userId;
  final String complaintType;
  final String description;

  const ReportUserEvent({required this.userId, required this.complaintType, required this.description});

  @override
  List<Object?> get props => [userId, complaintType, description];
}

class EditMessageEvent extends ChatEvent {
  final int messageId;
  final String text;

  const EditMessageEvent({required this.messageId, required this.text});

  @override
  List<Object?> get props => [messageId, text];
}

class DeleteMessageEvent extends ChatEvent {
  final int messageId;

  const DeleteMessageEvent(this.messageId);

  @override
  List<Object?> get props => [messageId];
}
