
/// Domain-layer contract for the Add Property feature.
///
/// - [submitProperty] → RemoteDataSource (API)
/// - [saveDraft] / [loadDraft] / [clearDraft] → LocalDataSource (SharedPreferences)
///
/// The Bloc depends ONLY on this abstract interface — never on its implementation.
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
abstract class AddPropertyRepository {
  // ── Remote ─────────────────────────────────────────────────
  Future<int> createPropertyDraft({
    required CreatePropertyRequestModel data,
    required String token,
  });

  Future<void> uploadPropertyMedia({
    required int propertyId,
    required String filePath,
    required bool isCover,
    required int sortOrder,
    required String token,
  });

  Future<void> addPropertyRoom({
    required int propertyId,
    required CreateRoomRequestModel data,
    required String token,
  });

  Future<void> setPropertyAvailability({
    required int propertyId,
    required SetAvailabilityRequestModel data,
    required String token,
  });

  Future<void> submitProperty({
    required int propertyId,
    required String token,
  });

  // ── Local Draft ─────────────────────────────────────────────
  Future<void> saveDraft(String prefix, PropertyDraftEntity entity);

  Future<PropertyDraftEntity?> loadDraft(String prefix);

  Future<void> clearDraft(String prefix);

  Future<String?> getLastActiveFlow();

  Future<void> setLastActiveFlow(String prefix);
}
