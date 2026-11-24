
// ─────────────────────────────────────────────────────────────────────────────
// CONTRACT
// ─────────────────────────────────────────────────────────────────────────────
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
abstract class AddPropertyRemoteDataSource {
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

  Future<void> submitProperty({required int propertyId, required String token});
}

// ─────────────────────────────────────────────────────────────────────────────
// IMPLEMENTATION
// ─────────────────────────────────────────────────────────────────────────────
class AddPropertyRemoteDataSourceImpl implements AddPropertyRemoteDataSource {
  final ApiConsumer api;

  AddPropertyRemoteDataSourceImpl(this.api);

  // ── 1. Create Property Draft ─────────────────────────────────────────────
  // POST /api/v1/Properties
  // Returns: standard API envelope { success, data: { id, ... }, message }
  @override
  Future<int> createPropertyDraft({
    required CreatePropertyRequestModel data,
    required String token,
  }) async {
    final payload = data.toJson();

    try {
      final response = await api.post(
        EndPoints.createProperty,
        data: payload,
        token: token,
      );

      // Extract propertyId from API envelope.
      // Backend wraps response as: { success: true, data: { id: 42, ... } }
      final responseData = response.data;
      int? propertyId;

      if (responseData is Map) {
        // Standard envelope: { data: { id: 42 } }
        final inner = responseData['data'];
        if (inner is Map) {
          propertyId = (inner['id'] as num?)?.toInt();
        }
        // Fallback: { id: 42 } at top level
        propertyId ??= (responseData['id'] as num?)?.toInt();
      } else if (responseData is int) {
        // Some backends return just the ID directly
        propertyId = responseData;
      }
      if (propertyId == null || propertyId <= 0) {
        throw ServerException(
          'Property creation failed: could not extract a valid property ID from server response.',
        );
      }

      return propertyId;
    } catch (e) {
      rethrow;
    }
  }

  // ── 2. Upload Property Media ─────────────────────────────────────────────
  // POST /api/v1/Properties/{id}/media  (multipart/form-data)
  // Fields: file (binary), isCover (bool), sortOrder (int)
  // Optional: roomId (int) — not used in Add Property flow
  @override
  Future<void> uploadPropertyMedia({
    required int propertyId,
    required String filePath,
    required bool isCover,
    required int sortOrder,
    required String token,
  }) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        filePath,
        filename: filePath.split('/').last.split('\\').last,
      ),
      'isCover': isCover.toString(),
      'sortOrder': sortOrder.toString(),
    });

    // Uses EndPoints.propertyMedia() which returns a RELATIVE path.
    // DioConsumer's baseUrl handles the host automatically.
    await api.post(
      EndPoints.propertyMedia(propertyId),
      data: formData,
      token: token,
    );
  }

  // ── 3. Add Property Room ─────────────────────────────────────────────────
  // POST /api/v1/Properties/{id}/rooms
  @override
  Future<void> addPropertyRoom({
    required int propertyId,
    required CreateRoomRequestModel data,
    required String token,
  }) async {
    await api.post(
      EndPoints.propertyRooms(propertyId),
      data: data.toJson(),
      token: token,
    );
  }

  // ── 4. Set Availability ──────────────────────────────────────────────────
  @override
  Future<void> setPropertyAvailability({
    required int propertyId,
    required SetAvailabilityRequestModel data,
    required String token,
  }) async {
    await api.post(
      EndPoints.propertyAvailability(propertyId),
      data: data.toJson(),
      token: token,
    );
  }

  // ── 5. Submit Property ───────────────────────────────────────────────────
  // POST /api/v1/Properties/{id}/submit
  @override
  Future<void> submitProperty({
    required int propertyId,
    required String token,
  }) async {
    await api.post(EndPoints.propertySubmit(propertyId), token: token);
  }
}
