/// Represents the Didit session created by POST /api/v1/verification-documents.
/// The [verificationUrl] must be opened in an external browser so the user
/// can complete identity verification on Didit's hosted page.
class DiditSessionEntity {
  final int id;
  final String documentType;
  final String diditSessionId;
  final String verificationUrl;
  final String status;
  final String submittedAt;

  DiditSessionEntity({
    required this.id,
    required this.documentType,
    required this.diditSessionId,
    required this.verificationUrl,
    required this.status,
    required this.submittedAt,
  });
}
