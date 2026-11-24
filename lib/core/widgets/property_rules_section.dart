import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class PropertyRulesSection extends StatefulWidget {
  final IconData sectionIcon;
  final String title;
  final String? subtitle;
  final List<AmenityModel> availableItems;
  final List<AmenityModel> selectedItems;
  final bool showRightPlusIndicator;
  final String customInputHint;
  final ValueChanged<List<AmenityModel>> onSelectedApply;
  final bool isLoading;

  // Quiet Hours special handling
  final bool quietHoursEnabled;
  final TimeOfDay? quietHoursStart;
  final TimeOfDay? quietHoursEnd;
  final void Function(bool enabled, TimeOfDay? start, TimeOfDay? end)?
  onQuietHoursChanged;

  const PropertyRulesSection({
    super.key,
    required this.sectionIcon,
    required this.title,
    this.subtitle,
    required this.availableItems,
    required this.selectedItems,
    required this.showRightPlusIndicator,
    required this.customInputHint,
    required this.onSelectedApply,
    this.isLoading = false,
    this.quietHoursEnabled = false,
    this.quietHoursStart,
    this.quietHoursEnd,
    this.onQuietHoursChanged,
  });

  @override
  State<PropertyRulesSection> createState() => _PropertyRulesSectionState();
}

class _PropertyRulesSectionState extends State<PropertyRulesSection> {
  bool isExpanded = false;
  final TextEditingController _customController = TextEditingController();
  final FocusNode _customFocus = FocusNode();

  void _toggleItem(AmenityModel item) {
    // Special handling for Quiet Hours
    final bool isQuietHours =
        item.id == 'quiet_hours' ||
        item.name.toLowerCase().contains('quiet hour');
    if (isQuietHours && widget.onQuietHoursChanged != null) {
      if (widget.quietHoursEnabled) {
        // Already enabled → deselect immediately
        widget.onQuietHoursChanged?.call(false, null, null);
      } else {
        // Not enabled → show time picker
        _showQuietHoursPickers(context);
      }
      return;
    }

    final updated = List<AmenityModel>.from(widget.selectedItems);
    final exists = updated.any((e) => e.id == item.id);
    if (exists) {
      updated.removeWhere((e) => e.id == item.id);
    } else {
      updated.add(item);
    }
    widget.onSelectedApply(updated);
  }

  Future<void> _showQuietHoursPickers(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark
        ? DarkColors.darkmainColor
        : LightColors.lightmaincolor;

    final TimeOfDay? startTime = await showTimePicker(
      context: context,
      initialTime:
          widget.quietHoursStart ?? const TimeOfDay(hour: 22, minute: 0),
      helpText: 'Quiet Hours - Start Time',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primary,
              onPrimary: Colors.white,
              onSurface: isDark ? Colors.white : Colors.black,
              surface: isDark ? const Color(0xFF1E2A2E) : Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: primary),
            ),
          ),
          child: child!,
        );
      },
    );
    if (startTime == null) return;

    if (!mounted) return;
    final TimeOfDay? endTime = await showTimePicker(
      context: context,
      initialTime: widget.quietHoursEnd ?? const TimeOfDay(hour: 6, minute: 0),
      helpText: 'Quiet Hours - End Time',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primary,
              onPrimary: Colors.white,
              onSurface: isDark ? Colors.white : Colors.black,
              surface: isDark ? const Color(0xFF1E2A2E) : Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: primary),
            ),
          ),
          child: child!,
        );
      },
    );
    if (endTime == null) return;

    if (!mounted) return;
    widget.onQuietHoursChanged?.call(true, startTime, endTime);
  }

  String _formatTimeOfDay(TimeOfDay? time) {
    if (time == null) return "None";
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.jm().format(dt);
  }

  void _addCustomItem() {
    final text = _customController.text.trim();
    if (text.isNotEmpty) {
      final newItem = AmenityModel(
        id: 'custom_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(100)}',
        name: text,
        icon: Icons.check_circle_outline,
      );
      final updated = List<AmenityModel>.from(widget.selectedItems)
        ..add(newItem);
      widget.onSelectedApply(updated);
      _customController.clear();
      _customFocus.unfocus();
    }
  }

  @override
  void dispose() {
    _customController.dispose();
    _customFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark
        ? DarkColors.darkmainColor
        : LightColors.lightmaincolor;
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);

    // Merge available with any custom ones the user already selected
    final customSelected = widget.selectedItems.where(
      (sel) => !widget.availableItems.any((avail) => avail.id == sel.id),
    );
    final allItems = [...widget.availableItems, ...customSelected];

    const initialLimit = 8;
    final visibleItems = isExpanded || allItems.length <= initialLimit
        ? allItems
        : allItems.take(initialLimit).toList();

    final showSeeMoreButton = !isExpanded && allItems.length > initialLimit;

    // Bring quiet hours to front if enabled
    final List<AmenityModel> sortedVisibleItems = List.from(visibleItems);
    if (widget.quietHoursEnabled) {
      final qhIndex = sortedVisibleItems.indexWhere(
        (i) =>
            i.id == 'quiet_hours' ||
            i.name.toLowerCase().contains('quiet hour'),
      );
      if (qhIndex != -1) {
        final qhItem = sortedVisibleItems.removeAt(qhIndex);
        sortedVisibleItems.insert(0, qhItem);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Row
        Row(
          children: [
            Icon(widget.sectionIcon, size: 18, color: primary),
            const SizedBox(width: 8),
            Text(
              widget.title,
              style: TextStyle(
                fontFamily: AppFonts.font,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: titleColor,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),

        // Subtitle (if available)
        if (widget.subtitle != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E2A2E) : const Color(0xFFF1F7F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.subtitle!,
              style: TextStyle(
                fontFamily: AppFonts.font,
                fontSize: 13,
                height: 1.4,
                color: isDark ? Colors.white70 : const Color(0xFF334155),
              ),
            ),
          ),
        ],

        // Chips Wrap
        if (widget.isLoading && widget.availableItems.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: CircularProgressIndicator()),
          )
        else
          LayoutBuilder(
            builder: (context, constraints) {
            final double spacing = 10;
            final double width = (constraints.maxWidth - spacing - 0.1) / 2;

            return Wrap(
              spacing: spacing,
              runSpacing: 12,
              children: [
                ...sortedVisibleItems.map((item) {
                  final bool isQuietHours =
                      item.id == 'quiet_hours' ||
                      item.name.toLowerCase().contains('quiet hour');
                  final bool isSelected;

                  if (isQuietHours) {
                    isSelected = widget.quietHoursEnabled;
                  } else {
                    isSelected = widget.selectedItems.any(
                      (sel) => sel.id == item.id,
                    );
                  }

                  // For quiet hours, show time range in label when enabled
                  final String chipLabel;
                  if (isQuietHours && widget.quietHoursEnabled) {
                    chipLabel =
                        'Quiet Hours (${_formatTimeOfDay(widget.quietHoursStart)} – ${_formatTimeOfDay(widget.quietHoursEnd)})';
                  } else {
                    chipLabel = item.name;
                  }

                  final bool isFullWidth =
                      isQuietHours && widget.quietHoursEnabled;

                  return SizedBox(
                    width: isFullWidth ? constraints.maxWidth : width,
                    child: _buildChip(
                      item,
                      isSelected,
                      primary,
                      isDark,
                      labelOverride: chipLabel,
                    ),
                  );
                }),
                if (showSeeMoreButton)
                  SizedBox(
                    width: width,
                    child: _buildSeeMoreChip(primary, isDark),
                  ),
              ],
            );
          },
        ),

        const SizedBox(height: 16),

        // Custom Input
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A2428) : const Color(0xFFF8FAFB),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _customController,
                  focusNode: _customFocus,
                  style: TextStyle(
                    fontFamily: AppFonts.font,
                    fontSize: 14,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                  decoration: InputDecoration(
                    hintText: widget.customInputHint,
                    hintStyle: TextStyle(
                      fontFamily: AppFonts.font,
                      fontSize: 14,
                      color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onSubmitted: (_) => _addCustomItem(),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: _addCustomItem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  child: const Text(
                    'Add',
                    style: TextStyle(
                      fontFamily: AppFonts.font,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChip(
    AmenityModel item,
    bool isSelected,
    Color primary,
    bool isDark, {
    String? labelOverride,
  }) {
    final borderColor = isSelected
        ? primary
        : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0));
    final bgColor = isSelected
        ? (isDark ? const Color(0xFF1E2A2E) : const Color(0xFFF2F8F8))
        : (isDark ? const Color(0xFF1A2428) : Colors.white);
    final textColor = isSelected
        ? primary
        : (isDark ? Colors.white70 : const Color(0xFF0F172A));
    final iconColor = isSelected
        ? primary
        : (isDark ? Colors.white54 : const Color(0xFF64748B));

    return GestureDetector(
      onTap: () => _toggleItem(item),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(item.icon, size: 17, color: iconColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                labelOverride ?? item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: AppFonts.font,
                  fontSize: 12, // Slightly smaller to fit in 2 columns
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
            if (widget.showRightPlusIndicator && !isSelected) ...[
              const SizedBox(width: 8),
              Icon(
                Icons.add,
                size: 16,
                color: isDark ? Colors.white38 : const Color(0xFFA0AEC0),
              ),
            ],
            if (widget.showRightPlusIndicator && isSelected) ...[
              const SizedBox(width: 8),
              Icon(Icons.check, size: 16, color: primary),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSeeMoreChip(Color primary, bool isDark) {
    return AppDashedContainer(
      color: primary.withOpacity(0.5),
      onTap: () => setState(() => isExpanded = true),
      borderRadius: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2A2E) : const Color(0xFFF2F8F8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'See More',
              style: TextStyle(
                fontFamily: AppFonts.font,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: primary,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: primary),
          ],
        ),
      ),
    );
  }
}
