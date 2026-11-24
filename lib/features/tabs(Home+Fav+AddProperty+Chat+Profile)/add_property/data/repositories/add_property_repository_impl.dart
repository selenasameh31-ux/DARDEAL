
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
class AddPropertyRepositoryImpl implements AddPropertyRepository {
  final AddPropertyRemoteDataSource remote;
  final PropertyDraftLocalDataSource local;

  AddPropertyRepositoryImpl({required this.remote, required this.local});

  // ── Remote ─────────────────────────────────────────────────
  @override
  Future<int> createPropertyDraft({
    required CreatePropertyRequestModel data,
    required String token,
  }) async {
    final result = await remote.createPropertyDraft(data: data, token: token);
    return result;
  }

  @override
  Future<void> uploadPropertyMedia({
    required int propertyId,
    required String filePath,
    required bool isCover,
    required int sortOrder,
    required String token,
  }) async {
    await remote.uploadPropertyMedia(
      propertyId: propertyId,
      filePath: filePath,
      isCover: isCover,
      sortOrder: sortOrder,
      token: token,
    );
  }

  @override
  Future<void> addPropertyRoom({
    required int propertyId,
    required CreateRoomRequestModel data,
    required String token,
  }) async {
    await remote.addPropertyRoom(
      propertyId: propertyId,
      data: data,
      token: token,
    );
  }

  @override
  Future<void> submitProperty({
    required int propertyId,
    required String token,
  }) async {
    await remote.submitProperty(propertyId: propertyId, token: token);
  }

  @override
  Future<void> setPropertyAvailability({
    required int propertyId,
    required SetAvailabilityRequestModel data,
    required String token,
  }) async {
    await remote.setPropertyAvailability(
      propertyId: propertyId,
      data: data,
      token: token,
    );
  }

  // ── Local Draft ─────────────────────────────────────────────
  @override
  Future<void> saveDraft(String prefix, PropertyDraftEntity entity) =>
      local.saveDraft(prefix, entity);

  @override
  Future<PropertyDraftEntity?> loadDraft(String prefix) =>
      local.loadDraft(prefix);

  @override
  Future<void> clearDraft(String prefix) => local.clearDraft(prefix);

  @override
  Future<String?> getLastActiveFlow() => local.getLastActiveFlow();

  @override
  Future<void> setLastActiveFlow(String prefix) =>
      local.setLastActiveFlow(prefix);
}
