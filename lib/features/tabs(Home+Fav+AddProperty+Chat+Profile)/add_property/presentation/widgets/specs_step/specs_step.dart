
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
class SpecsStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const SpecsStep({super.key, required this.onNext, required this.onBack});

  @override
  State<SpecsStep> createState() => _SpecsStepState();
}

class _SpecsStepState extends State<SpecsStep> {
  final _formKey = GlobalKey<FormState>();
  final _areaController = TextEditingController();
  final _floorController = TextEditingController();

  static const _bedroomOptions = ['Studio', '1', '2', '3', '4', '5+'];
  static const _bathroomOptions = ['1', '2', '3', '4', '5+'];
  static const _furnishingOptions = ['Furnished', 'Semi', 'Unfurnished'];
  static const _areaUnits = ['m²', 'sq ft'];

  String? _bedroomError;
  String? _bathroomError;
  String? _furnishingError;
  String? _areaError;

  @override
  void initState() {
    super.initState();
    final s = context.read<AddPropertyBloc>().state;
    _areaController.text = s.totalArea ?? '';
    _floorController.text = s.floorNumber ?? '';
  }

  @override
  void dispose() {
    _areaController.dispose();
    _floorController.dispose();
    super.dispose();
  }

  void _dispatch({
    String? totalArea,
    String? areaUnit,
    String? bedrooms,
    String? bathrooms,
    String? floorNumber,
    String? furnishingStatus,
  }) {
    context.read<AddPropertyBloc>().add(
      UpdateSpecsEvent(
        totalArea: totalArea,
        areaUnit: areaUnit,
        bedrooms: bedrooms,
        bathrooms: bathrooms,
        floorNumber: floorNumber,
        furnishingStatus: furnishingStatus,
      ),
    );
  }

  String? _numericValidator(String? val) {
    if (val == null || val.trim().isEmpty) return 'Required';
    final clean = val.trim();
    if (clean.startsWith('0') && clean.length > 1) return 'No leading zeros';
    final parsed = double.tryParse(clean);
    if (parsed == null) return 'Numbers only';
    if (parsed <= 0) return 'Must be greater than 0';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddPropertyBloc, AddPropertyState>(
      builder: (context, state) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final primary = context.primaryColor;
        final txtColor = context.titleColor;
        final subtitleColor = isDark ? Colors.white60 : const Color(0xFF64748B);
        final labelColor = isDark ? Colors.white70 : const Color(0xFF374151);
        final selectedBedroom = state.bedrooms;
        final selectedBathroom = state.bathrooms;
        final selectedFurnishing = state.furnishingStatus;
        final selectedUnit = state.areaUnit ?? 'm²';

        return Material(
          color: context.scaffoldBgColor,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ──────────────────────────────────────────
                  const StepHeader(),
                  const SizedBox(height: 20),

                  // ── Title block ──────────────────────────────────────
                  Text(
                    'Specifications',
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
                    "Tell buyers about the property's size, layout, and features.",
                    style: TextStyle(
                      fontFamily: AppFonts.font,
                      fontSize: 13,
                      color: subtitleColor,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Total Area ───────────────────────────────────────
                  _buildSectionLabel(
                    'Total Area',
                    required: true,
                    isDark: isDark,
                    labelColor: labelColor,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 62,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? DarkColors.darkTextFieldColor
                          : const Color(
                              0xFFF8FAFB,
                            ), // Kept this specific light color as it looks good for this container
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: context.buttonBorderColor,
                      ),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 14),
                        Expanded(
                          child: TextFormField(
                            controller: _areaController,
                            keyboardType: TextInputType.number,
                            cursorColor: primary,
                            style: TextStyle(
                              color: txtColor,
                              fontFamily: AppFonts.font,
                              fontSize: 15,
                            ),
                            decoration: InputDecoration(
                              hintText: 'e.g. 150',
                              hintStyle: TextStyle(
                                fontFamily: AppFonts.font,
                                color: isDark
                                    ? Colors.white38
                                    : const Color(0xFF94A3B8),
                                fontSize: 15,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onChanged: (v) => _dispatch(totalArea: v),
                            validator: (v) {
                              final err = _numericValidator(v);
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (mounted && _areaError != err) {
                                  setState(() => _areaError = err);
                                }
                              });
                              return err;
                            },
                          ),
                        ),
                        // Unit toggle inside
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E2A2E)
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: _areaUnits.map((unit) {
                              final isSelected = selectedUnit == unit;
                              return GestureDetector(
                                onTap: () => _dispatch(areaUnit: unit),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: isSelected && !isDark
                                        ? [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.05,
                                              ),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Text(
                                    unit,
                                    style: TextStyle(
                                      fontFamily: AppFonts.font,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: isSelected
                                          ? primary
                                          : (isDark
                                                ? Colors.white54
                                                : const Color(0xFF94A3B8)),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                    ),
                  ),
                  if (_areaError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6, left: 12),
                      child: Text(
                        _areaError!,
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),

                  // ── Bedrooms ─────────────────────────────────────────
                  _buildSectionLabel(
                    'Bedrooms',
                    required: true,
                    isDark: isDark,
                    labelColor: labelColor,
                  ),
                  const SizedBox(height: 10),
                  _buildChoiceChips(
                    options: _bedroomOptions,
                    selected: selectedBedroom,
                    primary: primary,
                    isDark: isDark,
                    onTap: (v) {
                      setState(() => _bedroomError = null);
                      _dispatch(bedrooms: v);
                    },
                    error: _bedroomError,
                  ),
                  const SizedBox(height: 24),

                  // ── Bathrooms ────────────────────────────────────────
                  _buildSectionLabel(
                    'Bathrooms',
                    required: true,
                    isDark: isDark,
                    labelColor: labelColor,
                  ),
                  const SizedBox(height: 10),
                  _buildChoiceChips(
                    options: _bathroomOptions,
                    selected: selectedBathroom,
                    primary: primary,
                    isDark: isDark,
                    circular: false, // Match bedrooms
                    onTap: (v) {
                      setState(() => _bathroomError = null);
                      _dispatch(bathrooms: v);
                    },
                    error: _bathroomError,
                  ),
                  const SizedBox(height: 24),

                  // ── Floor Number ─────────────────────────────────────
                  _buildSectionLabel(
                    'Floor Number',
                    required: false,
                    isDark: isDark,
                    labelColor: labelColor,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _floorController,
                    keyboardType: TextInputType.number,
                    cursorColor: primary,
                    style: TextStyle(
                      color: txtColor,
                      fontFamily: AppFonts.font,
                    ),
                    decoration: _inputDecoration(
                      hint: 'e.g. 4  (optional)',
                      isDark: isDark,
                      primary: primary,
                    ),
                    onChanged: (v) => _dispatch(floorNumber: v),
                  ),
                  const SizedBox(height: 24),

                  // ── Furnishing Status ─────────────────────────────────
                  _buildSectionLabel(
                    'Furnishing Status',
                    required: true,
                    isDark: isDark,
                    labelColor: labelColor,
                  ),
                  const SizedBox(height: 10),
                  _buildChoiceChips(
                    options: _furnishingOptions,
                    selected: selectedFurnishing,
                    primary: primary,
                    isDark: isDark,
                    expanded: true,
                    onTap: (v) {
                      setState(() => _furnishingError = null);
                      _dispatch(furnishingStatus: v);
                    },
                    error: _furnishingError,
                  ),
                  const SizedBox(height: 12),

                  // ── Auto-saved ───────────────────────────────────────
                  _buildAutoSavedBadge(isDark),
                  const SizedBox(height: 28),

                  // ── Navigation ───────────────────────────────────────
                  StepNavigationButtons(
                    step: 2,
                    onBack: widget.onBack,
                    onNext: () {
                      final formValid =
                          _formKey.currentState?.validate() ?? false;
                      final s = context.read<AddPropertyBloc>().state;

                      setState(() {
                        _bedroomError =
                            (s.bedrooms == null || s.bedrooms!.isEmpty)
                            ? 'Please select bedrooms'
                            : null;
                        _bathroomError =
                            (s.bathrooms == null || s.bathrooms!.isEmpty)
                            ? 'Please select bathrooms'
                            : null;
                        _furnishingError =
                            (s.furnishingStatus == null ||
                                s.furnishingStatus!.isEmpty)
                            ? 'Please select furnishing'
                            : null;
                        _areaError = _numericValidator(_areaController.text);
                      });

                      if (formValid &&
                          _bedroomError == null &&
                          _bathroomError == null &&
                          _furnishingError == null &&
                          _areaError == null) {
                        widget.onNext();
                      } else {
                        AppSnackBar.error(
                          context,
                          'Please fill all required specifications correctly.',
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ────────────────────────────────────────────────────────────────
  // Helpers
  // ────────────────────────────────────────────────────────────────

  Widget _buildSectionLabel(
    String label, {
    required bool required,
    required bool isDark,
    required Color labelColor,
  }) {
    return RichText(
      text: TextSpan(
        text: label,
        style: TextStyle(
          fontFamily: AppFonts.font,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: labelColor,
        ),
        children: required
            ? [
                const TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]
            : [],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required bool isDark,
    required Color primary,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontFamily: AppFonts.font,
        color: isDark ? Colors.white38 : const Color(0xFFA0AEC0),
        fontSize: 14,
      ),
      filled: true,
      fillColor: isDark
          ? DarkColors.darkTextFieldColor
          : const Color(0xFFF8FAFB),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFDDE2E8),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFDDE2E8),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
    );
  }

  Widget _buildChoiceChips({
    required List<String> options,
    required String? selected,
    required Color primary,
    required bool isDark,
    required ValueChanged<String> onTap,
    bool circular = false,
    bool expanded = false,
    String? error,
  }) {
    final chips = options.map((opt) {
      final isSelected = selected == opt;
      final child = GestureDetector(
        onTap: () => onTap(opt),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: circular ? 62 : null,
          height: 62,
          padding: circular
              ? EdgeInsets.zero
              : const EdgeInsets.symmetric(horizontal: 12), // Reduced padding for more text space
          decoration: BoxDecoration(
            color: isSelected
                ? primary
                : (isDark ? const Color(0xFF1A2428) : Colors.white),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? primary
                  : (context.buttonBorderColor),
              width: 1.2,
            ),
          ),
          child: Center(
            widthFactor: circular ? null : 1.0,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  opt,
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: AppFonts.font,
                    fontSize: expanded ? 14 : 17,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? Colors.white70 : const Color(0xFF0F172A)),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      return expanded ? Expanded(child: child) : child;
    }).toList();

    Widget chipsContent;
    if (expanded) {
      chipsContent = Row(
        children: chips.expand((c) => [c, const SizedBox(width: 10)]).toList()
          ..removeLast(),
      );
    } else {
      chipsContent = Wrap(spacing: 10, runSpacing: 10, children: chips);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        chipsContent,
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 4),
            child: Text(
              error,
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAutoSavedBadge(bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.check_circle_outline_rounded,
          size: 14,
          color: context.primaryColor,
        ),
        const SizedBox(width: 6),
        Text(
          'Auto-saved',
          style: TextStyle(
            fontFamily: AppFonts.font,
            fontSize: 12,
            color: context.primaryColor,
          ),
        ),
      ],
    );
  }

}
