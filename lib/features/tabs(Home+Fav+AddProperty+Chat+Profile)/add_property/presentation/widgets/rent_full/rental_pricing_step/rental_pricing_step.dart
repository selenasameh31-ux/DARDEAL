
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
class RentalPricingStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const RentalPricingStep({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<RentalPricingStep> createState() => _RentalPricingStepState();
}

class _RentalPricingStepState extends State<RentalPricingStep> {
  final _formKey = GlobalKey<FormState>();
  String? _availableFromError;

  void _tryNext() {
    final state = context.read<AddPropertyBloc>().state;
    final isShortTerm = state.rentalPeriod == 'Short-Term';

    final formValid = _formKey.currentState?.validate() ?? false;

    setState(() {
      _availableFromError = (!isShortTerm && state.availableFromDate == null)
          ? 'Please select the "Available From" date'
          : null;
    });

    if (formValid && _availableFromError == null) {
      widget.onNext();
    } else {
      AppSnackBar.error(
        context,
        'Please review the rental pricing information.',
      );
    }
  }

  Future<void> _selectDate(
    BuildContext context,
    DateTime? initialDate,
    bool isAvailableFrom,
  ) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    final safeInitial = (initialDate != null && !initialDate.isBefore(today))
        ? initialDate
        : today;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: safeInitial,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDark
                ? const ColorScheme.dark(
                    primary: DarkColors.darkmainColor,
                    onPrimary: Colors.white,
                    surface: Color(0xFF2A2A2A),
                    onSurface: Colors.white,
                  )
                : const ColorScheme.light(
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
    if (picked != null && context.mounted) {
      if (isAvailableFrom) {
        context.read<AddPropertyBloc>().add(
          UpdateRentalPricingEvent(availableFromDate: picked),
        );
        setState(() => _availableFromError = null);
      } else {
        context.read<AddPropertyBloc>().add(
          UpdateRentalPricingEvent(availableUntilDate: picked),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddPropertyBloc, AddPropertyState>(
      builder: (context, state) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final primary = context.primaryColor;
        final isShortTerm = state.rentalPeriod == 'Short-Term';
        final txtColor = context.titleColor;
        final subtitleColor = isDark ? Colors.white60 : const Color(0xFF64748B);
        final labelColor = isDark ? Colors.white70 : const Color(0xFF0F172A);

        return Material(
          color: context.scaffoldBgColor,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StepHeader(),
                  const SizedBox(height: 20),

                  // ── Title ─────────────────────────────────────────
                  Text(
                    'Rental Pricing',
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
                    'Set your rent and lease terms.',
                    style: TextStyle(
                      fontFamily: AppFonts.font,
                      fontSize: 14,
                      color: subtitleColor,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Duration selector ─────────────────────────────
                  _buildLabel(
                    'How would you like to rent this property?',
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
                          onTap: () {
                            context.read<AddPropertyBloc>().add(
                              UpdateRentalPricingEvent(
                                rentalPeriod: 'Long-Term',
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SelectionCard(
                          title: 'Short-Term',
                          subtitle: 'Daily/Weekly',
                          icon: Icons.beach_access_outlined,
                          isSelected: isShortTerm,
                          onTap: () {
                            context.read<AddPropertyBloc>().add(
                              UpdateRentalPricingEvent(
                                rentalPeriod: 'Short-Term',
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // ── Conditional fields ────────────────────────────
                  if (!isShortTerm) ...[
                    // ===== LONG-TERM =====
                    LongTermBaseFields(
                      monthlyRent: state.price,
                      deposit: state.deposit,
                      depositSubtitle:
                          'Refundable amount returned at end of lease',
                      onMonthlyRentChanged: (val) {
                        context.read<AddPropertyBloc>().add(
                          UpdateRentalPricingEvent(rentPrice: val),
                        );
                      },
                      onDepositChanged: (val) {
                        context.read<AddPropertyBloc>().add(
                          UpdateRentalPricingEvent(deposit: val),
                        );
                      },
                      rentValidator: (val) => AppValidators.validateNumeric(
                        val,
                        isRequired: true,
                        minLength: 3,
                      ),
                      depositValidator: (val) => AppValidators.validateNumeric(
                        val,
                        isRequired: false,
                        minLength: 3,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Minimum Lease Duration
                    _buildLabel('Minimum Lease Duration', isDark, labelColor),
                    const SizedBox(height: 8),
                    AppCustomDropdown(
                      hint: '6 months',
                      value: state.minimumLeaseDuration ?? '6 months',
                      items: const [
                        '3 months',
                        '6 months',
                        '1 year',
                        '2 years',
                        'Custom',
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          context.read<AddPropertyBloc>().add(
                            UpdateRentalPricingEvent(minimumLeaseDuration: val),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 24),

                    // Available From
                    _buildLabel('Available From', isDark, labelColor),
                    const SizedBox(height: 8),
                    _buildDatePickerField(
                      context: context,
                      date: state.availableFromDate,
                      placeholder: DateFormat(
                        'MM/dd/yyyy',
                      ).format(DateTime.now()),
                      isDark: isDark,
                      primary: primary,
                      icon: Icons.calendar_today_outlined,
                      onTap: () =>
                          _selectDate(context, state.availableFromDate, true),
                    ),
                    if (_availableFromError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 4),
                        child: Text(
                          _availableFromError!,
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),

                    // Available Until (optional)
                    RichText(
                      text: TextSpan(
                        text: 'Available Until',
                        style: TextStyle(
                          fontFamily: AppFonts.font,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: labelColor,
                        ),
                        children: [
                          TextSpan(
                            text: ' (optional)',
                            style: TextStyle(
                              fontFamily: AppFonts.font,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.italic,
                              color: context.hintColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildDatePickerField(
                      context: context,
                      date: state.availableUntilDate,
                      placeholder: 'mm/dd/yyyy',
                      isDark: isDark,
                      primary: primary,
                      icon: Icons.event_available_outlined,
                      onTap: () =>
                          _selectDate(context, state.availableUntilDate, false),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 6, left: 4),
                      child: Text(
                        'Leave empty for open-ended rental',
                        style: TextStyle(
                          fontFamily: AppFonts.font,
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          color: isDark ? context.hintColor : context.hintColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Market Insight Banner
                    _buildInsightBanner(
                      isDark: isDark,
                      title: 'Market Insight:',
                      content:
                          'Rentals in this area average EGP 12,000–18,000/month. Properties available immediately get 2× more inquiries.',
                    ),
                  ] else ...[
                    // ===== SHORT-TERM =====
                    ShortTermFields(
                      nightlyRate: state.nightlyRate,
                      deposit: state.deposit,
                      depositSubtitle: 'Held during stay, fully refundable',
                      minimumStay: state.minimumStay,
                      maximumStay: state.maximumStay,
                      onNightlyRateChanged: (val) {
                        context.read<AddPropertyBloc>().add(
                          UpdateRentalPricingEvent(nightlyRate: val),
                        );
                      },
                      onDepositChanged: (val) {
                        context.read<AddPropertyBloc>().add(
                          UpdateRentalPricingEvent(deposit: val),
                        );
                      },
                      onMinimumStayChanged: (val) {
                        if (val != null) {
                          context.read<AddPropertyBloc>().add(
                            UpdateRentalPricingEvent(minimumStay: val),
                          );
                        }
                      },
                      onMaximumStayChanged: (val) {
                        if (val != null) {
                          context.read<AddPropertyBloc>().add(
                            UpdateRentalPricingEvent(maximumStay: val),
                          );
                        }
                      },
                      nightlyRateValidator: (val) =>
                          AppValidators.validateNumeric(
                            val,
                            isRequired: true,
                            minLength: 3,
                          ),
                      depositValidator: (val) => AppValidators.validateNumeric(
                        val,
                        isRequired: false,
                        minLength: 3,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Pricing Tip Banner
                    _buildInsightBanner(
                      isDark: isDark,
                      title: 'Pricing Tip:',
                      content:
                          'Similar properties charge EGP 800–1,500/night. Short-term listings with clear availability get 35% more bookings.',
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Auto-saved
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 14,
                          color: isDark ? context.hintColor : context.hintColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Auto-saved',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? context.hintColor
                                : context.hintColor,
                            fontFamily: AppFonts.font,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Navigation
                  StepNavigationButtons(
                    step: 3,
                    onNext: _tryNext,
                    onBack: widget.onBack,
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

  // ── Helper Widgets ──────────────────────────────────────────────

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

  Widget _buildDatePickerField({
    required BuildContext context,
    required DateTime? date,
    required String placeholder,
    required bool isDark,
    required Color primary,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A2428) : const Color(0xFFF8FAFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.buttonBorderColor),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: isDark ? context.hintColor : primary),
            const SizedBox(width: 12),
            Text(
              date != null
                  ? DateFormat('MM/dd/yyyy').format(date)
                  : placeholder,
              style: TextStyle(
                fontSize: 16,
                color: date != null
                    ? (context.titleColor87)
                    : (context.hintColor),
                fontFamily: AppFonts.font,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: onTap,
              child: Icon(
                Icons.calendar_month,
                size: 20,
                color: isDark ? context.hintColor : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightBanner({
    required bool isDark,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2A2E) : const Color(0xFFE8F6F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: const Color(0xFF0C6B6B),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: isDark ? Colors.white70 : const Color(0xFF2C7A7B),
                  fontFamily: AppFonts.font,
                ),
                children: [
                  TextSpan(
                    text: '$title ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: content),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
