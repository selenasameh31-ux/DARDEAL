
/// A reusable, pixel-perfect "Listing Submitted" confirmation screen.
///
/// Used as the final step in Sale, Rent Full Property, and Rent Room flows.
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
class SuccessStep extends StatefulWidget {
  final String title;
  final String subtitle;
  final String listingTypeLabel;
  final IconData listingTypeIcon;
  final VoidCallback onGoToListings;
  final VoidCallback onAddAnother;

  const SuccessStep({
    super.key,
    required this.title,
    required this.subtitle,
    required this.listingTypeLabel,
    required this.listingTypeIcon,
    required this.onGoToListings,
    required this.onAddAnother,
  });

  @override
  State<SuccessStep> createState() => _SuccessStepState();
}

class _SuccessStepState extends State<SuccessStep>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;
  late final AnimationController _checkController;
  late final Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();

    // Pulse glow — loops forever
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Circle scale-in on appear
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );
    _scaleController.forward();

    // Checkmark draw
    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _checkAnimation = CurvedAnimation(
      parent: _checkController,
      curve: Curves.easeOut,
    );
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) _checkController.forward();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scaleController.dispose();
    _checkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = context.primaryColor;
    final bgColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final txtColor = context.titleColor;
    final subtitleColor = isDark ? Colors.white60 : const Color(0xFF64748B);
    final cardBg = isDark ? const Color(0xFF1E2A2E) : const Color(0xFFF8FAFC);
    final cardBorder = context.buttonBorderColor;

    final todayFormatted = DateFormat('MMM d, yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // ── Animated Circle with Pulse Glow ──
              AnimatedBuilder(
                animation: Listenable.merge([_pulseAnimation, _scaleAnimation]),
                builder: (context, child) {
                  final pulse = _pulseAnimation.value;
                  final scale = _scaleAnimation.value;
                  return Transform.scale(
                    scale: scale,
                    child: SizedBox(
                      width: 160,
                      height: 160,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outermost glow ring (animated)
                          Container(
                            width: 140 + (pulse * 20),
                            height: 140 + (pulse * 20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(
                                0xFF2ECC71,
                              ).withValues(alpha: 0.06 + (pulse * 0.04)),
                            ),
                          ),
                          // Middle glow ring
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF2ECC71).withOpacity(0.12),
                            ),
                          ),
                          // Main green circle
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF2ECC71),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF2ECC71,
                                  ).withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: AnimatedBuilder(
                              animation: _checkAnimation,
                              builder: (context, _) {
                                return Opacity(
                                  opacity: _checkAnimation.value,
                                  child: Transform.scale(
                                    scale: 0.5 + (_checkAnimation.value * 0.5),
                                    child: Icon(
                                      Icons.check_rounded,
                                      color: Colors.white,
                                      size: 46,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),

              // ── Title ──
              Text(
                widget.title,
                style: TextStyle(
                  fontFamily: AppFonts.font,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: txtColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),

              // ── Subtitle with "Pending Review" in orange/bold ──
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: AppFonts.font,
                    fontSize: 14.5,
                    height: 1.55,
                    color: subtitleColor,
                  ),
                  children: _buildSubtitleSpans(widget.subtitle),
                ),
              ),
              const SizedBox(height: 28),

              // ── Info Card ──
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: cardBorder, width: 1),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        widget.listingTypeIcon,
                        color: primaryColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.listingTypeLabel,
                          style: TextStyle(
                            fontFamily: AppFonts.font,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: txtColor,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Submitted on $todayFormatted',
                          style: TextStyle(
                            fontFamily: AppFonts.font,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 3),

              // ── "Go to My Listings" button with icon ──
              SizedBox(
                width: double.infinity,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.onGoToListings,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: isDark
                            ? null
                            : [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.25),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.list_alt_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Go to My Listings',
                            style: TextStyle(
                              fontFamily: AppFonts.font,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // ── "Add Another Listing" text button ──
              TextButton(
                onPressed: widget.onAddAnother,
                child: Text(
                  'Add Another Listing',
                  style: TextStyle(
                    fontFamily: AppFonts.font,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /// Splits subtitle text at "Pending Review" to style it in orange bold.
  List<TextSpan> _buildSubtitleSpans(String text) {
    const keyword = 'Pending Review';
    final idx = text.indexOf(keyword);
    if (idx == -1) return [TextSpan(text: text)];

    return [
      TextSpan(text: text.substring(0, idx)),
      TextSpan(
        text: keyword,
        style: TextStyle(
          color: Color(0xFFF59E0B),
          fontWeight: FontWeight.w700,
        ),
      ),
      TextSpan(text: text.substring(idx + keyword.length)),
    ];
  }
}
