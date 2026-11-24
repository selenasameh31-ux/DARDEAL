import 'package:graduation_project_flutter/core/routing/routes_export.dart';

// ============================================================
// shared_property_widgets.dart
// ويدجيتس مشتركة متطابقة بين جميع شاشات تفاصيل العقارات الخمس
// ============================================================

// -----------------------------------------------------------
// 1. SliverPersistentHeader Delegate (متطابق في الخمس شاشات)
// -----------------------------------------------------------
class PropertyStickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  PropertyStickyHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(PropertyStickyHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

String _getRelativeTime(String? dateStr) {
  if (dateStr == null || dateStr.isEmpty || dateStr == 'Just now')
    return 'Just now';

  String parseableDate = dateStr;
  try {
    if (!parseableDate.endsWith('Z') && !parseableDate.contains('+')) {
      parseableDate = '${parseableDate}Z';
    }
    DateTime date = DateTime.parse(parseableDate);
    final now = DateTime.now().toUtc();
    final difference = now.difference(date);
    if (difference.inDays > 365)
      return "${(difference.inDays / 365).floor()} years ago";
    if (difference.inDays > 30)
      return "${(difference.inDays / 30).floor()} months ago";
    if (difference.inDays > 0) return "${difference.inDays} days ago";
    if (difference.inHours > 0) return "${difference.inHours} hours ago";
    if (difference.inMinutes > 0) return "${difference.inMinutes} minutes ago";
    return "Just now";
  } catch (e) {
    return dateStr;
  }
}

// -----------------------------------------------------------
// 2. Review Card Widget (متطابق في الخمس شاشات)
// -----------------------------------------------------------
class PropertyReviewCardWidget extends StatefulWidget {
  final Map<String, dynamic> data;
  final Color mainColor;
  final Color textColor;
  final Color bodyTextColor;
  final Color hintColor;
  final bool isDark;
  final bool isFullWidth;

  const PropertyReviewCardWidget({
    super.key,
    required this.data,
    required this.mainColor,
    required this.textColor,
    required this.bodyTextColor,
    required this.hintColor,
    required this.isDark,
    this.isFullWidth = false,
  });

  @override
  State<PropertyReviewCardWidget> createState() =>
      _PropertyReviewCardWidgetState();
}

class _PropertyReviewCardWidgetState extends State<PropertyReviewCardWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.isFullWidth ? double.infinity : 280,
      margin: EdgeInsets.only(right: widget.isFullWidth ? 0 : 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.isDark ? const Color(0xff1E1E1E) : Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: widget.isDark ? Colors.transparent : Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              widget.data['avatar'] != null &&
                      widget.data['avatar'].toString().isNotEmpty
                  ? CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(widget.data['avatar']),
                      backgroundColor: widget.isDark
                          ? Colors.grey[700]
                          : Colors.grey[300],
                    )
                  : Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.isDark
                            ? Colors.grey[700]
                            : Colors.grey[300],
                      ),
                      child: Icon(
                        Icons.person,
                        color: widget.isDark
                            ? Colors.grey[400]
                            : Colors.grey[500],
                      ),
                    ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.data['name'],
                      style: TextStyle(
                        fontFamily: AppFonts.font,
                        color: widget.textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _getRelativeTime(widget.data['date']),
                      style: TextStyle(
                        fontFamily: AppFonts.font,
                        color: widget.hintColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < widget.data['stars']
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.data['text'],
            maxLines: isExpanded ? null : 3,
            overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: AppFonts.font,
              color: widget.bodyTextColor,
              height: 1.4,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => setState(() => isExpanded = !isExpanded),
            child: Text(
              isExpanded ? "Show less" : "Show more",
              style: TextStyle(
                fontFamily: AppFonts.font,
                color: widget.mainColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------
// 3. Rating Breakdown Widget (متطابق في الخمس شاشات)
// -----------------------------------------------------------
class PropertyRatingBreakdownWidget extends StatelessWidget {
  final Color mainColor;
  final Color textColor;
  final Color hintColor;
  final bool isDark;
  final List<Map<String, dynamic>>? breakdown;

  const PropertyRatingBreakdownWidget({
    super.key,
    required this.mainColor,
    required this.textColor,
    required this.hintColor,
    required this.isDark,
    this.breakdown,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> finalBreakdown =
        breakdown ??
        [
          {'stars': '5', 'percent': 0.85},
          {'stars': '4', 'percent': 0.10},
          {'stars': '3', 'percent': 0.03},
          {'stars': '2', 'percent': 0.01},
          {'stars': '1', 'percent': 0.01},
        ];

    return Column(
      children: finalBreakdown.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(
            children: [
              SizedBox(
                width: 15,
                child: Text(
                  item['stars'],
                  style: TextStyle(
                    fontFamily: AppFonts.font,
                    fontSize: 13,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.star, color: Colors.amber, size: 14),
              const SizedBox(width: 12),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: item['percent'],
                    minHeight: 8,
                    backgroundColor: isDark
                        ? const Color(0xff333333)
                        : Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.amber,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 35,
                child: Text(
                  "${(item['percent'] * 100).toInt()}%",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontFamily: AppFonts.font,
                    fontSize: 12,
                    color: hintColor,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// -----------------------------------------------------------
// 4. Add Review Modal (متطابق في الخمس شاشات)
// -----------------------------------------------------------
void showAddReviewModal(
  BuildContext context, {
  required int propertyId,
  required Color mainColor,
  required Color textColor,
  required Color hintColor,
  required bool isDark,
}) {
  final reviewsCubit = context.read<ReviewsCubit>();

  int selectedRating = 0;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: isDark ? const Color(0xff1E1E1E) : Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setStateModal) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Add a Review",
                          style: TextStyle(
                            fontFamily: AppFonts.font,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: textColor, size: 22),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        "How was your experience?",
                        style: TextStyle(
                          fontFamily: AppFonts.font,
                          fontSize: 16,
                          color: hintColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () =>
                              setStateModal(() => selectedRating = index + 1),
                          child: Icon(
                            index < selectedRating
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 36,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        "Tap a star to rate",
                        style: TextStyle(
                          fontFamily: AppFonts.font,
                          fontSize: 13,
                          color: hintColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      "Review Title",
                      style: TextStyle(
                        fontFamily: AppFonts.font,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: titleController,
                      cursorColor: mainColor,
                      style: TextStyle(color: textColor, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: "Review title...",
                        hintStyle: TextStyle(
                          fontFamily: AppFonts.font,
                          color: hintColor,
                          fontSize: 13,
                        ),
                        filled: true,
                        fillColor: isDark
                            ? const Color(0xff2A2A2A)
                            : Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Your Review",
                      style: TextStyle(
                        fontFamily: AppFonts.font,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: commentController,
                      maxLines: 4,
                      cursorColor: mainColor,
                      style: TextStyle(color: textColor, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: "Write your experience here...",
                        hintStyle: TextStyle(
                          fontFamily: AppFonts.font,
                          color: hintColor,
                          fontSize: 13,
                        ),
                        filled: true,
                        fillColor: isDark
                            ? const Color(0xff2A2A2A)
                            : Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (selectedRating == 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select a rating.'),
                              ),
                            );
                            return;
                          }
                          if (commentController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please write a review.'),
                              ),
                            );
                            return;
                          }
                          final fullComment = titleController.text.isNotEmpty
                              ? "${titleController.text}\n${commentController.text}"
                              : commentController.text;

                          final sessionState = context
                              .read<SessionCubit>()
                              .state;
                          String? avatarUrl;
                          int? currentUserId;
                          String? userName;
                          if (sessionState is SessionAuthenticated) {
                            avatarUrl = sessionState.user.profileImagePath;
                            userName = sessionState.user.name;
                            currentUserId = int.tryParse(sessionState.user.id);
                          }

                          final error = await reviewsCubit.addReview(
                            propertyId,
                            selectedRating,
                            fullComment,
                            userName: userName,
                            userAvatar: avatarUrl,
                            currentUserId: currentUserId,
                          );

                          if (error != null && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(error),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else if (context.mounted) {
                            // Update wishlist rating with new average
                            final reviewState = reviewsCubit.state;
                            if (reviewState is ReviewsLoaded) {
                              final newRating =
                                  reviewState.summary.averageRating;
                              context
                                  .read<WishlistCubit>()
                                  .updatePropertyRating(propertyId, newRating);
                            }
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Submit Review",
                          style: TextStyle(
                            fontFamily: AppFonts.font,
                            color: isDark ? Colors.black : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

// -----------------------------------------------------------
// 5. App Bar Widget (متطابق في الخمس شاشات)
// -----------------------------------------------------------
class PropertyCustomAppBar extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onFavoritePressed;
  final VoidCallback? onSharePressed;
  final VoidCallback onBackPressed;
  final Color textColor;
  final Color attentionColor;

  const PropertyCustomAppBar({
    super.key,
    required this.isFavorite,
    required this.onFavoritePressed,
    this.onSharePressed,
    required this.onBackPressed,
    required this.textColor,
    required this.attentionColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onBackPressed,
            icon: SvgPicture.asset(
              AppIcons.ArrowIcon,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: onSharePressed,
                child: Icon(Icons.share_outlined, color: textColor),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: onFavoritePressed,
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? attentionColor : textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------
// 6. Image Gallery Widget (متطابق في الخمس شاشات)
// -----------------------------------------------------------
class PropertyImageGallery extends StatelessWidget {
  final PageController imagePageController;
  final int totalImages;
  final int currentImageIndex;
  final ValueChanged<int> onPageChanged;
  final String badgeText;
  final IconData? badgeIcon;
  final Color mainColor;
  final Color attentionColor;
  final bool isDark;
  final List<String>? imageUrls;

  const PropertyImageGallery({
    super.key,
    required this.imagePageController,
    required this.totalImages,
    required this.currentImageIndex,
    required this.onPageChanged,
    required this.badgeText,
    this.badgeIcon,
    required this.mainColor,
    required this.attentionColor,
    required this.isDark,
    this.imageUrls,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 4 / 3,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: isDark ? Colors.grey[800] : Colors.grey[400],
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: PageView.builder(
                    controller: imagePageController,
                    itemCount: totalImages,
                    onPageChanged: onPageChanged,
                    itemBuilder: (context, index) {
                      //debugPrint("IMAGE URL => ${imageUrls![index]}");
                      if (imageUrls != null &&
                          imageUrls!.isNotEmpty &&
                          index < imageUrls!.length) {
                        debugPrint("IMAGE URL => ${imageUrls![index]}");
                        //   return Image.network(
                        //     imageUrls![index],
                        //     fit: BoxFit.cover,

                        //     // errorBuilder: (context, error, stackTrace) =>
                        //     //     Container(
                        //     //       color: isDark
                        //     //           ? Colors.grey[800]
                        //     //           : Colors.grey[400],
                        //     //     ),
                        //     errorBuilder: (context, error, stackTrace) {
                        //       debugPrint("IMAGE ERROR => $error");

                        //       //   return Container(
                        //       //     color: Colors.red,
                        //       //     child: const Center(
                        //       //       child: Icon(Icons.error, color: Colors.white),
                        //       //     ),
                        //       //   );
                        //       // },

                        //       return Container(
                        //         color: isDark
                        //             ? Colors.grey[800]
                        //             : Colors.grey[200],
                        //         child: Column(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           children: [
                        //             Icon(
                        //               Icons.image_not_supported_outlined,
                        //               size: 40,
                        //               color: Colors.grey,
                        //             ),
                        //             const SizedBox(height: 8),
                        //             Text(
                        //               'Image unavailable',
                        //               style: TextStyle(
                        //                 color: isDark
                        //                     ? Colors.white70
                        //                     : Colors.black54,
                        //                 fontSize: 12,
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       );
                        //     },
                        //   );
                        final mediaUrl = imageUrls![index];
                        //final isVideo = mediaUrl.toLowerCase().endsWith('.mp4');
                        final isVideo = isVideoFile(mediaUrl);

                        if (isVideo) {
                          return PropertyVideoPlayer(
                            videoUrl: mediaUrl,
                            mainColor: mainColor,
                          );
                        }

                        // return Image.network(
                        //   mediaUrl,
                        //   fit: BoxFit.cover,
                        //   errorBuilder: (context, error, stackTrace) {
                        //     return Container(
                        //       color: isDark
                        //           ? Colors.grey[800]
                        //           : Colors.grey[200],
                        //       child: Column(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           Icon(
                        //             Icons.image_not_supported_outlined,
                        //             size: 40,
                        //             color: Colors.grey,
                        //           ),
                        //           const SizedBox(height: 8),
                        //           Text(
                        //             'Image unavailable',
                        //             style: TextStyle(
                        //               color: isDark
                        //                   ? Colors.white70
                        //                   : Colors.black54,
                        //               fontSize: 12,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     );
                        //   },
                        // );
                        if (isImageFile(mediaUrl)) {
                          return Image.network(
                            mediaUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }

                              return Center(
                                child: CircularProgressIndicator(
                                  color: mainColor,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: isDark
                                    ? Colors.grey[800]
                                    : Colors.grey[200],
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.image_not_supported_outlined,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Image unavailable',
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white70
                                            : Colors.black54,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }

                        return Container(
                          color: isDark ? Colors.grey[800] : Colors.grey[200],
                          child: const Center(
                            child: Icon(
                              Icons.insert_drive_file_outlined,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      }
                      return Container(
                        color: isDark ? Colors.grey[800] : Colors.grey[400],
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: mainColor.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            if (badgeIcon != null) ...[
                              Icon(
                                badgeIcon,
                                color: isDark ? Colors.black : Colors.white,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                            ],
                            Text(
                              badgeText,
                              style: TextStyle(
                                fontFamily: AppFonts.font,
                                color: isDark ? Colors.black : Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: attentionColor.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.verified, color: Colors.white, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              "OWNER DIRECT",
                              style: TextStyle(
                                fontFamily: AppFonts.font,
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${currentImageIndex + 1}/$totalImages",
                          style: TextStyle(
                            fontFamily: AppFonts.font,
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(totalImages > 8 ? 8 : totalImages, (
                      index,
                    ) {
                      bool isActive = index == (currentImageIndex % 8);
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: isActive ? 8 : 6,
                        height: isActive ? 8 : 6,
                        decoration: BoxDecoration(
                          color: isActive
                              ? Colors.white
                              : Colors.white.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 75,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: totalImages,
            itemBuilder: (context, index) {
              bool isSelected = currentImageIndex == index;
              return GestureDetector(
                onTap: () => imagePageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
                child: Container(
                  width: 75,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[700] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(15),
                    border: isSelected
                        ? Border.all(color: mainColor, width: 2)
                        : null,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child:
                        imageUrls != null &&
                            imageUrls!.isNotEmpty &&
                            index < imageUrls!.length
                        ? (isVideoFile(imageUrls![index])
                              ? VideoPropertyDetailsThumbnailWidget(
                                  videoUrl: imageUrls![index],
                                )
                              : Image.network(
                                  imageUrls![index],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: isDark
                                          ? Colors.grey[700]
                                          : Colors.grey[300],
                                      child: const Center(
                                        child: Icon(
                                          Icons.image_not_supported_outlined,
                                          color: Colors.grey,
                                          size: 20,
                                        ),
                                      ),
                                    );
                                  },
                                ))
                        : Container(
                            color: isDark ? Colors.grey[700] : Colors.grey[300],
                            child: const Center(
                              child: Icon(
                                Icons.image_outlined,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                          ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  bool isImageFile(String url) {
    final uri = Uri.tryParse(url);

    if (uri == null) return false;

    final path = uri.path.toLowerCase();

    return [
      '.jpg',
      '.jpeg',
      '.png',
      '.gif',
      '.webp',
      '.bmp',
      '.heic',
      '.heif',
    ].any(path.endsWith);
  }
}

// -----------------------------------------------------------
// 7. Bottom Bar Widget (متطابق في الخمس شاشات)
// -----------------------------------------------------------
class PropertyBottomBar extends StatelessWidget {
  final String label;
  final String price;
  final String? priceSuffix;
  final String buttonText;
  final VoidCallback onChatPressed;
  final VoidCallback onButtonPressed;
  final Color textColor;
  final Color bodyTextColor;
  final Color mainColor;
  final bool isDark;
  final int priceFlex;
  final int buttonFlex;

  const PropertyBottomBar({
    super.key,
    required this.label,
    required this.price,
    this.priceSuffix,
    required this.buttonText,
    required this.onChatPressed,
    required this.onButtonPressed,
    required this.textColor,
    required this.bodyTextColor,
    required this.mainColor,
    required this.isDark,
    this.priceFlex = 11,
    this.buttonFlex = 9,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: priceFlex,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: AppFonts.font,
                    color: bodyTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        price,
                        style: TextStyle(
                          fontFamily: AppFonts.font,
                          color: mainColor,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (priceSuffix != null) ...[
                        const SizedBox(width: 4),
                        Text(
                          priceSuffix!,
                          style: TextStyle(
                            fontFamily: AppFonts.font,
                            color: textColor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xff2A2A2A) : Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: IconButton(
              icon: Icon(Icons.chat_bubble_outline, color: textColor),
              onPressed: onChatPressed,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: buttonFlex,
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: onButtonPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    buttonText,
                    style: TextStyle(
                      fontFamily: AppFonts.font,
                      color: isDark ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 📍 Shared Location Section
// ==========================================
class SharedLocationSection extends StatelessWidget {
  final bool isDark;
  final Color textColor;
  final Color mainColor;
  final Color hintColor;
  final String? street;
  final String? buildingNumber;
  final int? floorNumber;
  final String? unitNumber;

  const SharedLocationSection({
    super.key,
    required this.isDark,
    required this.textColor,
    required this.mainColor,
    required this.hintColor,
    this.governorate,
    this.city,
    this.district,
    this.street,
    this.buildingNumber,
    this.floorNumber,
    this.unitNumber,
    this.latitude,
    this.longitude,
    this.nearbyFacilities,
  });

  final String? governorate;
  final String? city;
  final String? district;

  final double? latitude;
  final double? longitude;
  final List<dynamic>? nearbyFacilities;

  Widget _buildAddressItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: AppFonts.font,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: hintColor,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontFamily: AppFonts.font,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Location Map",
              style: TextStyle(
                fontFamily: AppFonts.font,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Row(
              children: [
                Text(
                  "Map",
                  style: TextStyle(
                    fontFamily: AppFonts.font,
                    color: mainColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.map_outlined, color: mainColor, size: 18),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(24),
            width: double.infinity,
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: mainColor.withOpacity(0.3)),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on, size: 48, color: mainColor),
                  const SizedBox(height: 8),
                  if (governorate != null || city != null || district != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.black87 : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 8),
                        ],
                      ),
                      child: Text(
                        [
                          governorate,
                          city ?? district,
                        ].where((e) => e != null && e.isNotEmpty).join(' / '),
                        style: TextStyle(
                          fontFamily: AppFonts.font,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    Text(
                      "Location details not specified",
                      style: TextStyle(
                        fontFamily: AppFonts.font,
                        fontSize: 14,
                        color: hintColor,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[850] : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Address Details",
                style: TextStyle(
                  fontFamily: AppFonts.font,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 24,
                runSpacing: 16,
                children: [
                  if (governorate != null && governorate!.isNotEmpty)
                    _buildAddressItem("GOVERNORATE", governorate!),
                  if (city != null && city!.isNotEmpty)
                    _buildAddressItem("CITY", city!),
                  if (district != null && district!.isNotEmpty)
                    _buildAddressItem("DISTRICT", district!),
                  if (street != null && street!.isNotEmpty)
                    _buildAddressItem("STREET", street!),
                  if (buildingNumber != null && buildingNumber!.isNotEmpty)
                    _buildAddressItem("BUILDING", buildingNumber!),
                  if (floorNumber != null)
                    _buildAddressItem("FLOOR", floorNumber!.toString()),
                  if (unitNumber != null && unitNumber!.isNotEmpty)
                    _buildAddressItem("UNIT", unitNumber!),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              Text(
                "Nearby Facilities",
                style: TextStyle(
                  fontFamily: AppFonts.font,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 12),
              if (nearbyFacilities != null && nearbyFacilities!.isNotEmpty)
                ExpandableChipsWidget(
                  items: nearbyFacilities!.map((f) {
                    String label;
                    if (f is Map) {
                      label =
                          (f['nameEn'] ??
                                  f['nameAr'] ??
                                  f['name'] ??
                                  f['code'] ??
                                  '')
                              .toString();
                    } else {
                      label = f.toString();
                    }
                    return {'icon': Icons.place, 'label': label, 'unit': ''};
                  }).toList(),
                  mainColor: mainColor,
                  textColor: textColor,
                  isDark: isDark,
                  hintColor: hintColor,
                )
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[850] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: hintColor, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "No nearby facilities listed for this property yet.",
                          style: TextStyle(
                            fontFamily: AppFonts.font,
                            fontSize: 13,
                            color: hintColor,
                          ),
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
}

// ==========================================
// 👤 Shared Owner Section
// ==========================================
class SharedOwnerSection extends StatelessWidget {
  final bool isDark;
  final Color textColor;
  final Color mainColor;
  final Color hintColor;
  final Color verifiedColor;
  final Map<String, dynamic>? ownerData;

  const SharedOwnerSection({
    super.key,
    required this.isDark,
    required this.textColor,
    required this.mainColor,
    required this.hintColor,
    required this.verifiedColor,
    this.ownerData,
  });

  @override
  Widget build(BuildContext context) {
    final name =
        ownerData?['name'] ?? ownerData?['fullName'] ?? "Property Owner";
    final isVerified = ownerData?['isVerified'] == true;
    final rating = ownerData?['rating'] ?? 5.0;
    final sales = ownerData?['sales'] ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Direct Owner",
          style: TextStyle(
            fontFamily: AppFonts.font,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[850] : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: mainColor.withOpacity(0.2),
                            width: 2,
                          ),
                          color: isDark ? Colors.grey[700] : Colors.grey[200],
                        ),
                        child:
                            (ownerData?['profilePhoto'] != null &&
                                ownerData!['profilePhoto']
                                    .toString()
                                    .isNotEmpty)
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(
                                  ownerData!['profilePhoto'],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(
                                        Icons.person,
                                        color: isDark
                                            ? Colors.grey[500]
                                            : Colors.grey[400],
                                        size: 35,
                                      ),
                                ),
                              )
                            : Icon(
                                Icons.person,
                                color: isDark
                                    ? Colors.grey[500]
                                    : Colors.grey[400],
                                size: 35,
                              ),
                      ),
                      if (isVerified)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: verifiedColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.verified,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontFamily: AppFonts.font,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            if (isVerified) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  "ID VERIFIED",
                                  style: TextStyle(
                                    fontFamily: AppFonts.font,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                            Icon(
                              Icons.star,
                              color: const Color(0xffFFB800),
                              size: 14,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              "$rating ($sales sales)",
                              style: TextStyle(
                                fontFamily: AppFonts.font,
                                fontSize: 12,
                                color: hintColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.access_time, color: hintColor, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      ownerData?['responseTime'] ??
                          "Usually responds in a few hours",
                      style: TextStyle(
                        fontFamily: AppFonts.font,
                        fontSize: 13,
                        color: hintColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Starting chat with $name...'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: mainColor,
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: mainColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        color: mainColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Chat with Owner",
                        style: TextStyle(
                          fontFamily: AppFonts.font,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: mainColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.gpp_bad_outlined,
                      color: Colors.red,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Never transfer money outside of the platform. Dealing directly through DarDeal ensures buyer protection.",
                        style: TextStyle(
                          fontFamily: AppFonts.font,
                          fontSize: 13,
                          color: Colors.red[700],
                        ),
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
}

// ==========================================
// ⭐️ Shared Reviews Section Manager
// ==========================================
class SharedReviewsSectionManager extends StatefulWidget {
  final int propertyId;
  final Color mainColor, textColor, bodyTextColor, hintColor;
  final bool isDark;

  const SharedReviewsSectionManager({
    super.key,
    required this.propertyId,
    required this.mainColor,
    required this.textColor,
    required this.bodyTextColor,
    required this.hintColor,
    required this.isDark,
  });

  @override
  State<SharedReviewsSectionManager> createState() =>
      _SharedReviewsSectionManagerState();
}

class _SharedReviewsSectionManagerState
    extends State<SharedReviewsSectionManager> {
  void _showSeeAllReviewsModal(
    BuildContext context,
    List<dynamic> reviews,
    dynamic summary,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: widget.isDark ? const Color(0xff1A1A1A) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 25, 24, 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            summary.averageRating.toStringAsFixed(1),
                            style: TextStyle(
                              fontFamily: AppFonts.font,
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: widget.textColor,
                            ),
                          ),
                          Row(
                            children: List.generate(
                              5,
                              (index) => Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 18,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${summary.totalReviews} reviews",
                            style: TextStyle(
                              fontFamily: AppFonts.font,
                              fontSize: 13,
                              color: widget.hintColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: PropertyRatingBreakdownWidget(
                          mainColor: widget.mainColor,
                          textColor: widget.textColor,
                          hintColor: widget.hintColor,
                          isDark: widget.isDark,
                          breakdown: [
                            {
                              'stars': '5',
                              'percent': summary.totalReviews > 0
                                  ? (summary.ratingDistribution[5] ?? 0) /
                                        summary.totalReviews
                                  : 0.0,
                            },
                            {
                              'stars': '4',
                              'percent': summary.totalReviews > 0
                                  ? (summary.ratingDistribution[4] ?? 0) /
                                        summary.totalReviews
                                  : 0.0,
                            },
                            {
                              'stars': '3',
                              'percent': summary.totalReviews > 0
                                  ? (summary.ratingDistribution[3] ?? 0) /
                                        summary.totalReviews
                                  : 0.0,
                            },
                            {
                              'stars': '2',
                              'percent': summary.totalReviews > 0
                                  ? (summary.ratingDistribution[2] ?? 0) /
                                        summary.totalReviews
                                  : 0.0,
                            },
                            {
                              'stars': '1',
                              'percent': summary.totalReviews > 0
                                  ? (summary.ratingDistribution[1] ?? 0) /
                                        summary.totalReviews
                                  : 0.0,
                            },
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1),
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    padding: const EdgeInsets.all(24),
                    itemCount: reviews.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      final rev = reviews[index];
                      final sessionState = context.read<SessionCubit>().state;
                      final isMine =
                          (sessionState is SessionAuthenticated &&
                              rev.userId?.toString() ==
                                  sessionState.user.id.toString()) ||
                          rev.userName == 'You';
                      final Map<String, dynamic> reviewData = {
                        'name': (isMine && sessionState is SessionAuthenticated)
                            ? sessionState.user.name
                            : (rev.userName ?? "Anonymous"),
                        'date': _getRelativeTime(rev.createdAt),
                        'stars': rev.rating ?? 5,
                        'text': rev.comment ?? "",
                        'avatar':
                            (isMine &&
                                sessionState is SessionAuthenticated &&
                                sessionState.user.profileImagePath.isNotEmpty)
                            ? sessionState.user.profileImagePath
                            : rev.userAvatar,
                      };
                      return PropertyReviewCardWidget(
                        data: reviewData,
                        mainColor: widget.mainColor,
                        textColor: widget.textColor,
                        bodyTextColor: widget.bodyTextColor,
                        hintColor: widget.hintColor,
                        isDark: widget.isDark,
                        isFullWidth: true,
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewsCubit, ReviewsState>(
      builder: (context, state) {
        if (state is ReviewsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ReviewsError) {
          return Center(
            child: Text(
              "Error loading reviews",
              style: TextStyle(color: Colors.red),
            ),
          );
        } else if (state is ReviewsLoaded) {
          final reviews = state.reviews;
          final summary = state.summary;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "Reviews",
                        style: TextStyle(
                          fontFamily: AppFonts.font,
                          color: widget.textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        summary.averageRating.toStringAsFixed(1),
                        style: TextStyle(
                          fontFamily: AppFonts.font,
                          color: widget.textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        summary.totalReviews == 0
                            ? "No reviews"
                            : "(${summary.totalReviews})",
                        style: TextStyle(
                          fontFamily: AppFonts.font,
                          color: widget.hintColor,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => showAddReviewModal(
                          context,
                          propertyId: widget.propertyId,
                          mainColor: widget.mainColor,
                          textColor: widget.textColor,
                          hintColor: widget.hintColor,
                          isDark: widget.isDark,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: widget.mainColor.withOpacity(0.5),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit,
                                color: widget.mainColor,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Add Review",
                                style: TextStyle(
                                  fontFamily: AppFonts.font,
                                  color: widget.mainColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (reviews.isNotEmpty)
                        GestureDetector(
                          onTap: () => _showSeeAllReviewsModal(
                            context,
                            reviews,
                            summary,
                          ),
                          child: Text(
                            "See All",
                            style: TextStyle(
                              fontFamily: AppFonts.font,
                              color: widget.mainColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (reviews.isEmpty)
                Text(
                  "No reviews",
                  style: TextStyle(
                    color: widget.hintColor,
                    fontFamily: AppFonts.font,
                  ),
                )
              else
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: reviews.take(3).map((rev) {
                      final sessionState = context.read<SessionCubit>().state;
                      final isMine =
                          (sessionState is SessionAuthenticated &&
                              rev.userId?.toString() ==
                                  sessionState.user.id.toString()) ||
                          rev.userName == 'You';
                      final Map<String, dynamic> reviewData = {
                        'name': (isMine && sessionState is SessionAuthenticated)
                            ? sessionState.user.name
                            : (rev.userName ?? "Anonymous"),
                        'date': _getRelativeTime(rev.createdAt),
                        'stars': rev.rating ?? 5,
                        'text': rev.comment ?? "",
                        'avatar':
                            (isMine &&
                                sessionState is SessionAuthenticated &&
                                sessionState.user.profileImagePath.isNotEmpty)
                            ? sessionState.user.profileImagePath
                            : rev.userAvatar,
                      };
                      return PropertyReviewCardWidget(
                        data: reviewData,
                        mainColor: widget.mainColor,
                        textColor: widget.textColor,
                        bodyTextColor: widget.bodyTextColor,
                        hintColor: widget.hintColor,
                        isDark: widget.isDark,
                      );
                    }).toList(),
                  ),
                ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}

// class PropertyVideoPlayer extends StatefulWidget {
//   final String videoUrl;

//   const PropertyVideoPlayer({super.key, required this.videoUrl});

//   @override
//   State<PropertyVideoPlayer> createState() => _PropertyVideoPlayerState();
// }

// class _PropertyVideoPlayerState extends State<PropertyVideoPlayer> {
//   VideoPlayerController? _controller;
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();

//     _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
//       ..initialize().then((_) {
//         // if (mounted) {
//         //   setState(() {
//         //     _loading = false;
//         //   });
//         // }
//         debugPrint("VIDEO DURATION => ${_controller!.value.duration}");

//         _controller!.setLooping(false);

//         if (mounted) {
//           setState(() {
//             _loading = false;
//           });
//         }
//       });

//     _controller!.addListener(() {
//       // تحديث الأيقونة Play/Pause
//       if (mounted) {
//         setState(() {});
//       }

//       // تتبع التقدم
//       debugPrint(
//         "POSITION => ${_controller!.value.position} "
//         "/ ${_controller!.value.duration}",
//       );

//       // تتبع الـ Buffering
//       debugPrint("BUFFERING => ${_controller!.value.isBuffering}");

//       // تتبع الأخطاء
//       if (_controller!.value.hasError) {
//         debugPrint("VIDEO ERROR => ${_controller!.value.errorDescription}");
//       }

//       // لما الفيديو يخلص
//       if (_controller!.value.position >= _controller!.value.duration) {
//         _controller!.seekTo(Duration.zero);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_loading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     return AspectRatio(
//       aspectRatio: _controller!.value.aspectRatio,
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           VideoPlayer(_controller!),

//           GestureDetector(
//             onTap: () {
//               setState(() {
//                 if (_controller!.value.isPlaying) {
//                   _controller!.pause();
//                 } else {
//                   _controller!.play();
//                 }
//               });
//             },
//             child: Container(
//               color: Colors.transparent,
//               child: Icon(
//                 _controller!.value.isPlaying
//                     ? Icons.pause_circle
//                     : Icons.play_circle,
//                 color: Colors.white,
//                 size: 70,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class PropertyVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final Color mainColor;

  const PropertyVideoPlayer({
    super.key,
    required this.mainColor,
    required this.videoUrl,
  });

  @override
  State<PropertyVideoPlayer> createState() => _PropertyVideoPlayerState();
}

class _PropertyVideoPlayerState extends State<PropertyVideoPlayer> {
  VideoPlayerController? _controller;
  bool _loading = true;
  bool _isBuffering = false;

  @override
  void initState() {
    super.initState();

    debugPrint("VIDEO URL => ${widget.videoUrl}");

    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        _controller!.setLooping(false);

        debugPrint("VIDEO DURATION => ${_controller!.value.duration}");

        if (mounted) {
          setState(() {
            _loading = false;
          });
        }
      });

    // _controller!.addListener(() {
    //   if (_controller!.value.hasError) {
    //     debugPrint("VIDEO ERROR => ${_controller!.value.errorDescription}");
    //   }
    // });
    _controller!.addListener(() {
      if (!mounted) return;

      final value = _controller!.value;

      if (value.hasError) {
        debugPrint("VIDEO ERROR => ${value.errorDescription}");
      }

      // الفيديو خلص
      if (value.position >= value.duration && value.duration != Duration.zero) {
        //_controller!.pause();
        _controller!.pause();
        _controller!.seekTo(Duration.zero);

        setState(() {
          _isBuffering = false;
        });

        return;
      }

      // تحديث حالة البافر
      if (_isBuffering != value.isBuffering) {
        setState(() {
          _isBuffering = value.isBuffering;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller == null || !_controller!.value.isInitialized) return;

    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _controller == null || !_controller!.value.isInitialized) {
      return Container(
        color: Colors.black12,
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.videocam_outlined, size: 50, color: Colors.grey),
              SizedBox(height: 12),
              CircularProgressIndicator(),
            ],
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: _controller!.value.aspectRatio,
      child: GestureDetector(
        onTap: _togglePlayPause,
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(_controller!),

            // زر التشغيل يظهر فقط لما الفيديو متوقف
            if (!_controller!.value.isPlaying && !_isBuffering)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.25),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(12),
                child: Icon(
                  Icons.play_circle_fill,
                  color: Colors.white,
                  size: 70,
                ),
              ),

            // مؤشر تحميل أثناء الـ buffering
            //if (_controller!.value.isBuffering)
            if (_isBuffering)
              Container(
                color: Colors.black26,
                child: Center(
                  child: CircularProgressIndicator(
                    color: widget.mainColor,
                    strokeWidth: 3,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// لدعم اي اكستنشن للفيديو
bool isVideoFile(String url) {
  final uri = Uri.tryParse(url);

  if (uri == null) return false;

  final path = uri.path.toLowerCase();

  return [
    '.mp4',
    '.mov',
    '.avi',
    '.mkv',
    '.webm',
    '.m4v',
    '.3gp',
    '.wmv',
    '.flv',
  ].any(path.endsWith);
}

// لعرض اول فريم من الفيديو في البوكس المربع الصغير
class VideoPropertyDetailsThumbnailWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPropertyDetailsThumbnailWidget({super.key, required this.videoUrl});

  @override
  State<VideoPropertyDetailsThumbnailWidget> createState() => _VideoPropertyDetailsThumbnailWidgetState();
}

class _VideoPropertyDetailsThumbnailWidgetState extends State<VideoPropertyDetailsThumbnailWidget> {
  Uint8List? _thumbnail;

  @override
  void initState() {
    super.initState();
    _generateThumbnail();
  }

  Future<void> _generateThumbnail() async {
    try {
      final bytes = await VideoThumbnail.thumbnailData(
        video: widget.videoUrl,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 200,
        quality: 75,
      );

      if (mounted) {
        setState(() {
          _thumbnail = bytes;
        });
      }
    } catch (e) {
      debugPrint('VIDEO THUMBNAIL ERROR => $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        _thumbnail != null
            ? Image.memory(_thumbnail!, fit: BoxFit.cover)
            : Container(
                color: Colors.grey.shade300,
                child: const Center(child: CircularProgressIndicator()),
              ),

        Container(color: Colors.black.withOpacity(0.2)),

        const Center(
          child: Icon(Icons.play_circle_fill, color: Colors.white, size: 30),
        ),
      ],
    );
  }
}
