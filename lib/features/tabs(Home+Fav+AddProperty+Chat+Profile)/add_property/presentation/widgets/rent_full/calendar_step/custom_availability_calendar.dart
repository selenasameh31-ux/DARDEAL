
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
class CustomAvailabilityCalendar extends StatefulWidget {
  final Set<DateTime> blockedDates;
  final Set<DateTime> bookedDates;
  final Set<DateTime> selectedDates;
  final Function(DateTime) onDateTapped;
  final bool autoBlockPastDates;

  const CustomAvailabilityCalendar({
    super.key,
    required this.blockedDates,
    this.bookedDates = const {},
    this.selectedDates = const {},
    required this.onDateTapped,
    this.autoBlockPastDates = false,
  });

  @override
  State<CustomAvailabilityCalendar> createState() =>
      _CustomAvailabilityCalendarState();
}

enum _DayState { selected, blocked, booked, available, disabled }

class _CustomAvailabilityCalendarState
    extends State<CustomAvailabilityCalendar> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentMonth = DateTime(now.year, now.month);
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  _DayState _getState(DateTime date) {
    if (widget.autoBlockPastDates) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      if (date.isBefore(today)) {
        return _DayState.disabled;
      }
    }
    if (widget.selectedDates.any((d) => _isSameDay(d, date))) {
      return _DayState.selected;
    }
    if (widget.blockedDates.any((d) => _isSameDay(d, date))) {
      return _DayState.blocked;
    }
    if (widget.bookedDates.any((d) => _isSameDay(d, date))) {
      return _DayState.booked;
    }
    return _DayState.available;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor =
        context.primaryColor;
    final bgColor = isDark ? const Color(0xFF1E2A2E) : Colors.white;
    final borderColor =
        context.buttonBorderColor;
    final headerTextColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final dayOfWeekColor =
        isDark ? Colors.grey.shade400 : const Color(0xFF64748B);
    final defaultTextColor = context.titleColor;

    final year = _currentMonth.year;
    final month = _currentMonth.month;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final firstWeekday = DateTime(year, month, 1).weekday % 7; // 0=Sun

    // Build week rows
    final List<List<int?>> weeks = [];
    List<int?> currentWeek = List.filled(7, null);
    for (int day = 1; day <= daysInMonth; day++) {
      final col = (firstWeekday + day - 1) % 7;
      if (col == 0 && day > 1) {
        weeks.add(currentWeek);
        currentWeek = List.filled(7, null);
      }
      currentWeek[col] = day;
    }
    weeks.add(currentWeek);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      child: Column(
        children: [
          // ── Month nav ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left, color: primaryColor),
                onPressed: _previousMonth,
              ),
              Text(
                DateFormat('MMMM yyyy').format(_currentMonth),
                style: TextStyle(
                  fontFamily: AppFonts.font,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: headerTextColor,
                ),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right, color: primaryColor),
                onPressed: _nextMonth,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Weekday labels ──
          Row(
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                .map(
                  (d) => Expanded(
                    child: Center(
                      child: Text(
                        d,
                        style: TextStyle(
                          fontFamily: AppFonts.font,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: dayOfWeekColor,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),

          // ── Date rows ──
          ...weeks.map(
            (week) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: SizedBox(
                height: 42,
                child: Row(
                  children: List.generate(7, (col) {
                    final day = week[col];
                    if (day == null) return const Expanded(child: SizedBox());

                    final date = DateTime(year, month, day);
                    final state = _getState(date);

                    return Expanded(
                      child: GestureDetector(
                        onTap: state == _DayState.disabled
                            ? null
                            : () => widget.onDateTapped(date),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2.5),
                          child: _buildCell(
                            day: day,
                            state: state,
                            isDark: isDark,
                            primaryColor: primaryColor,
                            defaultTextColor: defaultTextColor,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // Cell builder — Individual rounded cells with gaps
  // ─────────────────────────────────────────────────────────
  Widget _buildCell({
    required int day,
    required _DayState state,
    required bool isDark,
    required Color primaryColor,
    required Color defaultTextColor,
  }) {
    final borderRadius = BorderRadius.circular(12);

    Color? cellBg;
    Color textColor = defaultTextColor;
    FontWeight weight = FontWeight.w500;
    TextDecoration? decoration;
    Color? decorationColor;

    switch (state) {
      case _DayState.selected:
        cellBg = primaryColor;
        textColor = Colors.white;
        weight = FontWeight.w700;
        break;
      case _DayState.blocked:
        cellBg = isDark ? const Color(0xFF3F1D1D) : const Color(0xFFFFF1F1);
        textColor = const Color(0xFFEF5350);
        weight = FontWeight.bold;
        decoration = TextDecoration.lineThrough;
        decorationColor = const Color(0xFFEF5350);
        break;
      case _DayState.booked:
        // Match the background color of the 'SELECTED RANGE' bar (#F0F7F8)
        cellBg = isDark ? const Color(0xFF132B2B) : const Color(0xFFF0F7F8);
        textColor = const Color(0xFF007A7A); // Teal text
        weight = FontWeight.w600;
        break;
      case _DayState.available:
        cellBg = Colors.transparent;
        break;
      case _DayState.disabled:
        cellBg = Colors.transparent;
        textColor = isDark ? Colors.white30 : const Color(0xFFCBD5E1);
        weight = FontWeight.w500;
        decoration = TextDecoration.lineThrough;
        decorationColor = isDark ? Colors.white30 : const Color(0xFFCBD5E1);
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: cellBg,
        borderRadius: borderRadius,
      ),
      child: Center(
        child: Text(
          '$day',
          style: TextStyle(
            fontSize: 14,
            fontWeight: weight,
            color: textColor,
            decoration: decoration,
            decorationColor: decorationColor,
            decorationThickness: 1.5,
          ),
        ),
      ),
    );
  }
}
