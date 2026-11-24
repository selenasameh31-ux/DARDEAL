import 'package:graduation_project_flutter/core/routing/routes_export.dart';

/// A stateless helper for picking images and videos from the gallery or camera.
///
/// All error reporting is done via [AppSnackBar] for UI consistency.
/// This helper does NOT hold state — it returns results directly to the caller.
class MediaPickerHelper {
  MediaPickerHelper._();

  static final ImagePicker _imagePicker = ImagePicker();

  /// Pick multiple images and/or videos from the gallery.
  static Future<List<File>?> pickGalleryMedia(
    BuildContext context, {
    int maxAssets = 10,
  }) async {
    try {
      final List<AssetEntity>? result = await AssetPicker.pickAssets(
        context,
        pickerConfig: AssetPickerConfig(
          maxAssets: maxAssets,
          requestType: RequestType.common,
        ),
      );

      if (result != null && result.isNotEmpty) {
        final List<File> files = [];
        for (final entity in result) {
          final file = await entity.file;
          if (file != null) files.add(file);
        }
        return files;
      }
    } catch (e) {
      if (context.mounted) {
        AppSnackBar.error(context, 'Gallery Error: $e');
      }
    }
    return null;
  }

  /// Capture a single photo using the device camera.
  static Future<File?> pickCameraImage(BuildContext context) async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
      );
      if (photo != null) return File(photo.path);
    } catch (e) {
      if (context.mounted) {
        AppSnackBar.error(context, 'Camera Error: $e');
      }
    }
    return null;
  }

  /// Capture a single video using the device camera.
  static Future<File?> pickCameraVideo(BuildContext context) async {
    try {
      final XFile? video = await _imagePicker.pickVideo(
        source: ImageSource.camera,
      );
      if (video != null) return File(video.path);
    } catch (e) {
      if (context.mounted) {
        AppSnackBar.error(context, 'Camera Error: $e');
      }
    }
    return null;
  }
}
