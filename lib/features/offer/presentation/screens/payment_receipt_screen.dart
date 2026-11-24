import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class PaymentReceiptScreen extends StatefulWidget {
  final String transactionId;
  final String amount;
  final String date;
  final String propertyName;
  final String location;

  const PaymentReceiptScreen({
    super.key,
    required this.transactionId,
    required this.amount,
    required this.date,
    required this.propertyName,
    required this.location,
  });

  @override
  State<PaymentReceiptScreen> createState() => _PaymentReceiptScreenState();
}

class _PaymentReceiptScreenState extends State<PaymentReceiptScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  bool _isSharing = false;

  Future<void> _shareReceipt() async {
    if (_isSharing) return;
    setState(() => _isSharing = true);

    try {
      // Capture the receipt widget
      final image = await _screenshotController.capture(
        delay: const Duration(milliseconds: 10),
        pixelRatio: 2.0, // High quality
      );

      if (image != null) {
        // Get temp directory
        final directory = await getTemporaryDirectory();
        final imagePath = '${directory.path}/receipt_${widget.transactionId}.png';
        final imageFile = File(imagePath);
        await imageFile.writeAsBytes(image);

        // Share the image using share_plus
        await Share.shareXFiles(
          [XFile(imagePath)],
          text: 'Payment Receipt from DarDeal for ${widget.propertyName}',
          subject: 'DarDeal Receipt',
        );
      }
    } catch (e) {
      debugPrint('Error sharing receipt: $e');
      if (mounted) {
        AppSnackBar.error(
          context,
          'Failed to share receipt. Please try again.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSharing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = isDark ? DarkColors.darkBackGround : const Color(0xFFF3F4F6);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: context.titleColor87,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'E-Receipt',
          style: TextStyle(
            color: context.titleColor87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.font,
          ),
        ),
        centerTitle: true,
        actions: [
          _isSharing
              ? Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : IconButton(
                  icon: Icon(
                    Icons.share,
                    color: context.primaryColor,
                  ),
                  onPressed: _shareReceipt,
                ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Screenshot(
            controller: _screenshotController,
            child: _buildReceiptCard(context, isDark, colorScheme),
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptCard(BuildContext context, bool isDark, ColorScheme colorScheme) {
    final primaryColor = context.primaryColor;
    final cardColor = isDark ? DarkColors.darkTextFieldColor : Colors.white;
    final textColor = context.titleColor87;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Payment Successful',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontFamily: AppFonts.font,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.amount,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: primaryColor,
                    fontFamily: AppFonts.font,
                  ),
                ),
              ],
            ),
          ),

          // Dashed Divider
          Row(
            children: [
              SizedBox(
                height: 20,
                width: 10,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.scaffoldBgColor,
                    borderRadius: BorderRadius.horizontal(right: Radius.circular(10)),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final boxWidth = constraints.constrainWidth();
                      const dashWidth = 5.0;
                      const dashHeight = 1.0;
                      final dashCount = (boxWidth / (2 * dashWidth)).floor();
                      return Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(dashCount, (_) {
                          return SizedBox(
                            width: dashWidth,
                            height: dashHeight,
                            child: DecoratedBox(
                              decoration: BoxDecoration(color: context.hintColor),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
                width: 10,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.scaffoldBgColor,
                    borderRadius: BorderRadius.horizontal(left: Radius.circular(10)),
                  ),
                ),
              ),
            ],
          ),

          // Details
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Transaction ID', widget.transactionId, isDark),
                const SizedBox(height: 16),
                _buildDetailRow('Date', widget.date, isDark),
                const SizedBox(height: 16),
                _buildDetailRow('Property', widget.propertyName, isDark),
                const SizedBox(height: 16),
                _buildDetailRow('Location', widget.location, isDark),
                const SizedBox(height: 16),
                _buildDetailRow('Status', 'Completed', isDark, valueColor: Colors.green),
                
                const SizedBox(height: 32),
                
                // Footer & QR
                Center(
                  child: Column(
                    children: [
                      QrImageView(
                        data: 'Transaction: ${widget.transactionId}\\nDate: ${widget.date}\\nProperty: ${widget.propertyName}\\nLocation: ${widget.location}\\nAmount: ${widget.amount}\\nStatus: Completed',
                        version: QrVersions.auto,
                        size: 120,
                        backgroundColor: Colors.white,
                        foregroundColor: isDark ? Colors.black87 : Colors.black87,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Scan to verify',
                        style: TextStyle(
                          fontSize: 12,
                          color: context.hintColor,
                          fontFamily: AppFonts.font,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Powered by DarDeal',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                          fontFamily: AppFonts.font,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: context.hintColor,
            fontFamily: AppFonts.font,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? (context.titleColor87),
            fontFamily: AppFonts.font,
          ),
        ),
      ],
    );
  }
}
