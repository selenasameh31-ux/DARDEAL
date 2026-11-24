import '../../domain/entities/didit_session_entity.dart';

class DiditSessionModel extends DiditSessionEntity {
  DiditSessionModel({
    required super.id,
    required super.documentType,
    required super.diditSessionId,
    required super.verificationUrl,
    required super.status,
    required super.submittedAt,
  });

  factory DiditSessionModel.fromJson(Map<String, dynamic> json) {
    return DiditSessionModel(
      id: json['id'],
      documentType: json['documentType'],
      diditSessionId: json['diditSessionId'],
      verificationUrl: json['verificationUrl'],
      status: json['status'],
      submittedAt: json['submittedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentType': documentType,
      'diditSessionId': diditSessionId,
      'verificationUrl': verificationUrl,
      'status': status,
      'submittedAt': submittedAt,
    };
  }
}
