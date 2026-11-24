
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
class AmenitiesStep extends StatefulWidget {
  final int stepIndex;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const AmenitiesStep({
    super.key,
    required this.stepIndex,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<AmenitiesStep> createState() => _AmenitiesStepState();
}

class _AmenitiesStepState extends State<AmenitiesStep> {
  String? _amenitiesError;
  String? _rulesError;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddPropertyBloc, AddPropertyState>(
      builder: (context, state) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final txtColor = isDark ? Colors.white : const Color(0xFF1A212D);
        final subtitleColor = isDark ? Colors.white60 : const Color(0xFF64748B);

        return Material(
          color: context.scaffoldBgColor,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──────────────────────────────────────────
                const StepHeader(stepName: 'Amenities & Preferences'),
                const SizedBox(height: 20),

                // ── Title block ──────────────────────────────────────
                Text(
                  'Amenities & Preferences',
                  style: TextStyle(
                    fontFamily: AppFonts.font,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: txtColor,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Set expectations for the property and list all available amenities.',
                  style: TextStyle(
                    fontFamily: AppFonts.font,
                    fontSize: 13,
                    color: subtitleColor,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 32),

                // ── Amenities Section ──────────────────────────────────
                PropertyRulesSection(
                  sectionIcon: Icons.eco_outlined,
                  title: 'Amenities',
                  availableItems: state.availableAmenities,
                  selectedItems: state.selectedAmenities,
                  isLoading: state.isLoadingLookups,
                  showRightPlusIndicator: true,
                  customInputHint: 'e.g. Espresso Machine',
                  onSelectedApply: (list) {
                    setState(() => _amenitiesError = null);
                    context.read<AddPropertyBloc>().add(
                      UpdateSelectedAmenitiesEvent(list),
                    );
                  },
                ),
                if (_amenitiesError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 4),
                    child: Text(
                      _amenitiesError!,
                      style: TextStyle(color: Colors.redAccent, fontSize: 12),
                    ),
                  ),

                const SizedBox(height: 32),

                // ── Rules & Preferences Section ────────────────────────
                PropertyRulesSection(
                  sectionIcon: Icons.design_services_outlined,
                  title: 'Rules & Preferences',
                  subtitle:
                      "Clearly communicate who you're looking for and what is/isn't allowed in the property to avoid mismatched tenants.",
                  availableItems: state.availableRules,
                  selectedItems: state.selectedCommunityRules,
                  isLoading: state.isLoadingLookups,
                  showRightPlusIndicator: true,
                  customInputHint: 'e.g. No visitors after 10pm',
                  quietHoursEnabled: state.quietHoursEnabled,
                  quietHoursStart: state.quietHoursStart,
                  quietHoursEnd: state.quietHoursEnd,
                  onSelectedApply: (list) {
                    setState(() => _rulesError = null);
                    context.read<AddPropertyBloc>().add(
                      UpdateCommunityRulesSelectionEvent(list),
                    );
                  },
                  onQuietHoursChanged: (enabled, start, end) {
                    context.read<AddPropertyBloc>().add(
                      UpdateCommunityRulesEvent(
                        quietHoursEnabled: enabled,
                        quietHoursStart: start,
                        quietHoursEnd: end,
                      ),
                    );
                  },
                ),
                if (_rulesError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 4),
                    child: Text(
                      _rulesError!,
                      style: TextStyle(color: Colors.redAccent, fontSize: 12),
                    ),
                  ),

                const SizedBox(height: 32),

                // ── Navigation ───────────────────────────────────────
                StepNavigationButtons(
                  step: widget.stepIndex,
                  onBack: widget.onBack,
                  onNext: () {
                    final s = context.read<AddPropertyBloc>().state;
                    setState(() {
                      _amenitiesError = s.selectedAmenities.isEmpty ? 'Please select at least one amenity' : null;
                      _rulesError = s.selectedCommunityRules.isEmpty ? 'Please select at least one rule' : null;
                    });
                    
                    if (_amenitiesError == null && _rulesError == null) {
                      widget.onNext();
                    } else {
                      AppSnackBar.error(
                        context,
                        'Please review the amenities and rules selection.',
                      );
                    }
                  },
                ),

                const SizedBox(height: 16),

                // ── Auto-saved ───────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      size: 14,
                      color: isDark
                          ? DarkColors.darkmainColor
                          : const Color(0xFF8692A6),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Auto-saved',
                      style: TextStyle(
                        fontFamily: AppFonts.font,
                        fontSize: 12,
                        color: isDark
                            ? DarkColors.darkmainColor
                            : const Color(0xFF8692A6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}

