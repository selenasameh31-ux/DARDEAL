
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
class ClearDraftUseCase {
  final AddPropertyRepository _repository;

  ClearDraftUseCase(this._repository);

  Future<void> call({required String prefix}) {
    return _repository.clearDraft(prefix);
  }
}
