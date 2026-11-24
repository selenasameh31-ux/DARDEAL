
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
class StepNavigationButtons extends StatelessWidget {
  final int step;
  final VoidCallback? onNext;
  final VoidCallback? onBack;
  final VoidCallback? onSaveDraft;
  final VoidCallback? onPublish;
  final bool Function()? onValidate;

  const StepNavigationButtons({
    super.key,
    required this.step,
    this.onNext,
    this.onBack,
    this.onSaveDraft,
    this.onPublish,
    this.onValidate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            /// BACK BUTTON
            if (step > 1) ...[
              Expanded(
                flex: 1,
                child: AppPrimaryButton(
                  text: "Back",
                  isPrimary: false,
                  onPressed: onBack,
                  buttonColor: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF1A2428)
                      : Colors.white,
                  textColor: Theme.of(context).brightness == Brightness.dark
                      ? DarkColors.darkmainColor
                      : LightColors.lightmaincolor,
                  borderColor: Theme.of(context).brightness == Brightness.dark
                      ? DarkColors.darkmainColor
                      : LightColors.lightmaincolor,
                ),
              ),
              const SizedBox(width: 16),
            ],

            /// NEXT / PUBLISH BUTTON
            Expanded(
              flex: 2,
              child: AppPrimaryButton(
                text: step == 9 ? "Publish Property" : "Continue",
                trailingIcon: step == 9 ? null : Icons.arrow_forward_rounded,
                onPressed: () {
                  if (onValidate != null) {
                    if (onValidate!()) {
                      (step == 9 ? onPublish : onNext)?.call();
                    }
                  } else {
                    (step == 9 ? onPublish : onNext)?.call();
                  }
                },
                textColor: Colors.white,
                buttonColor: LightColors.lightmaincolor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 100), // Space for the floating bottom navigation bar and FAB
      ],
    );
  }
}
