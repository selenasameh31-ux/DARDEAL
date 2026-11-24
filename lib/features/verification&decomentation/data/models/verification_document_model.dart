import '../../domain/entities/verification_document_entity.dart';

class VerificationDocumentModel extends VerificationDocumentEntity {
  VerificationDocumentModel({
    required super.id,
    required super.documentType,
    super.fileName,
    super.fileSize,
    required super.status,
    super.notes,
    super.rejectionReason,
    required super.submittedAt,
    super.reviewedAt,
    super.diditSessionId,
    super.diditVerificationUrl,
    super.diditDecision,
  });

  factory VerificationDocumentModel.fromJson(Map<String, dynamic> json) {
    return VerificationDocumentModel(
      id: json['id'],
      documentType: json['documentType'],
      fileName: json['fileName'],
      fileSize: json['fileSize'],
      status: json['status'],
      notes: json['notes'],
      rejectionReason: json['rejectionReason'],
      submittedAt: json['submittedAt'],
      reviewedAt: json['reviewedAt'],
      diditSessionId: json['diditSessionId'],
      diditVerificationUrl: json['diditVerificationUrl'],
      diditDecision: json['diditDecision'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentType': documentType,
      'fileName': fileName,
      'fileSize': fileSize,
      'status': status,
      'notes': notes,
      'rejectionReason': rejectionReason,
      'submittedAt': submittedAt,
      'reviewedAt': reviewedAt,
      'diditSessionId': diditSessionId,
      'diditVerificationUrl': diditVerificationUrl,
      'diditDecision': diditDecision,
    };
  }
}
