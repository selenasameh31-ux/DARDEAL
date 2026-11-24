import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class OfferBloc extends Bloc<OfferEvent, OfferState> {
  final CreateOfferUseCase createOfferUseCase;
  final SubmitOfferUseCase submitOfferUseCase;
  final ConfirmPaymentUseCase confirmPaymentUseCase;
  final CompleteHandoverUseCase completeHandoverUseCase;
  final GetPropertySummaryUseCase getPropertySummaryUseCase;
  final InitiatePaymentUseCase initiatePaymentUseCase;
  final CheckPaymentStatusUseCase checkPaymentStatusUseCase;

  OfferBloc({
    required this.createOfferUseCase,
    required this.submitOfferUseCase,
    required this.confirmPaymentUseCase,
    required this.completeHandoverUseCase,
    required this.getPropertySummaryUseCase,
    required this.initiatePaymentUseCase,
    required this.checkPaymentStatusUseCase,
  }) : super(const OfferState()) {
    on<LoadPropertyForOffer>(_onLoadProperty);
    on<OfferPriceChanged>(_onPriceChanged);
    on<TermsToggled>(_onTermsToggled);
    on<SubmitOfferRequested>(_onSubmitOffer);
    on<PaymentMethodSelected>(_onPaymentMethodSelected);
    on<ProcessPaymentRequested>(_onProcessPayment);
    on<CheckPaymentStatusRequested>(_onCheckPaymentStatus);
    on<ChecklistItemToggled>(_onChecklistItemToggled);
    on<ConfirmHandoverRequested>(_onConfirmHandover);
    on<ResetOfferStatus>(
      (event, emit) => emit(
        state.copyWith(status: OfferFlowStatus.initial, clearError: true),
      ),
    );
    on<SaleDownPaymentChanged>(_onSaleDownPaymentChanged);
    on<SalePaymentMethodChanged>(_onSalePaymentMethodChanged);
    on<SaleInstallmentDurationChanged>(_onSaleInstallmentDurationChanged);
  }

  // ═════════════════════════════════════════════════════════
  //  Load Property Details
  // ═════════════════════════════════════════════════════════

  Future<void> _onLoadProperty(
    LoadPropertyForOffer event,
    Emitter<OfferState> emit,
  ) async {
    emit(state.copyWith(status: OfferFlowStatus.loading));

    try {
      final property = await getPropertySummaryUseCase(event.propertyId);

      emit(
        state.copyWith(
          status: OfferFlowStatus.initial,
          propertyPrice: property.askingPrice,
          propertyTitle: property.title,
          propertyLocation: property.location,
          propertyImageUrl: property.imageUrl,
          isPropertyLoaded: true,
          offerPrice: property.askingPrice,
          isTermsAccepted: false, // User needs to explicitly accept terms
          clearError: true,
          listingType: property.listingType,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: OfferFlowStatus.failure,
          errorMessage: 'Failed to load property details. ${e.toString()}',
        ),
      );
    }
  }

  // ═════════════════════════════════════════════════════════
  //  Make Offer Screen Handlers
  // ═════════════════════════════════════════════════════════

  void _onPriceChanged(OfferPriceChanged event, Emitter<OfferState> emit) {
    emit(state.copyWith(offerPrice: event.price, clearError: true));
  }

  void _onTermsToggled(TermsToggled event, Emitter<OfferState> emit) {
    emit(state.copyWith(isTermsAccepted: event.accepted, clearError: true));
  }

  Future<void> _onSubmitOffer(
    SubmitOfferRequested event,
    Emitter<OfferState> emit,
  ) async {
    // ── Guard: prevent duplicate submissions ──
    if (state.isSubmitting) return;

    // ── Validation ──
    if (!state.isOfferValid) {
      emit(
        state.copyWith(
          status: OfferFlowStatus.failure,
          errorMessage: 'Please enter a valid price and accept the terms.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: OfferFlowStatus.loading,
        isSubmitting: true,
        clearError: true,
      ),
    );

    try {
      String? moveInDate;
      String? endDate;

      if (event.leaseStart != null) {
        String formatIso(DateTime d) {
          return "${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}T${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}:${d.second.toString().padLeft(2, '0')}.${d.millisecond.toString().padLeft(3, '0')}Z";
        }

        // Preserve the selected date in UTC to avoid timezone shifts
        final startUtc = DateTime.utc(
          event.leaseStart!.year,
          event.leaseStart!.month,
          event.leaseStart!.day,
          event.leaseStart!.hour,
          event.leaseStart!.minute,
          event.leaseStart!.second,
          event.leaseStart!.millisecond,
        );
        moveInDate = formatIso(startUtc);
      }

      if (event.leaseEnd != null) {
        String formatIso(DateTime d) {
          return "${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}T${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}:${d.second.toString().padLeft(2, '0')}.${d.millisecond.toString().padLeft(3, '0')}Z";
        }
        
        final endUtc = DateTime.utc(
          event.leaseEnd!.year,
          event.leaseEnd!.month,
          event.leaseEnd!.day,
          event.leaseEnd!.hour,
          event.leaseEnd!.minute,
          event.leaseEnd!.second,
          event.leaseEnd!.millisecond,
        );
        endDate = formatIso(endUtc);
      }

      // ── Client-side validation: prevent duplicate active offers ──
      try {
        final existingOffers = await sl<OfferRepository>().getMyOffers();
        final hasActiveOffer = existingOffers.any(
          (o) =>
              o.propertyId.toString() == event.propertyId &&
              (o.status.name.toUpperCase() == 'PENDING' ||
                  o.status.name.toUpperCase() == 'ACCEPTED'),
        );

        if (hasActiveOffer) {
          emit(
            state.copyWith(
              status: OfferFlowStatus.failure,
              errorMessage:
                  'You already have a Pending or Accepted offer for this property. You cannot submit another one until it is rejected.',
              isSubmitting: false,
            ),
          );
          return;
        }
      } catch (_) {
        // If it fails to fetch offers, we gracefully proceed rather than blocking completely
      }

      // Step 1: Create offer
      final offer = await createOfferUseCase(
        propertyId: event.propertyId,
        offerPrice: state.offerPrice,
        isTermsAccepted: state.isTermsAccepted,
        message: event.message,
        seekerNotes: event.seekerNotes,
        proposedMoveInDate: moveInDate,
        proposedEndDate: endDate,
      );

      // Step 2: Submit to backend
      final submittedOffer = await submitOfferUseCase(offer);

      emit(
        state.copyWith(
          status: OfferFlowStatus.success,
          isSubmitting: false,
          offerId: submittedOffer.id,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: OfferFlowStatus.failure,
          errorMessage: e.toString(),
          isSubmitting: false,
        ),
      );
    }
  }

  // ═════════════════════════════════════════════════════════
  //  Payment Screen Handlers
  // ═════════════════════════════════════════════════════════

  void _onPaymentMethodSelected(
    PaymentMethodSelected event,
    Emitter<OfferState> emit,
  ) {
    emit(state.copyWith(selectedPaymentMethod: event.method, clearError: true));
  }

  Future<void> _onProcessPayment(
    ProcessPaymentRequested event,
    Emitter<OfferState> emit,
  ) async {
    // ── Guard: prevent duplicate submissions ──
    if (state.isSubmitting) return;

    // ── Validation ──
    if (!state.isPaymentValid) {
      emit(
        state.copyWith(
          status: OfferFlowStatus.failure,
          errorMessage: 'Please select a payment method.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: OfferFlowStatus.loading,
        isSubmitting: true,
        clearError: true,
      ),
    );

    try {
      final offerId = int.tryParse(event.offerId);
      if (offerId == null || offerId == 0) {
        emit(
          state.copyWith(
            status: OfferFlowStatus.failure,
            errorMessage: 'Invalid offer ID. Please restart the offer flow.',
            isSubmitting: false,
          ),
        );
        return;
      }
      final idempotencyKey = const Uuid().v4();

      final result = await initiatePaymentUseCase(
        offerId: offerId,
        idempotencyKey: idempotencyKey,
      );

      final clientSecret = result['clientSecret'] as String?;
      final paymentId = result['paymentId'] as int?;

      emit(
        state.copyWith(
          status: OfferFlowStatus.paymentInitiated,
          clientSecret: clientSecret,
          paymentId: paymentId,
          isSubmitting: false,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: OfferFlowStatus.failure,
          errorMessage: e.toString(),
          isSubmitting: false,
        ),
      );
    }
  }

  Future<void> _onCheckPaymentStatus(
    CheckPaymentStatusRequested event,
    Emitter<OfferState> emit,
  ) async {
    try {
      final status = await checkPaymentStatusUseCase(
        paymentId: event.paymentId,
      );

      if (status == 'PAID') {
        emit(state.copyWith(status: OfferFlowStatus.success, clearError: true));
      } else if (status == 'FAILED') {
        emit(
          state.copyWith(
            status: OfferFlowStatus.failure,
            errorMessage: 'Payment failed. Please try again.',
          ),
        );
      }
      // For PENDING/INITIATED the UI will keep polling — emit nothing
    } catch (e) {
      emit(
        state.copyWith(
          status: OfferFlowStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  // ═════════════════════════════════════════════════════════
  //  Handover Screen Handlers
  // ═════════════════════════════════════════════════════════

  void _onChecklistItemToggled(
    ChecklistItemToggled event,
    Emitter<OfferState> emit,
  ) {
    final updatedChecklist = Map<String, bool>.from(state.checklistMap);
    updatedChecklist[event.key] = event.value;

    emit(
      state.copyWith(
        checklistMap: updatedChecklist,
        status: OfferFlowStatus.initial,
        clearError: true,
      ),
    );
  }

  Future<void> _onConfirmHandover(
    ConfirmHandoverRequested event,
    Emitter<OfferState> emit,
  ) async {
    // ── Guard: prevent duplicate submissions ──
    if (state.isSubmitting) return;

    // ── Validation ──
    if (!state.isHandoverValid) {
      emit(
        state.copyWith(
          status: OfferFlowStatus.failure,
          errorMessage: 'Please complete all checklist items.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: OfferFlowStatus.loading,
        isSubmitting: true,
        clearError: true,
      ),
    );

    try {
      await completeHandoverUseCase(
        offerId: event.offerId,
        contractFile: event.contractFile,
      );

      emit(
        state.copyWith(status: OfferFlowStatus.success, isSubmitting: false),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: OfferFlowStatus.failure,
          isSubmitting: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onSaleDownPaymentChanged(
    SaleDownPaymentChanged event,
    Emitter<OfferState> emit,
  ) {
    emit(state.copyWith(saleDownPayment: event.downPayment, clearError: true));
  }

  void _onSalePaymentMethodChanged(
    SalePaymentMethodChanged event,
    Emitter<OfferState> emit,
  ) {
    emit(state.copyWith(salePaymentMethod: event.method, clearError: true));
  }

  void _onSaleInstallmentDurationChanged(
    SaleInstallmentDurationChanged event,
    Emitter<OfferState> emit,
  ) {
    emit(state.copyWith(saleInstallmentDuration: event.duration, clearError: true));
  }
}
