class VerificationDocumentEntity {
  final int id;
  final String documentType;
  final String? fileName;
  final int? fileSize;
  final String status;
  final String? notes;
  final String? rejectionReason;
  final String submittedAt;
  final String? reviewedAt;
  final String? diditSessionId;
  final String? diditVerificationUrl;
  final String? diditDecision;

  VerificationDocumentEntity({
    required this.id,
    required this.documentType,
    this.fileName,
    this.fileSize,
    required this.status,
    this.notes,
    this.rejectionReason,
    required this.submittedAt,
    this.reviewedAt,
    this.diditSessionId,
    this.diditVerificationUrl,
    this.diditDecision,
  });
}
