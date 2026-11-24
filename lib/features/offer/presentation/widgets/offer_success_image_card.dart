import 'package:graduation_project_flutter/core/routing/routes_export.dart';

/// Displays the paper-plane success illustration card.
/// The card has a sky-blue tinted background with a bottom gradient fade.
class OfferSuccessImageCard extends StatelessWidget {
  const OfferSuccessImageCard({super.key});

  static const _imageUrl =
      'https://images.unsplash.com/photo-1548438294-1ad5d5f4f063'
      '?w=600&auto=format&fit=crop&q=80';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        width: double.infinity,
        height: 260,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Background tint ─────────────────────────────────────
            ColoredBox(
              color: isDark
                  ? const Color(0xFF1E3A5F).withValues(alpha: 0.3)
                  : const Color(0xFFEFF6FF),
            ),

            // ── Image ───────────────────────────────────────────────
            Image.network(
              _imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (_, child, progress) =>
                  progress == null ? child : const SizedBox.shrink(),
              errorBuilder: (_, __, ___) => Center(
                child: Icon(
                  Icons.send_rounded,
                  size: 72,
                  color: isDark
                      ? DarkColors.darkmainColor.withValues(alpha: 0.6)
                      : LightColors.lightmaincolor.withValues(alpha: 0.4),
                ),
              ),
            ),

            // ── Bottom gradient fade ─────────────────────────────────
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      colorScheme.surface.withValues(alpha: 0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
