 import 'package:graduation_project_flutter/core/routing/routes_export.dart';

// class PropertyTypeListingScreen extends StatelessWidget {
//   final String propertyType;
//   final IconData propertyIcon;
//   final bool isRent;

//   const PropertyTypeListingScreen({
//     super.key,
//     required this.propertyType,
//     required this.propertyIcon,
//     required this.isRent,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) =>
//           sl<PropertyTypeListingCubit>()
//             ..loadProperties(propertyType: propertyType, isRent: isRent),
//       child: _PropertyTypeListingScreenContent(
//         propertyType: propertyType,
//         propertyIcon: propertyIcon,
//         isRent: isRent,
//       ),
//     );
//   }
// }

// class _PropertyTypeListingScreenContent extends StatefulWidget {
//   final String propertyType;
//   final IconData propertyIcon;
//   final bool isRent;

//   const _PropertyTypeListingScreenContent({
//     super.key,
//     required this.propertyType,
//     required this.propertyIcon,
//     required this.isRent,
//   });

//   @override
//   State<_PropertyTypeListingScreenContent> createState() =>
//       _PropertyTypeListingScreenContentState();
// }

// class _PropertyTypeListingScreenContentState
//     extends State<_PropertyTypeListingScreenContent> {
//   // ─── سيُستخدم مستقبلاً للـ pagination ───
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_onScroll);
//   }

//   void _onScroll() {
//     if (_scrollController.position.pixels >=
//         _scrollController.position.maxScrollExtent - 200) {
//       context.read<PropertyTypeListingCubit>().loadMoreProperties();
//     }
//   }

//   @override
//   void dispose() {
//     _scrollController.removeListener(_onScroll);
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = context.isDark;
//     final mainThemeColor = context.primaryColor;
//     final titleColor = context.titleColor;
//     final hintColor = context.hintColor;
//     final bgColor = context.scaffoldBgColor;

//     return Scaffold(
//       backgroundColor: bgColor,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // ─── Header ─────────────────────────────────────────────────
//             _PropertyTypeHeader(
//               propertyType: widget.propertyType,
//               propertyIcon: widget.propertyIcon,
//               isDark: isDark,
//               mainThemeColor: mainThemeColor,
//               titleColor: titleColor,
//             ),

//             // ─── Content ─────────────────────────────────────────────────
//             Expanded(
//               child:
//                   BlocBuilder<
//                     PropertyTypeListingCubit,
//                     PropertyTypeListingState
//                   >(
//                     builder: (context, state) {
//                       if (state is PropertyTypeListingLoading) {
//                         return Center(
//                           child: CircularProgressIndicator(
//                             color: mainThemeColor,
//                           ),
//                         );
//                       } else if (state is PropertyTypeListingError) {
//                         return Center(
//                           child: Text(
//                             state.message,
//                             style: const TextStyle(color: Colors.red),
//                           ),
//                         );
//                       } else if (state is PropertyTypeListingLoaded) {
//                         if (state.properties.isEmpty) {
//                           return _buildEmptyState(
//                             isDark,
//                             mainThemeColor,
//                             hintColor,
//                           );
//                         }
//                         return _buildGrid(
//                           isDark,
//                           state.properties,
//                           state.hasReachedMax,
//                         );
//                       }
//                       return const SizedBox();
//                     },
//                   ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Grid عمودين بـ padding مناسب – جاهز للـ infinite scroll لاحقاً
//   Widget _buildGrid(
//     bool isDark,
//     List<HomePropertyModel> properties,
//     bool hasReachedMax,
//   ) {
//     return GridView.builder(
//       controller: _scrollController,
//       physics: const BouncingScrollPhysics(),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 12,
//         mainAxisSpacing: 14,
//         childAspectRatio: 0.70,
//       ),
//       itemCount: properties.length + (hasReachedMax ? 0 : 2),
//       itemBuilder: (context, index) {
//         // مؤشر التحميل في نهاية القائمة
//         if (index >= properties.length) {
//           return const _LoadingPlaceholderCard();
//         }
//         return PropertyTypeListingCard(
//           isDark: isDark,
//           property: properties[index],
//         );
//       },
//     );
//   }

//   /// حالة القائمة الفارغة
//   Widget _buildEmptyState(bool isDark, Color mainThemeColor, Color hintColor) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             widget.propertyIcon,
//             size: 64,
//             color: mainThemeColor.withOpacity(0.4),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'No ${widget.propertyType}s available',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: hintColor,
//               fontFamily: AppFonts.font,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Check back later for new listings',
//             style: TextStyle(
//               fontSize: 14,
//               color: hintColor.withOpacity(0.7),
//               fontFamily: AppFonts.font,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ──────────────────────────────────────────────────────────────
// //  HEADER WIDGET – زر الرجوع + عنوان ديناميكي
// // ──────────────────────────────────────────────────────────────
// class _PropertyTypeHeader extends StatelessWidget {
//   final String propertyType;
//   final IconData propertyIcon;
//   final bool isDark;
//   final Color mainThemeColor;
//   final Color titleColor;

//   const _PropertyTypeHeader({
//     required this.propertyType,
//     required this.propertyIcon,
//     required this.isDark,
//     required this.mainThemeColor,
//     required this.titleColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       child: Row(
//         children: [
//           // زر الرجوع – نفس الستايل المستخدم في باقي الشاشات
//           InkWell(
//             borderRadius: BorderRadius.circular(50),
//             onTap: () => Navigator.pop(context),
//             child: Padding(
//               padding: const EdgeInsets.all(6),
//               child: SvgPicture.asset(
//                 AppIcons.ArrowIcon,
//                 width: 26,
//                 height: 26,
//                 colorFilter: ColorFilter.mode(titleColor, BlendMode.srcIn),
//               ),
//             ),
//           ),

//           // العنوان في المنتصف
//           Expanded(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(propertyIcon, color: mainThemeColor, size: 20),
//                 const SizedBox(width: 6),
//                 Text(
//                   '${propertyType}s',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: titleColor,
//                     fontFamily: AppFonts.font,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // مسافة موازية لزر الرجوع لتوسيط العنوان
//           const SizedBox(width: 38),
//         ],
//       ),
//     );
//   }
// }

// // ──────────────────────────────────────────────────────────────
// //  PROPERTY TYPE CARD – نفس تصميم الـ Home card بدون badges
// //  حجمه أكبر قليلاً من الـ Home card (ممتد في الـ Grid)
// // ──────────────────────────────────────────────────────────────
// class PropertyTypeListingCard extends StatefulWidget {
//   final bool isDark;
//   final HomePropertyModel property;

//   const PropertyTypeListingCard({
//     super.key,
//     required this.isDark,
//     required this.property,
//   });

//   @override
//   State<PropertyTypeListingCard> createState() =>
//       _PropertyTypeListingCardState();
// }

// class _PropertyTypeListingCardState extends State<PropertyTypeListingCard> {
//   bool _isFavorite = false;

//   @override
//   Widget build(BuildContext context) {
//     final cardBgColor = widget.isDark ? const Color(0xff2A2A2A) : Colors.white;
//     final titleColor = widget.isDark
//         ? DarkColors.darkTitleAndSubTitleText
//         : LightColors.lightTitleAndSubTitleText;
//     final hintColor = widget.isDark
//         ? DarkColors.darkHintTextFieldColor
//         : LightColors.lightHintTextFieldColor;
//     final attentionColor = widget.isDark
//         ? DarkColors.darkAttentionText
//         : LightColors.lightAttentionText;
//     final mainThemeColor = widget.isDark
//         ? DarkColors.darkmainColor
//         : LightColors.lightmaincolor;

//     return GestureDetector(
//       onTap: () {
//         final propId = widget.property.id ?? 0;
//         if (propId > 0) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (ctx) => BlocProvider.value(
//                 value: context.read<WishlistCubit>(),
//                 child: PropertyDetailsWrapperScreen(propertyId: propId),
//               ),
//             ),
//           );
//         }
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: cardBgColor,
//           borderRadius: BorderRadius.circular(24),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ─── صورة العقار ─────────────────────────────────
//             Expanded(
//               flex: 5,
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(24),
//                 ),
//                 child: Stack(
//                   fit: StackFit.expand,
//                   children: [
//                     Container(color: Colors.grey.shade400),
//                     if (widget.property.imageUrl != null &&
//                         widget.property.imageUrl!.isNotEmpty)
//                       Image.network(
//                         widget.property.imageUrl!,
//                         fit: BoxFit.cover,
//                         errorBuilder: (c, e, s) =>
//                             Container(color: Colors.grey.shade400),
//                       ),
//                     Positioned(
//                       top: 10,
//                       right: 10,
//                       child: BlocBuilder<WishlistCubit, WishlistState>(
//                         builder: (context, state) {
//                           final propertyId = widget.property.id ?? 0;
//                           final isFavorite = context
//                               .read<WishlistCubit>()
//                               .isWished(propertyId);
//                           return GestureDetector(
//                             onTap: () {
//                               if (propertyId > 0) {
//                                 final newItem = WishlistItemModel(
//                                   propertyId: propertyId,
//                                   title: widget.property.title,
//                                   location: widget.property.address,
//                                   price: widget.property.price.toDouble(),
//                                   imageUrl: widget.property.imageUrl,
//                                   propertyType: widget.property.propertyType,
//                                   listingType: widget
//                                       .property
//                                       .listingType, // ✅ تمرير listingType
//                                 );
//                                 context.read<WishlistCubit>().toggleWishlist(
//                                   propertyId,
//                                   newItem: newItem,
//                                 );
//                               }
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.all(6),
//                               decoration: BoxDecoration(
//                                 color: widget.isDark
//                                     ? Colors.black.withOpacity(0.6)
//                                     : Colors.white.withOpacity(0.9),
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Icon(
//                                 isFavorite
//                                     ? Icons.favorite
//                                     : Icons.favorite_border,
//                                 color: isFavorite ? attentionColor : hintColor,
//                                 size: 18,
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // ─── تفاصيل العقار ───────────────────────────────
//             Expanded(
//               flex: 4,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 10,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Text(
//                       widget.property.title,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         color: titleColor,
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: AppFonts.font,
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.location_on,
//                           color: mainThemeColor,
//                           size: 12,
//                         ),
//                         const SizedBox(width: 3),
//                         Expanded(
//                           child: Text(
//                             widget.property.address,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                               color: hintColor,
//                               fontSize: 12,
//                               fontFamily: AppFonts.font,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 6),
//                     RichText(
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       text: TextSpan(
//                         children: [
//                           TextSpan(
//                             text: '${widget.property.price} EGP',
//                             style: TextStyle(
//                               color: attentionColor,
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               fontFamily: AppFonts.font,
//                             ),
//                           ),
//                           TextSpan(
//                             text: ' /mo',
//                             style: TextStyle(
//                               color: hintColor,
//                               fontSize: 12.5,
//                               fontFamily: AppFonts.font,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ──────────────────────────────────────────────────────────────
// //  LOADING PLACEHOLDER – يظهر أسفل القائمة عند جلب المزيد
// // ──────────────────────────────────────────────────────────────
// class _LoadingPlaceholderCard extends StatelessWidget {
//   const _LoadingPlaceholderCard();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: context.textFieldBgColor,
//         borderRadius: BorderRadius.circular(24),
//       ),
//       child: Center(
//         child: CircularProgressIndicator(
//           color: context.primaryColor,
//           strokeWidth: 2,
//         ),
//       ),
//     );
//   }
// }




// class PropertyTypeListingScreen extends StatelessWidget {
//   final String propertyType;
//   final IconData propertyIcon;
//   final bool isRent;

//   const PropertyTypeListingScreen({
//     super.key,
//     required this.propertyType,
//     required this.propertyIcon,
//     required this.isRent,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) =>
//           sl<PropertyTypeListingCubit>()
//             ..loadProperties(propertyType: propertyType, isRent: isRent),
//       child: _PropertyTypeListingScreenContent(
//         propertyType: propertyType,
//         propertyIcon: propertyIcon,
//         isRent: isRent,
//       ),
//     );
//   }
// }

// class _PropertyTypeListingScreenContent extends StatefulWidget {
//   final String propertyType;
//   final IconData propertyIcon;
//   final bool isRent;

//   const _PropertyTypeListingScreenContent({
//     super.key,
//     required this.propertyType,
//     required this.propertyIcon,
//     required this.isRent,
//   });

//   @override
//   State<_PropertyTypeListingScreenContent> createState() =>
//       _PropertyTypeListingScreenContentState();
// }

// class _PropertyTypeListingScreenContentState
//     extends State<_PropertyTypeListingScreenContent> {
//   // ─── سيُستخدم مستقبلاً للـ pagination ───
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_onScroll);
//   }

//   void _onScroll() {
//     if (_scrollController.position.pixels >=
//         _scrollController.position.maxScrollExtent - 200) {
//       context.read<PropertyTypeListingCubit>().loadMoreProperties();
//     }
//   }

//   @override
//   void dispose() {
//     _scrollController.removeListener(_onScroll);
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = context.isDark;
//     final mainThemeColor = context.primaryColor;
//     final titleColor = context.titleColor;
//     final hintColor = context.hintColor;
//     final bgColor = context.scaffoldBgColor;

//     return Scaffold(
//       backgroundColor: bgColor,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // ─── Header ─────────────────────────────────────────────────
//             _PropertyTypeHeader(
//               propertyType: widget.propertyType,
//               propertyIcon: widget.propertyIcon,
//               isDark: isDark,
//               mainThemeColor: mainThemeColor,
//               titleColor: titleColor,
//             ),

//             // ─── Content ─────────────────────────────────────────────────
//             Expanded(
//               child:
//                   BlocBuilder<
//                     PropertyTypeListingCubit,
//                     PropertyTypeListingState
//                   >(
//                     builder: (context, state) {
//                       if (state is PropertyTypeListingLoading) {
//                         return Center(
//                           child: CircularProgressIndicator(
//                             color: mainThemeColor,
//                           ),
//                         );
//                       } else if (state is PropertyTypeListingError) {
//                         return Center(
//                           child: Text(
//                             state.message,
//                             style: const TextStyle(color: Colors.red),
//                           ),
//                         );
//                       } else if (state is PropertyTypeListingLoaded) {
//                         if (state.properties.isEmpty) {
//                           return _buildEmptyState(
//                             isDark,
//                             mainThemeColor,
//                             hintColor,
//                           );
//                         }
//                         return _buildGrid(
//                           isDark,
//                           state.properties,
//                           state.hasReachedMax,
//                         );
//                       }
//                       return const SizedBox();
//                     },
//                   ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Grid عمودين بـ padding مناسب – جاهز للـ infinite scroll لاحقاً
//   Widget _buildGrid(
//     bool isDark,
//     List<HomePropertyModel> properties,
//     bool hasReachedMax,
//   ) {
//     return GridView.builder(
//       controller: _scrollController,
//       physics: const BouncingScrollPhysics(),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 12,
//         mainAxisSpacing: 14,
//         childAspectRatio: 0.70,
//       ),
//       itemCount: properties.length + (hasReachedMax ? 0 : 2),
//       itemBuilder: (context, index) {
//         // مؤشر التحميل في نهاية القائمة
//         if (index >= properties.length) {
//           return const _LoadingPlaceholderCard();
//         }
//         return PropertyTypeListingCard(
//           isDark: isDark,
//           property: properties[index],
//         );
//       },
//     );
//   }

//   /// حالة القائمة الفارغة
//   Widget _buildEmptyState(bool isDark, Color mainThemeColor, Color hintColor) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             widget.propertyIcon,
//             size: 64,
//             color: mainThemeColor.withOpacity(0.4),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'No ${widget.propertyType}s available',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: hintColor,
//               fontFamily: AppFonts.font,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Check back later for new listings',
//             style: TextStyle(
//               fontSize: 14,
//               color: hintColor.withOpacity(0.7),
//               fontFamily: AppFonts.font,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ──────────────────────────────────────────────────────────────
// //  HEADER WIDGET – زر الرجوع + عنوان ديناميكي
// // ──────────────────────────────────────────────────────────────
// class _PropertyTypeHeader extends StatelessWidget {
//   final String propertyType;
//   final IconData propertyIcon;
//   final bool isDark;
//   final Color mainThemeColor;
//   final Color titleColor;

//   const _PropertyTypeHeader({
//     required this.propertyType,
//     required this.propertyIcon,
//     required this.isDark,
//     required this.mainThemeColor,
//     required this.titleColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       child: Row(
//         children: [
//           // زر الرجوع – نفس الستايل المستخدم في باقي الشاشات
//           InkWell(
//             borderRadius: BorderRadius.circular(50),
//             onTap: () => Navigator.pop(context),
//             child: Padding(
//               padding: const EdgeInsets.all(6),
//               child: SvgPicture.asset(
//                 AppIcons.ArrowIcon,
//                 width: 26,
//                 height: 26,
//                 colorFilter: ColorFilter.mode(titleColor, BlendMode.srcIn),
//               ),
//             ),
//           ),

//           // العنوان في المنتصف
//           Expanded(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(propertyIcon, color: mainThemeColor, size: 20),
//                 const SizedBox(width: 6),
//                 Text(
//                   '${propertyType}s',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: titleColor,
//                     fontFamily: AppFonts.font,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // مسافة موازية لزر الرجوع لتوسيط العنوان
//           const SizedBox(width: 38),
//         ],
//       ),
//     );
//   }
// }

// // ──────────────────────────────────────────────────────────────
// //  PROPERTY TYPE CARD – نفس تصميم الـ Home card بدون badges
// //  حجمه أكبر قليلاً من الـ Home card (ممتد في الـ Grid)
// // ──────────────────────────────────────────────────────────────
// class PropertyTypeListingCard extends StatefulWidget {
//   final bool isDark;
//   final HomePropertyModel property;

//   const PropertyTypeListingCard({
//     super.key,
//     required this.isDark,
//     required this.property,
//   });

//   @override
//   State<PropertyTypeListingCard> createState() =>
//       _PropertyTypeListingCardState();
// }

// class _PropertyTypeListingCardState extends State<PropertyTypeListingCard> {
//   bool _isFavorite = false;

//   @override
//   Widget build(BuildContext context) {
//     final cardBgColor = widget.isDark ? const Color(0xff2A2A2A) : Colors.white;
//     final titleColor = widget.isDark
//         ? DarkColors.darkTitleAndSubTitleText
//         : LightColors.lightTitleAndSubTitleText;
//     final hintColor = widget.isDark
//         ? DarkColors.darkHintTextFieldColor
//         : LightColors.lightHintTextFieldColor;
//     final attentionColor = widget.isDark
//         ? DarkColors.darkAttentionText
//         : LightColors.lightAttentionText;
//     final mainThemeColor = widget.isDark
//         ? DarkColors.darkmainColor
//         : LightColors.lightmaincolor;

//     return GestureDetector(
//       onTap: () {
//         final propId = widget.property.id ?? 0;
//         if (propId > 0) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (ctx) => BlocProvider.value(
//                 value: context.read<WishlistCubit>(),
//                 child: PropertyDetailsWrapperScreen(propertyId: propId),
//               ),
//             ),
//           );
//         }
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: cardBgColor,
//           borderRadius: BorderRadius.circular(24),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ─── صورة العقار ─────────────────────────────────
//             Expanded(
//               flex: 5,
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(24),
//                 ),
//                 child: Stack(
//                   fit: StackFit.expand,
//                   children: [
//                     Container(color: Colors.grey.shade400),
//                     if (widget.property.imageUrl != null &&
//                         widget.property.imageUrl!.isNotEmpty)
//                       Image.network(
//                         widget.property.imageUrl!,
//                         fit: BoxFit.cover,
//                         errorBuilder: (c, e, s) =>
//                             Container(color: Colors.grey.shade400),
//                       ),
//                     Positioned(
//                       top: 10,
//                       right: 10,
//                       child: BlocBuilder<WishlistCubit, WishlistState>(
//                         builder: (context, state) {
//                           final propertyId = widget.property.id ?? 0;
//                           final isFavorite = context
//                               .read<WishlistCubit>()
//                               .isWished(propertyId);
//                           return GestureDetector(
//                             onTap: () {
//                               if (propertyId > 0) {
//                                 final newItem = WishlistItemModel(
//                                   propertyId: propertyId,
//                                   title: widget.property.title,
//                                   location: widget.property.address,
//                                   price: widget.property.price.toDouble(),
//                                   imageUrl: widget.property.imageUrl,
//                                   propertyType: widget.property.propertyType,
//                                   listingType: widget
//                                       .property
//                                       .listingType, // ✅ تمرير listingType
//                                 );
//                                 context.read<WishlistCubit>().toggleWishlist(
//                                   propertyId,
//                                   newItem: newItem,
//                                 );
//                               }
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.all(6),
//                               decoration: BoxDecoration(
//                                 color: widget.isDark
//                                     ? Colors.black.withOpacity(0.6)
//                                     : Colors.white.withOpacity(0.9),
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Icon(
//                                 isFavorite
//                                     ? Icons.favorite
//                                     : Icons.favorite_border,
//                                 color: isFavorite ? attentionColor : hintColor,
//                                 size: 18,
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // ─── تفاصيل العقار ───────────────────────────────
//             Expanded(
//               flex: 4,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 10,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Text(
//                       widget.property.title,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         color: titleColor,
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: AppFonts.font,
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.location_on,
//                           color: mainThemeColor,
//                           size: 12,
//                         ),
//                         const SizedBox(width: 3),
//                         Expanded(
//                           child: Text(
//                             widget.property.address,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                               color: hintColor,
//                               fontSize: 12,
//                               fontFamily: AppFonts.font,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 6),
//                     RichText(
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       text: TextSpan(
//                         children: [
//                           TextSpan(
//                             text: '${widget.property.price} EGP',
//                             style: TextStyle(
//                               color: attentionColor,
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               fontFamily: AppFonts.font,
//                             ),
//                           ),
//                           TextSpan(
//                             text: (widget.property.listingType?.toLowerCase() != 'sale')
//                                 ? ' /mo'
//                                 : '',
//                             style: TextStyle(
//                               color: hintColor,
//                               fontSize: 12.5,
//                               fontFamily: AppFonts.font,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ──────────────────────────────────────────────────────────────
// //  LOADING PLACEHOLDER – يظهر أسفل القائمة عند جلب المزيد
// // ──────────────────────────────────────────────────────────────
// class _LoadingPlaceholderCard extends StatelessWidget {
//   const _LoadingPlaceholderCard();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: context.textFieldBgColor,
//         borderRadius: BorderRadius.circular(24),
//       ),
//       child: Center(
//         child: CircularProgressIndicator(
//           color: context.primaryColor,
//           strokeWidth: 2,
//         ),
//       ),
//     );
//   }
// }







class PropertyTypeListingScreen extends StatelessWidget {
  final String propertyType;
  final IconData propertyIcon;
  final bool isRent;

  const PropertyTypeListingScreen({
    super.key,
    required this.propertyType,
    required this.propertyIcon,
    required this.isRent,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<PropertyTypeListingCubit>()
            ..loadProperties(propertyType: propertyType, isRent: isRent),
      child: _PropertyTypeListingScreenContent(
        propertyType: propertyType,
        propertyIcon: propertyIcon,
        isRent: isRent,
      ),
    );
  }
}

class _PropertyTypeListingScreenContent extends StatefulWidget {
  final String propertyType;
  final IconData propertyIcon;
  final bool isRent;

  const _PropertyTypeListingScreenContent({
    super.key,
    required this.propertyType,
    required this.propertyIcon,
    required this.isRent,
  });

  @override
  State<_PropertyTypeListingScreenContent> createState() =>
      _PropertyTypeListingScreenContentState();
}

class _PropertyTypeListingScreenContentState
    extends State<_PropertyTypeListingScreenContent> {
  // ─── سيُستخدم مستقبلاً للـ pagination ───
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<PropertyTypeListingCubit>().loadMoreProperties();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final mainThemeColor = context.primaryColor;
    final titleColor = context.titleColor;
    final hintColor = context.hintColor;
    final bgColor = context.scaffoldBgColor;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header ─────────────────────────────────────────────────
            _PropertyTypeHeader(
              propertyType: widget.propertyType,
              propertyIcon: widget.propertyIcon,
              isDark: isDark,
              mainThemeColor: mainThemeColor,
              titleColor: titleColor,
            ),

            // ─── Content ─────────────────────────────────────────────────
            Expanded(
              child:
                  BlocBuilder<
                    PropertyTypeListingCubit,
                    PropertyTypeListingState
                  >(
                    builder: (context, state) {
                      if (state is PropertyTypeListingLoading) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: mainThemeColor,
                          ),
                        );
                      } else if (state is PropertyTypeListingError) {
                        return Center(
                          child: Text(
                            state.message,
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      } else if (state is PropertyTypeListingLoaded) {
                        if (state.properties.isEmpty) {
                          return _buildEmptyState(
                            isDark,
                            mainThemeColor,
                            hintColor,
                          );
                        }
                        return _buildGrid(
                          isDark,
                          state.properties,
                          state.hasReachedMax,
                        );
                      }
                      return const SizedBox();
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }

  /// Grid عمودين بـ padding مناسب – جاهز للـ infinite scroll لاحقاً
  Widget _buildGrid(
    bool isDark,
    List<HomePropertyModel> properties,
    bool hasReachedMax,
  ) {
    return GridView.builder(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 14,
        childAspectRatio: 0.70,
      ),
      itemCount: properties.length + (hasReachedMax ? 0 : 2),
      itemBuilder: (context, index) {
        // مؤشر التحميل في نهاية القائمة
        if (index >= properties.length) {
          return const _LoadingPlaceholderCard();
        }
        return PropertyTypeListingCard(
          isDark: isDark,
          property: properties[index],
        );
      },
    );
  }

  /// حالة القائمة الفارغة
  Widget _buildEmptyState(bool isDark, Color mainThemeColor, Color hintColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.propertyIcon,
            size: 64,
            color: mainThemeColor.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'No ${widget.propertyType}s available',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: hintColor,
              fontFamily: AppFonts.font,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for new listings',
            style: TextStyle(
              fontSize: 14,
              color: hintColor.withOpacity(0.7),
              fontFamily: AppFonts.font,
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
//  HEADER WIDGET – زر الرجوع + عنوان ديناميكي
// ──────────────────────────────────────────────────────────────
class _PropertyTypeHeader extends StatelessWidget {
  final String propertyType;
  final IconData propertyIcon;
  final bool isDark;
  final Color mainThemeColor;
  final Color titleColor;

  const _PropertyTypeHeader({
    required this.propertyType,
    required this.propertyIcon,
    required this.isDark,
    required this.mainThemeColor,
    required this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // زر الرجوع – نفس الستايل المستخدم في باقي الشاشات
          InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () => Navigator.pop(context),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: SvgPicture.asset(
                AppIcons.ArrowIcon,
                width: 26,
                height: 26,
                colorFilter: ColorFilter.mode(titleColor, BlendMode.srcIn),
              ),
            ),
          ),

          // العنوان في المنتصف
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(propertyIcon, color: mainThemeColor, size: 20),
                const SizedBox(width: 6),
                Text(
                  '${propertyType}s',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                    fontFamily: AppFonts.font,
                  ),
                ),
              ],
            ),
          ),

          // مسافة موازية لزر الرجوع لتوسيط العنوان
          const SizedBox(width: 38),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
//  PROPERTY TYPE CARD – نفس تصميم الـ Home card بدون badges
//  حجمه أكبر قليلاً من الـ Home card (ممتد في الـ Grid)
// ──────────────────────────────────────────────────────────────
class PropertyTypeListingCard extends StatefulWidget {
  final bool isDark;
  final HomePropertyModel property;

  const PropertyTypeListingCard({
    super.key,
    required this.isDark,
    required this.property,
  });

  @override
  State<PropertyTypeListingCard> createState() =>
      _PropertyTypeListingCardState();
}

class _PropertyTypeListingCardState extends State<PropertyTypeListingCard> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final cardBgColor = widget.isDark ? const Color(0xff2A2A2A) : Colors.white;
    final titleColor = widget.isDark
        ? DarkColors.darkTitleAndSubTitleText
        : LightColors.lightTitleAndSubTitleText;
    final hintColor = widget.isDark
        ? DarkColors.darkHintTextFieldColor
        : LightColors.lightHintTextFieldColor;
    final attentionColor = widget.isDark
        ? DarkColors.darkAttentionText
        : LightColors.lightAttentionText;
    final mainThemeColor = widget.isDark
        ? DarkColors.darkmainColor
        : LightColors.lightmaincolor;

    return GestureDetector(
      onTap: () {
        final propId = widget.property.id ?? 0;
        if (propId > 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => BlocProvider.value(
                value: context.read<WishlistCubit>(),
                child: PropertyDetailsWrapperScreen(propertyId: propId),
              ),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── صورة العقار ─────────────────────────────────
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(color: Colors.grey.shade400),
                    if (widget.property.imageUrl != null &&
                        widget.property.imageUrl!.isNotEmpty)
                      Image.network(
                        widget.property.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) =>
                            Container(color: Colors.grey.shade400),
                      ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: BlocBuilder<WishlistCubit, WishlistState>(
                        builder: (context, state) {
                          final propertyId = widget.property.id ?? 0;
                          final isFavorite = context
                              .read<WishlistCubit>()
                              .isWished(propertyId);
                          return GestureDetector(
                            onTap: () {
                              if (propertyId > 0) {
                                final newItem = WishlistItemModel(
                                  propertyId: propertyId,
                                  title: widget.property.title,
                                  location: widget.property.address,
                                  price: widget.property.price.toDouble(),
                                  imageUrl: widget.property.imageUrl,
                                  propertyType: widget.property.propertyType,
                                  listingType: widget
                                      .property
                                      .listingType, // ✅ تمرير listingType
                                );
                                context.read<WishlistCubit>().toggleWishlist(
                                  propertyId,
                                  newItem: newItem,
                                );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: widget.isDark
                                    ? Colors.black.withOpacity(0.6)
                                    : Colors.white.withOpacity(0.9),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite ? attentionColor : hintColor,
                                size: 18,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ─── تفاصيل العقار ───────────────────────────────
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.property.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.font,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: mainThemeColor,
                          size: 12,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            widget.property.address,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: hintColor,
                              fontSize: 12,
                              fontFamily: AppFonts.font,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${widget.property.price} EGP',
                            style: TextStyle(
                              color: attentionColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppFonts.font,
                            ),
                          ),
                          TextSpan(
                            text: (widget.property.listingType?.toLowerCase() != 'sale')
                                ? ' /mo'
                                : '',
                            style: TextStyle(
                              color: hintColor,
                              fontSize: 12.5,
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
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
//  LOADING PLACEHOLDER – يظهر أسفل القائمة عند جلب المزيد
// ──────────────────────────────────────────────────────────────
class _LoadingPlaceholderCard extends StatelessWidget {
  const _LoadingPlaceholderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.textFieldBgColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: context.primaryColor,
          strokeWidth: 2,
        ),
      ),
    );
  }
}
