import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class PickedLocation {
  final double latitude;
  final double longitude;
  const PickedLocation({required this.latitude, required this.longitude});
}

class LocationPickerScreen extends StatefulWidget {
  final double? initialLatitude;
  final double? initialLongitude;

  const LocationPickerScreen({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
  });

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  late final MapController _mapController;
  late final ValueNotifier<LatLng> _currentCenterNotifier;
  late final ValueNotifier<bool> _isLoadingLocation;
  late final ValueNotifier<List<dynamic>> _searchResults;
  late final ValueNotifier<bool> _isSearching;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    LatLng initialLoc = const LatLng(30.0444, 31.2357); // Cairo default
    if (widget.initialLatitude != null && widget.initialLongitude != null) {
      initialLoc = LatLng(widget.initialLatitude!, widget.initialLongitude!);
    }

    _currentCenterNotifier = ValueNotifier(initialLoc);
    _isLoadingLocation = ValueNotifier(false);
    _searchResults = ValueNotifier([]);
    _isSearching = ValueNotifier(false);

    if (widget.initialLatitude == null || widget.initialLongitude == null) {
      _determinePosition();
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    _searchController.dispose();
    _currentCenterNotifier.dispose();
    _isLoadingLocation.dispose();
    _searchResults.dispose();
    _isSearching.dispose();
    super.dispose();
  }

  Future<void> _determinePosition() async {
    _isLoadingLocation.value = true;
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            AppSnackBar.error(
              context,
              'Location permission is required to find your position.',
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          AppSnackBar.error(
            context,
            'Location permissions are permanently denied. Please enable them in app settings.',
          );
        }
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (mounted) {
        final newLoc = LatLng(position.latitude, position.longitude);
        _currentCenterNotifier.value = newLoc;
        _mapController.move(newLoc, 15.0);
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.error(context, 'Failed to fetch location: $e');
      }
    } finally {
      if (mounted) _isLoadingLocation.value = false;
    }
  }

  void _confirm() {
    Navigator.pop(
      context,
      PickedLocation(
        latitude: _currentCenterNotifier.value.latitude,
        longitude: _currentCenterNotifier.value.longitude,
      ),
    );
  }

  Future<void> _searchPlaces(String query) async {
    if (query.isEmpty) {
      _searchResults.value = [];
      return;
    }

    _isSearching.value = true;
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=5&addressdetails=1',
      );
      final response = await get(url, headers: {'User-Agent': 'DarDeal_App'});

      if (response.statusCode == 200) {
        _searchResults.value = json.decode(response.body);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Search failed: $e')));
      }
    } finally {
      if (mounted) _isSearching.value = false;
    }
  }

  void _onSearchResultSelected(dynamic result) {
    final lat = double.parse(result['lat']);
    final lon = double.parse(result['lon']);
    final newLoc = LatLng(lat, lon);

    _currentCenterNotifier.value = newLoc;
    _searchResults.value = [];
    _searchController.clear();

    _mapController.move(newLoc, 15.0);
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = context.primaryColor;

    return Scaffold(
      backgroundColor: isDark
          ? DarkColors.darkBackGround
          : LightColors.lightBackGround,
      appBar: AppBar(
        backgroundColor: isDark
            ? DarkColors.darkBackGround
            : LightColors.lightBackGround,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close, color: context.titleColor87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Select Location',
          style: TextStyle(
            color: context.titleColor87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
            fontFamily: AppFonts.font,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _confirm,
            child: Text(
              'Confirm',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // Map Rendering
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _currentCenterNotifier.value,
                    initialZoom: 14.0,
                    onPositionChanged: (position, hasGesture) {
                      if (hasGesture && position.center != null) {
                        _currentCenterNotifier.value = position.center!;
                      }
                    },
                  ),
                  children: [
                    // Optimized Dark Mode: Wrapping TileLayer with ColorFiltered
                    // prevents per-tile matrix operations and applies to the entire layer.
                    if (isDark)
                      ColorFiltered(
                        colorFilter: const ColorFilter.matrix([
                          -1, 0, 0, 0, 255, // red
                          0, -1, 0, 0, 255, // green
                          0, 0, -1, 0, 255, // blue
                          0, 0, 0, 1, 0, // alpha
                        ]),
                        child: TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.graduation.project',
                        ),
                      )
                    else
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.graduation.project',
                      ),
                  ],
                ),

                // Fixed Center Pin
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 40.0,
                    ), // visual centering
                    child: Icon(
                      Icons.location_on,
                      size: 44,
                      color: primaryColor,
                    ),
                  ),
                ),

                // Search Bar Overlay
                Positioned(
                  top: 50,
                  left: 16,
                  right: 16,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: context.textFieldBgColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ValueListenableBuilder<bool>(
                          valueListenable: _isSearching,
                          builder: (context, isSearching, child) {
                            return TextField(
                              controller: _searchController,
                              onSubmitted: _searchPlaces,
                              style: TextStyle(
                                color: context.titleColor87,
                                fontFamily: AppFonts.font,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Search for a place...',
                                hintStyle: TextStyle(
                                  color: context.titleColor,
                                  fontSize: 14,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: primaryColor,
                                ),
                                suffixIcon: isSearching
                                    ? Container(
                                        padding: const EdgeInsets.all(12),
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: primaryColor,
                                        ),
                                      )
                                    : IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: () {
                                          _searchController.clear();
                                          _searchResults.value = [];
                                        },
                                      ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Search Results ListView
                      ValueListenableBuilder<List<dynamic>>(
                        valueListenable: _searchResults,
                        builder: (context, results, child) {
                          if (results.isEmpty) return const SizedBox.shrink();

                          return Container(
                            margin: const EdgeInsets.only(top: 4),
                            decoration: BoxDecoration(
                              color: context.textFieldBgColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            constraints: const BoxConstraints(maxHeight: 250),
                            child: ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: results.length,
                              separatorBuilder: (_, __) =>
                                  Divider(height: 1, color: context.titleColor),
                              itemBuilder: (context, index) {
                                final result = results[index];
                                return ListTile(
                                  leading: Icon(
                                    Icons.location_on_outlined,
                                    color: primaryColor,
                                    size: 20,
                                  ),
                                  title: Text(
                                    result['display_name'] ?? 'Unknown place',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: context.titleColor87,
                                      fontFamily: AppFonts.font,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  onTap: () => _onSearchResultSelected(result),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // My Location Button
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _isLoadingLocation,
                    builder: (context, isLoading, child) {
                      return FloatingActionButton(
                        heroTag: 'my_loc',
                        mini: true,
                        backgroundColor: context.textFieldBgColor,
                        onPressed: _determinePosition,
                        child: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(Icons.my_location, color: primaryColor),
                      );
                    },
                  ),
                ),

                // Instruction Banner
                Positioned(
                  top: 12,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.black87
                            : Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        'Drag the map to position the pin',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: context.titleColor87,
                          fontFamily: AppFonts.font,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Panel
          Container(
            decoration: BoxDecoration(
              color: context.textFieldBgColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ValueListenableBuilder<LatLng>(
                  valueListenable: _currentCenterNotifier,
                  builder: (context, currentCenter, child) {
                    return Row(
                      children: [
                        Expanded(
                          child: _CoordinateTile(
                            label: 'Latitude',
                            value: currentCenter.latitude.toStringAsFixed(6),
                            icon: Icons.my_location,
                            isDark: isDark,
                            primaryColor: primaryColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _CoordinateTile(
                            label: 'Longitude',
                            value: currentCenter.longitude.toStringAsFixed(6),
                            icon: Icons.explore,
                            isDark: isDark,
                            primaryColor: primaryColor,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: AppPrimaryButton(
                    onPressed: _confirm,
                    text: 'Confirm Location',
                    buttonColor: LightColors.lightmaincolor,
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CoordinateTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isDark;
  final Color primaryColor;

  const _CoordinateTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.isDark,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: primaryColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: context.titleColor,
                    fontFamily: AppFonts.font,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: context.titleColor87,
                    fontFamily: AppFonts.font,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
