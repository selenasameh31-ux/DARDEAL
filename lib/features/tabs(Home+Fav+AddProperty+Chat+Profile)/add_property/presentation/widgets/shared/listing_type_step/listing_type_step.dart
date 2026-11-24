
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
class ListingTypeStep extends StatefulWidget {
  final VoidCallback onNext;

  const ListingTypeStep({super.key, required this.onNext});

  @override
  State<ListingTypeStep> createState() => _ListingTypeStepState();
}

class _ListingTypeStepState extends State<ListingTypeStep> {
  int? _getSelectedIndex(AddPropertyState state) {
    if (state.transactionType == 'For Sale') {
      return 0;
    } else if (state.transactionType == 'For Rent') {
      if (state.listingStyle == 'Room-by-Room') {
        return 2;
      } else {
        return 1;
      }
    }
    return null;
  }

  void _onOptionSelected(int index) {
    final bloc = context.read<AddPropertyBloc>();
    if (index == 0) {
      bloc.add(SwitchFlowEvent('For Sale', 'Entire Property'));
    } else if (index == 1) {
      bloc.add(SwitchFlowEvent('For Rent', 'Entire Property'));
    } else if (index == 2) {
      bloc.add(SwitchFlowEvent('For Rent', 'Room-by-Room'));
    }
  }

  Widget _buildOptionCard({
    required int index,
    required bool isSelected,
    required IconData icon,
    required String title,
    required String description,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = context.primaryColor;

    return GestureDetector(
      onTap: () => _onOptionSelected(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withOpacity(0.05)
              : (context.textFieldBgColor),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? primaryColor
                : (context.buttonBorderColor),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: context.textFieldBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: primaryColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: AppFonts.font,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: context.titleColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: TextStyle(
                      fontFamily: AppFonts.font,
                      fontSize: 13,
                      height: 1.3,
                      color: context.hintColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? primaryColor
                      : (isDark ? Colors.white38 : Colors.grey.shade400),
                  width: isSelected ? 5 : 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<AddPropertyBloc, AddPropertyState>(
      builder: (context, state) {
        final activeIndex = _getSelectedIndex(state);

        return Material(
          color: isDark ? DarkColors.darkBackGround : LightColors.lightBackGround,
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: StepHeader(),
                ),

                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontFamily: AppFonts.font,
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: context.titleColor,
                                height: 1.2,
                                letterSpacing: -0.5,
                              ),
                              children: [
                                const TextSpan(text: "What would you\nlike to "),
                                TextSpan(
                                  text: "do?",
                                  style: TextStyle(
                                    color: context.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Choose how you want to list your property. This determines the flow and fields you'll see.",
                            style: TextStyle(
                              fontFamily: AppFonts.font,
                              fontSize: 15,
                              height: 1.4,
                              color: context.hintColor,
                            ),
                          ),
                          const SizedBox(height: 32),

                          _buildOptionCard(
                            index: 0,
                            isSelected: activeIndex == 0,
                            icon: Icons.local_offer_outlined,
                            title: "For Sale",
                            description:
                                "List for sale at a fixed or negotiable price. One-time transaction.",
                          ),
                          _buildOptionCard(
                            index: 1,
                            isSelected: activeIndex == 1,
                            icon: Icons.vpn_key_outlined,
                            title: "Rent — Full Property",
                            description:
                                "Rent the entire unit monthly or yearly. Ideal for families and long-term tenants.",
                          ),
                          _buildOptionCard(
                            index: 2,
                            isSelected: activeIndex == 2,
                            icon: Icons.bed_outlined,
                            title: "Rent — Room",
                            description:
                                "Rent individual rooms. Perfect for shared living or short-term stays.",
                          ),
                          const SizedBox(height: 32),

                          // Bottom Continue Button
                          AppPrimaryButton(
                            text: "Continue →",
                            onPressed: activeIndex != null ? widget.onNext : () {},
                            textColor: Colors.white,
                            buttonColor: activeIndex != null
                                ? (context.primaryColor)
                                : Colors.grey.shade400,
                          ),
                          const SizedBox(height: 80), // Extra space for the bottom nav bar
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
