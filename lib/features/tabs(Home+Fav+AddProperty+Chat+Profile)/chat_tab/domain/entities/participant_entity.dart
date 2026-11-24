class ParticipantEntity {
  final int id;
  final String name;
  final String? profilePhoto;
  final bool isVerified;
  final bool isOnline;
  final DateTime? lastSeenAt;

  const ParticipantEntity({
    required this.id,
    required this.name,
    this.profilePhoto,
    required this.isVerified,
    this.isOnline = false,
    this.lastSeenAt,
  });
}
