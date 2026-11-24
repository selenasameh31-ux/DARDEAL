import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class HandoverCheckScreen extends StatefulWidget {
  final String offerId;

  const HandoverCheckScreen({super.key, required this.offerId});

  @override
  State<HandoverCheckScreen> createState() => _HandoverCheckScreenState();
}

class _HandoverCheckScreenState extends State<HandoverCheckScreen> {
  bool _isAgreed = false;
  File? _contractImage;

  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
      );
      if (result != null && result.files.single.path != null) {
        setState(() {
          _contractImage = File(result.files.single.path!);
        });
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    }
  }

  void _showImage() {
    if (_contractImage == null) return;

    final path = _contractImage!.path.toLowerCase();
    if (path.endsWith('.pdf') ||
        path.endsWith('.doc') ||
        path.endsWith('.docx')) {
      AppSnackBar.success(
        context,
        'Document selected: ${_contractImage!.path.split('/').last}',
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            InteractiveViewer(child: Image.file(_contractImage!)),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<OfferBloc>().add(ResetOfferStatus());
  }

  void _onToggle(bool value) {
    setState(() => _isAgreed = value);
    // Sync with existing bloc logic without changing business layer
    context.read<OfferBloc>().add(ChecklistItemToggled('keys_received', value));
    context.read<OfferBloc>().add(
      ChecklistItemToggled('utilities_working', value),
    );
    context.read<OfferBloc>().add(ChecklistItemToggled('no_damages', value));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = context.primaryColor;
    final backgroundColor = isDark
        ? DarkColors.darkBackGround
        : LightColors.lightBackGround;
    final surfaceColor = isDark ? DarkColors.darkTextFieldColor : Colors.white;
    final textColor = context.titleColor87;
    final subtitleColor = isDark ? context.hintColor : context.hintColor;

    const stepLabels = ['Details', 'Review', 'Payment', 'Handover'];
    const currentStep = 3;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'HANDOVER',
          style: TextStyle(
            color: subtitleColor,
            fontFamily: AppFonts.font,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocListener<OfferBloc, OfferState>(
        listener: (context, state) {
          if (state.status == OfferFlowStatus.failure &&
              state.errorMessage != null) {
            AppSnackBar.error(context, state.errorMessage!);
          } else if (state.status == OfferFlowStatus.success &&
              state.isSubmitting == false) {
            // Only navigate if we actually requested a confirmation and it succeeded
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const FinalSuccessScreen(),
              ),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const OfferProgressStepper(
                  currentStep: currentStep,
                  stepLabels: stepLabels,
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'STEP 4: MOVE-IN & CONFIRMATION',
                    style: TextStyle(
                      color: subtitleColor.withValues(alpha: 0.8),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.font,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                _buildIconSection(primaryColor, surfaceColor),
                const SizedBox(height: 24),
                Text(
                  'Handover Check',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.font,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Verify the condition of the property with the\nowner before releasing the payment.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 13,
                    height: 1.5,
                    fontFamily: AppFonts.font,
                  ),
                ),
                const SizedBox(height: 32),
                _buildChecklistCard(
                  primaryColor,
                  surfaceColor,
                  textColor,
                  subtitleColor,
                  isDark,
                ),
                const SizedBox(height: 32),
                _buildUploadContractSection(
                  primaryColor,
                  textColor,
                  subtitleColor,
                ),
                const SizedBox(height: 32),
                BlocBuilder<OfferBloc, OfferState>(
                  builder: (context, state) {
                    return _buildConfirmButton(
                      primaryColor,
                      state.isSubmitting,
                    );
                  },
                ),
                const SizedBox(height: 16),
                if (!_isAgreed) _buildReportIssueLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconSection(Color primaryColor, Color surfaceColor) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: surfaceColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Transform.rotate(
              angle: -0.785398, // -45 degrees
              child: Icon(
                Icons.vpn_key_outlined,
                size: 40,
                color: primaryColor,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
              border: Border.all(color: context.scaffoldBgColor, width: 3),
            ),
            child: Icon(Icons.home_rounded, color: Colors.white, size: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildChecklistCard(
    Color primaryColor,
    Color surfaceColor,
    Color textColor,
    Color subtitleColor,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : context.textFieldBgColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildChecklistItem(
            primaryColor,
            textColor,
            'Keys received and tested for main entrance and unit.',
          ),
          const SizedBox(height: 20),
          _buildChecklistItem(
            primaryColor,
            textColor,
            'Utilities (water, electricity, gas) are functioning properly.',
          ),
          const SizedBox(height: 20),
          _buildChecklistItem(
            primaryColor,
            textColor,
            'Property condition matches the listing photos and description.',
          ),
          const SizedBox(height: 24),
          Divider(color: isDark ? Colors.grey[800] : context.textFieldBgColor),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'I agree to release funds',
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppFonts.font,
                ),
              ),
              CupertinoSwitch(
                value: _isAgreed,
                activeTrackColor: primaryColor,
                onChanged: _onToggle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(Color primaryColor, Color textColor, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle_outline, color: primaryColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: textColor.withValues(alpha: 0.9),
              fontSize: 13,
              height: 1.4,
              fontFamily: AppFonts.font,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmButton(Color primaryColor, bool isSubmitting) {
    return AppPrimaryButton(
      text: 'Confirm & Release Funds',
      buttonColor: primaryColor,
      textColor: Colors.white,
      trailingIcon: Icons.arrow_forward,
      loading: isSubmitting,
      onPressed: () {
        if (_contractImage == null) {
          AppSnackBar.error(
            context,
            'Please upload a photo or PDF of the signed contract to proceed.',
          );
          return;
        }
        if (!_isAgreed) {
          AppSnackBar.error(
            context,
            'Please agree to release funds by toggling the switch.',
          );
          return;
        }
        final state = context.read<OfferBloc>().state;
        context.read<OfferBloc>().add(
          ConfirmHandoverRequested(
            offerId: state.offerId ?? widget.offerId,
            contractFile: _contractImage,
          ),
        );
      },
    );
  }

  Widget _buildReportIssueLink() {
    return InkWell(
      onTap: () {
        // Report issue action
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 16),
            const SizedBox(width: 6),
            Text(
              'Issue during handover? Report here',
              style: TextStyle(
                color: Colors.red[600],
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: AppFonts.font,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadContractSection(
    Color primaryColor,
    Color textColor,
    Color subtitleColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload Signed Contract',
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: AppFonts.font,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Please upload a clear photo or PDF of the signed physical contract for our records.',
          style: TextStyle(
            color: subtitleColor,
            fontSize: 13,
            height: 1.4,
            fontFamily: AppFonts.font,
          ),
        ),
        const SizedBox(height: 16),
        if (_contractImage == null)
          AppDashedContainer(
            onTap: _pickImage,
            color: primaryColor,
            borderRadius: 12.0,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              color: primaryColor.withValues(alpha: 0.05),
              child: Column(
                children: [
                  Icon(Icons.upload_file, color: primaryColor, size: 28),
                  const SizedBox(height: 8),
                  Text(
                    'Tap to Upload File/Image',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.font,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.description_outlined, color: primaryColor),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contract Uploaded',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                          fontFamily: AppFonts.font,
                        ),
                      ),
                      const SizedBox(height: 4),
                      InkWell(
                        onTap: _showImage,
                        child: Text(
                          'Tap to view file details',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                            fontFamily: AppFonts.font,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _contractImage = null;
                    });
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}
