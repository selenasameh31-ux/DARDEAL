import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class BasicInfoStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const BasicInfoStep({super.key, required this.onNext, required this.onBack});

  @override
  State<BasicInfoStep> createState() => _BasicInfoStepState();
}

class _BasicInfoStepState extends State<BasicInfoStep> {
  late String propertyType;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _propertyTypeError;

  @override
  void initState() {
    super.initState();
    final state = context.read<AddPropertyBloc>().state;
    propertyType = state.propertyType ?? "";
    titleController.text = state.title ?? '';
    descriptionController.text = state.description ?? '';
  }

  void _dispatch(String? pType) {
    final bloc = context.read<AddPropertyBloc>();
    bloc.add(
      UpdateBasicInfoEvent(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        propertyType: pType ?? propertyType,
        collectionCategory:
            bloc.state.collectionCategory, // Preserved from ListingTypeStep
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: isDark
            ? DarkColors.darkmainColor.withOpacity(0.15)
            : const Color(0xFFF2F8F8),
        border: Border.all(
          color: isDark ? const Color(0xFF4A4A4A) : const Color(0xFFE8EAEF),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        cursorColor: context.primaryColor,
        style: TextStyle(
          color: isDark ? DarkColors.darkBodyColors : const Color(0xFF2C3E50),
          fontSize: 15,
        ),
        onChanged: (val) {
          _dispatch(null);
        },
        validator: validator,
        decoration: InputDecoration(
          border: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            color: isDark
                ? DarkColors.darkHintTextFieldColor
                : const Color(0xFFA0AEC0),
            fontFamily: AppFonts.font,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: context.scaffoldBgColor,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StepHeader(stepName: 'Basic Info'),
              const SizedBox(height: 24),

              Text(
                "Tell us about your property",
                style: TextStyle(
                  fontFamily: AppFonts.font,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Start with the essentials to help people find your listing.",
                style: TextStyle(
                  fontFamily: AppFonts.font,
                  fontSize: 15,
                  color: isDark ? Colors.white60 : const Color(0xFF64748B),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              ValueListenableBuilder<TextEditingValue>(
                valueListenable: titleController,
                builder: (context, value, child) {
                  return AppSectionTitle(
                    title: "Property Title *",
                    padding: const EdgeInsets.only(bottom: 12),
                    trailing: Text(
                      "${value.text.length} / 200",
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? Colors.white38
                            : const Color(0xFF94A3B8),
                        fontFamily: AppFonts.font,
                      ),
                    ),
                  );
                },
              ),
              _buildTextField(
                context: context,
                controller: titleController,
                hintText: "e.g. Modern Villa with Pool",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Property title is required";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              ValueListenableBuilder<TextEditingValue>(
                valueListenable: descriptionController,
                builder: (context, value, child) {
                  return AppSectionTitle(
                    title: "Description",
                    padding: const EdgeInsets.only(bottom: 12),
                    trailing: Text(
                      "${value.text.length} / 5000",
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? Colors.white38
                            : const Color(0xFF94A3B8),
                        fontFamily: AppFonts.font,
                      ),
                    ),
                  );
                },
              ),
              _buildTextField(
                context: context,
                controller: descriptionController,
                hintText:
                    "Describe the unique features, surroundings, and amenities...",
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Description is required";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ── AI Tip Card ───────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E2A2E)
                      : const Color(0xFFF2F9F9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lightbulb_outline_rounded,
                      color: isDark
                          ? DarkColors.darkmainColor
                          : const Color(0xFF00A382),
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.5,
                            fontFamily: AppFonts.font,
                            color: isDark
                                ? Colors.white70
                                : const Color(0xFF00A382),
                          ),
                          children: const [
                            TextSpan(
                              text: "AI Tip: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  "Listings with 100+ words receive 3x more views. Mention nearby landmarks, transport and unique features.",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Transaction Type is now handled in ListingTypeStep
              const AppSectionTitle(
                title: "Property Type *",
                padding: const EdgeInsets.only(bottom: 16),
              ),
              BlocBuilder<AddPropertyBloc, AddPropertyState>(
                buildWhen: (prev, curr) =>
                    prev.propertyType != curr.propertyType ||
                    prev.availablePropertyTypes !=
                        curr.availablePropertyTypes ||
                    prev.isLoadingLookups != curr.isLoadingLookups,
                builder: (context, typeState) {
                  return PropertyTypeSelector(
                    selectedType: typeState.propertyType ?? propertyType,
                    availablePropertyTypes: typeState.availablePropertyTypes,
                    isLoading: typeState.isLoadingLookups,
                    onChanged: (value) {
                      setState(() {
                        propertyType = value;
                        _propertyTypeError = null;
                      });
                      _dispatch(value);
                    },
                  );
                },
              ),
              if (_propertyTypeError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 4),
                  child: Text(
                    _propertyTypeError!,
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              const SizedBox(height: 32),

              StepNavigationButtons(
                step: 1, // Fixed step index
                onNext: () {
                  final formValid = _formKey.currentState?.validate() ?? false;
                  final currentState = context.read<AddPropertyBloc>().state;

                  setState(() {
                    _propertyTypeError =
                        (currentState.propertyType == null ||
                            currentState.propertyType!.isEmpty)
                        ? 'Please select a Property Type'
                        : null;
                  });

                  if (formValid && _propertyTypeError == null) {
                    _dispatch(null); // Final sync
                    widget.onNext();
                  } else {
                    AppSnackBar.error(
                      context,
                      'Please fill all required fields correctly.',
                    );
                  }
                },
                onBack: widget.onBack,
              ),

              const SizedBox(height: 24),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      size: 16,
                      color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Auto-saved",
                      style: TextStyle(
                        fontFamily: AppFonts.font,
                        fontSize: 13,
                        color: isDark
                            ? Colors.white38
                            : const Color(0xFF94A3B8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
