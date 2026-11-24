import 'package:graduation_project_flutter/core/routing/routes_export.dart';

// قيمة الصورة و العنوان و التيكست و طريقة عرض الانيميشن و زرار سكيب و زرار جيت ستارتيد و الدوتس اللي بتعرفني رقم الصفحة

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final List<OnboardingData> pages = [
    OnboardingData(
      image: AppImages.onboarding1,
      title: 'No Brokers',
      description:
          'Direct deals between owner and client – no middleman, no extra costs.',
    ),
    OnboardingData(
      image: AppImages.onboarding2,
      title: 'Any Property',
      description:
          'List any type of property – from homes and villas to shops, restaurants, or even factories.',
    ),
    OnboardingData(
      image: AppImages.onboarding3,
      title: 'Dream Home',
      description: 'Easily find your dream home in the location you choose.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cubit = OnboardingCubit();
    final theme = Theme.of(context);

    return BlocBuilder<OnboardingCubit, int>(
      bloc: cubit,
      builder: (context, index) {
        //  تحديد التدرج العام للاشكال البيضاوية حسب الثيم
        final isDark = Theme.of(context).brightness == Brightness.dark;

        final Gradient rightGradient = LinearGradient(
          // الجانب الايمن في الاشكال البيضاوية
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: isDark
              ? const [
                  Color.fromARGB(255, 139, 229, 233),
                  Color.fromARGB(255, 218, 255, 254),
                ]
              : const [Color(0xFF389FA4), Color(0xFF97BCBB)],
          stops: const [0, 0.9],
        );

        final Gradient leftGradient = LinearGradient(
          // الجانب الايسر في الاشكال البيضاوية
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: isDark
              ? const [
                  Color.fromARGB(255, 139, 229, 233),
                  Color.fromARGB(255, 218, 255, 254),
                ]
              : const [Color(0xFF389FA4), Color(0xFF97BCBB)],
          stops: const [0, 0.9],
        );

        return Scaffold(
          backgroundColor: context.scaffoldBgColor,
          body: Stack(
            children: [
              // المستوى العلوي
              MovingEllipse(
                gradient: leftGradient.withOpacity(0.4),
                isLeft: true,
                width: 160,
                height: 75,
                top: 90,
                startVisibleFraction: 0.2,
                endVisibleFraction: 0.8,
                delay: 0,
                duration: const Duration(seconds: 3),
              ),
              MovingEllipse(
                gradient: rightGradient.withOpacity(0.4),
                isLeft: false,
                width: 160,
                height: 75,
                top: 30,
                startVisibleFraction: 0.2,
                endVisibleFraction: 0.8,
                delay: 400,
                duration: const Duration(seconds: 3),
              ),

              // المستوى الأوسط
              MovingEllipse(
                gradient: leftGradient.withOpacity(0.4),
                isLeft: true,
                width: 160,
                height: 75,
                top: 400,
                startVisibleFraction: 0.1,
                endVisibleFraction: 0.5,
                delay: 800,
                duration: const Duration(seconds: 3),
              ),
              MovingEllipse(
                gradient: rightGradient.withOpacity(0.4),
                isLeft: false,
                width: 160,
                height: 75,
                top: 300,
                startVisibleFraction: 0.1,
                endVisibleFraction: 0.5,
                delay: 1200,
                duration: const Duration(seconds: 3),
              ),

              // المستوى السفلي
              MovingEllipse(
                gradient: leftGradient.withOpacity(0.4),
                isLeft: true,
                width: 160,
                height: 75,
                top: 700,
                startVisibleFraction: 0.05,
                endVisibleFraction: 0.25,
                delay: 1600,
                duration: const Duration(seconds: 3),
              ),
              MovingEllipse(
                gradient: rightGradient.withOpacity(0.4),
                isLeft: false,
                width: 160,
                height: 75,
                top: 600,
                startVisibleFraction: 0.05,
                endVisibleFraction: 0.25,
                delay: 2000,
                duration: const Duration(seconds: 3),
              ),

              //  محتوى الصفحة الواحدة
              PageView.builder(
                itemCount: pages.length,
                onPageChanged: (value) => cubit.changePage(value),
                itemBuilder: (context, i) => OnboardingItem(model: pages[i]),
              ),

              // skip Button
              Positioned(
                top: 50,
                right: 20,
                // Skip Button logic
                child: index == pages.length - 1
                    ? const SizedBox()
                    : TextButton(
                        onPressed: () {
                          sl<CacheHelper>().setOnboardingDone();
                          Navigator.pushReplacementNamed(
                            context,
                            Routes.authOptions,
                          );
                        },
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.w800,
                            fontFamily: AppFonts.font,
                            fontSize: 30,
                          ),
                        ),
                      ),
              ),

              // page_indicators اللي بتعرفني انا واقفة فصفحة رقم كام فالاون بوردينج
              Positioned(
                bottom: 60,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        pages.length,
                        (dotIndex) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          width: index == dotIndex ? 30 : 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: index == dotIndex
                                ? theme.primaryColor
                                : theme.secondaryHeaderColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    if (index == pages.length - 1)
                      TextButton(
                        onPressed: () {
                          sl<CacheHelper>().setOnboardingDone();
                          Navigator.pushReplacementNamed(
                            context,
                            Routes.authOptions,
                          );
                        },

                        child: Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: theme.primaryColor,
                            fontFamily: AppFonts.font,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
