import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class MakeOfferScreen extends StatefulWidget {
  final String propertyId;

  const MakeOfferScreen({super.key, required this.propertyId});

  @override
  State<MakeOfferScreen> createState() => _MakeOfferScreenState();
}

class _MakeOfferScreenState extends State<MakeOfferScreen> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _downPaymentController = TextEditingController();
  DateTime? _leaseStart;
  DateTime? _leaseEnd;
  String _selectedPaymentTerm = 'Monthly';
  bool _showErrors = false;
  bool _isPriceEditable = false;

  @override
  void initState() {
    super.initState();
    // Price will be set after property loads from Bloc
  }

  @override
  void dispose() {
    _priceController.dispose();
    _downPaymentController.dispose();
    super.dispose();
  }

  Future<void> _selectLeaseStart(BuildContext context) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final picked = await showDatePicker(
      context: context,
      initialDate: _leaseStart ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: isDark
                ? ColorScheme.dark(
                    primary: colorScheme.primary,
                    onPrimary: colorScheme.onPrimary,
                    surface: colorScheme.surface,
                    onSurface: colorScheme.onSurface,
                  )
                : ColorScheme.light(
                    primary: LightColors.lightmaincolor,
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: Colors.black,
                  ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _leaseStart) {
      setState(() {
        _leaseStart = picked;
        // If lease end is now before lease start, reset it
        if (_leaseEnd != null && _leaseEnd!.isBefore(_leaseStart!)) {
          _leaseEnd = null;
        }
      });
    }
  }

  Future<void> _selectLeaseEnd(BuildContext context) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final firstDate = _leaseStart ?? DateTime.now().add(const Duration(days: 1));

    final picked = await showDatePicker(
      context: context,
      initialDate: _leaseEnd ?? firstDate.add(const Duration(days: 30)),
      firstDate: firstDate,
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)), // e.g. up to 10 years
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: isDark
                ? ColorScheme.dark(
                    primary: colorScheme.primary,
                    onPrimary: colorScheme.onPrimary,
                    surface: colorScheme.surface,
                    onSurface: colorScheme.onSurface,
                  )
                : ColorScheme.light(
                    primary: LightColors.lightmaincolor,
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: Colors.black,
                  ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _leaseEnd) {
      setState(() {
        _leaseEnd = picked;
      });
    }
  }

  void _showGuidelinesDialog() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = isDark
        ? theme.colorScheme.primary
        : LightColors.lightmaincolor;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Community Guidelines',
          style: TextStyle(
            fontFamily: AppFonts.font,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        content: Text(
          '1. Offers are binding for 24 hours.\n'
          '2. Users must adhere to fair housing policies.\n'
          '3. Harassment or discriminatory behavior is strictly prohibited.\n'
          '4. All financial transactions must be conducted through the platform.',
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Got it',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = isDark
        ? DarkColors.darkBackGround
        : LightColors.lightBackGround;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: colorScheme.onSurface,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Make an Offer',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontFamily: AppFonts.font,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: colorScheme.onSurfaceVariant),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocConsumer<OfferBloc, OfferState>(
        listenWhen: (prev, curr) =>
            prev.status != curr.status ||
            prev.isPropertyLoaded != curr.isPropertyLoaded,
        listener: (context, state) {
          if (state.status == OfferFlowStatus.failure &&
              state.errorMessage != null) {
            AppSnackBar.error(context, state.errorMessage!);
          } else if (state.status == OfferFlowStatus.success) {
            final offerBloc = context.read<OfferBloc>();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: offerBloc,
                  child: const OfferSentSuccessScreen(),
                ),
              ),
            );
          }
          // Set price controller when property loads
          if (state.isPropertyLoaded && _priceController.text.isEmpty) {
            _priceController.text = state.propertyPrice.toInt().toString();
          }
        },
        builder: (context, offerState) {
          if (!offerState.isPropertyLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          return SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 16.0,
                    bottom: 120.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: OfferProgressStepper(
                          currentStep: 0,
                          stepLabels: [
                            'Details',
                            'Review',
                            'Payment',
                            'Handover',
                          ],
                        ),
                      ),
                      const VerifiedListingBanner(),
                      const SizedBox(height: 16),
                      PropertySummaryCard(
                        title: offerState.propertyTitle,
                        location: offerState.propertyLocation,
                        imageUrl: offerState.propertyImageUrl,
                        price: offerState.propertyPrice,
                        onDetailsTap: () {
                          final pId = int.tryParse(widget.propertyId) ?? 0;
                          final route = offerState.listingType?.toLowerCase() == 'sale'
                              ? Routes.propertyDetailsSale
                              : Routes.propertyDetailsRent;
                          Navigator.pushNamed(
                            context,
                            route,
                            arguments: pId,
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      const OfferSectionTitle(
                        title: 'Proposed Terms',
                        subtitle: '',
                      ),
                      const SizedBox(height: 12),
                      if (offerState.listingType?.toLowerCase() == 'sale')
                        SaleProposedTermsCard(
                          priceController: _priceController,
                          showErrors: _showErrors,
                          isPriceEditable: _isPriceEditable,
                          onEditTap: () {
                            setState(() {
                              _isPriceEditable = true;
                            });
                          },
                          onPriceChanged: (value) {
                            final price = double.tryParse(value) ?? 0.0;
                            context.read<OfferBloc>().add(
                              OfferPriceChanged(price),
                            );
                            if (_showErrors) setState(() {});
                          },
                          selectedPaymentMethod: offerState.salePaymentMethod,
                          onPaymentMethodChanged: (method) {
                            context.read<OfferBloc>().add(
                              SalePaymentMethodChanged(method),
                            );
                          },
                          downPaymentController: _downPaymentController,
                          onDownPaymentChanged: (value) {
                            final downPayment = double.tryParse(value) ?? 0.0;
                            context.read<OfferBloc>().add(
                              SaleDownPaymentChanged(downPayment),
                            );
                            if (_showErrors) setState(() {});
                          },
                          selectedInstallmentDuration: offerState.saleInstallmentDuration,
                          onInstallmentDurationChanged: (duration) {
                            context.read<OfferBloc>().add(
                              SaleInstallmentDurationChanged(duration),
                            );
                          },
                          leaseStart: _leaseStart,
                          onLeaseStartTap: () => _selectLeaseStart(context),
                        )
                      else
                        ProposedTermsCard(
                          priceController: _priceController,
                          showErrors: _showErrors,
                          isPriceEditable: _isPriceEditable,
                          onEditTap: () {
                            setState(() {
                              _isPriceEditable = true;
                            });
                          },
                          onPriceChanged: (value) {
                            final price = double.tryParse(value) ?? 0.0;
                            context.read<OfferBloc>().add(
                              OfferPriceChanged(price),
                            );
                            if (_showErrors) setState(() {});
                          },
                          leaseStart: _leaseStart,
                          onLeaseStartTap: () => _selectLeaseStart(context),
                          leaseEnd: _leaseEnd,
                          onLeaseEndTap: () => _selectLeaseEnd(context),
                          selectedPaymentTerm: _selectedPaymentTerm,
                          onPaymentTermChanged: (term) {
                            setState(() {
                              _selectedPaymentTerm = term;
                            });
                          },
                        ),
                      const SizedBox(height: 16),
                      CommunityGuidelinesCard(
                        onReadMore: _showGuidelinesDialog,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: BlocBuilder<OfferBloc, OfferState>(
                      buildWhen: (previous, current) =>
                          previous.isSubmitting != current.isSubmitting ||
                          previous.isOfferValid != current.isOfferValid ||
                          previous.listingType != current.listingType ||
                          previous.salePaymentMethod != current.salePaymentMethod ||
                          previous.saleDownPayment != current.saleDownPayment,
                      builder: (context, state) {
                        final isPriceEmpty = _priceController.text.isEmpty;
                        final isRent = state.listingType?.toLowerCase() != 'sale';
                        
                        bool isInvalid = isPriceEmpty;
                        if (isRent) {
                          isInvalid = isPriceEmpty || _leaseStart == null || _leaseEnd == null;
                        } else {
                          final needsDownPayment = state.salePaymentMethod == 'Installments';
                          isInvalid = isPriceEmpty || _leaseStart == null;
                          if (needsDownPayment) {
                            isInvalid = isInvalid || _downPaymentController.text.isEmpty || state.saleDownPayment <= 0;
                          }
                        }

                        return AppPrimaryButton(
                          text: 'Submit Offer',
                          loading: state.isSubmitting,
                          trailingIcon: Icons.arrow_forward,
                          textColor: Colors.white,
                          onPressed: !state.isSubmitting
                              ? () {
                                  if (isInvalid) {
                                    setState(() {
                                      _showErrors = true;
                                    });
                                    AppSnackBar.error(
                                      context,
                                      'Please complete all required fields.',
                                    );
                                    return;
                                  }
                                  
                                  String? seekerNotes = "string";
                                  if (!isRent) {
                                    seekerNotes = "Payment Method: ${state.salePaymentMethod}\n"
                                                  "Down Payment: ${state.saleDownPayment.toInt()} EGP\n"
                                                  "Installment Duration: ${state.saleInstallmentDuration}";
                                  }
                                  
                                  context.read<OfferBloc>().add(
                                    SubmitOfferRequested(
                                      propertyId: widget.propertyId,
                                      message: "string",
                                      seekerNotes: seekerNotes,
                                      leaseStart: _leaseStart,
                                      leaseEnd: isRent ? _leaseEnd : null,
                                    ),
                                  );
                                }
                              : null,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
