import 'participant_entity.dart';

class ChatEntity {
  final int id;
  final int propertyId;
  final String propertyTitle;
  final String? propertyPhoto;
  
  // From List endpoint
  final ParticipantEntity? otherParticipant;
  final int? unreadCount;
  
  // From Details endpoint
  final ParticipantEntity? seeker;
  final ParticipantEntity? owner;
  final int? seekerUnreadCount;
  final int? ownerUnreadCount;
  final DateTime? createdAt;

  final String? lastMessagePreview;
  final DateTime? lastMessageAt;
  final bool isActive;

  const ChatEntity({
    required this.id,
    required this.propertyId,
    required this.propertyTitle,
    this.propertyPhoto,
    this.otherParticipant,
    this.unreadCount,
    this.seeker,
    this.owner,
    this.seekerUnreadCount,
    this.ownerUnreadCount,
    this.createdAt,
    this.lastMessagePreview,
    this.lastMessageAt,
    required this.isActive,
  });
}
