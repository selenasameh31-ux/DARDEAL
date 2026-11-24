import '../../domain/entities/verification_document_entity.dart';
import '../../domain/entities/didit_session_entity.dart';

abstract class VerificationState {
  const VerificationState();
}

/// Initial state before any data is loaded.
class VerificationInitial extends VerificationState {
  const VerificationInitial();
}

/// Shown only on the very first load (before any data arrives).
class VerificationLoading extends VerificationState {
  const VerificationLoading();
}

/// A new Didit session was created successfully.
/// UI shows a manual-open button; polling starts immediately.
class VerificationSessionCreated extends VerificationState {
  final DiditSessionEntity session;
  const VerificationSessionCreated(this.session);
}

/// The latest verification status loaded from the API.
/// [latestDoc] is the session with the most recent submittedAt.
class VerificationStatusLoaded extends VerificationState {
  final List<VerificationDocumentEntity> documents;

  /// The most recently submitted document (sorted by submittedAt descending).
  VerificationDocumentEntity? get latestDoc {
    if (documents.isEmpty) return null;
    return documents.reduce((a, b) {
      final aTime = DateTime.tryParse(a.submittedAt) ?? DateTime(0);
      final bTime = DateTime.tryParse(b.submittedAt) ?? DateTime(0);
      return aTime.isAfter(bTime) ? a : b;
    });
  }

  const VerificationStatusLoaded(this.documents);
}


/// A non-fatal error from the API.
class VerificationError extends VerificationState {
  final String message;
  const VerificationError(this.message);
}
