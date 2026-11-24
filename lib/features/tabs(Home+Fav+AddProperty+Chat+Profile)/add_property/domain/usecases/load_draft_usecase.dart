
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
class LoadDraftUseCase {
  final AddPropertyRepository _repository;

  LoadDraftUseCase(this._repository);

  Future<PropertyDraftEntity?> call({required String prefix}) {
    return _repository.loadDraft(prefix);
  }
}
