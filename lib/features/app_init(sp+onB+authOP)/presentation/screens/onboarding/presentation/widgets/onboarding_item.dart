import 'package:graduation_project_flutter/core/routing/routes_export.dart';

// خصائص الصورة و العنوان و التيكست فقط

class OnboardingItem extends StatelessWidget {
  final OnboardingData model;

  const OnboardingItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // صورة الأونبوردينج
          Expanded(
            flex: 6,
            child: Image.asset(model.image, fit: BoxFit.contain),
          ),

          const SizedBox(height: 15),

          // العنوان
          Text(
            model.title,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 45,
              fontFamily: AppFonts.font,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),

          const SizedBox(height: 15),
          // الوصف
          Text(
            model.description,
            textAlign: TextAlign.left,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 25,
              fontFamily: AppFonts.font,
              fontWeight: FontWeight.w400,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),

          const Spacer(flex: 3),
        ],
      ),
    );
  }
}
