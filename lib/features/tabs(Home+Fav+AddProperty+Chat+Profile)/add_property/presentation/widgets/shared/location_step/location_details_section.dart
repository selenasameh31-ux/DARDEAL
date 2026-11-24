
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
class LocationDetailsSection extends StatefulWidget {
  const LocationDetailsSection({super.key});

  @override
  State<LocationDetailsSection> createState() => _LocationDetailsSectionState();
}

class _LocationDetailsSectionState extends State<LocationDetailsSection> {
  final addressController = TextEditingController();
  final buildingController = TextEditingController();
  final floorController = TextEditingController();
  final unitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final state = context.read<AddPropertyBloc>().state;
    addressController.text = state.address ?? '';
    buildingController.text = state.building ?? '';
    floorController.text = state.floor ?? '';
    unitController.text = state.unit ?? '';
  }

  void _dispatch() {
    final state = context.read<AddPropertyBloc>().state;
    context.read<AddPropertyBloc>().add(
      LocationUpdateEvent(
        governorate: state.governorate,
        governorateId: state.governorateId,
        city: state.city,
        cityId: state.cityId,
        area: state.area,
        districtId: state.districtId,
        address: addressController.text.trim().isEmpty
            ? null
            : addressController.text.trim(),
        building: buildingController.text.trim().isEmpty
            ? null
            : buildingController.text.trim(),
        floor: floorController.text.trim().isEmpty
            ? null
            : floorController.text.trim(),
        unit: unitController.text.trim().isEmpty
            ? null
            : unitController.text.trim(),
      ),
    );
  }

  @override
  void dispose() {
    addressController.dispose();
    buildingController.dispose();
    floorController.dispose();
    unitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Where is your property?",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : const Color(0xFF202A38),
            fontFamily: AppFonts.font,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Provide exact details to help potential buyers find it.",
          style: TextStyle(
            fontSize: 13,
            color: isDark ? context.hintColor : const Color(0xFF718096),
            fontFamily: AppFonts.font,
          ),
        ),
        const SizedBox(height: 16),

        // Map Placeholder – tappable
        BlocBuilder<AddPropertyBloc, AddPropertyState>(
          buildWhen: (prev, curr) =>
              prev.latitude != curr.latitude ||
              prev.longitude != curr.longitude,
          builder: (context, state) {
            final pickedLat = state.latitude;
            final pickedLng = state.longitude;

            return GestureDetector(
              onTap: () async {
                final result = await Navigator.push<PickedLocation>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LocationPickerScreen(
                      initialLatitude: pickedLat,
                      initialLongitude: pickedLng,
                    ),
                  ),
                );
                if (result != null && mounted) {
                  context.read<AddPropertyBloc>().add(
                    MapLocationUpdateEvent(
                      latitude: result.latitude,
                      longitude: result.longitude,
                    ),
                  );
                }
              },
              child: Container(
                height: 160,
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xff2A2A2A)
                      : const Color(0xffE6E6E6),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: pickedLat != null
                        ? Colors.green.withOpacity(0.5)
                        : (isDark ? Colors.white12 : const Color(0xffD9D9D9)),
                  ),
                ),
                child: pickedLat != null
                    ? Stack(
                        children: [
                          AbsorbPointer(
                            child: FlutterMap(
                              options: MapOptions(
                                initialCenter: LatLng(pickedLat!, pickedLng!),
                                initialZoom: 15.0,
                                interactionOptions: const InteractionOptions(
                                  flags: InteractiveFlag.none,
                                ),
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName:
                                      'com.graduation.project',
                                  tileBuilder: isDark
                                      ? (context, tileWidget, tile) =>
                                            ColorFiltered(
                                              colorFilter:
                                                  const ColorFilter.matrix([
                                                    -1,
                                                    0,
                                                    0,
                                                    0,
                                                    255,
                                                    0,
                                                    -1,
                                                    0,
                                                    0,
                                                    255,
                                                    0,
                                                    0,
                                                    -1,
                                                    0,
                                                    255,
                                                    0,
                                                    0,
                                                    0,
                                                    1,
                                                    0,
                                                  ]),
                                              child: tileWidget,
                                            )
                                      : null,
                                ),
                              ],
                            ),
                          ),
                          // Pin in center
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: Icon(
                                Icons.location_on,
                                size: 40,
                                color: context.primaryColor,
                              ),
                            ),
                          ),
                          // Coordinate Banner
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isDark ? Colors.black87 : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${pickedLat.toStringAsFixed(4)}, ${pickedLng!.toStringAsFixed(4)}',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: context.titleColor87,
                                      fontFamily: AppFonts.font,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Edit Button Overlay
                          Positioned(
                            bottom: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: context.primaryColor,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.edit_location_alt,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Change Location',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(
                        color: isDark
                            ? const Color(0xff2A2A2A)
                            : const Color(0xFF90BBA0).withOpacity(0.55),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Large Pin Graphic
                            Center(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Outer lighter circle
                                  Container(
                                    width: 130,
                                    height: 130,
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? Colors.white10
                                          : Colors.white.withOpacity(0.3),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  // Inner Pin
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 20),
                                    child: Icon(
                                      Icons.location_on,
                                      size: 130, // huge
                                      color: Color(0xFFCC4F25), // Orange pin
                                    ),
                                  ),
                                  // Small inner circle of the pin
                                  Positioned(
                                    top: 15,
                                    child: Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF0C6B6B),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.circle,
                                          size: 8,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Set pin on map Button
                            Positioned(
                              bottom: 20,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0C6B6B),
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.public,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "Set pin on map",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: AppFonts.font,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // GPS Icon bottom right
                            Positioned(
                              bottom: 16,
                              right: 16,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isDark ? Colors.black87 : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.my_location,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF5A6B6B),
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            );
          },
        ),

        const SizedBox(height: 24),

        // 2. Governorate
        BlocBuilder<AddPropertyBloc, AddPropertyState>(
          buildWhen: (prev, curr) =>
              prev.availableGovernorates != curr.availableGovernorates ||
              prev.governorate != curr.governorate,
          builder: (context, state) {
            final governorates = state.availableGovernorates
                .map((e) => e.nameEn)
                .toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel("Governorate"),
                AppCustomDropdown(
                  hint: "Select Governorate",
                  value: state.governorate,
                  items: governorates,
                  validator: (val) => val == null ? "Required" : null,
                  onChanged: (val) {
                    if (val == null) return;
                    final selectedGov = state.availableGovernorates.firstWhere(
                      (e) => e.nameEn == val,
                    );

                    // Dispatch updates and load cities
                    context.read<AddPropertyBloc>().add(
                      LocationUpdateEvent(
                        governorate: val,
                        governorateId: selectedGov.id,
                        city: null,
                        cityId: null,
                        area: null,
                        districtId: null,
                        clearCityAndDistrict: true,
                      ),
                    );
                    context.read<AddPropertyBloc>().add(
                      LoadCitiesEvent(selectedGov.id!),
                    );
                  },
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),

        // 3. City & District Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: BlocBuilder<AddPropertyBloc, AddPropertyState>(
                buildWhen: (prev, curr) =>
                    prev.availableCities != curr.availableCities ||
                    prev.city != curr.city,
                builder: (context, state) {
                  final cities = state.availableCities
                      .map((e) => e.nameEn)
                      .toList();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("City"),
                      AppCustomDropdown(
                        hint: "Select City",
                        value: state.city,
                        items: cities,
                        validator: (val) => val == null ? "Required" : null,
                        onChanged: (val) {
                          if (val == null) return;
                          final selectedCity = state.availableCities.firstWhere(
                            (e) => e.nameEn == val,
                          );

                          context.read<AddPropertyBloc>().add(
                            LocationUpdateEvent(
                              governorate: state.governorate,
                              governorateId: state.governorateId,
                              city: val,
                              cityId: selectedCity.id,
                              area: null,
                              districtId: null,
                            ),
                          );
                          context.read<AddPropertyBloc>().add(
                            LoadDistrictsEvent(selectedCity.id!),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: BlocBuilder<AddPropertyBloc, AddPropertyState>(
                buildWhen: (prev, curr) =>
                    prev.availableDistricts != curr.availableDistricts ||
                    prev.area != curr.area,
                builder: (context, state) {
                  final districts = state.availableDistricts
                      .map((e) => e.nameEn)
                      .toList();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("District"),
                      AppCustomDropdown(
                        hint: "Select District",
                        value: state.area,
                        items: districts,
                        validator: (val) => val == null ? "Required" : null,
                        onChanged: (val) {
                          if (val == null) return;
                          final selectedDistrict = state.availableDistricts
                              .firstWhere((e) => e.nameEn == val);

                          context.read<AddPropertyBloc>().add(
                            LocationUpdateEvent(
                              governorate: state.governorate,
                              governorateId: state.governorateId,
                              city: state.city,
                              cityId: state.cityId,
                              area: val,
                              districtId: selectedDistrict.id,
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // 4. Street Address
        _buildLabel("Street Address"),
        _buildCustomTextField(
          context: context,
          controller: addressController,
          hintText: "e.g. 15 El-Tahrir Street",
          prefixIcon: Icons.map_outlined,
          validator: (val) => AppValidators.validateText(
            val,
            minLength: 5,
            fieldName: "Street Address",
          ),
        ),
        const SizedBox(height: 16),

        // 5. Building, Floor, Unit Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Building"),
                  _buildCustomTextField(
                    context: context,
                    controller: buildingController,
                    hintText: "B-12",
                    isCentered: true,
                    validator: (val) => AppValidators.validateText(
                      val,
                      minLength: 1,
                      fieldName: "Building",
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Floor"),
                  _buildCustomTextField(
                    context: context,
                    controller: floorController,
                    hintText: "4th",
                    isCentered: true,
                    validator: (val) => AppValidators.validateText(
                      val,
                      minLength: 1,
                      fieldName: "Floor",
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Unit"),
                  _buildCustomTextField(
                    context: context,
                    controller: unitController,
                    hintText: "402",
                    isCentered: true,
                    inputType: TextInputType.number,
                    validator: (val) => AppValidators.validateNumeric(
                      val,
                      isRequired: true,
                      minLength: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white70
              : const Color(0xFF2D3748),
          fontFamily: AppFonts.font,
        ),
      ),
    );
  }

  Widget _buildCustomTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String hintText,
    IconData? prefixIcon,
    bool isCentered = false,
    TextInputType inputType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      controller: controller,
      textAlign: isCentered ? TextAlign.center : TextAlign.start,
      keyboardType: inputType,
      onChanged: (_) => _dispatch(),
      validator: validator,
      cursorColor: isDark ? Colors.white : const Color(0xFF0C6B6B),
      style: TextStyle(
        color: isDark ? Colors.white : const Color(0xFF2D3748),
        fontSize: 15,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF7FDF9),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF4A4A4A) : const Color(0xFFDFE6E9),
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF4A4A4A) : const Color(0xFFDFE6E9),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: isDark ? Colors.white54 : const Color(0xFF0C6B6B),
            width: 1.5,
          ),
        ),
        errorStyle: TextStyle(color: Colors.redAccent, fontSize: 12),
        hintText: hintText,
        prefixIconConstraints: const BoxConstraints(minWidth: 35),
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: isDark ? Colors.white54 : const Color(0xFF0C6B6B),
                size: 20,
              )
            : null,
        hintStyle: TextStyle(
          color: isDark ? Colors.white38 : const Color(0xFFA0AEC0),
          fontFamily: AppFonts.font,
          fontSize: 14,
        ),
      ),
    );
  }
}
