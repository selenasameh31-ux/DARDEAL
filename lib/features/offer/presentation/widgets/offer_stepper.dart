import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class OfferStepper extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String>? stepLabels;

  const OfferStepper({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.stepLabels,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = context.primaryColor;
    final inactiveColor = isDark 
        ? DarkColors.darkTextFieldColor 
        : const Color(0xFFEAF4F6); // Light green line for stepper

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalSteps * 2 - 1, (index) {
              if (index.isEven) {
                // Circle
                final stepIndex = index ~/ 2;
                final isActive = stepIndex <= currentStep;
                return Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive ? activeColor : inactiveColor,
                  ),
                  child: Center(
                    child: stepIndex < currentStep
                        ? Icon(Icons.check, color: Colors.white, size: 16)
                        : Text(
                            '${stepIndex + 1}',
                            style: TextStyle(
                              color: isActive ? Colors.white : (isDark ? Colors.grey : Colors.black54),
                              fontWeight: FontWeight.bold,
                              fontFamily: AppFonts.font,
                            ),
                          ),
                  ),
                );
              } else {
                // Line
                final stepIndex = index ~/ 2;
                final isActive = stepIndex < currentStep;
                return Expanded(
                  child: Container(
                    height: 4,
                    color: isActive ? activeColor : inactiveColor,
                  ),
                );
              }
            }),
          ),
          if (stepLabels != null && stepLabels!.length == totalSteps) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(totalSteps, (index) {
                final isActive = index <= currentStep;
                return Text(
                  stepLabels![index],
                  style: TextStyle(
                    color: isActive ? activeColor : Colors.grey,
                    fontSize: 12,
                    fontFamily: AppFonts.font,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                );
              }),
            ),
          ]
        ],
      ),
    );
  }
}
