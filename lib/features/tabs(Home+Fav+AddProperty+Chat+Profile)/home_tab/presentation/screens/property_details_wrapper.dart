import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class PropertyDetailsWrapperScreen extends StatelessWidget {
  final int propertyId;

  const PropertyDetailsWrapperScreen({super.key, required this.propertyId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              sl<PropertyDetailsCubit>()..loadPropertyDetails(propertyId),
        ),
        BlocProvider(
          create: (context) => sl<ReviewsCubit>()..loadReviews(propertyId),
        ),
      ],
      child: Scaffold(
        body: BlocListener<ReviewsCubit, ReviewsState>(
          listener: (context, reviewsState) {
            // Sync the average rating to WishlistCubit whenever reviews are loaded/updated
            if (reviewsState is ReviewsLoaded) {
              final newRating = reviewsState.summary.totalReviews > 0
                  ? reviewsState.summary.averageRating
                  : 0.0;
              try {
                context.read<WishlistCubit>().updatePropertyRating(
                  propertyId,
                  newRating,
                );
              } catch (_) {
                // WishlistCubit may not be available in this context
              }
            }
          },
          child: BlocBuilder<PropertyDetailsCubit, PropertyDetailsState>(
            builder: (context, state) {
              if (state is PropertyDetailsLoading ||
                  state is PropertyDetailsInitial) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is PropertyDetailsError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: ${state.message}',
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context
                            .read<PropertyDetailsCubit>()
                            .loadPropertyDetails(propertyId),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              } else if (state is PropertyDetailsLoaded) {
                return _routeToDetailsScreen(state.property);
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _routeToDetailsScreen(PropertyDetailsModel property) {
    // تحويل كل القيم لـ LowerCase بشكل آمن لتجنب أي اختلاف في الحروف من الباكيند
    final listingType = property.listingType?.toLowerCase() ?? '';
    final rentalModel = property.rentalModel?.toLowerCase() ?? '';
    final roomType = property.roomType?.toLowerCase() ?? '';
    final title = property.title?.toLowerCase() ?? '';
    final category = property.category?.toLowerCase() ?? '';
    final propertyType = property.propertyType?.toLowerCase() ?? '';

    // ديباج للتأكد من القيم أثناء التثبيت
    debugPrint("--- ROUTING PROPERTY ID: ${property.id} ---");
    debugPrint("LISTING TYPE => $listingType");
    debugPrint("RENTAL MODEL => $rentalModel");
    debugPrint("PROPERTY TYPE => $propertyType");
    debugPrint("TITLE => $title");

    // 1. أولوية البيع (Sale): لو كاش أو قسط بتفتح صفحة البيع فوراً
    if (listingType == 'sale' ||
        listingType == 'buy' ||
        property.salePricing != null) {
      return PropertyDetailsSaleScreen(property: property);
    }

    // 2. أولوية الإيجار قصير المدى (Short-Term / Daily):
    // أي عقار (سواء شقة كاملة أو غرفة) طالما بيتحسب باليوم وله dailyPrice لازم يروح هنا أولاً
    if (rentalModel == 'daily' ||
        listingType == 'shorttermrent' ||
        property.dailyPrice != null ||
        property.minStayNights != null ||
        title.contains('short-term') ||
        title.contains('short term')) {
      return ShortTermDetailsScreen(property: property);
    }

    // 3. أولوية الغرف (Rooms) للإيجار العادي/الشهري (Long-Term):
    // بندخل هنا لو العقار عبارة عن غرفة مش شورت تيرم
    if (listingType == 'rentroom' ||
        roomType.isNotEmpty ||
        propertyType == 'room') {
      // فحص دقيق هل الغرفة مشتركة (Shared) أم خاصة (Private)
      final isSharedRoom =
          title.contains('shared room') ||
          title.contains('shared') ||
          category == 'sharedhousing' ||
          roomType.contains('shared');

      if (isSharedRoom) {
        return SharedRoomDetailsScreen(property: property);
      } else {
        return PropertyDetailsRoomScreen(property: property);
      }
    }

    // 4. الإيجار الافتراضي (Monthly Rent):
    // لو العقار مش بيع، ومش يومي، ومش غرفة -> إذن هو شقة/فيلا كاملة للإيجار الشهري العادي
    return PropertyDetailsRentScreen(property: property);
  }
}

