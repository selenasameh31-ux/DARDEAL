// ─────────────────────────────────────────────
// BLOC
// ─────────────────────────────────────────────
import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class AddPropertyBloc extends Bloc<AddPropertyEvent, AddPropertyState> {
  final SaveDraftUseCase saveDraftUseCase;
  final LoadDraftUseCase loadDraftUseCase;
  final ClearDraftUseCase clearDraftUseCase;
  final AddPropertyUseCase submitPropertyUseCase;
  final CacheHelper cacheHelper;

  // Lookup UseCases — injected, nullable so legacy callers work without them
  final FetchAmenitiesUseCase? fetchAmenitiesUseCase;
  final FetchNearbyFacilitiesUseCase? fetchNearbyFacilitiesUseCase;
  final FetchRulesUseCase? fetchRulesUseCase;
  final FetchPropertyTypesUseCase? fetchPropertyTypesUseCase;
  final FetchGovernotatesUseCase? fetchGovernotatesUseCase;
  final FetchCitiesUseCase? fetchCitiesUseCase;
  final FetchDistrictsUseCase? fetchDistrictsUseCase;

  Timer? _saveTimer;
  bool _isSwitchingFlow = false;

  AddPropertyBloc({
    required this.saveDraftUseCase,
    required this.loadDraftUseCase,
    required this.clearDraftUseCase,
    required this.submitPropertyUseCase,
    required this.cacheHelper,
    this.fetchAmenitiesUseCase,
    this.fetchNearbyFacilitiesUseCase,
    this.fetchRulesUseCase,
    this.fetchPropertyTypesUseCase,
    this.fetchGovernotatesUseCase,
    this.fetchCitiesUseCase,
    this.fetchDistrictsUseCase,
  }) : super(const AddPropertyState()) {
    // Image handlers
    on<AddPropertyImagesPickedEvent>(_onAddPropertyImagesPicked);
    on<RemovePropertyImageEvent>(_onRemovePropertyImage);
    on<EditPropertyImageEvent>(_onEditPropertyImage);
    on<SetCoverImageEvent>(_onSetCoverImage);
    on<ReorderPropertyImagesEvent>(_onReorderPropertyImages);
    on<AddPropertyVideoEvent>(_onAddPropertyVideo);
    on<RemovePropertyVideoEvent>(_onRemovePropertyVideo);
    on<UpdateUploadProgressEvent>(_onUpdateUploadProgress);
    // Room handlers
    on<AddRoomEvent>(_onAddRoom);
    on<EditRoomEvent>(_onEditRoom);
    on<DeleteRoomEvent>(_onDeleteRoom);
    // Reset State handler
    on<ResetStateEvent>(_onResetState);
    // Location handler
    on<LocationUpdateEvent>(_onLocationUpdate);
    // Basic Info handler
    on<UpdateBasicInfoEvent>(_onUpdateBasicInfo);
    // Listing Style handler
    on<UpdateListingStyleEvent>(_onUpdateListingStyle);
    // Community Rules handler
    on<UpdateCommunityRulesEvent>(_onUpdateCommunityRules);
    // Pricing handler
    on<UpdatePricingEvent>(_onUpdatePricing);
    on<UpdatePricingAndSpecsEvent>(_onUpdatePricingAndSpecs);
    on<UpdateSpecsEvent>(_onUpdateSpecs);
    on<UpdateRentalPricingEvent>((event, emit) {
      emit(
        state.copyWith(
          currency: event.currency ?? state.currency,
          price: event.rentPrice ?? state.price, // Map rent price to price
          rentalPeriod: event.rentalPeriod ?? state.rentalPeriod,
          deposit: event.deposit ?? state.deposit,
          paymentSchedule: event.paymentSchedule ?? state.paymentSchedule,
          priceIncludesCommission:
              event.priceIncludesCommission ?? state.priceIncludesCommission,
          totalArea: event.totalArea ?? state.totalArea,
          bedrooms: event.bedrooms ?? state.bedrooms,
          bathrooms: event.bathrooms ?? state.bathrooms,
          furnishingStatus: event.furnishingStatus ?? state.furnishingStatus,
          minimumLeaseDuration:
              event.minimumLeaseDuration ?? state.minimumLeaseDuration,
          availableFromDate: event.availableFromDate ?? state.availableFromDate,
          availableUntilDate:
              event.availableUntilDate ?? state.availableUntilDate,
          nightlyRate: event.nightlyRate ?? state.nightlyRate,
          weeklyRate: event.weeklyRate ?? state.weeklyRate,
          monthlyRate: event.monthlyRate ?? state.monthlyRate,
          minimumStay: event.minimumStay ?? state.minimumStay,
          maximumStay: event.maximumStay ?? state.maximumStay,
          checkInTime: event.checkInTime ?? state.checkInTime,
          checkOutTime: event.checkOutTime ?? state.checkOutTime,
        ),
      );
    });

    // Room Pricing handler — uses room-isolated fields
    on<UpdateRoomPricingEvent>((event, emit) {
      emit(
        state.copyWith(
          roomRentalPeriod: event.roomRentalPeriod ?? state.roomRentalPeriod,
          roomPrice: event.roomPrice ?? state.roomPrice,
          roomDeposit: event.roomDeposit ?? state.roomDeposit,
          roomNightlyRate: event.roomNightlyRate ?? state.roomNightlyRate,
          roomMinimumStay: event.roomMinimumStay ?? state.roomMinimumStay,
          roomMaximumStay: event.roomMaximumStay ?? state.roomMaximumStay,
          roomPrivacy: event.roomPrivacy ?? state.roomPrivacy,
          roomCapacity: event.roomCapacity ?? state.roomCapacity,
          roomArea: event.roomArea ?? state.roomArea,
          roomAreaUnit: event.roomAreaUnit ?? state.roomAreaUnit,
          listBeds: event.listBeds ?? state.listBeds,
          singleBeds: event.singleBeds ?? state.singleBeds,
          doubleBeds: event.doubleBeds ?? state.doubleBeds,
          queenBeds: event.queenBeds ?? state.queenBeds,
          kingBeds: event.kingBeds ?? state.kingBeds,
        ),
      );
    });

    // Amenities handler
    on<SearchAmenitiesEvent>(_onSearchAmenities);
    on<UpdateSelectedAmenitiesEvent>(_onUpdateSelectedAmenities);
    on<UpdateCommunityRulesSelectionEvent>(_onUpdateCommunityRulesSelection);
    on<UpdateNearbyFacilitiesSelectionEvent>(
      _onUpdateNearbyFacilitiesSelection,
    );
    // Lookup loading
    on<LoadLookupsEvent>(_onLoadLookups);
    on<LoadCitiesEvent>(_onLoadCities);
    on<LoadDistrictsEvent>(_onLoadDistricts);
    // Map pin handler
    on<MapLocationUpdateEvent>(_onMapLocationUpdate);
    // Calendar handlers
    on<ToggleCalendarDateEvent>(_onToggleCalendarDate);
    on<BlockWeekendsEvent>(_onBlockWeekends);
    on<ClearMonthEvent>(_onClearMonth);
    on<BlockSelectedDatesEvent>(_onBlockSelectedDates);
    on<BookSelectedDatesEvent>(_onBookSelectedDates);
    on<UnblockSelectedDatesEvent>(_onUnblockSelectedDates);
    // Draft handler
    on<SaveDraftEvent>(_onSaveDraft);
    on<UpdateCurrentStepEvent>(_onUpdateCurrentStep);
    on<LoadDraftEvent>(_onLoadDraft);
    on<ClearDraftEvent>(_onClearDraft);
    on<SwitchFlowEvent>(_onSwitchFlow);
    // Submit Property handler
    on<SubmitPropertyEvent>(_onSubmitProperty);
  }

  @override
  void onChange(Change<AddPropertyState> change) {
    super.onChange(change);

    // Don't auto-save while switching flows, loading, or after publishing
    if (_isSwitchingFlow || state.isPublished) return;

    // Trigger debounced save on any change
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 2), () {
      if (!isClosed) {
        add(SaveDraftEvent());
      }
    });
  }

  @override
  Future<void> close() {
    _saveTimer?.cancel();
    return super.close();
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _getDraftPrefix(String transactionType, String listingStyle) {
    if (transactionType == 'For Sale') return 'sell_draft_';
    if (transactionType == 'For Rent' && listingStyle == 'Room-by-Room') {
      return 'rent_room_draft_';
    }
    return 'rent_full_draft_';
  }

  void _onUpdateCurrentStep(
    UpdateCurrentStepEvent event,
    Emitter<AddPropertyState> emit,
  ) async {
    emit(state.copyWith(currentStep: event.step));
    if (event.saveDraft) {
      await _performManualSave();
    }
  }

  // ── Image handlers ──────────────────────────
  Future<void> _onAddPropertyImagesPicked(
    AddPropertyImagesPickedEvent event,
    Emitter<AddPropertyState> emit,
  ) async {
    final List<File> validFiles = [];
    for (var file in event.newImages) {
      if (file.lengthSync() <= 20 * 1024 * 1024) {
        // 20 MB max
        validFiles.add(file);
      }
    }

    if (validFiles.isNotEmpty) {
      final newImages = [...state.propertyImages, ...validFiles];
      File? newCover = state.coverImage;

      if (newCover == null && newImages.isNotEmpty) {
        newCover = newImages.first;
        newImages.removeAt(0);
      }

      emit(state.copyWith(propertyImages: newImages, coverImage: newCover));
    }
  }

  void _onReorderPropertyImages(
    ReorderPropertyImagesEvent event,
    Emitter<AddPropertyState> emit,
  ) {
    if (event.oldIndex < 0 || event.oldIndex >= state.propertyImages.length)
      return;
    int newIdx = event.newIndex;
    if (newIdx > state.propertyImages.length)
      newIdx = state.propertyImages.length;
    if (event.oldIndex < newIdx) {
      newIdx -= 1;
    }

    final updatedList = List<File>.from(state.propertyImages);
    final item = updatedList.removeAt(event.oldIndex);
    updatedList.insert(newIdx, item);

    emit(state.copyWith(propertyImages: updatedList));
  }

  Future<void> _onAddPropertyVideo(
    AddPropertyVideoEvent event,
    Emitter<AddPropertyState> emit,
  ) async {
    try {
      final file = event.file;
      // Max 50 MB
      if (file.lengthSync() <= 50 * 1024 * 1024) {
        emit(state.copyWith(propertyVideo: file));
      } else {
        if (event.onError != null) {
          event.onError!("Video size exceeds 50MB limit");
        }
      }
    } catch (_) {}
  }

  void _onRemovePropertyVideo(
    RemovePropertyVideoEvent event,
    Emitter<AddPropertyState> emit,
  ) {
    emit(state.copyWith(clearPropertyVideo: true));
  }

  void _onRemovePropertyImage(
    RemovePropertyImageEvent event,
    Emitter<AddPropertyState> emit,
  ) {
    if (event.index == -1 && state.coverImage != null) {
      // Remove Cover Image
      File? newCover;
      List<File> updatedImages = List.from(state.propertyImages);

      if (updatedImages.isNotEmpty) {
        newCover = updatedImages.first;
        updatedImages.removeAt(0);
      }

      emit(
        state.copyWith(
          coverImage: newCover,
          propertyImages: updatedImages,
          clearCoverImage: newCover == null,
        ),
      );
    } else if (event.index >= 0 && event.index < state.propertyImages.length) {
      final updated = List<File>.from(state.propertyImages)
        ..removeAt(event.index);
      emit(state.copyWith(propertyImages: updated));
    }
  }

  void _onEditPropertyImage(
    EditPropertyImageEvent event,
    Emitter<AddPropertyState> emit,
  ) {
    final file = event.newImage;
    if (file.lengthSync() <= 20 * 1024 * 1024) {
      if (event.index == -1) {
        // Edit cover image
        emit(state.copyWith(coverImage: file));
      } else if (event.index >= 0 &&
          event.index < state.propertyImages.length) {
        final updated = List<File>.from(state.propertyImages);
        updated[event.index] = file;
        emit(state.copyWith(propertyImages: updated));
      }
    }
  }

  void _onSetCoverImage(
    SetCoverImageEvent event,
    Emitter<AddPropertyState> emit,
  ) {
    if (event.index >= 0 && event.index < state.propertyImages.length) {
      final newCover = state.propertyImages[event.index];
      final updatedImages = List<File>.from(state.propertyImages)
        ..removeAt(event.index);
      if (state.coverImage != null) {
        updatedImages.insert(0, state.coverImage!);
      }
      emit(state.copyWith(coverImage: newCover, propertyImages: updatedImages));
    }
  }

  void _onUpdateUploadProgress(
    UpdateUploadProgressEvent event,
    Emitter<AddPropertyState> emit,
  ) {
    final updatedProgress = Map<int, double>.from(state.uploadProgress);
    if (event.progress == null || event.progress! >= 1.0) {
      updatedProgress.remove(event.index);
    } else {
      updatedProgress[event.index] = event.progress!;
    }
    emit(state.copyWith(uploadProgress: updatedProgress));
  }

  // ── Room handlers ───────────────────────────
  void _onAddRoom(AddRoomEvent event, Emitter<AddPropertyState> emit) {
    emit(state.copyWith(rooms: [...state.rooms, event.room]));
  }

  void _onEditRoom(EditRoomEvent event, Emitter<AddPropertyState> emit) {
    if (event.index >= 0 && event.index < state.rooms.length) {
      final updated = List<RoomModel>.from(state.rooms)
        ..[event.index] = event.updated;
      emit(state.copyWith(rooms: updated));
    }
  }

  void _onDeleteRoom(DeleteRoomEvent event, Emitter<AddPropertyState> emit) {
    if (event.index >= 0 && event.index < state.rooms.length) {
      final updated = List<RoomModel>.from(state.rooms)..removeAt(event.index);
      emit(state.copyWith(rooms: updated));
    }
  }

  // ── Location handler ────────────────────────
  void _onLocationUpdate(
    LocationUpdateEvent event,
    Emitter<AddPropertyState> emit,
  ) {
    emit(
      state.copyWith(
        governorate: event.governorate,
        city: event.city,
        area: event.area,
        address: event.address,
        building: event.building,
        floor: event.floor,
        unit: event.unit,
        governorateId: event.governorateId ?? state.governorateId,
        cityId: event.cityId ?? state.cityId,
        districtId: event.districtId ?? state.districtId,
        clearCityAndDistrict: event.clearCityAndDistrict,
      ),
    );
  }

  void _onUpdateBasicInfo(
    UpdateBasicInfoEvent event,
    Emitter<AddPropertyState> emit,
  ) {
    emit(
      state.copyWith(
        title: event.title,
        description: event.description,
        transactionType: event.transactionType,
        propertyType: event.propertyType,
        collectionCategory: event.collectionCategory,
      ),
    );
  }

  void _onUpdateListingStyle(
    UpdateListingStyleEvent event,
    Emitter<AddPropertyState> emit,
  ) {
    emit(state.copyWith(listingStyle: event.style));
  }

  void _onUpdateCommunityRules(
    UpdateCommunityRulesEvent event,
    Emitter<AddPropertyState> emit,
  ) {
    emit(
      state.copyWith(
        quietHoursEnabled: event.quietHoursEnabled,
        quietHoursStart: event.quietHoursStart,
        quietHoursEnd: event.quietHoursEnd,
        clearQuietHours: event.quietHoursEnabled == false,
      ),
    );
  }

  void _onUpdatePricing(
    UpdatePricingEvent event,
    Emitter<AddPropertyState> emit,
  ) {
    emit(
      state.copyWith(
        price: event.price ?? state.price,
        deposit: event.deposit ?? state.deposit,
        secondaryDescription:
            event.secondaryDescription ?? state.secondaryDescription,
      ),
    );
  }

  void _onUpdatePricingAndSpecs(
    UpdatePricingAndSpecsEvent event,
    Emitter<AddPropertyState> emit,
  ) {
    emit(
      state.copyWith(
        currency: event.currency ?? state.currency,
        price: event.price ?? state.price,
        deposit: event.deposit ?? state.deposit,
        maintenance: event.maintenance ?? state.maintenance,
        priceIncludesCommission:
            event.priceIncludesCommission ?? state.priceIncludesCommission,
        totalArea: event.totalArea ?? state.totalArea,
        bedrooms: event.bedrooms ?? state.bedrooms,
        bathrooms: event.bathrooms ?? state.bathrooms,
        furnishingStatus: event.furnishingStatus ?? state.furnishingStatus,
        paymentMethod: event.paymentMethod ?? state.paymentMethod,
        priceNegotiable: event.priceNegotiable ?? state.priceNegotiable,
        downPayment: event.downPayment ?? state.downPayment,
        installmentDuration:
            event.installmentDuration ?? state.installmentDuration,
      ),
    );
  }

  void _onUpdateSpecs(UpdateSpecsEvent event, Emitter<AddPropertyState> emit) {
    emit(
      state.copyWith(
        totalArea: event.totalArea ?? state.totalArea,
        areaUnit: event.areaUnit ?? state.areaUnit,
        bedrooms: event.bedrooms ?? state.bedrooms,
        bathrooms: event.bathrooms ?? state.bathrooms,
        floorNumber: event.floorNumber ?? state.floorNumber,
        furnishingStatus: event.furnishingStatus ?? state.furnishingStatus,
      ),
    );
  }

  // ── Map Pin handler ─────────────────────────
  void _onMapLocationUpdate(
    MapLocationUpdateEvent event,
    Emitter<AddPropertyState> emit,
  ) {
    emit(state.copyWith(latitude: event.latitude, longitude: event.longitude));
  }

  // ── Amenities handlers ───────────────────────
  void _onSearchAmenities(
    SearchAmenitiesEvent event,
    Emitter<AddPropertyState> emit,
  ) {
    emit(state.copyWith(amenitiesSearchQuery: event.query));
  }

  void _onUpdateSelectedAmenities(
    UpdateSelectedAmenitiesEvent event,
    Emitter<AddPropertyState> emit,
  ) {
    emit(state.copyWith(selectedAmenities: event.amenities));
  }

  void _onUpdateCommunityRulesSelection(
    UpdateCommunityRulesSelectionEvent event,
    Emitter<AddPropertyState> emit,
  ) {
    emit(state.copyWith(selectedCommunityRules: event.rules));
  }

  void _onUpdateNearbyFacilitiesSelection(
    UpdateNearbyFacilitiesSelectionEvent event,
    Emitter<AddPropertyState> emit,
  ) {
    emit(state.copyWith(selectedNearbyFacilities: event.facilities));
  }

  // ── Draft handlers ───────────────────────────
  void _onSwitchFlow(
    SwitchFlowEvent event,
    Emitter<AddPropertyState> emit,
  ) async {
    if (state.transactionType == event.transactionType &&
        state.listingStyle == event.listingStyle) {
      return;
    }

    _isSwitchingFlow = true;
    _saveTimer?.cancel();

    // Capture outgoing state before clearing it
    final outgoingPrefix = _getDraftPrefix(
      state.transactionType ?? 'For Sale',
      state.listingStyle,
    );
    final outgoingEntity = _stateToEntity(state);

    // Snapshot lookup lists BEFORE clearing — they are API-loaded and must survive flow switches
    final existingGovernorates = state.availableGovernorates;
    final existingCities = state.availableCities;
    final existingDistricts = state.availableDistricts;
    final existingAmenities = state.availableAmenities;
    final existingRules = state.availableRules;
    final existingFacilities = state.availableNearbyFacilities;
    final existingPropertyTypes = state.availablePropertyTypes;

    // 1. INSTANT FEEDBACK: Emit a fresh state for the target flow, preserving all API lookups
    emit(
      AddPropertyState(
        transactionType: event.transactionType,
        listingStyle: event.listingStyle,
        propertyType: _getDefaultPropertyType(
          event.transactionType,
          event.listingStyle,
        ),
        availableGovernorates: existingGovernorates,
        availableCities: existingCities,
        availableDistricts: existingDistricts,
        availableAmenities: existingAmenities,
        availableRules: existingRules,
        availableNearbyFacilities: existingFacilities,
        availablePropertyTypes: existingPropertyTypes,
      ),
    );

    // 2. Persist the outgoing flow's state
    await saveDraftUseCase(prefix: outgoingPrefix, entity: outgoingEntity);

    // 3. Trigger the load for the new flow's draft
    add(
      LoadDraftEvent(
        transactionType: event.transactionType,
        listingStyle: event.listingStyle,
      ),
    );
  }

  void _onSaveDraft(
    SaveDraftEvent event,
    Emitter<AddPropertyState> emit,
  ) async {
    if (_isSwitchingFlow || state.isPublished) return;

    try {
      final prefix = _getDraftPrefix(
        state.transactionType ?? 'For Sale',
        state.listingStyle,
      );
      final entity = _stateToEntity(state);
      await saveDraftUseCase(prefix: prefix, entity: entity);
      emit(state.copyWith(draftSaved: true));
    } catch (_) {
      emit(state.copyWith(draftSaved: true));
    }
  }

  Future<void> _performManualSave() async {
    try {
      final prefix = _getDraftPrefix(
        state.transactionType ?? 'For Sale',
        state.listingStyle,
      );
      final entity = _stateToEntity(state);
      await saveDraftUseCase(prefix: prefix, entity: entity);
    } catch (_) {}
  }

  void _onLoadDraft(
    LoadDraftEvent event,
    Emitter<AddPropertyState> emit,
  ) async {
    // Snapshot the target flow to guard against race conditions
    final targetTransaction = event.transactionType ?? state.transactionType;
    final targetStyle = event.listingStyle ?? state.listingStyle;

    try {
      final prefix = _getDraftPrefix(
        event.transactionType ?? state.transactionType ?? 'For Sale',
        event.listingStyle ?? state.listingStyle,
      );

      final entity = await loadDraftUseCase(prefix: prefix);
      final bool isExplicitSelection = event.transactionType != null;

      // GUARD: If the user switched flows again while we were loading, abort
      if (state.transactionType != targetTransaction ||
          state.listingStyle != targetStyle) {
        return;
      }

      if (entity == null) {
        if (event.transactionType != null) {
          emit(
            AddPropertyState(
              transactionType: event.transactionType,
              listingStyle: event.listingStyle ?? 'Entire Property',
              propertyType: _getDefaultPropertyType(
                event.transactionType!,
                event.listingStyle ?? 'Entire Property',
              ),
              availableGovernorates: state.availableGovernorates,
              availableCities: state.availableCities,
              availableDistricts: state.availableDistricts,
              availableAmenities: state.availableAmenities,
              availableRules: state.availableRules,
              availableNearbyFacilities: state.availableNearbyFacilities,
              availablePropertyTypes: state.availablePropertyTypes,
            ),
          );
        }
        _isSwitchingFlow = false;
        return;
      }

      // Convert Entity back to State
      final newState = _entityToState(
        entity,
        isExplicitSelection,
        event,
        state,
      );

      // FINAL GUARD: Ensure we are still on the right flow before final emission
      if (state.transactionType != targetTransaction ||
          state.listingStyle != targetStyle) {
        return;
      }

      emit(newState);
      _isSwitchingFlow = false;

      // ── Draft Restoration: Reload cities (and districts) if IDs were saved ──
      // availableCities and availableDistricts are runtime-only; they are
      // never persisted in the draft entity. We re-fetch them so the
      // dropdowns can display the previously-selected values correctly.
      //
      // IMPORTANT: We only dispatch LoadCitiesEvent here. LoadDistrictsEvent
      // is dispatched inside _onLoadCities when it detects that a cityId
      // already exists in state (i.e., draft restoration context).
      // This prevents a race condition where LoadCitiesEvent would reset
      // availableDistricts=[] and cityId=null AFTER LoadDistrictsEvent
      // had already populated them.
      if (newState.governorateId != null) {
        add(LoadCitiesEvent(newState.governorateId!));
      }
    } catch (_) {
      _isSwitchingFlow = false;
    }
  }

  void _onClearDraft(
    ClearDraftEvent event,
    Emitter<AddPropertyState> emit,
  ) async {
    emit(state.copyWith(isPublished: true));

    try {
      final prefix = _getDraftPrefix(event.transactionType, event.listingStyle);
      await clearDraftUseCase(prefix: prefix);
    } catch (_) {}
  }

  void _onResetState(
    ResetStateEvent event,
    Emitter<AddPropertyState> emit,
  ) {
    emit(
      AddPropertyState(
        availableGovernorates: state.availableGovernorates,
        availableCities: state.availableCities,
        availableDistricts: state.availableDistricts,
        availableAmenities: state.availableAmenities,
        availableRules: state.availableRules,
        availableNearbyFacilities: state.availableNearbyFacilities,
        availablePropertyTypes: state.availablePropertyTypes,
      ),
    );
  }

  void _onToggleCalendarDate(
    ToggleCalendarDateEvent event,
    Emitter<AddPropertyState> emit,
  ) {
    // Strip time for consistency
    final date = DateTime(event.date.year, event.date.month, event.date.day);

    final newSelected = Set<DateTime>.from(state.selectedDates);
    if (newSelected.contains(date)) {
      newSelected.remove(date);
    } else {
      newSelected.add(date);
    }
    emit(state.copyWith(selectedDates: newSelected));
  }

  void _onBlockWeekends(
    BlockWeekendsEvent event,
    Emitter<AddPropertyState> emit,
  ) {
    final newBlocked = Set<DateTime>.from(state.blockedDates);
    final daysInMonth = DateTime(event.year, event.month + 1, 0).day;
    for (int i = 1; i <= daysInMonth; i++) {
      final d = DateTime(event.year, event.month, i);
      if (d.weekday == DateTime.saturday || d.weekday == DateTime.sunday) {
        newBlocked.add(d);
      }
    }
    emit(state.copyWith(blockedDates: newBlocked));
  }

  void _onClearMonth(ClearMonthEvent event, Emitter<AddPropertyState> emit) {
    final newBlocked = Set<DateTime>.from(state.blockedDates);
    newBlocked.removeWhere(
      (d) => d.year == event.year && d.month == event.month,
    );
    emit(state.copyWith(blockedDates: newBlocked));
  }

  void _onBlockSelectedDates(
    BlockSelectedDatesEvent event,
    Emitter<AddPropertyState> emit,
  ) {
    if (state.selectedDates.isEmpty) return;

    final newBlocked = Set<DateTime>.from(state.blockedDates);
    final newBooked = Set<DateTime>.from(state.bookedDates);

    newBlocked.addAll(state.selectedDates);
    // Remove from booked if we are blocking
    for (var date in state.selectedDates) {
      newBooked.removeWhere((d) => _isSameDay(d, date));
    }

    emit(
      state.copyWith(
        blockedDates: newBlocked,
        bookedDates: newBooked,
        selectedDates: {},
      ),
    );
  }

  void _onUnblockSelectedDates(
    UnblockSelectedDatesEvent event,
    Emitter<AddPropertyState> emit,
  ) {
    if (state.selectedDates.isEmpty) return;

    final newBlocked = Set<DateTime>.from(state.blockedDates);
    final newBooked = Set<DateTime>.from(state.bookedDates);

    for (var date in state.selectedDates) {
      newBlocked.removeWhere((d) => _isSameDay(d, date));
      newBooked.removeWhere((d) => _isSameDay(d, date));
    }

    emit(
      state.copyWith(
        blockedDates: newBlocked,
        bookedDates: newBooked,
        selectedDates: {},
      ),
    );
  }

  void _onBookSelectedDates(
    BookSelectedDatesEvent event,
    Emitter<AddPropertyState> emit,
  ) {
    if (state.selectedDates.isEmpty) return;

    final newBooked = Set<DateTime>.from(state.bookedDates);
    final newBlocked = Set<DateTime>.from(state.blockedDates);

    newBooked.addAll(state.selectedDates);
    // Remove from blocked if we are booking
    for (var date in state.selectedDates) {
      newBlocked.removeWhere((d) => _isSameDay(d, date));
    }

    emit(
      state.copyWith(
        bookedDates: newBooked,
        blockedDates: newBlocked,
        selectedDates: {},
      ),
    );
  }

  String _getDefaultPropertyType(String transactionType, String listingStyle) {
    // Rent Room flow → default to 'Room'
    if (listingStyle == 'Room-by-Room' ||
        listingStyle == 'Private Room' ||
        listingStyle == 'Shared Room') {
      return 'Room';
    }
    // Sell / Rent Full Property → default to 'Apartment'
    return 'Apartment';
  }

  String? _timeOfDayToString(TimeOfDay? time) {
    if (time == null) return null;
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  TimeOfDay? _stringToTimeOfDay(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return null;
    try {
      // Handle HH:mm format
      if (timeStr.contains(':')) {
        final parts = timeStr.trim().split(':');
        // Handle HH:mm AM/PM legacy format if any
        if (parts.length >= 2) {
          int hour = int.parse(parts[0].replaceAll(RegExp(r'[^0-9]'), ''));
          int minute = int.parse(
            parts[1].split(' ')[0].replaceAll(RegExp(r'[^0-9]'), ''),
          );

          if (timeStr.toLowerCase().contains('pm') && hour < 12) hour += 12;
          if (timeStr.toLowerCase().contains('am') && hour == 12) hour = 0;

          return TimeOfDay(hour: hour, minute: minute);
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  // ── Mappers: State ↔ Entity ───────────────────────────────────────────────

  PropertyDraftEntity _stateToEntity(AddPropertyState st) {
    return PropertyDraftEntity(
      currentStep: st.currentStep,
      transactionType: st.transactionType ?? 'For Sale',
      listingStyle: st.listingStyle,
      governorate: st.governorate,
      city: st.city,
      area: st.area,
      address: st.address,
      building: st.building,
      floor: st.floor,
      unit: st.unit,
      latitude: st.latitude,
      longitude: st.longitude,
      title: st.title,
      description: st.description,
      propertyType: st.propertyType,
      collectionCategory: st.collectionCategory,
      quietHoursEnabled: st.quietHoursEnabled,
      quietHoursStart: _timeOfDayToString(st.quietHoursStart),
      quietHoursEnd: _timeOfDayToString(st.quietHoursEnd),
      price: st.price,
      deposit: st.deposit,
      secondaryDescription: st.secondaryDescription,
      currency: st.currency,
      maintenance: st.maintenance,
      priceIncludesCommission: st.priceIncludesCommission,
      totalArea: st.totalArea,
      areaUnit: st.areaUnit,
      bedrooms: st.bedrooms,
      bathrooms: st.bathrooms,
      floorNumber: st.floorNumber,
      furnishingStatus: st.furnishingStatus,
      paymentMethod: st.paymentMethod,
      priceNegotiable: st.priceNegotiable,
      downPayment: st.downPayment,
      installmentDuration: st.installmentDuration,
      rentalPeriod: st.rentalPeriod,
      paymentSchedule: st.paymentSchedule,
      minimumLeaseDuration: st.minimumLeaseDuration,
      availableFromDate: st.availableFromDate?.toIso8601String(),
      availableUntilDate: st.availableUntilDate?.toIso8601String(),
      blockedDates: st.blockedDates.map((e) => e.toIso8601String()).toList(),
      nightlyRate: st.nightlyRate,
      weeklyRate: st.weeklyRate,
      monthlyRate: st.monthlyRate,
      minimumStay: st.minimumStay,
      maximumStay: st.maximumStay,
      checkInTime: st.checkInTime,
      checkOutTime: st.checkOutTime,
      roomRentalPeriod: st.roomRentalPeriod,
      roomPrice: st.roomPrice,
      roomDeposit: st.roomDeposit,
      roomNightlyRate: st.roomNightlyRate,
      roomMinimumStay: st.roomMinimumStay,
      roomMaximumStay: st.roomMaximumStay,
      roomPrivacy: st.roomPrivacy,
      roomCapacity: st.roomCapacity ?? 1,
      roomArea: st.roomArea,
      roomAreaUnit: st.roomAreaUnit,
      listBeds: st.listBeds,
      singleBeds: st.singleBeds,
      doubleBeds: st.doubleBeds,
      queenBeds: st.queenBeds,
      kingBeds: st.kingBeds,
      selectedAmenityIds: st.selectedAmenities
          .map((a) => "${a.apiId}:${a.name}:${a.icon.codePoint}")
          .join('|'),
      selectedCommunityRuleIds: st.selectedCommunityRules
          .map((a) => "${a.apiId}:${a.name}:${a.icon.codePoint}")
          .join('|'),
      selectedNearbyFacilityIds: st.selectedNearbyFacilities
          .map((a) => "${a.apiId}:${a.name}:${a.icon.codePoint}")
          .join('|'),
      coverImagePath: st.coverImage?.path,
      propertyImagePaths: st.propertyImages.map((f) => f.path).toList(),
      propertyVideoPath: st.propertyVideo?.path,
      roomCount: st.rooms.length,
      roomsData: st.rooms
          .map(
            (r) => {
              'id': r.id,
              'title': r.title,
              'capacity': r.capacity,
              'size': r.size,
              'price': r.price,
              'icon': r.icon.codePoint,
              'imagePath': r.imagePath,
            },
          )
          .toList(),
      governorateId: st.governorateId,
      cityId: st.cityId,
      districtId: st.districtId,
    );
  }

  AddPropertyState _entityToState(
    PropertyDraftEntity entity,
    bool isExplicitSelection,
    LoadDraftEvent event,
    AddPropertyState currentState,
  ) {
    bool quietHoursEnabled = entity.quietHoursEnabled;
    TimeOfDay? quietHoursStart = _stringToTimeOfDay(entity.quietHoursStart);
    TimeOfDay? quietHoursEnd = _stringToTimeOfDay(entity.quietHoursEnd);

    if (quietHoursEnabled &&
        (quietHoursStart == null || quietHoursEnd == null)) {
      quietHoursEnabled = false;
      quietHoursStart = null;
      quietHoursEnd = null;
    }

    final transactionType = event.transactionType ?? entity.transactionType;
    final listingStyle = event.listingStyle ?? entity.listingStyle;

    final propertyType =
        (entity.propertyType == null || entity.propertyType!.isEmpty)
        ? _getDefaultPropertyType(transactionType, listingStyle)
        : entity.propertyType;

    // Load Media Files safely
    final loadedImages = entity.propertyImagePaths
        .map((p) => File(p))
        .where((f) => f.existsSync())
        .toList();

    File? loadedCover;
    if (entity.coverImagePath != null) {
      final f = File(entity.coverImagePath!);
      if (f.existsSync()) loadedCover = f;
    }

    File? loadedVideo;
    if (entity.propertyVideoPath != null) {
      final f = File(entity.propertyVideoPath!);
      if (f.existsSync()) loadedVideo = f;
    }

    // Load Amenities
    List<AmenityModel> loadedAmenities = _parseAmenitiesData(
      entity.selectedAmenityIds,
    );

    // Load Rules
    List<AmenityModel> loadedRules = _parseAmenitiesData(
      entity.selectedCommunityRuleIds,
    );
    List<AmenityModel> loadedFacilities = _parseAmenitiesData(
      entity.selectedNearbyFacilityIds,
    );

    // Load Rooms
    final List<RoomModel> rooms = [];
    for (int i = 0; i < entity.roomCount; i++) {
      final r = entity.roomsData[i];
      rooms.add(
        RoomModel(
          id: r['id'] ?? '',
          title: r['title'] ?? '',
          capacity: r['capacity'] ?? 1,
          size: r['size'] ?? 0.0,
          price: r['price'] ?? 0.0,
          icon: IconData(
            r['icon'] ?? Icons.room.codePoint,
            fontFamily: 'MaterialIcons',
          ),
          imagePath: r['imagePath'],
        ),
      );
    }

    return AddPropertyState(
      currentStep: 0,
      governorate: entity.governorate,
      city: entity.city,
      area: entity.area,
      address: entity.address,
      building: entity.building,
      floor: entity.floor,
      unit: entity.unit,
      title: entity.title,
      description: entity.description,
      transactionType: transactionType,
      propertyType: propertyType,
      collectionCategory: entity.collectionCategory,
      listingStyle: listingStyle,
      quietHoursEnabled: quietHoursEnabled,
      quietHoursStart: quietHoursStart,
      quietHoursEnd: quietHoursEnd,
      price: entity.price,
      deposit: entity.deposit,
      secondaryDescription: entity.secondaryDescription,
      currency: entity.currency,
      maintenance: entity.maintenance,
      priceIncludesCommission: entity.priceIncludesCommission,
      totalArea: entity.totalArea,
      areaUnit: entity.areaUnit,
      bedrooms: entity.bedrooms,
      bathrooms: entity.bathrooms,
      floorNumber: entity.floorNumber,
      furnishingStatus: entity.furnishingStatus,
      paymentMethod: entity.paymentMethod,
      priceNegotiable: entity.priceNegotiable,
      downPayment: entity.downPayment,
      installmentDuration: entity.installmentDuration,
      rentalPeriod: entity.rentalPeriod,
      paymentSchedule: entity.paymentSchedule,
      minimumLeaseDuration: entity.minimumLeaseDuration,
      availableFromDate: entity.availableFromDate != null
          ? DateTime.tryParse(entity.availableFromDate!)
          : null,
      availableUntilDate: entity.availableUntilDate != null
          ? DateTime.tryParse(entity.availableUntilDate!)
          : null,
      blockedDates: entity.blockedDates.map((e) => DateTime.parse(e)).toSet(),
      nightlyRate: entity.nightlyRate,
      weeklyRate: entity.weeklyRate,
      monthlyRate: entity.monthlyRate,
      minimumStay: entity.minimumStay,
      maximumStay: entity.maximumStay,
      checkInTime: entity.checkInTime,
      checkOutTime: entity.checkOutTime,
      roomRentalPeriod: entity.roomRentalPeriod,
      roomPrice: entity.roomPrice,
      roomDeposit: entity.roomDeposit,
      roomNightlyRate: entity.roomNightlyRate,
      roomMinimumStay: entity.roomMinimumStay,
      roomMaximumStay: entity.roomMaximumStay,
      roomPrivacy: entity.roomPrivacy,
      roomCapacity: entity.roomCapacity,
      roomArea: entity.roomArea,
      roomAreaUnit: entity.roomAreaUnit,
      listBeds: entity.listBeds,
      singleBeds: entity.singleBeds,
      doubleBeds: entity.doubleBeds,
      queenBeds: entity.queenBeds,
      kingBeds: entity.kingBeds,
      latitude: entity.latitude,
      longitude: entity.longitude,
      governorateId: entity.governorateId,
      cityId: entity.cityId,
      districtId: entity.districtId,
      propertyImages: loadedImages,
      coverImage: loadedCover,
      propertyVideo: loadedVideo,
      rooms: rooms,
      selectedAmenities: loadedAmenities,
      selectedCommunityRules: loadedRules,
      selectedNearbyFacilities: loadedFacilities,
      // Preserve API-loaded lookup lists — they are not persisted in the draft entity
      availableGovernorates: currentState.availableGovernorates,
      availableCities: currentState.availableCities,
      availableDistricts: currentState.availableDistricts,
      availableAmenities: currentState.availableAmenities,
      availableRules: currentState.availableRules,
      availableNearbyFacilities: currentState.availableNearbyFacilities,
      availablePropertyTypes: currentState.availablePropertyTypes,
    );
  }

  List<AmenityModel> _parseAmenitiesData(String source) {
    if (source.isEmpty) return [];
    final List<AmenityModel> result = [];
    final parts = source.split('|');
    for (var part in parts) {
      final data = part.split(':');
      if (data.length >= 3) {
        final apiId = int.tryParse(data[0]) ?? 0;
        result.add(
          AmenityModel(
            id: data[0],
            apiId: apiId,
            name: data[1],
            icon: IconData(
              int.tryParse(data[2]) ?? Icons.check.codePoint,
              fontFamily: 'MaterialIcons',
            ),
          ),
        );
      }
    }
    return result;
  }

  // ── Lookup Handlers ────────────────────────────────────────────────────────

  Future<void> _onLoadLookups(
    LoadLookupsEvent event,
    Emitter<AddPropertyState> emit,
  ) async {
    // ── Cache guard: skip fetch if all lookup data is already in state ──────
    // This prevents flickering/empty grid on navigation back or screen rebuild.
    if (state.availablePropertyTypes.isNotEmpty &&
        state.availableAmenities.isNotEmpty &&
        state.availableGovernorates.isNotEmpty) {
      return;
    }

    emit(state.copyWith(isLoadingLookups: true));
    int retryCount = 0;
    while (retryCount < 3) {
      try {
        // Fetch all lookup lists in parallel for efficiency
        final results = await Future.wait([
          fetchAmenitiesUseCase?.call() ?? Future.value(<LookupItemModel>[]),
          fetchNearbyFacilitiesUseCase?.call() ??
              Future.value(<LookupItemModel>[]),
          fetchRulesUseCase?.call() ?? Future.value(<LookupItemModel>[]),
          fetchPropertyTypesUseCase?.call() ?? Future.value(<LookupItemModel>[]),
          fetchGovernotatesUseCase?.call() ?? Future.value(<GovernorateModel>[]),
        ]);

        final amenityItems = results[0] as List<LookupItemModel>;
        final facilityItems = results[1] as List<LookupItemModel>;
        final ruleItems = results[2] as List<LookupItemModel>;
        final propTypeItems = results[3] as List<LookupItemModel>;
        final governorates = results[4] as List<GovernorateModel>;

        final fallbackIcon = Icons.star_outline;

        emit(
          state.copyWith(
            isLoadingLookups: false,
            availableAmenities: amenityItems
                .map(
                  (l) => AmenityModel.fromLookup(l, fallbackIcon: fallbackIcon),
                )
                .toList(),
            availableNearbyFacilities: facilityItems
                .map(
                  (l) => AmenityModel.fromLookup(
                    l,
                    fallbackIcon: Icons.location_on_outlined,
                  ),
                )
                .toList(),
            availableRules: ruleItems
                .map(
                  (l) => AmenityModel.fromLookup(
                    l,
                    fallbackIcon: Icons.rule_outlined,
                  ),
                )
                .toList(),
            availablePropertyTypes: propTypeItems.map((l) => l.nameEn).toList(),
            availableGovernorates: governorates,
          ),
        );
        return; // Success
      } catch (_) {
        retryCount++;
        if (retryCount >= 3) {
          // Silently fall back to static data — UI will use AmenitiesData
          emit(state.copyWith(isLoadingLookups: false));
          return;
        }
        await Future.delayed(const Duration(seconds: 2));
      }
    }
  }

  Future<void> _onLoadCities(
    LoadCitiesEvent event,
    Emitter<AddPropertyState> emit,
  ) async {
    try {
      // Snapshot the existing cityId BEFORE the async gap.
      // If cityId is non-null here, it means we are in a draft restoration
      // context — the draft had a saved city. In that case, we must NOT
      // reset cityId/districtId, and we should chain LoadDistrictsEvent.
      final restoredCityId = state.cityId;

      final cities = await fetchCitiesUseCase?.call(event.governorateId) ?? [];

      if (restoredCityId != null) {
        // ── Draft Restoration Context ──
        // Preserve the restored cityId and districtId; only populate the
        // cities dropdown list so the saved value can be displayed.
        emit(
          state.copyWith(
            governorateId: event.governorateId,
            availableCities: cities,
          ),
        );
        // Chain: now that cities are loaded, load the districts for the
        // restored city. This guarantees correct ordering.
        add(LoadDistrictsEvent(restoredCityId));
      } else {
        // ── Normal User Interaction (manual governorate change) ──
        // Reset downstream selections as the user is starting fresh.
        emit(
          state.copyWith(
            governorateId: event.governorateId,
            availableCities: cities,
            availableDistricts: [],
            cityId: null,
            districtId: null,
          ),
        );
      }
    } catch (_) {}
  }

  Future<void> _onLoadDistricts(
    LoadDistrictsEvent event,
    Emitter<AddPropertyState> emit,
  ) async {
    try {
      final districts = await fetchDistrictsUseCase?.call(event.cityId) ?? [];
      emit(
        state.copyWith(
          cityId: event.cityId,
          availableDistricts: districts,
          districtId: null,
        ),
      );
    } catch (_) {}
  }

  // ─────────────────────────────────────────────
  // SUBMIT PROPERTY — Phase 4
  // ─────────────────────────────────────────────
  Future<void> _onSubmitProperty(
    SubmitPropertyEvent event,
    Emitter<AddPropertyState> emit,
  ) async {
    // Guard: Prevent duplicate submissions
    if (state.isSubmitting) return;

    final token = cacheHelper.getToken();

    if (token == null || token.isEmpty) {
      emit(state.copyWith(submitErrorMessage: 'You must log in first'));
      return;
    }

    // Cancel any pending auto-save to avoid race condition
    _saveTimer?.cancel();

    emit(state.copyWith(isSubmitting: true, submitErrorMessage: null));

    print("=== [SubmitFlow] Started submitting property ===");

    try {
      final draftPrefix = _getDraftPrefix(
        state.transactionType ?? 'For Sale',
        state.listingStyle,
      );

      // ALways use the latest live state for submission, to prevent using stale cache data
      final draft = _stateToEntity(state);

      print("=== [SubmitFlow] Entity mapped successfully ===");

      await submitPropertyUseCase(draft: draft, token: token);
      print(
        "=== [SubmitFlow] submitPropertyUseCase completed successfully ===",
      );

      // ✅ Draft cleared ONLY after full orchestration succeeds
      await clearDraftUseCase(prefix: draftPrefix);

      emit(
        state.copyWith(
          isSubmitting: false,
          isPublished: true,
          submitErrorMessage: null,
        ),
      );
      print("=== [SubmitFlow] Finished successfully ===");
    } on UnauthorizedException catch (e, stack) {
      print("=== [SubmitFlow] UnauthorizedException: ${e.message} ===");
      emit(state.copyWith(isSubmitting: false, submitErrorMessage: e.message));
    } on NotFoundException catch (e, stack) {
      emit(state.copyWith(isSubmitting: false, submitErrorMessage: e.message));
    } on ServerException catch (e, stack) {
      print("=== [SubmitFlow] ServerException: ${e.message} ===");
      emit(state.copyWith(isSubmitting: false, submitErrorMessage: e.message));
    } on DioException catch (e, stack) {
      String message = 'Submission failed due to a network error';
      if (e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map) {
          if (data.containsKey('errors') && data['errors'] is Map) {
            final errors = data['errors'] as Map;
            if (errors.isNotEmpty) {
              final firstKey = errors.keys.first;
              final firstErrorList = errors[firstKey];
              if (firstErrorList is List && firstErrorList.isNotEmpty) {
                message = firstErrorList.first.toString();
              }
            }
          } else if (data.containsKey('message')) {
            message = data['message'].toString();
          }
        }
      }
      emit(state.copyWith(isSubmitting: false, submitErrorMessage: message));
    } catch (e, stack) {
      print("=== [SubmitFlow] Unhandled Exception: $e ===");
      print("=== [SubmitFlow] StackTrace: $stack ===");
      final message = e.toString().replaceFirst('Exception: ', '');
      emit(state.copyWith(isSubmitting: false, submitErrorMessage: message));
    }
  }
}

extension on PropertyDraftEntity {
  PropertyDraftEntity copyWithStep(int step) {
    return PropertyDraftEntity(
      currentStep: step,
      transactionType: transactionType,
      listingStyle: listingStyle,
      // Pass all other fields as is
      governorate: governorate,
      city: city,
      area: area,
      address: address,
      building: building,
      floor: floor,
      unit: this.unit,
      latitude: latitude,
      longitude: longitude,
      title: title,
      description: description,
      propertyType: propertyType,
      collectionCategory: collectionCategory,
      quietHoursEnabled: quietHoursEnabled,
      quietHoursStart: quietHoursStart,
      quietHoursEnd: quietHoursEnd,
      price: price,
      deposit: deposit,
      secondaryDescription: secondaryDescription,
      currency: currency,
      maintenance: maintenance,
      priceIncludesCommission: priceIncludesCommission,
      totalArea: totalArea,
      areaUnit: areaUnit,
      bedrooms: bedrooms,
      bathrooms: bathrooms,
      floorNumber: floorNumber,
      furnishingStatus: furnishingStatus,
      paymentMethod: paymentMethod,
      priceNegotiable: priceNegotiable,
      downPayment: downPayment,
      installmentDuration: installmentDuration,
      rentalPeriod: rentalPeriod,
      paymentSchedule: paymentSchedule,
      minimumLeaseDuration: minimumLeaseDuration,
      nightlyRate: nightlyRate,
      weeklyRate: weeklyRate,
      monthlyRate: monthlyRate,
      minimumStay: minimumStay,
      maximumStay: maximumStay,
      checkInTime: checkInTime,
      checkOutTime: checkOutTime,
      roomRentalPeriod: roomRentalPeriod,
      roomPrice: roomPrice,
      roomDeposit: roomDeposit,
      roomNightlyRate: roomNightlyRate,
      roomMinimumStay: roomMinimumStay,
      roomMaximumStay: roomMaximumStay,
      roomPrivacy: roomPrivacy,
      roomCapacity: roomCapacity,
      roomArea: roomArea,
      roomAreaUnit: roomAreaUnit,
      listBeds: listBeds,
      singleBeds: singleBeds,
      doubleBeds: doubleBeds,
      queenBeds: queenBeds,
      kingBeds: kingBeds,
      selectedAmenityIds: selectedAmenityIds,
      selectedCommunityRuleIds: selectedCommunityRuleIds,
      selectedNearbyFacilityIds: selectedNearbyFacilityIds,
      coverImagePath: coverImagePath,
      propertyImagePaths: propertyImagePaths,
      propertyVideoPath: propertyVideoPath,
      roomCount: roomCount,
      roomsData: roomsData,
    );
  }
}
