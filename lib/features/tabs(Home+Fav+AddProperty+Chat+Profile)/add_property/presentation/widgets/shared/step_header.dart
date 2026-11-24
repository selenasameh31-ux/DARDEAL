
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
class StepHeader extends StatelessWidget {
  final VoidCallback? onSaveAndExit;
  final VoidCallback? onBack; // custom back action (e.g. return to previous tab)
  final String? stepName;

  const StepHeader({Key? key, this.onSaveAndExit, this.onBack, this.stepName})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mainColor = context.primaryColor;
    final navContext = StepNavigationContext.of(context);
    final currentStep = navContext?.current ?? 0;
    final totalSteps = navContext?.total ?? 1;

    // We check if it's the pre-step (currentStep == 0)
    final isPreStep = currentStep == 0;
    final percentValue = isPreStep ? 0.0 : ((currentStep / totalSteps) * 100);
    final percentString = percentValue.toStringAsFixed(
      percentValue.truncateToDouble() == percentValue ? 0 : 1,
    );

    const headerTitle = 'Add Property';

    // Use onBack from context (provided by add_property_screen) if available,
    // fall back to widget-level onBack, then Navigator.pop.
    final contextOnBack = navContext?.onBack;
    final effectiveOnBack = contextOnBack ?? onBack;
    // At step 0, onBack is null → hide the arrow entirely
    final showBackArrow = effectiveOnBack != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Row: Back button (hidden at step 0), fixed title, Save & Exit
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (showBackArrow)
              IconButton(
                icon: Icon(Icons.arrow_back_ios_new, size: 18),
                onPressed: effectiveOnBack,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              )
            else
              const SizedBox(width: 48), // keeps title centred
            Text(
              headerTitle,
              style: TextStyle(
                fontFamily: AppFonts.font,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: context.titleColor,
              ),
            ),
            TextButton(
              onPressed:
                  onSaveAndExit ??
                  () {
                    context.read<AddPropertyBloc>().add(
                      UpdateCurrentStepEvent(currentStep, saveDraft: true),
                    );
                    AppSnackBar.success(
                      context,
                      'Draft saved successfully!',
                      isTop: true,
                    );
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Routes.mainLayout,
                      (route) => false,
                    );
                  },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Save & Exit',
                style: TextStyle(
                  fontFamily: AppFonts.font,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: mainColor,
                ),
              ),
            ),
          ],
        ),
        if (!isPreStep) ...[
          const SizedBox(height: 8),
          // Step info row with percentage
          Row(
            children: [
              Text(
                stepName != null
                    ? 'STEP $currentStep OF $totalSteps • ${stepName!.toUpperCase()}'
                    : 'STEP $currentStep OF $totalSteps',
                style: TextStyle(
                  fontFamily: AppFonts.font,
                  fontSize: 12,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w800,
                  color: mainColor,
                ),
              ),
              const Spacer(),
              Text(
                '$percentString%',
                style: TextStyle(
                  fontFamily: AppFonts.font,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white54 : const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Segmented progress bar (step based)
          Row(
            children: List.generate(totalSteps, (index) {
              final isActive = index < currentStep;
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  height: 3,
                  decoration: BoxDecoration(
                    color: isActive
                        ? mainColor
                        : (isDark
                              ? Colors.white.withOpacity(0.1)
                              : const Color(0xFFF1F5F9)),
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}
