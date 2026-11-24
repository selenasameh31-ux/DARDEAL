import 'package:graduation_project_flutter/core/routing/routes_export.dart';

/// A reusable, dynamic progress stepper for the full Offer flow.
///
/// Steps visual states:
///   • Completed  → filled circle with ✓ icon
///   • Current    → outlined circle with number (primary color)
///   • Future     → grey outlined circle with number
///
/// Usage:
/// ```dart
/// OfferProgressStepper(
///   currentStep: 1,           // 0-indexed
///   stepLabels: ['Details', 'Review', 'Decision', 'Lease'],
/// )
/// ```
class OfferProgressStepper extends StatelessWidget {
  final int currentStep;
  final List<String> stepLabels;

  const OfferProgressStepper({
    super.key,
    required this.currentStep,
    required this.stepLabels,
  });

  int get totalSteps => stepLabels.length;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = context.primaryColor;
    final inactiveLineColor = isDark
        ? const Color(0xFF374151)
        : const Color(0xFFE5E7EB);
    final inactiveCircleBorder = isDark
        ? const Color(0xFF4B5563)
        : const Color(0xFFD1D5DB);
    final inactiveTextColor = isDark
        ? const Color(0xFF9CA3AF)
        : const Color(0xFF6B7280);

    return Column(
      children: [
        // ── Circles + lines row ──────────────────────────────────────
        SizedBox(
          height: 36,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background line (full width)
              Positioned(
                left: 24,
                right: 24,
                child: Container(height: 2, color: inactiveLineColor),
              ),
              // Active fill line
              Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: totalSteps > 1
                      ? currentStep / (totalSteps - 1)
                      : 0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24),
                    child: Container(height: 2, color: primaryColor),
                  ),
                ),
              ),
              // Step circles
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(totalSteps, (i) {
                  final isDone = i < currentStep;
                  final isCurrent = i == currentStep;
                  final isFuture = i > currentStep;

                  return _StepCircle(
                    index: i,
                    isDone: isDone,
                    isCurrent: isCurrent,
                    isFuture: isFuture,
                    primaryColor: primaryColor,
                    inactiveBorderColor: inactiveCircleBorder,
                    inactiveTextColor: inactiveTextColor,
                    surfaceColor: colorScheme.surface,
                  );
                }),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // ── Labels row ───────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(totalSteps, (i) {
            final isActive = i <= currentStep;
            return SizedBox(
              width: 48,
              child: Text(
                stepLabels[i],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: AppFonts.font,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? primaryColor : inactiveTextColor,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

// ── Private helper widget ──────────────────────────────────────────────────

class _StepCircle extends StatelessWidget {
  final int index;
  final bool isDone;
  final bool isCurrent;
  final bool isFuture;
  final Color primaryColor;
  final Color inactiveBorderColor;
  final Color inactiveTextColor;
  final Color surfaceColor;

  const _StepCircle({
    required this.index,
    required this.isDone,
    required this.isCurrent,
    required this.isFuture,
    required this.primaryColor,
    required this.inactiveBorderColor,
    required this.inactiveTextColor,
    required this.surfaceColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDone ? primaryColor : surfaceColor,
        border: Border.all(
          color: isFuture ? inactiveBorderColor : primaryColor,
          width: isCurrent ? 2 : 1.5,
        ),
      ),
      child: Center(
        child: isDone
            ? Icon(Icons.check, color: Colors.white, size: 16)
            : Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFonts.font,
                  color: isCurrent ? primaryColor : inactiveTextColor,
                ),
              ),
      ),
    );
  }
}
