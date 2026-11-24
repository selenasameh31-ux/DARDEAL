import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/entities/chat_entity.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository repository;
  Timer? _pollingTimer;

  ChatBloc({required this.repository}) : super(ChatInitial()) {
    on<FetchChatsEvent>(_onFetchChats);
    on<SearchChatsEvent>(_onSearchChats);
    on<FetchMessagesEvent>(_onFetchMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<MarkChatReadEvent>(_onMarkChatRead);
    on<LoadUnreadCountEvent>(_onLoadUnreadCount);
    on<StartChatWithOwnerEvent>(_onStartChatWithOwner);
    on<UploadMediaEvent>(_onUploadMedia);
    on<BlockUserEvent>(_onBlockUser);
    on<UnblockUserEvent>(_onUnblockUser);
    on<ReportUserEvent>(_onReportUser);
    on<StartPollingEvent>(_onStartPolling);
    on<StopPollingEvent>(_onStopPolling);
    on<EditMessageEvent>(_onEditMessage);
    on<DeleteMessageEvent>(_onDeleteMessage);
  }

  List<ChatEntity> _allChats = [];

  void _onStartPolling(StartPollingEvent event, Emitter<ChatState> emit) {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      add(FetchMessagesEvent(event.chatId, isPolling: true));
    });
  }

  void _onStopPolling(StopPollingEvent event, Emitter<ChatState> emit) {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    return super.close();
  }

  Future<void> _onFetchChats(FetchChatsEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoading());

    final chatsResult = await repository.getChats(page: 1, pageSize: 50);
    final countResult = await repository.getUnreadCount();

    int unreadCount = 0;
    countResult.fold((l) {}, (count) => unreadCount = count);

    chatsResult.fold(
      (failure) => emit(ChatError(failure.message)),
      (data) {
        _allChats = (data['items'] as List).cast<ChatEntity>();
        emit(ChatLoaded(chats: _allChats, unreadCount: unreadCount));
      },
    );
  }

  void _onSearchChats(SearchChatsEvent event, Emitter<ChatState> emit) {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;
      final query = event.query.toLowerCase();
      
      if (query.isEmpty) {
        emit(currentState.copyWith(chats: _allChats, searchQuery: query));
        return;
      }

      final filtered = _allChats.where((chat) {
        return chat.propertyTitle.toLowerCase().contains(query) ||
            (chat.otherParticipant?.name.toLowerCase().contains(query) ?? false) ||
            (chat.lastMessagePreview?.toLowerCase().contains(query) ?? false);
      }).toList();

      emit(currentState.copyWith(chats: filtered, searchQuery: query));
    }
  }

  bool _isFetchingMessages = false;

  Future<void> _onFetchMessages(FetchMessagesEvent event, Emitter<ChatState> emit) async {
    if (_isFetchingMessages) return;
    _isFetchingMessages = true;

    try {
      if (!event.isPolling) {
        emit(MessagesLoading());
      }

      final detailsResult = await repository.getChatDetails(event.chatId);
      final messagesResult = await repository.getChatMessages(event.chatId, page: 1, pageSize: 50);

      detailsResult.fold(
        (failure) {
          if (!event.isPolling) emit(ChatError(failure.message));
        },
        (chatDetails) {
          messagesResult.fold(
            (failure) {
              if (!event.isPolling) emit(ChatError(failure.message));
            },
            (data) {
              emit(MessagesLoaded(
                messages: data['items'],
                chat: chatDetails,
              ));
            },
          );
        },
      );
    } finally {
      _isFetchingMessages = false;
    }
  }

  Future<void> _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    final currentState = state;
    if (currentState is MessagesLoaded) {
      // Keep old state
      emit(MessageSending());
      
      final result = await repository.sendMessage(
        event.chatId,
        text: event.text,
        messageType: event.messageType,
        attachmentsJson: event.attachmentsJson,
      );
      
      result.fold(
        (failure) {
          emit(MessageError(failure.message));
          // Revert to loaded
          emit(currentState);
        },
        (sentMessage) {
          emit(MessageSent(sentMessage));
          // Append message and revert to loaded
          final updatedMessages = List.of(currentState.messages)..insert(0, sentMessage);
          emit(currentState.copyWith(messages: updatedMessages));
        },
      );
    }
  }

  Future<void> _onEditMessage(EditMessageEvent event, Emitter<ChatState> emit) async {
    final currentState = state;
    if (currentState is MessagesLoaded) {
      emit(MessageSending());
      final result = await repository.editMessage(event.messageId, event.text);
      result.fold(
        (failure) {
          emit(MessageError(failure.message));
          emit(currentState);
        },
        (editedMessage) {
          final updatedMessages = currentState.messages.map((m) {
            return m.id == event.messageId ? editedMessage : m;
          }).toList();
          emit(currentState.copyWith(messages: updatedMessages));
        },
      );
    }
  }

  Future<void> _onMarkChatRead(MarkChatReadEvent event, Emitter<ChatState> emit) async {
    await repository.markChatAsRead(event.chatId);
    add(LoadUnreadCountEvent());
  }

  Future<void> _onLoadUnreadCount(LoadUnreadCountEvent event, Emitter<ChatState> emit) async {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;
      final countResult = await repository.getUnreadCount();
      countResult.fold(
        (failure) {}, 
        (count) {
          emit(currentState.copyWith(unreadCount: count));
        }
      );
    }
  }

  Future<void> _onStartChatWithOwner(StartChatWithOwnerEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    final result = await repository.createOrGetChat(event.propertyId, event.ownerId);
    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (chat) {
        emit(ChatCreated(chat.id));
      },
    );
  }

  Future<void> _onUploadMedia(UploadMediaEvent event, Emitter<ChatState> emit) async {
    final currentState = state;
    emit(MediaUploading());

    final result = await repository.uploadMedia(event.chatId, event.filePath);
    result.fold(
      (failure) {
        emit(MessageError(failure.message));
        if (currentState is MessagesLoaded) emit(currentState);
      },
      (data) {
        emit(MediaUploaded(responseData: data, messageType: event.messageType));
        if (currentState is MessagesLoaded) emit(currentState);
      },
    );
  }

  Future<void> _onBlockUser(BlockUserEvent event, Emitter<ChatState> emit) async {
    final currentState = state;
    emit(UserActionLoading());

    final result = await repository.blockUser(event.userId);
    result.fold(
      (failure) => emit(UserActionFailed(failure.message)),
      (_) => emit(const UserActionSuccess('User blocked successfully')),
    );
    // Restore messages state with isBlocked = true so UI locks the input
    if (currentState is MessagesLoaded) {
      emit(currentState.copyWith(isBlocked: true));
    }
  }

  Future<void> _onUnblockUser(UnblockUserEvent event, Emitter<ChatState> emit) async {
    final currentState = state;
    emit(UserActionLoading());

    final result = await repository.unblockUser(event.userId);
    result.fold(
      (failure) => emit(UserActionFailed(failure.message)),
      (_) => emit(const UserActionSuccess('User unblocked successfully')),
    );
    if (currentState is MessagesLoaded) emit(currentState);
  }

  Future<void> _onReportUser(ReportUserEvent event, Emitter<ChatState> emit) async {
    final currentState = state;
    emit(UserActionLoading());

    final result = await repository.reportUser(event.userId, event.complaintType, event.description);
    result.fold(
      (failure) => emit(UserActionFailed(failure.message)),
      (_) => emit(const UserActionSuccess('Complaint submitted successfully')),
    );
    if (currentState is MessagesLoaded) emit(currentState);
  }

  Future<void> _onDeleteMessage(DeleteMessageEvent event, Emitter<ChatState> emit) async {
    final currentState = state;
    if (currentState is! MessagesLoaded) return;

    final result = await repository.deleteMessage(event.messageId);
    result.fold(
      (failure) => emit(UserActionFailed(failure.message)),
      (_) {
        // Remove the deleted message from the list locally
        final updatedMessages = currentState.messages
            .where((m) => m.id != event.messageId)
            .toList();
        emit(MessageDeleted(event.messageId));
        emit(currentState.copyWith(messages: updatedMessages));
      },
    );
  }
}
