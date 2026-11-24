import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String selectedRole = "seeker";
  bool isInterestedInBoth = false;

  /// Maps local selection → API-expected string
  String get _apiRole {
    if (isInterestedInBoth) return "Both";
    return selectedRole == "owner" ? "Owner" : "Seeker";
  }

  void _onContinue(BuildContext context) {
    context.read<RoleSelectionBloc>().add(
      RoleSelectionRequested(role: _apiRole),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final titAndSubTitleleColor = isDark
        ? DarkColors.darkTitleAndSubTitleText
        : LightColors.lightTitleAndSubTitleText;

    final hintColor = isDark
        ? DarkColors.darkHintTextFieldColor
        : LightColors.lightHintTextFieldColor;

    final bodyColor = isDark
        ? DarkColors.darkBodyColors
        : LightColors.lightBodyColors;

    final attentionColor = isDark
        ? DarkColors.darkAttentionText
        : LightColors.lightAttentionText;

    return BlocProvider(
      create: (_) => sl<RoleSelectionBloc>(),
      child: BlocListener<RoleSelectionBloc, RoleSelectionState>(
        listener: (context, state) {
          if (state is RoleSelectionSuccess) {
            // Update session with the fresh tokens returned by the API
            context.read<SessionCubit>().authenticateUser(
              state.auth.user,
              state.auth.token,
              refreshToken: state.auth.refreshToken,
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.mainLayout,
              (route) => false,
            );
          }
          if (state is RoleSelectionFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red.shade700,
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 40,
                        ),
                        child: Column(
                          children: [
                            /// Title
                            Text(
                              "Choose Your Role",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                fontFamily: AppFonts.font,
                                color: titAndSubTitleleColor,
                              ),
                            ),

                            const SizedBox(height: 10),

                            /// Subtitle
                            Text(
                              "Select your role to start enjoying the app features",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: AppFonts.font,
                                color: titAndSubTitleleColor,
                              ),
                            ),

                            const SizedBox(height: 50),

                            /// Role Cards
                            Row(
                              children: [
                                Expanded(
                                  child: _buildCard(
                                    context: context,
                                    title: "Owner",
                                    subtitle:
                                        "List and manage your properties easily",
                                    image: AppImages.owner,
                                    isSelected:
                                        isInterestedInBoth ||
                                        selectedRole == "owner",
                                    onTap: () {
                                      setState(() {
                                        selectedRole = "owner";
                                        isInterestedInBoth = false;
                                      });
                                    },
                                  ),
                                ),

                                const SizedBox(width: 15),

                                Expanded(
                                  child: _buildCard(
                                    context: context,
                                    title: "Seeker",
                                    subtitle: "Find your dream property easily",
                                    image: AppImages.seeker,
                                    isSelected:
                                        isInterestedInBoth ||
                                        selectedRole == "seeker",
                                    onTap: () {
                                      setState(() {
                                        selectedRole = "seeker";
                                        isInterestedInBoth = false;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 35),

                            /// "Interested in Both" Checkbox
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => setState(
                                    () => isInterestedInBoth =
                                        !isInterestedInBoth,
                                  ),
                                  child: Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: attentionColor,
                                        width: 2,
                                      ),
                                      color: isInterestedInBoth
                                          ? attentionColor
                                          : Colors.transparent,
                                    ),
                                    child: isInterestedInBoth
                                        ? const Icon(
                                            Icons.check,
                                            size: 16,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(
                                      () => isInterestedInBoth =
                                          !isInterestedInBoth,
                                    ),
                                    child: Text(
                                      "I'm interested in both",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: AppFonts.font,
                                        color: bodyColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 30),

                            /// Info text
                            Text(
                              "Whether you are an owner or seeker, you will enjoy all app features",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: AppFonts.font,
                                color: hintColor,
                              ),
                            ),

                            const Spacer(),
                            const SizedBox(height: 20),

                            /// Continue Button — watches loading state
                            BlocBuilder<RoleSelectionBloc, RoleSelectionState>(
                              builder: (context, state) {
                                return AuthButton(
                                  text: "Continue",
                                  loading: state is RoleSelectionLoading,
                                  onPressed: state is RoleSelectionLoading
                                      ? () {} // التعديل هنا: دالة فارغة بدل null
                                      : () => _onContinue(context),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String image,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardColor = isDark
        ? const Color.fromARGB(255, 78, 78, 78).withOpacity(0.85)
        : const Color.fromARGB(255, 247, 247, 247);

    final bodyColor = isDark
        ? DarkColors.darkBodyColors
        : LightColors.lightBodyColors;

    final attentionColor = isDark
        ? DarkColors.darkAttentionText
        : LightColors.lightAttentionText;

    final titleColor = isSelected ? attentionColor : bodyColor;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: isSelected ? 1.05 : 1,
        duration: const Duration(milliseconds: 150),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(15),
                border: isSelected
                    ? Border.all(color: attentionColor, width: 2)
                    : null,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          blurRadius: 20,
                          spreadRadius: 1,
                          color: attentionColor.withOpacity(0.4),
                        ),
                      ]
                    : const [BoxShadow(blurRadius: 10, color: Colors.black12)],
              ),
              child: Column(
                children: [
                  Container(
                    height: 150,
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      fontFamily: AppFonts.font,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: AppFonts.font,
                      fontWeight: FontWeight.w500,
                      color: bodyColor,
                    ),
                  ),
                ],
              ),
            ),

            /// SELECTED Badge
            if (isSelected)
              Positioned(
                top: -10,
                left: 39,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: attentionColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "SELECTED",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontFamily: AppFonts.font,
                      fontWeight: FontWeight.w900,
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
