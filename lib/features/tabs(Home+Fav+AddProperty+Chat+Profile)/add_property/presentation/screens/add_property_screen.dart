import 'dart:async';
import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class AddPropertyScreen extends StatefulWidget {
  final void Function(int step)? onStepChanged;
  /// When true, the screen will restore the last saved step from the draft.
  final bool resumeMode;
  /// When true, ignores any saved draft and starts with a completely empty form.
  final bool startFresh;

  const AddPropertyScreen({
    super.key,
    this.onStepChanged,
    this.resumeMode = false,
    this.startFresh = false,
  });

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  int _currentStep = 0;
  bool _isLoadingStep = true;
  bool _showSuccess = false;
  String? _lastErrorMessage;
  bool _hasShownSuccess = false;
  StreamSubscription<AddPropertyState>? _draftLoadSub;

  @override
  void initState() {
    super.initState();
    if (widget.resumeMode) {
      // Wait until the first frame so the BlocProvider ancestor is accessible
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _waitForDraftAndResume();
      });
    } else {
      _loadSavedStep();
    }
  }

  /// Called only in resumeMode. Listens to the Bloc stream and sets
  /// [_currentStep] as soon as the first state change arrives (= draft loaded).
  void _waitForDraftAndResume() {
    if (!mounted) return;
    final bloc = context.read<AddPropertyBloc>();

    // If the Bloc already holds a non-default draft state, use it immediately
    if (bloc.state.title != null || bloc.state.currentStep > 0) {
      setState(() {
        _currentStep = bloc.state.currentStep;
        _isLoadingStep = false;
      });
      return;
    }

    // Otherwise subscribe and wait for the first meaningful emission
    _draftLoadSub = bloc.stream.listen((state) {
      if (!mounted) return;
      setState(() {
        _currentStep = state.currentStep;
        _isLoadingStep = false;
      });
      _draftLoadSub?.cancel();
      _draftLoadSub = null;
    });

    // Fallback: stop loading after 5 s regardless
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && _isLoadingStep) {
        setState(() => _isLoadingStep = false);
        _draftLoadSub?.cancel();
        _draftLoadSub = null;
      }
    });
  }

  Future<void> _loadSavedStep() async {
    try {
      if (mounted) setState(() => _isLoadingStep = false);
    } catch (_) {
      if (mounted) setState(() => _isLoadingStep = false);
    }
  }

  @override
  void dispose() {
    _draftLoadSub?.cancel();
    super.dispose();
  }

  void _nextStep(BuildContext ctx, int maxSteps, {bool saveDraft = true}) {
    if (_currentStep < maxSteps - 1) {
      final newStep = _currentStep + 1;
      setState(() => _currentStep = newStep);
      widget.onStepChanged?.call(newStep);
      ctx.read<AddPropertyBloc>().add(
        UpdateCurrentStepEvent(newStep, saveDraft: saveDraft),
      );
    }
  }

  void _previousStep(BuildContext ctx) {
    if (_currentStep > 0) {
      final newStep = _currentStep - 1;
      setState(() => _currentStep = newStep);
      widget.onStepChanged?.call(newStep);
      ctx.read<AddPropertyBloc>().add(UpdateCurrentStepEvent(newStep));
    }
  }

  void _goToStep(BuildContext ctx, int stepIndex) {
    setState(() => _currentStep = stepIndex);
    widget.onStepChanged?.call(stepIndex);
    ctx.read<AddPropertyBloc>().add(UpdateCurrentStepEvent(stepIndex));
  }

  @override
  Widget build(BuildContext context) {
    final inner = BlocListener<AddPropertyBloc, AddPropertyState>(
      listenWhen: (prev, curr) =>
          prev.currentStep != curr.currentStep ||
          prev.isPublished != curr.isPublished ||
          prev.submitErrorMessage != curr.submitErrorMessage,
      listener: (context, state) {
        if (state.isPublished && !_hasShownSuccess) {
          _hasShownSuccess = true;
          AppSnackBar.success(
            context,
            'Property published successfully and will be reviewed soon',
            isTop: true,
          );
          setState(() => _showSuccess = true);
          widget.onStepChanged?.call(999); // hide navbar on success screen
          return;
        }

        if (state.submitErrorMessage != null &&
            state.submitErrorMessage != _lastErrorMessage) {
          _lastErrorMessage = state.submitErrorMessage;
          AppSnackBar.error(context, state.submitErrorMessage!);
        } else if (state.submitErrorMessage == null) {
          _lastErrorMessage = null;
        }

        if (state.currentStep != _currentStep) {
          setState(() {
            _currentStep = state.currentStep;
          });
          widget.onStepChanged?.call(state.currentStep);
        }
      },
      child: Builder(
        builder: (ctx) => Scaffold(
          backgroundColor: Theme.of(ctx).scaffoldBackgroundColor,
          body: SafeArea(
            child: _isLoadingStep
                ? Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(ctx).brightness == Brightness.dark
                          ? DarkColors.darkmainColor
                          : LightColors.lightmaincolor,
                    ),
                  )
                : _buildCurrentStep(ctx),
          ),
        ),
      ),
    );

    // When resumeMode=true, the caller already provides a BlocProvider with the
    // pre-loaded draft, so we skip creating a new one here.
    if (widget.resumeMode) {
      return inner;
    }

    return BlocProvider(
      create: (_) {
        final bloc = sl<AddPropertyBloc>()..add(LoadLookupsEvent());
        if (widget.startFresh) {
          // Start with a completely empty form — don't load any saved draft
          bloc.add(ResetStateEvent());
        } else {
          bloc.add(LoadDraftEvent());
        }
        return bloc;
      },
      child: inner,
    );
  }

  Widget _buildCurrentStep(BuildContext ctx) {
    return BlocBuilder<AddPropertyBloc, AddPropertyState>(
      builder: (context, state) {
        final isSale = state.transactionType == 'For Sale';
        final isRent = state.transactionType == 'For Rent';
        final isRentFull = isRent && state.listingStyle == 'Entire Property';
        final isRentRoom = isRent && state.listingStyle == 'Room-by-Room';

        final steps = <Widget Function(int index, int totalSteps)>[];

        // 0. Listing Type (Pre-Step)
        steps.add(
          (idx, total) => ListingTypeStep(onNext: () => _nextStep(ctx, total)),
        );

        // 1. Basic Info
        steps.add(
          (idx, total) => BasicInfoStep(
            onNext: () => _nextStep(ctx, total),
            onBack: () => _previousStep(ctx),
          ),
        );

        // 2. Location
        steps.add(
          (idx, total) => LocationStep(
            onNext: () => _nextStep(ctx, total),
            onBack: () => _previousStep(ctx),
          ),
        );

        // 3. Pricing
        if (isSale) {
          steps.add(
            (idx, total) => SalePricingStep(
              onNext: () => _nextStep(ctx, total),
              onBack: () => _previousStep(ctx),
            ),
          );
        } else if (isRentFull) {
          steps.add(
            (idx, total) => RentalPricingStep(
              onNext: () => _nextStep(ctx, total),
              onBack: () => _previousStep(ctx),
            ),
          );
        } else if (isRentRoom) {
          steps.add(
            (idx, total) => RoomPricingStep(
              onNext: () => _nextStep(ctx, total),
              onBack: () => _previousStep(ctx),
            ),
          );
        }

        // 4. Specs & Features (Sale & Rent Full only)
        if (isSale || isRentFull) {
          steps.add(
            (idx, total) => SpecsStep(
              onNext: () => _nextStep(ctx, total),
              onBack: () => _previousStep(ctx),
            ),
          );
        }

        // 4b. Availability Calendar (Short-Term only, after Specs/Pricing)
        final isShortTermFull =
            isRentFull && state.rentalPeriod == 'Short-Term';
        final isShortTermRoom =
            isRentRoom && state.roomRentalPeriod == 'Short-Term';

        if (isShortTermFull || isShortTermRoom) {
          steps.add(
            (idx, total) => CalendarStep(
              onNext: () => _nextStep(ctx, total),
              onBack: () => _previousStep(ctx),
            ),
          );
        }

        // 5. Amenities & Preferences (unified screen)
        steps.add(
          (idx, total) => AmenitiesStep(
            stepIndex: idx,
            onNext: () => _nextStep(ctx, total),
            onBack: () => _previousStep(ctx),
          ),
        );

        // 7. Media (All)
        steps.add(
          (idx, total) => MediaStep(
            onNext: () => _nextStep(ctx, total),
            onBack: () => _previousStep(ctx),
          ),
        );

        // Summary (All)
        steps.add(
          (idx, total) => SummaryStep(
            onBack: () => _previousStep(ctx),
            onEditStep: (stepIdx) => _goToStep(ctx, stepIdx),
            onPublish: () {
              ctx.read<AddPropertyBloc>().add(SubmitPropertyEvent());
            },
          ),
        );

        if (_showSuccess) {
          final isRoom = isRentRoom;
          return SuccessStep(
            title: isRoom ? 'Room Submitted!' : 'Listing Submitted!',
            subtitle: isRoom
                ? 'Your room listing has been successfully submitted and is now Pending Review. Our team will review it within 24 hours.'
                : 'Your property listing has been successfully submitted and is now Pending Review. Our team will review it within 24 hours.',
            listingTypeLabel: isRoom ? 'Room Listing' : 'Property Listing',
            listingTypeIcon: isRoom
                ? Icons.bed_outlined
                : Icons.home_work_outlined,
            onGoToListings: () {
              if (ctx.mounted) {
                Navigator.pushAndRemoveUntil(
                  ctx,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (_) => sl<MyListingCubit>(),
                      child: const MyListingsScreen(),
                    ),
                  ),
                  (route) => route.settings.name == Routes.mainLayout,
                );
              }
            },
            onAddAnother: () {
              setState(() {
                _showSuccess = false;
                _hasShownSuccess = false;
                _lastErrorMessage = null;
                _currentStep = 0;
              });
              widget.onStepChanged?.call(0); // show navbar again on step 0
              ctx.read<AddPropertyBloc>().add(ResetStateEvent());
            },
          );
        }

        final rawSteps = steps;

        // Safely adjust currentStep if it's out of bounds after a flow change
        if (_currentStep >= rawSteps.length) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _currentStep = rawSteps.length - 1;
            });
          });
          return const Center(child: CircularProgressIndicator());
        }

        // We don't count the ListingType (index 0) and Success (last index) in the progress bar calculation
        final stepsForProgress = rawSteps.length - 2;

        return StepNavigationContext(
          current: _currentStep,
          total: stepsForProgress,
          // null at step 0 (no back arrow), _previousStep for steps 1+
          onBack: _currentStep == 0 ? null : () => _previousStep(ctx),
          child: rawSteps[_currentStep](_currentStep, rawSteps.length),
        );
      },
    );
  }
}

class StepNavigationContext extends InheritedWidget {
  final int current;
  final int total;
  final VoidCallback?
  onBack; // null = hide back arrow, non-null = go to previous step

  const StepNavigationContext({
    super.key,
    required this.current,
    required this.total,
    this.onBack,
    required super.child,
  });

  static StepNavigationContext? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<StepNavigationContext>();
  }

  @override
  bool updateShouldNotify(StepNavigationContext oldWidget) {
    return current != oldWidget.current ||
        total != oldWidget.total ||
        onBack != oldWidget.onBack;
  }
}
