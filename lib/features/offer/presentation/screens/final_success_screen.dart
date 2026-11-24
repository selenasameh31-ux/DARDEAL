import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class FinalSuccessScreen extends StatelessWidget {
  const FinalSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = isDark
        ? DarkColors.darkBackGround
        : LightColors.lightBackGround;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? Colors.white : colorScheme.onSurface,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'SUCCESS',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: isDark ? context.hintColor : context.hintColor,
            fontFamily: AppFonts.font,
          ),
        ),
        centerTitle: true,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 24),
              child: Text(
                '100%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDark ? context.hintColor : context.hintColor,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Progress Stepper ─────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: OfferProgressStepper(
                currentStep: 4, // All 4 steps marked as DONE
                stepLabels: ['Details', 'Review', 'Payment', 'Handover'],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SuccessIconSection(),
                    const SizedBox(height: 32),
                    _buildTextSection(context, isDark),
                    const SizedBox(height: 48),
                    const StatusStepsSection(),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: Column(
                children: [
                  AppPrimaryButton(
                    text: 'Done',
                    buttonColor: context.primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.mainLayout,
                        (route) => false,
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  const OfferHelpButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextSection(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Text(
            'Transaction Successful',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.font,
              color: context.titleColor87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Your funds have been released to the seller. You can now access your property documents.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? context.hintColor : context.hintColor,
              height: 1.5,
              fontFamily: AppFonts.font,
            ),
          ),
        ],
      ),
    );
  }
}

class SuccessIconSection extends StatelessWidget {
  const SuccessIconSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      height: 200,
      width: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Soft Glow Circle
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.green.withOpacity(isDark ? 0.15 : 0.08),
                  Colors.green.withOpacity(0),
                ],
              ),
            ),
          ),
          // Inner White/Dark Surface Circle
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? DarkColors.darkTextFieldColor : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : context.textFieldBgColor,
                width: 1,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.apartment_rounded,
                size: 56,
                color: Colors.green,
              ),
            ),
          ),
          // Success Badge
          Positioned(
            bottom: 40,
            right: 40,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? DarkColors.darkTextFieldColor : Colors.white,
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(Icons.check, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class StatusStepsSection extends StatelessWidget {
  const StatusStepsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 16),
            child: Text(
              'NEXT STEPS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: isDark ? context.hintColor : context.hintColor,
              ),
            ),
          ),
          _buildActionRow(
            context,
            'Review your contract',
            Icons.description_outlined,
            isPrimary: true,
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow(
    BuildContext context,
    String title,
    IconData icon, {
    bool isPrimary = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = context.primaryColor;
    final surfaceColor = isDark
        ? Colors.white.withOpacity(0.05)
        : Colors.grey[50];

    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: primaryColor, size: 18),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: context.titleColor87,
                  fontFamily: AppFonts.font,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: isDark ? context.hintColor : context.hintColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(BuildContext context, String title, bool isCompleted) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark
        ? Colors.white.withOpacity(0.05)
        : Colors.grey[50];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check, color: Colors.green, size: 18),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: context.titleColor87,
                fontFamily: AppFonts.font,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OfferHelpButton extends StatelessWidget {
  const OfferHelpButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = context.primaryColor;

    return Center(
      child: TextButton(
        onPressed: () {},
        child: Text(
          'Need Help?',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: primaryColor,
            fontFamily: AppFonts.font,
          ),
        ),
      ),
    );
  }
}
