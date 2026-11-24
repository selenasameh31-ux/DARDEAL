import 'package:graduation_project_flutter/core/routing/routes_export.dart';

/// Screen shown immediately after the user submits their offer.
/// Step index = 1 (0=Details ✓, 1=Review ←current, 2=Decision, 3=Lease)
class OfferSentSuccessScreen extends StatelessWidget {
  const OfferSentSuccessScreen({super.key});

  static const _stepLabels = ['Details', 'Review', 'Decision', 'Lease'];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: _buildAppBar(context, colorScheme),
      body: SafeArea(
        child: Column(
          children: [
            // ── Progress stepper ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: const OfferProgressStepper(
                currentStep: 1,
                stepLabels: _stepLabels,
              ),
            ),

            // ── Scrollable body ──────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 28,
                ),
                child: Column(
                  children: [
                    // Illustration card
                    const OfferSuccessImageCard(),

                    const SizedBox(height: 28),

                    // Title + subtitle
                    const OfferStatusTextSection(
                      title: 'Offer Sent Successfully',
                      subtitle:
                          'The owner has been notified.\nMost owners reply within 24 hours.',
                    ),

                    const SizedBox(height: 24),

                    // Validity pill
                    const OfferValidityBanner(),

                    // Spacer so button floats at bottom even on short screens
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),

            // ── Sticky CTA button ────────────────────────────────────
            _BottomCTA(colorScheme: colorScheme),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, ColorScheme colorScheme) {
    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: colorScheme.onSurface,
          size: 20,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'APPLICATION STATUS',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          fontFamily: AppFonts.font,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      centerTitle: true,
      // Empty trailing keeps title centred
      actions: const [SizedBox(width: 48)],
    );
  }
}

// ── Sticky bottom CTA ──────────────────────────────────────────────────────

class _BottomCTA extends StatelessWidget {
  final ColorScheme colorScheme;

  const _BottomCTA({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: AppPrimaryButton(
        text: 'Track Progress',
        textColor: Colors.white,
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyOffersScreen()),
          );
        },
      ),
    );
  }
}
