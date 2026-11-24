import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class AppImageUploader extends StatelessWidget {
  final List<File> images;
  final File? coverImage;
  final Map<int, double>? uploadProgress;
  final VoidCallback onAddImage;
  final Function(int index) onRemoveImage;
  final Function(int index)? onEditImage;
  final int maxImages;
  final int gridCrossAxisCount;

  const AppImageUploader({
    super.key,
    required this.images,
    this.coverImage,
    this.uploadProgress,
    required this.onAddImage,
    required this.onRemoveImage,
    this.onEditImage,
    this.maxImages = 5,
    this.gridCrossAxisCount = 2,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    const addColor = LightColors.lightmaincolor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (coverImage != null) ...[
          _buildCoverImage(context, isDark),
          const SizedBox(height: 16),
        ],
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridCrossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1, // square cards
          ),
          itemCount: images.length + (images.length < maxImages ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == images.length) {
              return _buildAddMoreCard(addColor, isDark);
            }
            return _buildGridImage(context, index);
          },
        ),
      ],
    );
  }

  Widget _buildCoverImage(BuildContext context, bool isDark) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: FileImage(coverImage!),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Badge
        Positioned(
          top: 12,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: LightColors.lightmaincolor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, color: Colors.white, size: 14),
                SizedBox(width: 4),
                Text(
                  "COVER PHOTO",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Edit and Delete buttons bottom right
        Positioned(
          bottom: 12,
          right: 12,
          child: Row(
            children: [
              if (onEditImage != null)
                _buildActionButton(
                  icon: Icons.edit,
                  onTap: () => onEditImage!(-1), // -1 for cover
                  color: Colors.white.withOpacity(0.3),
                  iconColor: Colors.white,
                ),
              if (onEditImage != null) const SizedBox(width: 8),
              _buildActionButton(
                icon: Icons.delete_outline,
                onTap: () => onRemoveImage(-1), // -1 for cover
                color: Colors.white.withOpacity(0.3),
                iconColor: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGridImage(BuildContext context, int index) {
    final file = images[index];
    final progress = uploadProgress?[index];
    final bool isUploading = progress != null && progress < 1.0;

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(image: FileImage(file), fit: BoxFit.cover),
          ),
        ),
        // Upload Overlay
        if (isUploading)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white.withOpacity(0.6),
            ),
            child: const Center(child: CircularProgressIndicator()),
          ),
        // Delete button top right
        if (!isUploading)
          Positioned(
            top: 4,
            right: 4,
            child: _buildActionButton(
              icon: Icons.close,
              onTap: () => onRemoveImage(index),
              color: const Color(0xFFF27E35), // Primary orange
              iconColor: Colors.white,
              size: 24,
              iconSize: 14,
            ),
          ),
        // Edit button bottom right
        if (!isUploading && onEditImage != null)
          Positioned(
            bottom: 4,
            right: 4,
            child: _buildActionButton(
              icon: Icons.edit,
              onTap: () => onEditImage!(index),
              color: Colors.white.withOpacity(0.8),
              iconColor: Colors.black,
              size: 24,
              iconSize: 14,
            ),
          ),
      ],
    );
  }

  Widget _buildAddMoreCard(Color addColor, bool isDark) {
    return AppDashedContainer(
      onTap: onAddImage,
      color: addColor,
      borderRadius: 12.0,
      child: Container(
        color: addColor.withOpacity(0.05), // Light tint
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: addColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.camera_alt, color: addColor, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              "Add More",
              style: TextStyle(
                color: addColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Up to 20mb",
              style: TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
    required Color iconColor,
    double size = 32,
    double iconSize = 18,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Center(
          child: Icon(icon, size: iconSize, color: iconColor),
        ),
      ),
    );
  }
}
