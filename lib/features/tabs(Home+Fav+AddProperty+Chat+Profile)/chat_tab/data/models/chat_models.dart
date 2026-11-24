import 'dart:convert';
import 'package:graduation_project_flutter/core/database/api/end_points.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/participant_entity.dart';

class ParticipantModel extends ParticipantEntity {
  const ParticipantModel({
    required super.id,
    required super.name,
    super.profilePhoto,
    required super.isVerified,
    super.isOnline = false,
    super.lastSeenAt,
  });

  factory ParticipantModel.fromJson(Map<String, dynamic> json) {
    return ParticipantModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      profilePhoto: json['profilePhoto'],
      isVerified: json['isVerified'] ?? false,
      isOnline: json['isOnline'] ?? false,
      lastSeenAt: json['lastSeenAt'] != null ? DateTime.tryParse(json['lastSeenAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profilePhoto': profilePhoto,
      'isVerified': isVerified,
      'isOnline': isOnline,
      'lastSeenAt': lastSeenAt?.toIso8601String(),
    };
  }
}

class ChatModel extends ChatEntity {
  const ChatModel({
    required super.id,
    required super.propertyId,
    required super.propertyTitle,
    super.propertyPhoto,
    super.otherParticipant,
    super.unreadCount,
    super.seeker,
    super.owner,
    super.seekerUnreadCount,
    super.ownerUnreadCount,
    super.createdAt,
    super.lastMessagePreview,
    super.lastMessageAt,
    required super.isActive,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    final seeker = json['seeker'] != null ? ParticipantModel.fromJson(json['seeker']) : null;
    final owner = json['owner'] != null ? ParticipantModel.fromJson(json['owner']) : null;

    // Derive otherParticipant: prefer API-supplied field, else pick the participant
    // that is NOT the current logged-in user from seeker/owner pair.
    ParticipantModel? otherParticipant;
    if (json['otherParticipant'] != null) {
      otherParticipant = ParticipantModel.fromJson(json['otherParticipant']);
    } else if (seeker != null || owner != null) {
      // Read current userId synchronously from SharedPreferences instance.
      // We use a best-effort approach: compare ids and pick the other one.
      final currentUserIdStr = _getCurrentUserId();
      final currentId = int.tryParse(currentUserIdStr) ?? -1;

      if (seeker != null && owner != null) {
        // Both exist — pick the one that is NOT the current user.
        otherParticipant = (seeker.id == currentId) ? owner : seeker;
      } else {
        // Only one participant available — use whichever is not null.
        otherParticipant = owner ?? seeker;
      }
    }

    return ChatModel(
      id: json['id'] ?? 0,
      propertyId: json['propertyId'] ?? 0,
      propertyTitle: json['propertyTitle'] ?? '',
      propertyPhoto: json['propertyPhoto'],
      otherParticipant: otherParticipant,
      unreadCount: json['unreadCount'],
      seeker: seeker,
      owner: owner,
      seekerUnreadCount: json['seekerUnreadCount'],
      ownerUnreadCount: json['ownerUnreadCount'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      lastMessagePreview: json['lastMessagePreview'],
      lastMessageAt: json['lastMessageAt'] != null ? DateTime.parse(json['lastMessageAt']) : null,
      isActive: json['isActive'] ?? false,
    );
  }

  /// Reads the cached user ID that was set after login/session restore.
  static String _getCurrentUserId() => _cachedUserId;

  // Updated externally when the user logs in (see SessionCubit).
  static String _cachedUserId = '';

  /// Call this once after login/session restore to enable correct participant resolution.
  static void setCurrentUserId(String userId) {
    _cachedUserId = userId;
  }
}

class ChatMessageModel extends ChatMessageEntity {
  const ChatMessageModel({
    required super.id,
    required super.chatId,
    required super.sender,
    required super.messageText,
    super.messageType = 'text',
    required super.isEdited,
    super.editedAt,
    required super.isDeleted,
    required super.isSystem,
    super.attachmentsJson,
    required super.timestamp,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] ?? 0,
      chatId: json['chatId'] ?? 0,
      sender: ParticipantModel.fromJson(json['sender'] ?? {}),
      messageText: json['messageText'] ?? '',
      messageType: json['messageType'] ?? 'text',
      isEdited: json['isEdited'] ?? false,
      editedAt: json['editedAt'] != null ? DateTime.parse(json['editedAt']) : null,
      isDeleted: json['isDeleted'] ?? false,
      isSystem: json['isSystem'] ?? false,
      attachmentsJson: _processAttachments(json['attachmentsJson']),
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : DateTime.now(),
    );
  }

  static String? _processAttachments(dynamic attachmentsJsonRaw) {
    if (attachmentsJsonRaw == null) return null;
    String rawJson = attachmentsJsonRaw.toString();
    if (rawJson.isEmpty) return rawJson;
    try {
      final data = jsonDecode(rawJson);
      if (data is List) {
        final processedList = data.map((item) {
          if (item is Map) {
            final newItem = Map<String, dynamic>.from(item);
            String url = newItem['url']?.toString() ?? newItem['mediaUrl']?.toString() ?? '';
            if (url.startsWith('/')) {
              newItem['url'] = '${EndPoints.baseUrl}$url';
            }
            return newItem;
          } else if (item is String) {
            if (item.startsWith('/')) {
              return '${EndPoints.baseUrl}$item';
            }
          }
          return item;
        }).toList();
        return jsonEncode(processedList);
      }
    } catch (_) {
      // Return raw if parsing fails
    }
    return rawJson;
  }
}
