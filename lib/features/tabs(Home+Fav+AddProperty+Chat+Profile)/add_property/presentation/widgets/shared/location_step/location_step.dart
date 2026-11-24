
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
class LocationStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const LocationStep({super.key, required this.onNext, required this.onBack});

  @override
  State<LocationStep> createState() => _LocationStepState();
}

class _LocationStepState extends State<LocationStep> {
  final _formKey = GlobalKey<FormState>();
  String? _mapError;
  String? _facilitiesError;

  void _tryNext(BuildContext context) {
    final state = context.read<AddPropertyBloc>().state;

    // Check Map Pin
    final hasMapPin = state.latitude != null && state.longitude != null;

    // Check Facilities
    final hasFacilities = state.selectedNearbyFacilities.isNotEmpty;

    setState(() {
      _mapError = !hasMapPin ? 'Please set a pin on the map' : null;
      _facilitiesError = !hasFacilities
          ? 'Please select at least one facility'
          : null;
    });

    if (hasMapPin &&
        hasFacilities &&
        (_formKey.currentState?.validate() ?? false)) {
      widget.onNext();
    } else {
      AppSnackBar.error(
        context,
        'Please complete all required location fields correctly.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
          color: context.scaffoldBgColor,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StepHeader(),

                  const SizedBox(height: 24),
                  const LocationDetailsSection(),
                  if (_mapError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12, left: 4),
                      child: Text(
                        _mapError!,
                        style: TextStyle(color: Colors.redAccent, fontSize: 12),
                      ),
                    ),
                  const SizedBox(height: 32),

                  BlocBuilder<AddPropertyBloc, AddPropertyState>(
                    buildWhen: (prev, curr) =>
                        prev.selectedNearbyFacilities !=
                            curr.selectedNearbyFacilities ||
                        prev.availableNearbyFacilities !=
                            curr.availableNearbyFacilities ||
                        prev.isLoadingLookups != curr.isLoadingLookups,
                    builder: (context, facilitiesState) {
                      return NearbyFacilitiesSection(
                        availableItems: facilitiesState.availableNearbyFacilities,
                        selectedItems: facilitiesState.selectedNearbyFacilities,
                        isLoading: facilitiesState.isLoadingLookups,
                        onChanged: (list) {
                          if (_facilitiesError != null) {
                            setState(() => _facilitiesError = null);
                          }
                          context.read<AddPropertyBloc>().add(
                            UpdateNearbyFacilitiesSelectionEvent(list),
                          );
                        },
                      );
                    },
                  ),
                  if (_facilitiesError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 4),
                      child: Text(
                        _facilitiesError!,
                        style: TextStyle(color: Colors.redAccent, fontSize: 12),
                      ),
                    ),

                  const SizedBox(height: 32),
                  StepNavigationButtons(
                    step: 3,
                    onNext: () => _tryNext(context),
                    onBack: widget.onBack,
                    onSaveDraft: () {
                      context.read<AddPropertyBloc>().add(SaveDraftEvent());
                      AppSnackBar.success(
                        context,
                        'Draft saved successfully!',
                        isTop: true,
                      );
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.mainLayout,
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
  }
}
