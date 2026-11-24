
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
class MediaStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const MediaStep({super.key, required this.onNext, required this.onBack});

  @override
  State<MediaStep> createState() => _MediaStepState();
}

class _MediaStepState extends State<MediaStep> {
  String? _imageError;

  Future<void> _pickImages(BuildContext context) async {
    try {
      final List<AssetEntity>? result = await AssetPicker.pickAssets(
        context,
        pickerConfig: const AssetPickerConfig(
          maxAssets: 20,
          requestType: RequestType.image,
        ),
      );
      if (result != null && result.isNotEmpty) {
        final List<File> files = [];
        for (var entity in result) {
          final file = await entity.file;
          if (file != null) files.add(file);
        }
        if (context.mounted) {
          setState(() => _imageError = null);
          context.read<AddPropertyBloc>().add(
            AddPropertyImagesPickedEvent(files),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        AppSnackBar.error(context, "Gallery Error: $e");
      }
    }
  }

  Future<void> _pickVideo(BuildContext context) async {
    try {
      final List<AssetEntity>? result = await AssetPicker.pickAssets(
        context,
        pickerConfig: const AssetPickerConfig(
          maxAssets: 1,
          requestType: RequestType.video,
        ),
      );
      if (result != null && result.isNotEmpty) {
        final file = await result.first.file;
        if (file != null && context.mounted) {
          context.read<AddPropertyBloc>().add(
            AddPropertyVideoEvent(
              file,
              onError: (msg) {
                if (context.mounted) {
                  AppSnackBar.error(context, msg);
                }
              },
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        AppSnackBar.error(context, "Gallery Error: $e");
      }
    }
  }

  Future<void> _editImage(BuildContext context, int index) async {
    try {
      final List<AssetEntity>? result = await AssetPicker.pickAssets(
        context,
        pickerConfig: const AssetPickerConfig(
          maxAssets: 1,
          requestType: RequestType.image,
        ),
      );
      if (result != null && result.isNotEmpty) {
        final file = await result.first.file;
        if (file != null && context.mounted) {
          context.read<AddPropertyBloc>().add(
            EditPropertyImageEvent(index, file),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        AppSnackBar.error(context, "Gallery Error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = context.primaryColor;

    return BlocBuilder<AddPropertyBloc, AddPropertyState>(
      builder: (context, state) {
        final totalImages =
            (state.coverImage != null ? 1 : 0) + state.propertyImages.length;

        return Material(
          color: context.scaffoldBgColor,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const StepHeader(),
                const SizedBox(height: 16),

                // ── Title ──────────────────────────
                Text(
                  "Photos & Videos",
                  style: TextStyle(
                    fontFamily: AppFonts.font,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: context.titleColor,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Upload at least 5 photos. First photo becomes the cover image.",
                  style: TextStyle(
                    fontFamily: AppFonts.font,
                    fontSize: 13,
                    color: isDark ? Colors.white60 : const Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Photo Counter Row ───────────────
                _buildCounterRow(context, totalImages, isDark, primaryColor),
                if (_imageError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 4),
                    child: Text(
                      _imageError!,
                      style: TextStyle(color: Colors.redAccent, fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 16),

                // ── Cover Photo ─────────────────────
                _buildCoverSection(context, state, isDark, primaryColor),
                const SizedBox(height: 12),

                // ── Gallery Grid ────────────────────
                _buildGalleryGrid(context, state, isDark, primaryColor),
                const SizedBox(height: 8),

                // ── Drag Hint ───────────────────────
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.drag_indicator,
                        size: 14,
                        color: isDark ? Colors.white38 : Colors.grey.shade400,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Long-press to drag & reorder",
                        style: TextStyle(
                          fontFamily: AppFonts.font,
                          fontSize: 11,
                          color: isDark ? Colors.white38 : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ── Video Tour (optional) ───────────
                _buildVideoSection(context, state, isDark, primaryColor),
                const SizedBox(height: 24),

                // ── Photography Tips ────────────────
                const PhotographyTipsCard(),
                const SizedBox(height: 24),

                // ── Navigation ──────────────────────
                StepNavigationButtons(
                  step: 6,
                  onNext: () {
                    final imgCount =
                        (state.coverImage != null ? 1 : 0) +
                        state.propertyImages.length;

                    if (imgCount < 5) {
                      setState(() {
                        _imageError =
                            "Please select at least 5 photos to continue.";
                      });
                      AppSnackBar.error(
                        context,
                        'Please select at least 5 photos to continue.',
                      );
                    } else {
                      widget.onNext();
                    }
                  },
                  onBack: widget.onBack,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Counter Row ──────────────────────────────────────────────────────────
  Widget _buildCounterRow(
    BuildContext context,
    int total,
    bool isDark,
    Color primaryColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: primaryColor.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.photo_library_outlined, size: 14, color: primaryColor),
              const SizedBox(width: 4),
              Text(
                total < 5 ? "$total / 5 minimum" : "$total / 20 photos",
                style: TextStyle(
                  fontFamily: AppFonts.font,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: total < 5 ? context.attentionColor : primaryColor,
                ),
              ),
            ],
          ),
        ),
        Text(
          "Max 20MB per file",
          style: TextStyle(
            fontFamily: AppFonts.font,
            fontSize: 11,
            color: isDark ? Colors.white38 : Colors.grey.shade400,
          ),
        ),
      ],
    );
  }

  // ── Cover Section ─────────────────────────────────────────────────────────
  Widget _buildCoverSection(
    BuildContext context,
    AddPropertyState state,
    bool isDark,
    Color primaryColor,
  ) {
    final hasCover = state.coverImage != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: LightColors.lightmaincolor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: Colors.white, size: 11),
                  SizedBox(width: 4),
                  Text(
                    "COVER",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: hasCover ? null : () => _pickImages(context),
          child: Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: hasCover
                  ? null
                  : (isDark
                        ? const Color(0xFF1E2A2E)
                        : const Color(0xFFF2F9F9)),
            ),
            child: hasCover
                ? _buildCoverImageWidget(context, state.coverImage!, isDark)
                : _buildCoverEmptyState(
                    primaryColor,
                    () => _pickImages(context),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildCoverImageWidget(BuildContext context, File image, bool isDark) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(image, fit: BoxFit.cover),
          // Dark overlay at bottom for buttons
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
                ),
              ),
            ),
          ),
          // Edit + Delete buttons
          Positioned(
            bottom: 10,
            right: 10,
            child: Row(
              children: [
                _buildActionBtn(
                  icon: Icons.edit_outlined,
                  onTap: () => _editImage(context, -1),
                ),
                const SizedBox(width: 8),
                _buildActionBtn(
                  icon: Icons.delete_outline,
                  onTap: () => context.read<AddPropertyBloc>().add(
                    RemovePropertyImageEvent(-1),
                  ),
                  color: Colors.redAccent.withOpacity(0.85),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverEmptyState(Color primaryColor, VoidCallback onTap) {
    return AppDashedContainer(
      onTap: onTap,
      color: primaryColor.withOpacity(0.4),
      borderRadius: 14,
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_photo_alternate_outlined,
                color: primaryColor,
                size: 32,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Cover Photo",
              style: TextStyle(
                fontFamily: AppFonts.font,
                color: primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Tap to upload • Recommended 1200×800",
              style: TextStyle(
                fontFamily: AppFonts.font,
                color: primaryColor.withOpacity(0.6),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Gallery Grid ──────────────────────────────────────────────────────────
  Widget _buildGalleryGrid(
    BuildContext context,
    AddPropertyState state,
    bool isDark,
    Color primaryColor,
  ) {
    final images = state.propertyImages;
    // Show existing images + 1 "Add More" card (if < 20 total)
    final totalItems =
        images.length +
        (images.length + (state.coverImage != null ? 1 : 0) < 20 ? 1 : 0);

    return ReorderableGridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: totalItems,
      onReorder: (oldIndex, newIndex) {
        if (oldIndex < images.length && newIndex < images.length) {
          context.read<AddPropertyBloc>().add(
            ReorderPropertyImagesEvent(oldIndex, newIndex),
          );
        }
      },
      itemBuilder: (context, index) {
        if (index == images.length) {
          return SizedBox(
            key: const ValueKey("add_more_card"),
            child: _buildAddMoreCard(context, primaryColor, isDark),
          );
        }
        return SizedBox(
          key: ValueKey("gallery_item_$index"),
          child: _buildGalleryItem(
            context,
            images[index],
            index,
            state,
            isDark,
          ),
        );
      },
    );
  }

  Widget _buildGalleryItem(
    BuildContext context,
    File file,
    int index,
    AddPropertyState state,
    bool isDark,
  ) {
    final progress = state.uploadProgress[index];
    final isUploading = progress != null && progress < 1.0;

    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(file, fit: BoxFit.cover),
        ),
        // Upload overlay
        if (isUploading)
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 2,
                  color: LightColors.lightmaincolor,
                ),
                const SizedBox(height: 4),
                Text(
                  "${(progress * 100).toInt()}%",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        // Remove button (top-right X)
        if (!isUploading)
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => context.read<AddPropertyBloc>().add(
                RemovePropertyImageEvent(index),
              ),
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, color: Colors.white, size: 13),
              ),
            ),
          ),
        // Set as cover on long-press hint (bottom pin icon)
        if (!isUploading)
          Positioned(
            bottom: 4,
            left: 4,
            child: GestureDetector(
              onTap: () => context.read<AddPropertyBloc>().add(
                SetCoverImageEvent(index),
              ),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.45),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(Icons.star_border, color: Colors.white, size: 12),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAddMoreCard(
    BuildContext context,
    Color primaryColor,
    bool isDark,
  ) {
    return AppDashedContainer(
      onTap: () => _pickImages(context),
      color: primaryColor.withOpacity(0.35),
      borderRadius: 10,
      child: Container(
        color: primaryColor.withOpacity(0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.camera_alt_outlined,
                color: primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Add More",
              style: TextStyle(
                fontFamily: AppFonts.font,
                color: primaryColor,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Video Section ────────────────────────────────────────────────────────
  Widget _buildVideoSection(
    BuildContext context,
    AddPropertyState state,
    bool isDark,
    Color primaryColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Video Tour (optional)",
          style: TextStyle(
            fontFamily: AppFonts.font,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 10),
        state.propertyVideo == null
            ? AppDashedContainer(
                onTap: () => _pickVideo(context),
                color: primaryColor.withOpacity(0.4),
                borderRadius: 14,
                child: Container(
                  height: 60,
                  width: double.infinity,
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.videocam_outlined,
                        color: primaryColor,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Upload Video",
                        style: TextStyle(
                          fontFamily: AppFonts.font,
                          color: primaryColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "(MP4, max 50MB)",
                        style: TextStyle(
                          fontFamily: AppFonts.font,
                          color: isDark
                              ? Colors.white54
                              : const Color(0xFF94A3B8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container(
                // Video selected view
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E2A2E)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: context.buttonBorderColor),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.movie_creation_outlined,
                        color: primaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.propertyVideo!.path.split('/').last,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: AppFonts.font,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: context.titleColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${(state.propertyVideo!.lengthSync() / (1024 * 1024)).toStringAsFixed(1)} MB",
                            style: TextStyle(
                              fontFamily: AppFonts.font,
                              fontSize: 11,
                              color: isDark
                                  ? Colors.white54
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.read<AddPropertyBloc>().add(
                        RemovePropertyVideoEvent(),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.close, color: Colors.white, size: 14),
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }

  // ── Action button helper ───────────────────────────────────────────────────
  Widget _buildActionBtn({
    required IconData icon,
    required VoidCallback onTap,
    Color color = Colors.black54,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}
