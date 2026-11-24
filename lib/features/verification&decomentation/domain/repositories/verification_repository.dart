import 'package:dartz/dartz.dart';
import 'package:graduation_project_flutter/core/errors/failure.dart';
import '../entities/verification_document_entity.dart';
import '../entities/didit_session_entity.dart';

abstract class VerificationRepository {
  Future<Either<Failure, DiditSessionEntity>> createVerificationSession();

  Future<Either<Failure, List<VerificationDocumentEntity>>> getVerificationStatus();
}
