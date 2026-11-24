
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
class SalePricingStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const SalePricingStep({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<SalePricingStep> createState() => _SalePricingStepState();
}

class _SalePricingStepState extends State<SalePricingStep> {
  final _formKey = GlobalKey<FormState>();

  void _tryNext() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onNext();
    } else {
      AppSnackBar.error(context, 'Please review the pricing information.');
    }
  }

  String _calculateMonthlyInstallment(
    String? priceStr,
    String? downPaymentStr,
    String? durationStr,
  ) {
    if (priceStr == null || priceStr.isEmpty) return "—";

    final price = double.tryParse(priceStr.replaceAll(',', '')) ?? 0.0;

    final downPayment = downPaymentStr != null && downPaymentStr.isNotEmpty
        ? (double.tryParse(downPaymentStr.replaceAll(',', '')) ?? 0.0)
        : 0.0;

    if (price <= downPayment) return "—";

    int months = 12; // default
    if (durationStr != null) {
      final match = RegExp(r'\d+').firstMatch(durationStr);
      if (match != null) {
        months = int.tryParse(match.group(0) ?? '12') ?? 12;
      }
    }

    if (months <= 0) return "—";

    final monthly = (price - downPayment) / months;

    final wholePart = monthly.round().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < wholePart.length; i++) {
      if (i > 0 && (wholePart.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(wholePart[i]);
    }

    return "${buffer.toString()} EGP";
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddPropertyBloc, AddPropertyState>(
      builder: (context, state) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Material(
          color: context.scaffoldBgColor,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StepHeader(stepName: 'Pricing'),
                  const SizedBox(height: 24),

                  Text(
                    "Sale Price",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: context.titleColor,
                      fontFamily: AppFonts.font,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Set a competitive price to attract buyers faster.",
                    style: TextStyle(
                      fontSize: 14,
                      color: context.hintColor,
                      fontFamily: AppFonts.font,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ── AI Valuation Insight ───────────────────────────
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E2A2E)
                          : const Color(0xFFF2F8F8),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? Colors.transparent
                            : const Color(0xFFE2E8F0).withOpacity(0.5),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: LightColors.lightmaincolor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.auto_awesome,
                            color: LightColors.lightmaincolor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "AI VALUATION INSIGHT",
                                style: TextStyle(
                                  color: LightColors.lightmaincolor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: AppFonts.font,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 6),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 13,
                                    height: 1.5,
                                    color: context.hintColor,
                                    fontFamily: AppFonts.font,
                                  ),
                                  children: const [
                                    TextSpan(text: "Similar properties in "),
                                    TextSpan(
                                      text: "New Cairo",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: LightColors.lightmaincolor,
                                      ),
                                    ),
                                    TextSpan(
                                      text: " with these specs average ",
                                    ),
                                    TextSpan(
                                      text: "EGP\n3.2M",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: LightColors.lightmaincolor,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          ". Competitive pricing increases leads by 40%.",
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Total Price ─────────────────────────────────────
                  PricingInputField(
                    label: "Total Asking Price",
                    hintText: "2,500,000",
                    initialValue: state.price,
                    isRequired: true,
                    validator: (val) => AppValidators.validateNumeric(
                      val,
                      isRequired: true,
                      minLength: 3,
                    ),
                    onChanged: (val) {
                      context.read<AddPropertyBloc>().add(
                        UpdatePricingAndSpecsEvent(price: val, currency: "EGP"),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // ── Security Deposit ─────────────────────────────────────
                  const SizedBox(height: 24),
                  PricingInputField(
                    label: "Security Deposit",
                    hintText: "e.g. 50,000",
                    initialValue: state.deposit,
                    isRequired: false,
                    validator: (val) => AppValidators.validateNumeric(
                      val,
                      isRequired: false,
                      minLength: 3,
                    ),
                    onChanged: (val) {
                      context.read<AddPropertyBloc>().add(
                        UpdatePricingAndSpecsEvent(deposit: val),
                      );
                    },
                  ),
                  const SizedBox(height: 32),

                  // ── Pricing Options ─────────────────────────────────────
                  Text(
                    "Pricing Options",
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      fontFamily: AppFonts.font,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildToggleCard(
                    title: "Price is Negotiable",
                    subtitle: "Buyers can submit offers",
                    icon: Icons.sell_outlined,
                    value: state.priceNegotiable,
                    isDark: isDark,
                    onChanged: (val) {
                      context.read<AddPropertyBloc>().add(
                        UpdatePricingAndSpecsEvent(priceNegotiable: val),
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  Text(
                    "Payment Method *",
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      fontFamily: AppFonts.font,
                    ),
                  ),
                  const SizedBox(height: 12),
                  FormField<String>(
                    initialValue: state.paymentMethod ?? "Cash",
                    validator: (val) =>
                        val == null ? "Please select a payment method" : null,
                    builder: (formState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSegmentedControl(
                            options: const ["Cash", "Installments", "Both"],
                            selectedValue: state.paymentMethod ?? "Cash",
                            onSelected: (val) {
                              formState.didChange(val);
                              context.read<AddPropertyBloc>().add(
                                UpdatePricingAndSpecsEvent(paymentMethod: val),
                              );
                            },
                            isDark: isDark,
                          ),
                          if (formState.hasError)
                            Padding(
                              padding: const EdgeInsets.only(top: 8, left: 12),
                              child: Text(
                                formState.errorText!,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // ── Installment Details ────────────────────────────
                  if (state.paymentMethod == "Installments" ||
                      state.paymentMethod == "Both") ...[
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1A2428) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: context.buttonBorderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calculate_outlined,
                                color: LightColors.lightmaincolor,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "INSTALLMENT PLAN",
                                style: TextStyle(
                                  color: LightColors.lightmaincolor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: AppFonts.font,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel("Down Payment", isDark),
                                    AppTextField(
                                      initialValue: state.downPayment,
                                      onChanged: (val) {
                                        context.read<AddPropertyBloc>().add(
                                          UpdatePricingAndSpecsEvent(
                                            downPayment: val,
                                          ),
                                        );
                                      },
                                      hintText: "500,000 EGP",
                                      keyboardType: TextInputType.number,
                                      validator: (val) =>
                                          AppValidators.validateNumeric(
                                            val,
                                            isRequired: true,
                                            minLength: 3,
                                          ),
                                      variant: AppInputVariant.formStep,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel("Duration", isDark),
                                    AppDropdownField(
                                      value:
                                          state.installmentDuration ??
                                          '12 months',
                                      items: const [
                                        '12 months',
                                        '24 months',
                                        '36 months',
                                        '48 months',
                                      ],
                                      onChanged: (val) {
                                        if (val != null) {
                                          context.read<AddPropertyBloc>().add(
                                            UpdatePricingAndSpecsEvent(
                                              installmentDuration: val,
                                            ),
                                          );
                                        }
                                      },
                                      variant: AppInputVariant.formStep,
                                      icon: Icon(
                                        Icons.unfold_more,
                                        color: isDark
                                            ? Colors.white54
                                            : const Color(0xFF64748B),
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF1E2A2E)
                                  : const Color(0xFFF2F8F8),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDark
                                    ? const Color(0xFF334155)
                                    : const Color(0xFFD6E4E4).withOpacity(0.5),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Est. Monthly Installment",
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white60
                                            : const Color(0xFF64748B),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: AppFonts.font,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _calculateMonthlyInstallment(
                                        state.price,
                                        state.downPayment,
                                        state.installmentDuration,
                                      ),
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white
                                            : const Color(0xFF0F172A),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: AppFonts.font,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.edit_calendar_outlined,
                                  color: LightColors.lightmaincolor.withOpacity(
                                    0.6,
                                  ),
                                  size: 26,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                  const SizedBox(height: 32),

                  const SizedBox(height: 40),

                  StepNavigationButtons(
                    step: 4,
                    onNext: _tryNext,
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
      },
    );
  }

  Widget _buildToggleCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required bool isDark,
    required ValueChanged<bool> onChanged,
  }) {
    final primaryColor = context.primaryColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2428) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFD6E4E4),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    fontFamily: AppFonts.font,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white60 : const Color(0xFF64748B),
                    fontFamily: AppFonts.font,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: primaryColor,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: isDark
                ? const Color(0xFF475569)
                : const Color(0xFFCBD5E1),
            trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : const Color(0xFF0F172A),
          fontFamily: AppFonts.font,
        ),
      ),
    );
  }

  Widget _buildSegmentedControl({
    required List<String> options,
    required String? selectedValue,
    required ValueChanged<String> onSelected,
    required bool isDark,
  }) {
    final primaryColor = context.primaryColor;
    final bg = isDark ? const Color(0xFF1E2A2E) : const Color(0xFFF1F5F9);

    IconData getIconForOption(String option) {
      if (option == "Cash") return Icons.payments_outlined;
      if (option == "Installments") return Icons.credit_card_outlined;
      return Icons.account_balance_wallet_outlined;
    }

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: options.map((option) {
          final isSelected = selectedValue == option;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelected(option),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? const Color(0xFF334155) : Colors.white)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isSelected && !isDark
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      getIconForOption(option),
                      size: 16,
                      color: isSelected
                          ? primaryColor
                          : (isDark ? Colors.white60 : const Color(0xFF64748B)),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      option,
                      style: TextStyle(
                        fontFamily: AppFonts.font,
                        fontSize: 14,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w600,
                        color: isSelected
                            ? primaryColor
                            : (isDark
                                  ? Colors.white60
                                  : const Color(0xFF64748B)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
