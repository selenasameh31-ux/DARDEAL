
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
class CalendarStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const CalendarStep({super.key, required this.onNext, required this.onBack});

  @override
  State<CalendarStep> createState() => _CalendarStepState();
}

class _CalendarStepState extends State<CalendarStep> {
  // Recurring rules local state
  bool _autoBlockPastDates = true;
  bool _requireGapBetweenStays = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = context.primaryColor;
    final txtColor = context.titleColor;
    final subtitleColor = isDark ? Colors.white60 : const Color(0xFF64748B);

    return BlocBuilder<AddPropertyBloc, AddPropertyState>(
      builder: (context, state) {
        // Determine selected range from selectedDates
        final sortedSelected = state.selectedDates.toList()..sort();
        final hasSelection = sortedSelected.isNotEmpty;
        final rangeStart = hasSelection ? sortedSelected.first : null;
        final rangeEnd = hasSelection ? sortedSelected.last : null;

        return Material(
          color: isDark
              ? DarkColors.darkBackGround
              : LightColors.lightBackGround,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const StepHeader(),
                const SizedBox(height: 20),

                // ── Title ─────────────────────────────────────────
                Text(
                  'Availability Calendar',
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
                  'Block dates when guests cannot book. Everything else stays open.',
                  style: TextStyle(
                    fontFamily: AppFonts.font,
                    fontSize: 14,
                    color: subtitleColor,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),

                // ── Action Buttons (3-column) ───────────────────
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.weekend_outlined,
                        label: 'Block\nWeekends',
                        isDark: isDark,
                        onTap: () {
                          context.read<AddPropertyBloc>().add(
                            BlockWeekendsEvent(
                              DateTime.now().month,
                              DateTime.now().year,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.delete_outline,
                        label: 'Clear\nMonth',
                        isDark: isDark,
                        onTap: () {
                          context.read<AddPropertyBloc>().add(
                            ClearMonthEvent(
                              DateTime.now().month,
                              DateTime.now().year,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ── Calendar ────────────────────────────────────
                CustomAvailabilityCalendar(
                  autoBlockPastDates: _autoBlockPastDates,
                  blockedDates: state.blockedDates,
                  bookedDates: state.bookedDates,
                  selectedDates: state.selectedDates,
                  onDateTapped: (date) {
                    context.read<AddPropertyBloc>().add(
                      ToggleCalendarDateEvent(date),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // ── Legend ───────────────────────────────────────
                _buildLegend(isDark, primary),
                if (hasSelection) ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E2A2E)
                          : const Color(0xFFF0F7F8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SELECTED RANGE',
                                style: TextStyle(
                                  fontFamily: AppFonts.font,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5,
                                  color: isDark
                                      ? primary
                                      : const Color(0xFF007A7A),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                rangeStart == rangeEnd
                                    ? DateFormat('MMM d').format(rangeStart!)
                                    : '${DateFormat('MMM d').format(rangeStart!)} – ${DateFormat('MMM d').format(rangeEnd!)}',
                                style: TextStyle(
                                  fontFamily: AppFonts.font,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildRangeButton(
                          label: 'Block',
                          textColor: const Color(0xFFEF5350),
                          bgColor: const Color(0xFFFFF0F0),
                          bdrColor: const Color(0xFFFFCDD2),
                          isDark: isDark,
                          onTap: () {
                            context.read<AddPropertyBloc>().add(
                              BlockSelectedDatesEvent(),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildRangeButton(
                          label: 'Book',
                          textColor: const Color(0xFF64748B),
                          bgColor: const Color(0xFFF8FAFC),
                          bdrColor: const Color(0xFFE2E8F0),
                          isDark: isDark,
                          onTap: () {
                            context.read<AddPropertyBloc>().add(
                              BookSelectedDatesEvent(),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildRangeButton(
                          label: 'Unblock',
                          textColor: const Color(0xFF00A382),
                          bgColor: const Color(0xFFEBF9EF),
                          bdrColor: const Color(0xFFCCEDD6),
                          isDark: isDark,
                          onTap: () {
                            context.read<AddPropertyBloc>().add(
                              UnblockSelectedDatesEvent(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 28),

                // ── Recurring Rules ─────────────────────────────
                Text(
                  'Recurring Rules',
                  style: TextStyle(
                    fontFamily: AppFonts.font,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: txtColor,
                  ),
                ),
                const SizedBox(height: 16),
                _buildRuleToggle(
                  title: 'Auto-block past dates',
                  value: _autoBlockPastDates,
                  isDark: isDark,
                  primary: primary,
                  onChanged: (val) => setState(() => _autoBlockPastDates = val),
                ),
                const SizedBox(height: 12),
                _buildRuleToggle(
                  title: 'Require 1-day gap between stays',
                  value: _requireGapBetweenStays,
                  isDark: isDark,
                  primary: primary,
                  onChanged: (val) =>
                      setState(() => _requireGapBetweenStays = val),
                ),

                const SizedBox(height: 24),

                // Auto-saved
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 14,
                        color: isDark ? context.hintColor : context.hintColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Auto-saved',
                        style: TextStyle(
                          fontSize: 12,
                          color: context.hintColor,
                          fontFamily: AppFonts.font,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // ── Navigation ──────────────────────────────────
                StepNavigationButtons(
                  step: 5,
                  onNext: widget.onNext,
                  onBack: widget.onBack,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // Widget Builders
  // ─────────────────────────────────────────────────────────────────

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.buttonBorderColor,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isDark ? Colors.white70 : const Color(0xFF1A2B34),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: AppFonts.font,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : const Color(0xFF1A2B34),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(bool isDark, Color primaryColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildLegendItem(
          'Available',
          isDark,
          borderColor: isDark ? Colors.grey.shade600 : const Color(0xFFCBD5E1),
        ),
        _buildLegendItem('Selected', isDark, bgColor: primaryColor),
        _buildLegendItem(
          'Blocked',
          isDark,
          bgColor: isDark ? const Color(0xFF5B3A3A) : const Color(0xFFFDECEC),
        ),
        _buildLegendItem(
          'Booked',
          isDark,
          bgColor: isDark ? const Color(0xFF132B2B) : const Color(0xFFF0F7F8),
        ),
      ],
    );
  }

  Widget _buildLegendItem(
    String label,
    bool isDark, {
    Color? bgColor,
    Color? borderColor,
  }) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: bgColor ?? Colors.transparent,
            shape: BoxShape.circle,
            border: borderColor != null
                ? Border.all(color: borderColor, width: 1.5)
                : null,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontFamily: AppFonts.font,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.grey.shade400 : const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  Widget _buildRangeButton({
    required String label,
    required Color textColor,
    required Color bgColor,
    required Color bdrColor,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? textColor.withAlpha(25) : bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: bdrColor, width: 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: AppFonts.font,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildRuleToggle({
    required String title,
    required bool value,
    required bool isDark,
    required Color primary,
    required ValueChanged<bool> onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2A2E) : const Color(0xFFF8FAFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.buttonBorderColor,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: value ? primary : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: value
                      ? primary
                      : (isDark
                            ? const Color(0xFF475569)
                            : const Color(0xFFCBD5E1)),
                  width: 1.5,
                ),
              ),
              child: value
                  ? Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: AppFonts.font,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: context.titleColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
