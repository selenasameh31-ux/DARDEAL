
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
class SummaryStep extends StatelessWidget {
  final VoidCallback onPublish;
  final VoidCallback onBack;
  final Function(int) onEditStep;

  const SummaryStep({
    super.key,
    required this.onPublish,
    required this.onBack,
    required this.onEditStep,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = context.primaryColor;

    return BlocBuilder<AddPropertyBloc, AddPropertyState>(
      builder: (context, state) {
        final isSale = state.transactionType == 'For Sale';
        final isRent = state.transactionType == 'For Rent';
        final isRentFull = isRent && state.listingStyle == 'Entire Property';
        final isRentRoom = isRent && state.listingStyle == 'Room-by-Room';

        int specsIdx = -1;
        int currentIdx = 4;
        if (isSale || isRentFull) {
          specsIdx = currentIdx++;
        }

        final isShortTermFull =
            isRentFull && state.rentalPeriod == 'Short-Term';
        final isShortTermRoom =
            isRentRoom && state.rentalPeriod == 'Short-Term';
        if (isShortTermFull || isShortTermRoom) {
          // Calendar step exists, skip its index
          currentIdx++;
        }

        final amenitiesIdx = currentIdx++;
        final mediaIdx = currentIdx++;

        return Material(
          color: context.scaffoldBgColor,
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 160),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopHeader(context, isDark, primaryColor, state),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          _buildBasicInfo(context, isDark, primaryColor, state),
                          _buildLocation(context, isDark, primaryColor, state),
                          _buildPricing(context, isDark, primaryColor, state),
                          if (specsIdx != -1)
                            _buildSpecs(
                              context,
                              isDark,
                              primaryColor,
                              state,
                              specsIdx,
                            ),
                          _buildAmenities(
                            context,
                            isDark,
                            primaryColor,
                            state,
                            amenitiesIdx,
                          ),
                          _buildMedia(
                            context,
                            isDark,
                            primaryColor,
                            state,
                            mediaIdx,
                          ),
                          _buildPendingReviewBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildStickyBottomBar(
                  context,
                  isDark,
                  primaryColor,
                  state.isSubmitting,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopHeader(
    BuildContext context,
    bool isDark,
    Color primaryColor,
    AddPropertyState state,
  ) {
    int totalDots = max(
      1,
      state.propertyImages.length + (state.coverImage != null ? 1 : 0),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios_new, color: primaryColor, size: 18),
                onPressed: onBack,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Text(
                "Review Listing",
                style: TextStyle(
                  fontFamily: AppFonts.font,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: context.titleColor,
                ),
              ),
              const SizedBox(width: 24), // Balance the row
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "FINAL STEP · REVIEW",
                style: TextStyle(
                  fontFamily: AppFonts.font,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: primaryColor,
                ),
              ),
              const Text(
                "100%",
                style: TextStyle(
                  fontFamily: AppFonts.font,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 4,
            width: double.infinity,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // Success Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF14532D).withOpacity(0.2)
                  : const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF166534)
                    : const Color(0xFFBBF7D0),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle,
                  color: const Color(0xFF22C55E),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "All steps completed!",
                        style: TextStyle(
                          fontFamily: AppFonts.font,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: isDark
                              ? const Color(0xFF4ADE80)
                              : const Color(0xFF166534),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Review your listing details below before submitting.",
                        style: TextStyle(
                          fontFamily: AppFonts.font,
                          fontSize: 13,
                          color: isDark
                              ? const Color(0xFF86EFAC)
                              : const Color(0xFF166534),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Media Preview Box
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: context.textFieldBgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: state.coverImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(state.coverImage!, fit: BoxFit.cover),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_outlined,
                        color: Colors.grey.shade400,
                        size: 48,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Cover Photo Preview",
                        style: TextStyle(
                          fontFamily: AppFonts.font,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 16),
          // Carousel Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalDots, (index) {
              final isActive = index == 0;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive
                      ? primaryColor
                      : (isDark ? Colors.white24 : const Color(0xFFE2E8F0)),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required List<Widget> children,
    required bool isDark,
    required Color primaryColor,
    required VoidCallback onEdit,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.textFieldBgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: primaryColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: AppFonts.font,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: context.titleColor,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: onEdit,
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 14, color: primaryColor),
                    const SizedBox(width: 4),
                    Text(
                      "Edit",
                      style: TextStyle(
                        fontFamily: AppFonts.font,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildKVRow(
    BuildContext context,
    String label,
    String value,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: AppFonts.font,
                color: context.hintColor,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: AppFonts.font,
                color: context.titleColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo(
    BuildContext context,
    bool isDark,
    Color primaryColor,
    AddPropertyState state,
  ) {
    return _buildSectionCard(
      context,
      icon: Icons.info_outline,
      title: "Basic Info",
      isDark: isDark,
      primaryColor: primaryColor,
      onEdit: () => onEditStep(1),
      children: [
        _buildKVRow(context, "Title", state.title ?? "-", isDark),
        _buildKVRow(
          context,
          "Type",
          "${state.propertyType ?? "-"} · ${state.transactionType ?? "-"}",
          isDark,
        ),
        _buildKVRow(
          context,
          "Category",
          state.collectionCategory ?? "-",
          isDark,
        ),
      ],
    );
  }

  Widget _buildLocation(
    BuildContext context,
    bool isDark,
    Color primaryColor,
    AddPropertyState state,
  ) {
    return _buildSectionCard(
      context,
      icon: Icons.location_on_outlined,
      title: "Location",
      isDark: isDark,
      primaryColor: primaryColor,
      onEdit: () => onEditStep(2),
      children: [
        _buildKVRow(
          context,
          "Area",
          "${state.area ?? '-'}, ${state.city ?? '-'}",
          isDark,
        ),
        _buildKVRow(context, "Address", state.address ?? "-", isDark),
      ],
    );
  }

  Widget _buildPricing(
    BuildContext context,
    bool isDark,
    Color primaryColor,
    AddPropertyState state,
  ) {
    // Correct price logic based on flow
    String displayPrice = "0";
    String periodLabel = "";

    if (state.listingStyle == 'Room-by-Room') {
      if (state.roomRentalPeriod == 'Short-Term') {
        displayPrice = state.roomNightlyRate ?? "0";
        periodLabel = "/ night";
      } else {
        displayPrice = state.roomPrice ?? "0";
        periodLabel = "/ month";
      }
    } else {
      // Entire Property
      if (state.transactionType == 'For Rent') {
        if (state.rentalPeriod == 'Short-Term') {
          displayPrice = state.nightlyRate ?? "0";
          periodLabel = "/ night";
        } else {
          displayPrice = state.price ?? "0";
          periodLabel = "/ month";
        }
      } else {
        // For Sale
        displayPrice = state.price ?? "0";
      }
    }

    if (displayPrice.isEmpty) displayPrice = "0";

    return _buildSectionCard(
      context,
      icon: Icons.payments_outlined,
      title: "Pricing",
      isDark: isDark,
      primaryColor: primaryColor,
      onEdit: () => onEditStep(3),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.textFieldBgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Price",
                    style: TextStyle(
                      fontFamily: AppFonts.font,
                      color: context.hintColor,
                      fontSize: 13,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        "${state.currency ?? 'EGP'} $displayPrice",
                        style: TextStyle(
                          fontFamily: AppFonts.font,
                          color: primaryColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (periodLabel.isNotEmpty)
                        Text(
                          " $periodLabel",
                          style: TextStyle(
                            fontFamily: AppFonts.font,
                            color: context.hintColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Payment",
                    style: TextStyle(
                      fontFamily: AppFonts.font,
                      color: context.hintColor,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    "${state.paymentMethod ?? 'Cash'} · ${state.priceNegotiable ? 'Negotiable' : 'Fixed'}",
                    style: TextStyle(
                      fontFamily: AppFonts.font,
                      color: context.titleColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpecs(
    BuildContext context,
    bool isDark,
    Color primaryColor,
    AddPropertyState state,
    int index,
  ) {
    Widget buildSpecCol(IconData icon, String value, String label) {
      return Column(
        children: [
          Icon(icon, color: primaryColor, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontFamily: AppFonts.font,
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: context.titleColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.font,
              fontSize: 12,
              color: context.hintColor,
            ),
          ),
        ],
      );
    }

    return _buildSectionCard(
      context,
      icon: Icons.straighten,
      title: "Specifications",
      isDark: isDark,
      primaryColor: primaryColor,
      onEdit: () => onEditStep(index),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildSpecCol(
              Icons.square_foot,
              "${state.totalArea ?? '-'}${state.areaUnit ?? 'm²'}",
              "Area",
            ),
            buildSpecCol(Icons.bed_outlined, state.bedrooms ?? "-", "Bedrooms"),
            buildSpecCol(
              Icons.bathtub_outlined,
              state.bathrooms ?? "-",
              "Bathrooms",
            ),
            buildSpecCol(
              Icons.chair_outlined,
              state.furnishingStatus ?? "-",
              "Furnished",
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAmenities(
    BuildContext context,
    bool isDark,
    Color primaryColor,
    AddPropertyState state,
    int index,
  ) {
    return _buildSectionCard(
      context,
      icon: Icons.spa_outlined,
      title: "Amenities",
      isDark: isDark,
      primaryColor: primaryColor,
      onEdit: () => onEditStep(index),
      children: [
        if (state.selectedAmenities.isEmpty)
          Text(
            "No amenities selected.",
            style: TextStyle(
              fontFamily: AppFonts.font,
              color: context.hintColor,
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: state.selectedAmenities.map((a) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  a.name,
                  style: TextStyle(
                    fontFamily: AppFonts.font,
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildMedia(
    BuildContext context,
    bool isDark,
    Color primaryColor,
    AddPropertyState state,
    int index,
  ) {
    Widget buildMiniThumb(int index) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: context.buttonBorderColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: context.textFieldBgColor, width: 2),
        ),
        child: Icon(
          Icons.image_outlined,
          size: 16,
          color: isDark ? Colors.white54 : Colors.grey,
        ),
      );
    }

    return _buildSectionCard(
      context,
      icon: Icons.image_outlined,
      title: "Media",
      isDark: isDark,
      primaryColor: primaryColor,
      onEdit: () => onEditStep(index),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.textFieldBgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 60,
                height: 40,
                child: Stack(
                  children: [
                    Positioned(left: 20, child: buildMiniThumb(2)),
                    Positioned(left: 10, child: buildMiniThumb(1)),
                    Positioned(left: 0, child: buildMiniThumb(0)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${state.propertyImages.length} photos, ${state.propertyVideo != null ? '1' : '0'} video",
                      style: TextStyle(
                        fontFamily: AppFonts.font,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: context.titleColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Cover photo set",
                      style: TextStyle(
                        fontFamily: AppFonts.font,
                        color: context.hintColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPendingReviewBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 32),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFEDD5), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.schedule, color: const Color(0xFFD97706), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Pending Review",
                  style: TextStyle(
                    fontFamily: AppFonts.font,
                    color: Color(0xFFD97706),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "After submitting, your listing will be reviewed by our team within 24 hours. You'll receive a notification once it's live.",
                  style: TextStyle(
                    fontFamily: AppFonts.font,
                    color: Color(0xFFD97706),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyBottomBar(
    BuildContext context,
    bool isDark,
    Color primaryColor,
    bool isSubmitting,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: context.tagTextColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -4),
            blurRadius: 10,
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: isSubmitting ? null : onPublish,
                icon: isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                      ),
                label: Text(
                  isSubmitting ? "Submitting..." : "Submit Listing",
                  style: const TextStyle(
                    fontFamily: AppFonts.font,
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  disabledBackgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: isSubmitting
                          ? null
                          : () {
                              // Preview logic
                            },
                      icon: Icon(
                        Icons.open_in_new,
                        size: 18,
                        color: primaryColor,
                      ),
                      label: Text(
                        "Preview",
                        style: TextStyle(
                          fontFamily: AppFonts.font,
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: primaryColor, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: isSubmitting
                          ? null
                          : () {
                              context.read<AddPropertyBloc>().add(
                                SaveDraftEvent(),
                              );
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
                      icon: Icon(
                        Icons.save_outlined,
                        size: 18,
                        color: primaryColor,
                      ),
                      label: Text(
                        "Save Draft",
                        style: TextStyle(
                          fontFamily: AppFonts.font,
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: primaryColor, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
