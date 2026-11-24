
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
class AddPropertyUseCase {
  final AddPropertyRepository repository;

  AddPropertyUseCase(this.repository);

  Future<void> call({
    required PropertyDraftEntity draft,
    required String token,
  }) async {
    // 1. Create Draft Property
    final requestModel = draft.toCreatePropertyRequest();
    final propertyId = await repository.createPropertyDraft(
      data: requestModel,
      token: token,
    );

    // 2. Upload Images
    int sortOrder = 0;

    // Cover image first (if separate from propertyImagePaths)
    final allPaths = <String>[];
    if (draft.coverImagePath != null && draft.coverImagePath!.isNotEmpty) {
      allPaths.add(draft.coverImagePath!);
    }
    for (final path in draft.propertyImagePaths) {
      if (path != draft.coverImagePath) {
        allPaths.add(path);
      }
    }

    int uploadedCount = 0;
    int failedCount = 0;
    final List<String> failedPaths = [];
    String lastErrorMessage = '';

    final uploadFutures = <Future<void>>[];
    for (int i = 0; i < allPaths.length; i++) {
      final filePath = allPaths[i];
      final isCover = filePath == draft.coverImagePath;
      final currentSortOrder = sortOrder++;
      
      uploadFutures.add(
        repository.uploadPropertyMedia(
          propertyId: propertyId,
          filePath: filePath,
          isCover: isCover,
          sortOrder: currentSortOrder,
          token: token,
        ).then((_) {
          uploadedCount++;
        }).catchError((e) {
          failedCount++;
          failedPaths.add(filePath);
          lastErrorMessage = e.toString();
        })
      );
    }
    
    // Do not await uploads here to prevent blocking the UI for a long time.
    // They will continue uploading in the background.
    Future.wait(uploadFutures).then((_) {
      print('Background media upload completed. Uploaded: $uploadedCount, Failed: $failedCount');
    }).catchError((e) {
      print('Background media upload error: $e');
    });

    // 3. Upload Video (optional - also sent to background)
    if (draft.propertyVideoPath != null &&
        draft.propertyVideoPath!.isNotEmpty) {
      repository.uploadPropertyMedia(
        propertyId: propertyId,
        filePath: draft.propertyVideoPath!,
        isCover: false,
        sortOrder: sortOrder++,
        token: token,
      ).catchError((e) {
        print('Background video upload error: $e');
      });
    }

    // 4. Upload Rooms (Rent Room flow only)
    // FIX: Bloc stores transactionType='For Rent' + listingStyle='Room-by-Room'
    // The old check 'Rent Room' never matched. Now correctly checks both fields.
    final isRentRoomFlow =
        draft.transactionType == 'For Rent' &&
        draft.listingStyle == 'Room-by-Room';

    if (isRentRoomFlow && draft.roomsData.isNotEmpty) {
      final roomFutures = <Future<void>>[];
      for (final room in draft.roomsData) {
        final roomModel = CreateRoomRequestModel(
          title: room['title']?.toString() ?? 'Room',
          description: room['description']?.toString(),
          roomType: room['roomType']?.toString() ?? 'Single',
          listingType: 'RentRoom',
          price: (room['price'] as num?)?.toDouble() ?? 0.0,
          pricePeriod: room['pricePeriod']?.toString() ?? 'Monthly',
          areaSquareMeters: (room['size'] as num?)?.toDouble(),
          furnishingStatus: room['furnishingStatus']?.toString(),
          amenities: _parseStringList(room['amenities']),
          isAvailable: true,
          hasPrivateBathroom: room['hasPrivateBathroom'] == true,
          hasBalcony: room['hasBalcony'] == true,
          maxOccupants: (room['capacity'] as num?)?.toInt(),
        );

        roomFutures.add(
          repository.addPropertyRoom(
            propertyId: propertyId,
            data: roomModel,
            token: token,
          )
        );
      }
      await Future.wait(roomFutures);
    }

    // 5. Submit Property — this transitions it from Draft → PendingReview
    await repository.submitProperty(propertyId: propertyId, token: token);

    // 6. Set Availability (if blockedDates exist)
    // We do this AFTER Phase 5 so the property is out of DRAFT status.
    if (draft.blockedDates.isNotEmpty) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final blockedDatesFutures = <Future<void>>[];

      for (final dateStr in draft.blockedDates) {
        try {
          final parsedDate = DateTime.tryParse(dateStr);
          if (parsedDate != null) {
            final dateOnly = DateTime(
              parsedDate.year,
              parsedDate.month,
              parsedDate.day,
            );
            if (dateOnly.isBefore(today)) {
              continue;
            }
          }

          final availabilityData = SetAvailabilityRequestModel(
            startDate: dateStr,
            endDate: dateStr,
            isBlocked: true,
            reason: 'Owner blocked via Calendar',
          );
          
          blockedDatesFutures.add(
            repository.setPropertyAvailability(
              propertyId: propertyId,
              data: availabilityData,
              token: token,
            )
          );
        } catch (_) {
          // ignore failures for individual dates
        }
      }
      
      try {
        await Future.wait(blockedDatesFutures);
      } catch (_) {
        // ignore failures for individual dates
      }
    }
  }

  List<String>? _parseStringList(dynamic value) {
    if (value == null) return null;
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    if (value is String && value.isNotEmpty) {
      return value.split(',').map((e) => e.trim()).toList();
    }
    return null;
  }
}
