
/// Inline Nearby Facilities picker.
/// Shows a limited set of chip-style selectable items.
/// Tapping "See More" expands to reveal all items in-place.
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
class NearbyFacilitiesSection extends StatefulWidget {
  final List<AmenityModel> availableItems;
  final List<AmenityModel> selectedItems;
  final ValueChanged<List<AmenityModel>> onChanged;
  final bool isLoading;

  /// How many items to show before "See More".
  final int initialVisibleCount;

  const NearbyFacilitiesSection({
    super.key,
    required this.availableItems,
    required this.selectedItems,
    required this.onChanged,
    this.isLoading = false,
    this.initialVisibleCount = 8,
  });

  @override
  State<NearbyFacilitiesSection> createState() =>
      _NearbyFacilitiesSectionState();
}

class _NearbyFacilitiesSectionState extends State<NearbyFacilitiesSection> {
  bool _expanded = false;

  void _toggle(AmenityModel item) {
    final current = List<AmenityModel>.from(widget.selectedItems);
    if (current.any((e) => e.id == item.id)) {
      current.removeWhere((e) => e.id == item.id);
    } else {
      current.add(item);
    }
    widget.onChanged(current);
  }

  bool _isSelected(AmenityModel item) =>
      widget.selectedItems.any((e) => e.id == item.id);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = context.primaryColor;

    final visibleItems = _expanded
        ? widget.availableItems
        : widget.availableItems.take(widget.initialVisibleCount).toList();

    final hasMore = widget.availableItems.length > widget.initialVisibleCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ────────────────────────────────────────────────
        Row(
          children: [
            Icon(Icons.navigation_rounded, size: 18, color: primaryColor),
            const SizedBox(width: 6),
            Text(
              'Nearby Facilities',
              style: TextStyle(
                fontFamily: AppFonts.font,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: context.titleColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // ── Chips ─────────────────────────────────────────────────
        if (widget.isLoading && widget.availableItems.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: CircularProgressIndicator()),
          )
        else
          LayoutBuilder(
            builder: (context, constraints) {
              final width = (constraints.maxWidth - 10 - 0.1) / 2;
              
              return Wrap(
                spacing: 10,
                runSpacing: 12,
                children: [
                ...visibleItems.map((item) {
                  final selected = _isSelected(item);
                  return SizedBox(
                    width: width,
                    child: GestureDetector(
                      onTap: () => _toggle(item),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 11,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? (isDark
                                    ? const Color(0xFF1E2A2E)
                                    : const Color(0xFFF2F8F8))
                              : (isDark
                                    ? Colors.white.withOpacity(0.05)
                                    : const Color(0xFFF8FAFC)),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: selected
                                ? primaryColor
                                : (context.buttonBorderColor),
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              item.icon,
                              size: 15,
                              color: selected
                                  ? primaryColor
                                  : (isDark
                                        ? Colors.white60
                                        : const Color(0xFF64748B)),
                            ),
                            const SizedBox(width: 7),
                            Expanded(
                              child: Text(
                                item.name,
                                style: TextStyle(
                                  fontFamily: AppFonts.font,
                                  fontSize: 13,
                                  fontWeight: selected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: selected
                                      ? (isDark
                                            ? Colors.white
                                            : const Color(0xFF1E293B))
                                      : (isDark
                                            ? Colors.white70
                                            : const Color(0xFF475569)),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              selected ? Icons.check : Icons.add,
                              size: 16,
                              color: selected
                                  ? primaryColor
                                  : (isDark
                                        ? Colors.white38
                                        : const Color(0xFFA0AEC0)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
                if (hasMore && !_expanded)
                  SizedBox(
                    width: width,
                    child: AppDashedContainer(
                      color: primaryColor.withOpacity(0.5),
                      onTap: () => setState(() => _expanded = true),
                      borderRadius: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 11,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1E2A2E)
                              : const Color(0xFFF2F8F8),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'See More',
                              style: TextStyle(
                                fontFamily: AppFonts.font,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 18,
                              color: primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }
        ),
      ],
    );
  }
}
