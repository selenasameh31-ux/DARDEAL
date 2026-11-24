import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class PropertyTypeSelector extends StatefulWidget {
  final String selectedType;
  final List<String> availablePropertyTypes;
  final Function(String) onChanged;
  final bool isLoading;

  const PropertyTypeSelector({
    super.key,
    required this.selectedType,
    required this.availablePropertyTypes,
    required this.onChanged,
    this.isLoading = false,
  });

  @override
  State<PropertyTypeSelector> createState() => _PropertyTypeSelectorState();
}

class _PropertyTypeSelectorState extends State<PropertyTypeSelector> {
  bool isExpanded = false;

  static const Map<String, IconData> _propertyTypeIcons = {
    'Room': Icons.meeting_room_outlined,
    'Apartment': Icons.apartment_outlined,
    'House': Icons.home_outlined,
    'Villa': Icons.villa_outlined,
    'Chalet': Icons.ac_unit_outlined,
    'Studio': Icons.deck_outlined,
    'Townhouse': Icons.holiday_village_outlined,
    'Duplex': Icons.layers_outlined,
    'Penthouse': Icons.apartment_outlined,
    'Office': Icons.corporate_fare_outlined,
    'Shop': Icons.storefront_outlined,
    'Commercial': Icons.store_outlined,
    'Warehouse': Icons.warehouse_outlined,
    'Building': Icons.domain_outlined,
    'Land': Icons.landscape_outlined,
  };

  IconData _getIconForType(String type) {
    for (final key in _propertyTypeIcons.keys) {
      if (key.toLowerCase() == type.toLowerCase()) {
        return _propertyTypeIcons[key]!;
      }
    }
    return Icons.category_outlined;
  }

  @override
  Widget build(BuildContext context) {
    // Fallback to static types if API data hasn't arrived or failed
    final List<String> effectiveItems = widget.availablePropertyTypes.isNotEmpty
        ? widget.availablePropertyTypes
        : _propertyTypeIcons.keys.toList();

    // Determine which items to show
    final bool hasMoreItems = effectiveItems.length > 5;
    final bool showSeeMore = hasMoreItems && !isExpanded;

    final List<String> displayItems = showSeeMore
        ? effectiveItems.take(5).toList()
        : effectiveItems;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: displayItems.length + (showSeeMore ? 1 : 0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.15,
      ),
      itemBuilder: (context, index) {
        // "See More" card — only when there are hidden items
        if (showSeeMore && index == displayItems.length) {
          return PropertyTypeCard(
            title: "See More",
            icon: Icons.keyboard_arrow_down_rounded,
            isSelected: false,
            isDashed: true,
            onTap: () {
              setState(() {
                isExpanded = true;
              });
            },
          );
        }

        final type = displayItems[index];

        return PropertyTypeCard(
          title: type,
          icon: _getIconForType(type),
          isSelected: widget.selectedType == type,
          onTap: () {
            widget.onChanged(type);
          },
        );
      },
    );
  }
}
