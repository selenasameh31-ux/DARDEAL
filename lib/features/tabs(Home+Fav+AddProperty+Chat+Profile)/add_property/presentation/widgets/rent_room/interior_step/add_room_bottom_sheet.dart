
// ─────────────────────────────────────────────
// Helper to open the bottom sheet
// ─────────────────────────────────────────────
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
Future<RoomModel?> showAddRoomBottomSheet(
  BuildContext context, {
  RoomModel? existing,
}) {
  return showModalBottomSheet<RoomModel>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => AddRoomBottomSheet(existing: existing),
  );
}

// ─────────────────────────────────────────────
// Bottom Sheet Widget
// ─────────────────────────────────────────────
class AddRoomBottomSheet extends StatefulWidget {
  final RoomModel? existing;
  const AddRoomBottomSheet({super.key, this.existing});

  @override
  State<AddRoomBottomSheet> createState() => _AddRoomBottomSheetState();
}

class _AddRoomBottomSheetState extends State<AddRoomBottomSheet> {
  late String _selectedType;
  late IconData _selectedIcon;
  final _capacityController = TextEditingController();
  final _sizeController = TextEditingController();
  final _priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  File? _selectedImage;

  Future<void> _pickImage() async {
    try {
      final List<AssetEntity>? result = await AssetPicker.pickAssets(
        context,
        pickerConfig: const AssetPickerConfig(
          maxAssets: 1,
          requestType: RequestType.image,
        ),
      );
      if (result != null && result.isNotEmpty) {
        final file = await result.first.file;
        if (file != null && mounted) {
          setState(() {
            _selectedImage = file;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.info(context, "Gallery Error: $e");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      final e = widget.existing!;
      _selectedType = e.title;
      _selectedIcon = e.icon;
      _capacityController.text = e.capacity.toString();
      _sizeController.text = e.size.toStringAsFixed(0);
      _priceController.text = e.price.toStringAsFixed(0);
      if (e.imagePath != null) {
        _selectedImage = File(e.imagePath!);
      }
    } else {
      _selectedType = RoomTypesData.roomTypes.first.title;
      _selectedIcon = RoomTypesData.roomTypes.first.icon;
    }
  }

  @override
  void dispose() {
    _capacityController.dispose();
    _sizeController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final room = RoomModel(
      id:
          widget.existing?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: _selectedType,
      capacity: int.tryParse(_capacityController.text.trim()) ?? 1,
      size: double.tryParse(_sizeController.text.trim()) ?? 0,
      price: double.tryParse(_priceController.text.trim()) ?? 0,
      icon: _selectedIcon,
      imagePath: _selectedImage?.path,
    );
    Navigator.of(context).pop(room);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final turquoise = isDark
        ? DarkColors.darkmainColor
        : const Color(0xFF0C6B6B);
    final labelColor = isDark
        ? DarkColors.darkBodyColors
        : LightColors.lightBodyColors;
    final bottomPad = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomPad),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                widget.existing != null ? 'Edit Room' : 'Add Room Type',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: AppFonts.font,
                  color: labelColor,
                ),
              ),
              const SizedBox(height: 20),

              // Image Picker
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 160,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : const Color(0xFFF8F5F2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? Colors.grey[700]! : LightColors.lightTextFieldColor,
                    ),
                    image: _selectedImage != null
                        ? DecorationImage(
                            image: FileImage(_selectedImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _selectedImage == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 40,
                              color: turquoise,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Add Room Photo",
                              style: TextStyle(
                                color: turquoise,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      : Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedImage = null),
                              child: CircleAvatar(
                                backgroundColor: Colors.white.withOpacity(0.8),
                                radius: 16,
                                child: const Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),

              // Room Type Dropdown
              Text(
                'Room Type',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: labelColor,
                ),
              ),
              const SizedBox(height: 8),
              AppDropdownField(
                value: _selectedType,
                items: RoomTypesData.roomTypes.map((t) => t.title).toList(),
                icon: Icon(_selectedIcon, size: 20, color: turquoise),
                onChanged: (val) {
                  if (val == null) return;
                  setState(() {
                    _selectedType = val;
                    _selectedIcon = RoomTypesData.roomTypes
                        .firstWhere((t) => t.title == val)
                        .icon;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Capacity
              Text(
                'Number of Guests',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: labelColor,
                ),
              ),
              const SizedBox(height: 8),
              AppTextField(
                controller: _capacityController,
                keyboardType: TextInputType.number,
                hintText: 'e.g. 2',
                prefixIcon: Icon(
                  Icons.people_outline,
                  color: turquoise,
                  size: 20,
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (int.tryParse(v.trim()) == null ||
                      int.parse(v.trim()) < 1) {
                    return 'Enter a valid number >= 1';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Room Size
              Text(
                'Room Size (sq ft)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: labelColor,
                ),
              ),
              const SizedBox(height: 8),
              AppTextField(
                controller: _sizeController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                hintText: 'e.g. 250',
                prefixIcon: Icon(
                  Icons.square_foot_outlined,
                  color: turquoise,
                  size: 20,
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (double.tryParse(v.trim()) == null) {
                    return 'Enter a valid size';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Price
              Text(
                'Monthly Price (EGP)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: labelColor,
                ),
              ),
              const SizedBox(height: 8),
              AppTextField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                hintText: 'e.g. 1200',
                suffixIcon: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  child: Text(
                    'EGP /mo',
                    style: TextStyle(
                      fontSize: 14,
                      color: labelColor.withOpacity(0.5),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (double.tryParse(v.trim()) == null)
                    return 'Enter a valid price';
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Save Button
              AppPrimaryButton(
                onPressed: _submit,
                text: widget.existing != null ? 'Save Changes' : 'Add Room',
                buttonColor: const Color(0xFF0C6B6B),
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
