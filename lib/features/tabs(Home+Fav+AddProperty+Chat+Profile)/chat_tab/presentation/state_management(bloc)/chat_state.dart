import 'package:equatable/equatable.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/entities/chat_message_entity.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatEntity> chats;
  final int unreadCount;
  final String searchQuery;

  const ChatLoaded({
    required this.chats,
    this.unreadCount = 0,
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [chats, unreadCount, searchQuery];

  ChatLoaded copyWith({
    List<ChatEntity>? chats,
    int? unreadCount,
    String? searchQuery,
  }) {
    return ChatLoaded(
      chats: chats ?? this.chats,
      unreadCount: unreadCount ?? this.unreadCount,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class ChatCreated extends ChatState {
  final int chatId;

  const ChatCreated(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object?> get props => [message];
}

class MessagesLoading extends ChatState {}

class MessagesLoaded extends ChatState {
  final List<ChatMessageEntity> messages;
  final ChatEntity chat;
  final bool isBlocked;

  const MessagesLoaded({
    required this.messages,
    required this.chat,
    this.isBlocked = false,
  });

  @override
  List<Object?> get props => [messages, chat, isBlocked];

  MessagesLoaded copyWith({
    List<ChatMessageEntity>? messages,
    ChatEntity? chat,
    bool? isBlocked,
  }) {
    return MessagesLoaded(
      messages: messages ?? this.messages,
      chat: chat ?? this.chat,
      isBlocked: isBlocked ?? this.isBlocked,
    );
  }
}

class MessageDeleted extends ChatState {
  final int messageId;
  const MessageDeleted(this.messageId);
  @override
  List<Object?> get props => [messageId];
}

class MessageSending extends ChatState {}

class MessageSent extends ChatState {
  final ChatMessageEntity message;

  const MessageSent(this.message);

  @override
  List<Object?> get props => [message];
}

class MessageError extends ChatState {
  final String message;

  const MessageError(this.message);

  @override
  List<Object?> get props => [message];
}

class MediaUploading extends ChatState {}

class MediaUploaded extends ChatState {
  final dynamic responseData;
  final String messageType;

  const MediaUploaded({required this.responseData, required this.messageType});

  @override
  List<Object?> get props => [responseData, messageType];
}

class UserActionLoading extends ChatState {}

class UserActionSuccess extends ChatState {
  final String message;

  const UserActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class UserActionFailed extends ChatState {
  final String message;

  const UserActionFailed(this.message);

  @override
  List<Object?> get props => [message];
}
