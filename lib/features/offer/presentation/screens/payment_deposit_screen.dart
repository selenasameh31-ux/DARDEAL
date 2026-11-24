import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class PaymentDepositScreen extends StatefulWidget {
  final String offerId;

  const PaymentDepositScreen({super.key, required this.offerId});

  @override
  State<PaymentDepositScreen> createState() => _PaymentDepositScreenState();
}

class _PaymentDepositScreenState extends State<PaymentDepositScreen> {
  Timer? _pollingTimer;
  int _pollAttempts = 0;
  static const int _maxPollAttempts = 45; // 3 minutes total

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> _launchPaymobCheckout(
    BuildContext context,
    String clientSecret,
    int paymentId,
  ) async {
    // ── iOS guard ──
    if (Platform.isIOS) {
      AppSnackBar.error(
        context,
        'Payment is not supported on iOS at the moment.',
      );
      return;
    }

    // Capture messenger before the async gap to avoid context-across-async warning
    // final messenger = ScaffoldMessenger.of(context); // removed to fix unused warning

    try {
      final result = await Paymob.pay(
        publicKey: 'egy_pk_test_YO6hDmjrWGGbpjbNeT5CudP06EpdYEPx',
        clientSecret: clientSecret,
        appName: 'DarDeal',
        buttonBackgroundColor: Colors.black,
        buttonTextColor: Colors.white,
      );

      if (!mounted) return;

      if (result.status == PaymobTransactionStatus.rejected) {
        _pollingTimer?.cancel();
        AppSnackBar.error(context, 'Payment cancelled by the user.');
      } else if (result.status == PaymobTransactionStatus.successful) {
        _pollingTimer?.cancel();

        final state = context.read<OfferBloc>().state;
        final offerPrice = state.offerPrice > 0 ? state.offerPrice : 15000.0;
        final totalAmount = offerPrice * 2 + 500;
        final transactionId =
            state.paymentId?.toString() ??
            'TXN-${DateTime.now().millisecondsSinceEpoch}';

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => BlocProvider.value(
              value: context.read<OfferBloc>(),
              child: PaymentSuccessScreen(
                offerId: widget.offerId,
                transactionId: transactionId,
                amountPaid: totalAmount,
              ),
            ),
          ),
        );
      } else {
        print("Paymob SDK returned ${result.status.name}");
      }
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.error(context, 'Payment error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? DarkColors.darkBackGround
        : LightColors.lightBackGround;

    return BlocListener<OfferBloc, OfferState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == OfferFlowStatus.paymentInitiated &&
            state.clientSecret != null &&
            state.paymentId != null) {
          context.read<OfferBloc>().add(ResetOfferStatus());
          _launchPaymobCheckout(context, state.clientSecret!, state.paymentId!);
        } else if (state.status == OfferFlowStatus.success) {
          _pollingTimer?.cancel();
          final offerBloc = context.read<OfferBloc>();
          final state = context.read<OfferBloc>().state;
          final offerPrice = state.offerPrice > 0 ? state.offerPrice : 15000.0;
          final totalAmount = offerPrice * 2 + 500;
          final transactionId =
              state.paymentId?.toString() ??
              'TXN-${DateTime.now().millisecondsSinceEpoch}';

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: offerBloc,
                child: PaymentSuccessScreen(
                  offerId: widget.offerId,
                  transactionId: transactionId,
                  amountPaid: totalAmount,
                ),
              ),
            ),
          );
        } else if (state.status == OfferFlowStatus.failure) {
          _pollingTimer?.cancel();
          AppSnackBar.error(context, state.errorMessage ?? 'Payment failed.');
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: context.titleColor87,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Payment & Deposit',
            style: TextStyle(
              color: context.titleColor87,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: AppFonts.font,
            ),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: 100,
              ),
              children: [
                const OfferProgressStepper(
                  currentStep: 2,
                  stepLabels: ['Details', 'Review', 'Payment', 'Handover'],
                ),
                const SizedBox(height: 24),
                const OfferAcceptedCard(),
                const SizedBox(height: 24),
                const PaymentBreakdownCard(),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    'Select Payment Method',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: context.titleColor87,
                      fontFamily: AppFonts.font,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                BlocBuilder<OfferBloc, OfferState>(
                  buildWhen: (prev, curr) =>
                      prev.selectedPaymentMethod != curr.selectedPaymentMethod,
                  builder: (context, state) {
                    final currentMethod =
                        state.selectedPaymentMethod ?? 'credit_card';
                    return Column(
                      children: [
                        PaymentMethodItem(
                          title: 'Credit / Debit Card',
                          subtitle: 'Instant processing. Secure encrypted.',
                          value: 'credit_card',
                          groupValue: currentMethod,
                          onChanged: (val) => context.read<OfferBloc>().add(
                            PaymentMethodSelected(val),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Opacity(
                                opacity: 0.7,
                                child: Image.network(
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuBwo1NqQ8ZhbhsvTIY25JalPHSAiRgmkAIlgPChKzESP_WZudASFjAMPznTIIbGrmTG1Ybdow996IVyG7PI6WMW5Lzi3oi1W3OjCO_gqMmwBTOhfCRy1VTb7aTgh8r8Jq2VnVjwiOH1tz6n7WNTt301bA4lSV82zXU7pnVbYPsHFGsCjLqAe1tBAogLZ4fbceCmb-qS8KD8k45mkOCa7FSDNeHmhJVmTLwHcG01Z2oifngaENMvUg5NYE5WB4NoP1wBdCC_ODCSAiHc',
                                  height: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Opacity(
                                opacity: 0.7,
                                child: Image.network(
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuBk87YpE_1hpWYRKpbSOYdSpp7sTZjwfPiRzv-IYWPfl_8NUqgEqPe8SvOT8Nwm_oezOA9IdLHG0c4Z7hGm52rnXNczlMu25f_5SmaeUI7IOtLkMNQKotVEhgQFCLyjQVr7-v6Ha4FHoj2jAeeynr-w0QWF-Xgx2l00d2eLaed0OhILzrP2HbcxSVHAioxUKJ-HyxKve0biLv3u1xKsluCA5MHglJfdZ_BqrkyDkASE2SFIHAcCW2gPDNfAeMy8jRibgtoJRqYDEi55',
                                  height: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PaymentMethodItem(
                          title: 'Vodafone Cash',
                          subtitle: 'Pay via mobile wallet number.',
                          value: 'vodafone',
                          groupValue: currentMethod,
                          onChanged: (val) => context.read<OfferBloc>().add(
                            PaymentMethodSelected(val),
                          ),
                          trailing: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                Icons.phonelink_ring,
                                color: Colors.red[600],
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                const SecureEscrowBanner(),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BottomPayButton(offerId: widget.offerId),
            ),
          ],
        ),
      ),
    );
  }
}

class OfferAcceptedCard extends StatelessWidget {
  const OfferAcceptedCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF0D9488)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -50,
            right: -40,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            left: -30,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.celebration, color: Colors.white, size: 28),
              ),
              const SizedBox(height: 12),
              const Text(
                'Offer Accepted!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: AppFonts.font,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Great news! The owner has accepted your offer.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                  fontFamily: AppFonts.font,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PaymentBreakdownCard extends StatelessWidget {
  const PaymentBreakdownCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OfferBloc, OfferState>(
      builder: (context, state) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final textColor = context.titleColor87;
        final cardColor = isDark ? DarkColors.darkTextFieldColor : Colors.white;

        final offerPrice = state.offerPrice > 0 ? state.offerPrice : 15000.0;
        final total = offerPrice * 2 + 500;
        final formatCurrency = (double amount) =>
            '${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r"\B(?=(\d{3})+(?!\d))"), (m) => ",")} EGP';

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment Breakdown',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  fontFamily: AppFonts.font,
                ),
              ),
              const SizedBox(height: 16),
              InfoRow(
                label: 'Security Deposit',
                value: formatCurrency(offerPrice),
              ),
              InfoRow(
                label: 'First Month Rent',
                value: formatCurrency(offerPrice),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Fee',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontFamily: AppFonts.font,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.info, size: 14, color: context.hintColor),
                      ],
                    ),
                    Text(
                      '500 EGP',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                        fontFamily: AppFonts.font,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Divider(
                color: isDark ? Colors.grey[800] : context.textFieldBgColor,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Move-in Total',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      fontFamily: AppFonts.font,
                    ),
                  ),
                  Text(
                    formatCurrency(total),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: context.primaryColor,
                      fontFamily: AppFonts.font,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class PaymentMethodItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget trailing;
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;

  const PaymentMethodItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = context.primaryColor;
    final cardColor = isDark ? DarkColors.darkTextFieldColor : Colors.white;
    final isSelected = value == groupValue;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.05) : cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? primaryColor
                : (isDark ? Colors.grey[800]! : context.textFieldBgColor),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? primaryColor
                      : (isDark ? context.hintColor : context.textFieldBgColor),
                  width: 1,
                ),
                color: isSelected ? primaryColor : Colors.transparent,
              ),
              child: Center(
                child: isSelected
                    ? Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      )
                    : const SizedBox(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: context.titleColor87,
                      fontFamily: AppFonts.font,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: context.hintColor,
                      fontFamily: AppFonts.font,
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

class SecureEscrowBanner extends StatelessWidget {
  const SecureEscrowBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.green[900]!.withOpacity(0.2)
            : Colors.green[50]!.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.green[800]! : Colors.green[100]!,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.shield, color: Colors.green[600], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Secure Escrow Payment',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.green[300] : Colors.green[800],
                    fontFamily: AppFonts.font,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your funds are held securely in an escrow account until you confirm successful move-in. PCI-DSS Compliant.',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.green[400] : Colors.green[700],
                    height: 1.4,
                    fontFamily: AppFonts.font,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BottomPayButton extends StatelessWidget {
  final String offerId;
  const BottomPayButton({super.key, required this.offerId});

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.primaryColor;

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.transparent,
      child: SafeArea(
        child: BlocBuilder<OfferBloc, OfferState>(
          buildWhen: (prev, curr) =>
              prev.isSubmitting != curr.isSubmitting ||
              prev.offerPrice != curr.offerPrice,
          builder: (context, state) {
            final isSubmitting = state.isSubmitting;
            final offerPrice = state.offerPrice > 0
                ? state.offerPrice
                : 15000.0;
            final total = offerPrice * 2 + 500;
            final formatCurrency = (double amount) =>
                '${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r"\B(?=(\d{3})+(?!\d))"), (m) => ",")} EGP';

            return InkWell(
              onTap: isSubmitting
                  ? null
                  : () {
                      context.read<OfferBloc>().add(
                        ProcessPaymentRequested(
                          offerId: offerId,
                          amount: total,
                        ),
                      );
                    },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: isSubmitting
                      ? primaryColor.withOpacity(0.5)
                      : primaryColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (state.isSubmitting)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    else
                      const Icon(Icons.lock, color: Colors.white, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      state.isSubmitting
                          ? 'Processing...'
                          : 'Pay ${formatCurrency(total)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.font,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
