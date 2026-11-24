
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
class SaveDraftUseCase {
  final AddPropertyRepository _repository;

  SaveDraftUseCase(this._repository);

  Future<void> call({
    required String prefix,
    required PropertyDraftEntity entity,
  }) {
    return _repository.saveDraft(prefix, entity);
  }
}
