
/// A standalone cover image picker used by the BLoC-independent
/// callers. The main Step 5 flow now uses AppDashedContainer directly,
/// but this widget is kept for any legacy usage.
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
class CoverImagePicker extends StatelessWidget {
  final File? image;
  final VoidCallback onTap;

  const CoverImagePicker({super.key, this.image, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = context.primaryColor;

    if (image != null) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.file(image!, fit: BoxFit.cover),
                // Bottom gradient
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
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.5),
                        ],
                      ),
                    ),
                  ),
                ),
                // Edit button bottom-right
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.edit_outlined,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Empty state with dashed border
    return AppDashedContainer(
      onTap: onTap,
      color: primaryColor.withOpacity(0.4),
      borderRadius: 14,
      child: Container(
        height: 180,
        color: isDark
            ? const Color(0xFF1E2A2E)
            : const Color(0xFFF2F9F9),
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
                size: 30,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Upload Cover Image",
              style: TextStyle(
                fontFamily: AppFonts.font,
                color: primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Recommended: 1200 × 800 px",
              style: TextStyle(
                fontFamily: AppFonts.font,
                color: primaryColor.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
