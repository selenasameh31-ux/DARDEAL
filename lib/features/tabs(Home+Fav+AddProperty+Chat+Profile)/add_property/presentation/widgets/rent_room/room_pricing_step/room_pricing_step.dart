import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class RoomPricingStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const RoomPricingStep({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<RoomPricingStep> createState() => _RoomPricingStepState();
}

class _RoomPricingStepState extends State<RoomPricingStep> {
  final _formKey = GlobalKey<FormState>();
  final _areaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final state = context.read<AddPropertyBloc>().state;
    _areaController.text = state.roomArea ?? '';
  }

  @override
  void dispose() {
    _areaController.dispose();
    super.dispose();
  }

  void _dispatch(UpdateRoomPricingEvent event) {
    context.read<AddPropertyBloc>().add(event);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddPropertyBloc, AddPropertyState>(
      builder: (context, state) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final primary = context.primaryColor;
        final txtColor = context.titleColor;
        final subtitleColor = isDark ? Colors.white60 : const Color(0xFF64748B);
        final labelColor = isDark ? Colors.white70 : const Color(0xFF0F172A);
        final isShortTerm = state.roomRentalPeriod == 'Short-Term';

        return Material(
          color: context.scaffoldBgColor,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ────────────────────────────────────────
                  const StepHeader(),
                  const SizedBox(height: 20),

                  // ── Title ─────────────────────────────────────────
                  Text(
                    'Pricing & Details',
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
                    'Set the right price and outline the room layout.',
                    style: TextStyle(
                      fontFamily: AppFonts.font,
                      fontSize: 14,
                      color: subtitleColor,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Duration selector (shared) ────────────────────
                  _buildLabel(
                    'How would you like to rent this room?',
                    isDark,
                    labelColor,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: SelectionCard(
                          title: 'Long-Term',
                          subtitle: 'Monthly/Yearly',
                          icon: Icons.home_outlined,
                          isSelected: !isShortTerm,
                          onTap: () => _dispatch(
                            UpdateRoomPricingEvent(
                              roomRentalPeriod: 'Long-Term',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SelectionCard(
                          title: 'Short-Term',
                          subtitle: 'Daily/Weekly',
                          icon: Icons.beach_access_outlined,
                          isSelected: isShortTerm,
                          onTap: () => _dispatch(
                            UpdateRoomPricingEvent(
                              roomRentalPeriod: 'Short-Term',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // ── Pricing fields (conditional) ──────────────────
                  if (!isShortTerm)
                    _buildLongTermFields(state)
                  else
                    _buildShortTermFields(state),

                  const SizedBox(height: 28),

                  // ── Room Privacy (shared between both modes) ──────
                  _buildLabel(
                    'Is this room private or shared?',
                    isDark,
                    labelColor,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: SelectionCard(
                          title: 'Private Room',
                          icon: Icons.door_front_door_outlined,
                          isSelected: state.roomPrivacy == 'Private Room',
                          onTap: () => _dispatch(
                            UpdateRoomPricingEvent(roomPrivacy: 'Private Room'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SelectionCard(
                          title: 'Shared Room',
                          icon: Icons.people_outline,
                          isSelected: state.roomPrivacy == 'Shared Room',
                          onTap: () => _dispatch(
                            UpdateRoomPricingEvent(roomPrivacy: 'Shared Room'),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ── Room Capacity (Only if Shared) ────────────────
                  if (state.roomPrivacy == 'Shared Room') ...[
                    const SizedBox(height: 28),
                    _buildLabel('Total Room Capacity', isDark, labelColor),
                    const SizedBox(height: 4),
                    Text(
                      'What is the maximum number of people who can share this room?',
                      style: TextStyle(
                        fontFamily: AppFonts.font,
                        fontSize: 13,
                        color: subtitleColor,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: AppCounterWidget(
                        label: '',
                        value: state.roomCapacity ?? 1,
                        minValue: 1,
                        width: 140,
                        backgroundColor: isDark
                            ? const Color(0xFF1A2428)
                            : const Color(0xFFF8FAFB),
                        borderColor: isDark
                            ? const Color(0xFF475569)
                            : const Color(0xFFCBD5E1),
                        onIncrement: () {
                          final current = state.roomCapacity ?? 1;
                          _dispatch(
                            UpdateRoomPricingEvent(roomCapacity: current + 1),
                          );
                        },
                        onDecrement: () {
                          final current = state.roomCapacity ?? 1;
                          if (current > 1) {
                            _dispatch(
                              UpdateRoomPricingEvent(roomCapacity: current - 1),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                  const SizedBox(height: 28),

                  // ── Room Area ──────────────────────────────────────
                  _buildRoomArea(state, isDark, primary, txtColor),
                  const SizedBox(height: 32),

                  // ── Bed Types ──────────────────────────────────────
                  _buildBedTypesSection(
                    state,
                    isDark,
                    txtColor,
                    labelColor,
                    primary,
                  ),

                  const SizedBox(height: 32),

                  // ── Navigation ─────────────────────────────────────
                  StepNavigationButtons(
                    step: 3,
                    onBack: widget.onBack,
                    onNext: () {
                      if (_areaController.text.trim().isEmpty) {
                        AppSnackBar.error(
                          context,
                          'Please enter the room area.',
                        );
                        return;
                      }
                      if (_formKey.currentState?.validate() ?? false) {
                        widget.onNext();
                      } else {
                        AppSnackBar.error(
                          context,
                          'Please review the room pricing information.',
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

  // ─────────────────────────────────────────────────────────────────
  // Long-Term Fields
  // ─────────────────────────────────────────────────────────────────
  Widget _buildLongTermFields(AddPropertyState state) {
    return LongTermBaseFields(
      monthlyRent: state.roomPrice,
      deposit: state.roomDeposit,
      depositSubtitle: 'Refundable amount returned at end of lease',
      onMonthlyRentChanged: (val) =>
          _dispatch(UpdateRoomPricingEvent(roomPrice: val)),
      onDepositChanged: (val) =>
          _dispatch(UpdateRoomPricingEvent(roomDeposit: val)),
      rentValidator: (val) =>
          AppValidators.validateNumeric(val, isRequired: true, minLength: 3),
      depositValidator: (val) =>
          AppValidators.validateNumeric(val, isRequired: false, minLength: 3),
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // Short-Term Fields
  // ─────────────────────────────────────────────────────────────────
  Widget _buildShortTermFields(AddPropertyState state) {
    return ShortTermFields(
      nightlyRate: state.roomNightlyRate,
      deposit: state.roomDeposit,
      depositSubtitle: 'Held during stay, fully refundable',
      minimumStay: state.roomMinimumStay,
      maximumStay: state.roomMaximumStay,
      onNightlyRateChanged: (val) =>
          _dispatch(UpdateRoomPricingEvent(roomNightlyRate: val)),
      onDepositChanged: (val) =>
          _dispatch(UpdateRoomPricingEvent(roomDeposit: val)),
      onMinimumStayChanged: (val) {
        if (val != null) {
          _dispatch(UpdateRoomPricingEvent(roomMinimumStay: val));
        }
      },
      onMaximumStayChanged: (val) {
        if (val != null) {
          _dispatch(UpdateRoomPricingEvent(roomMaximumStay: val));
        }
      },
      nightlyRateValidator: (val) =>
          AppValidators.validateNumeric(val, isRequired: true, minLength: 3),
      depositValidator: (val) =>
          AppValidators.validateNumeric(val, isRequired: false, minLength: 3),
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // Room Area
  // ─────────────────────────────────────────────────────────────────
  Widget _buildRoomArea(
    AddPropertyState state,
    bool isDark,
    Color primary,
    Color txtColor,
  ) {
    final labelColor = isDark ? Colors.white70 : const Color(0xFF0F172A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Room Area',
            style: TextStyle(
              fontFamily: AppFonts.font,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: labelColor,
            ),
            children: const [
              TextSpan(
                text: ' *',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A2428) : const Color(0xFFF8FAFB),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: context.buttonBorderColor),
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
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: 'e.g. 25',
                    hintStyle: TextStyle(
                      fontFamily: AppFonts.font,
                      color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (v) =>
                      _dispatch(UpdateRoomPricingEvent(roomArea: v)),
                  validator: (v) => AppValidators.validateNumeric(
                    v,
                    isRequired: true,
                    minLength: 2,
                  ),
                ),
              ),
              // Unit toggle
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E2A2E)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: ['m²', 'sq ft'].map((unit) {
                    final isSelected = (state.roomAreaUnit ?? 'm²') == unit;
                    return GestureDetector(
                      onTap: () =>
                          _dispatch(UpdateRoomPricingEvent(roomAreaUnit: unit)),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: isSelected && !isDark
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
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
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // Bed Types Section
  // ─────────────────────────────────────────────────────────────────
  Widget _buildBedTypesSection(
    AddPropertyState state,
    bool isDark,
    Color txtColor,
    Color labelColor,
    Color primary,
  ) {
    final subtitleColor = isDark ? Colors.white60 : const Color(0xFF64748B);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Toggle
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'List beds in this room?',
                    style: TextStyle(
                      fontFamily: AppFonts.font,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: txtColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Helpful if the room is furnished.',
                    style: TextStyle(
                      fontFamily: AppFonts.font,
                      fontSize: 13,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
            ),
            CupertinoSwitch(
              activeTrackColor: primary,
              value: state.listBeds,
              onChanged: (val) =>
                  _dispatch(UpdateRoomPricingEvent(listBeds: val)),
            ),
          ],
        ),

        // Bed Counters
        if (state.listBeds) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E2A2E) : const Color(0xFFF8FAFB),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.buttonBorderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bed Types & Quantities',
                  style: TextStyle(
                    fontFamily: AppFonts.font,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: labelColor,
                  ),
                ),
                const SizedBox(height: 16),
                _buildBedCounter(
                  'Single Bed',
                  Icons.single_bed_outlined,
                  state.singleBeds,
                  (val) => _dispatch(UpdateRoomPricingEvent(singleBeds: val)),
                  isDark,
                  txtColor,
                ),
                const SizedBox(height: 12),
                _buildBedCounter(
                  'Double Bed',
                  Icons.bed_outlined,
                  state.doubleBeds,
                  (val) => _dispatch(UpdateRoomPricingEvent(doubleBeds: val)),
                  isDark,
                  txtColor,
                ),
                const SizedBox(height: 12),
                _buildBedCounter(
                  'Queen Bed',
                  Icons.bed,
                  state.queenBeds,
                  (val) => _dispatch(UpdateRoomPricingEvent(queenBeds: val)),
                  isDark,
                  txtColor,
                ),
                const SizedBox(height: 12),
                _buildBedCounter(
                  'King Bed',
                  Icons.king_bed_outlined,
                  state.kingBeds,
                  (val) => _dispatch(UpdateRoomPricingEvent(kingBeds: val)),
                  isDark,
                  txtColor,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────────

  Widget _buildLabel(String text, bool isDark, Color labelColor) {
    return RichText(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: AppFonts.font,
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: labelColor,
        ),
        children: const [
          TextSpan(
            text: ' *',
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBedCounter(
    String title,
    IconData icon,
    int value,
    ValueChanged<int> onChanged,
    bool isDark,
    Color txtColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2428) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.buttonBorderColor),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isDark ? Colors.white54 : const Color(0xFF94A3B8),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: AppFonts.font,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: txtColor,
              ),
            ),
          ),
          SizedBox(
            width: 135,
            child: AppCounterWidget(
              label: '',
              value: value,
              minValue: 0,
              backgroundColor: isDark
                  ? const Color(0xFF1A2428)
                  : const Color(0xFFF8FAFB),
              borderColor: isDark
                  ? const Color(0xFF475569)
                  : const Color(0xFFCBD5E1),
              onIncrement: () => onChanged(value + 1),
              onDecrement: () {
                if (value > 0) onChanged(value - 1);
              },
            ),
          ),
        ],
      ),
    );
  }
}
