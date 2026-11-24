import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final String offerId;
  final String transactionId;
  final double amountPaid;

  const PaymentSuccessScreen({
    super.key,
    required this.offerId,
    required this.transactionId,
    required this.amountPaid,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? Colors.white : colorScheme.onSurface,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Payment Successful',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontFamily: AppFonts.font,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // The custom icon matching the design exactly
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Payment Successful!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? DarkColors.darkTitleAndSubTitleText
                            : LightColors.lightTitleAndSubTitleText,
                        fontFamily: AppFonts.font,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your deposit has been securely processed.',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? DarkColors.darkHintTextFieldColor
                            : LightColors.lightHintTextFieldColor,
                        fontFamily: AppFonts.font,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 48),

                    // Transaction Details Container
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest.withValues(
                          alpha: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          InfoRow(
                            label: 'Transaction ID',
                            value: transactionId.startsWith('TXN') ? transactionId : 'TXN-$transactionId',
                          ),
                          const Divider(height: 24),
                          InfoRow(
                            label: 'Amount Paid',
                            value: '${amountPaid.toStringAsFixed(0).replaceAllMapped(RegExp(r"\\B(?=(\\d{3})+(?!\\d))"), (match) => ",")} EGP',
                            isHighlighted: true,
                          ),
                          const Divider(height: 24),
                          InfoRow(
                            label: 'Date & Time',
                            value:
                                '${DateTime.now().toString().substring(0, 16)}',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // CTA Button
              AppPrimaryButton(
                text: 'View Handover Steps',
                textColor: Colors.white,
                onPressed: () {
                  final offerBloc = context.read<OfferBloc>();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider.value(
                        value: offerBloc,
                        child: HandoverCheckScreen(offerId: offerId),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  final state = context.read<OfferBloc>().state;
                  final formatCurrency = (double amount) => '${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r"\\B(?=(\\d{3})+(?!\\d))"), (m) => ",")} EGP';
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentReceiptScreen(
                        transactionId: transactionId.startsWith('TXN') ? transactionId : 'TXN-$transactionId',
                        amount: formatCurrency(amountPaid),
                        date: DateTime.now().toString().substring(0, 10),
                        propertyName: state.propertyTitle.isNotEmpty ? state.propertyTitle : 'Property',
                        location: state.propertyLocation.isNotEmpty ? state.propertyLocation : 'Location',
                      ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  side: BorderSide(color: context.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.receipt_long, color: context.primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      'View Receipt',
                      style: TextStyle(
                        color: context.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.font,
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
