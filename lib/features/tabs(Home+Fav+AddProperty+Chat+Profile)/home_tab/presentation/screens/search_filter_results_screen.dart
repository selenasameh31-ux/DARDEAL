 import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class SearchFilterResultsScreen extends StatelessWidget {
  final String title;
  final String? query;
  final Map<String, dynamic>? filterParams;

  const SearchFilterResultsScreen({
    super.key,
    required this.title,
    this.query,
    this.filterParams,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final cubit = sl<PropertyTypeListingCubit>();
            if (query != null) {
              cubit.searchWithQuery(query!);
            } else if (filterParams != null) {
              cubit.searchWithFilters(filterParams!);
            }
            return cubit;
          },
        ),
        BlocProvider.value(
          value: sl<WishlistCubit>(),
        ),
      ],
      child: _SearchFilterResultsContent(title: title),
    );
  }
}

class _SearchFilterResultsContent extends StatefulWidget {
  final String title;

  const _SearchFilterResultsContent({required this.title});

  @override
  State<_SearchFilterResultsContent> createState() =>
      _SearchFilterResultsContentState();
}

class _SearchFilterResultsContentState
    extends State<_SearchFilterResultsContent> {
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mainThemeColor = isDark
        ? DarkColors.darkmainColor
        : LightColors.lightmaincolor;
    final titleColor = isDark
        ? DarkColors.darkTitleAndSubTitleText
        : LightColors.lightTitleAndSubTitleText;
    final hintColor = isDark
        ? DarkColors.darkHintTextFieldColor
        : LightColors.lightHintTextFieldColor;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: SvgPicture.asset(
                        AppIcons.ArrowIcon,
                        width: 26,
                        height: 26,
                        colorFilter: ColorFilter.mode(
                          titleColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: titleColor,
                          fontFamily: AppFonts.font,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: 38), // لضبط التوسيط
                ],
              ),
            ),

            // Content
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
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: mainThemeColor.withOpacity(0.4),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No Results Found',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: hintColor,
                                    fontFamily: AppFonts.font,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return GridView.builder(
                          controller: _scrollController,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 14,
                                childAspectRatio: 0.70,
                              ),
                          itemCount:
                              state.properties.length +
                              (state.hasReachedMax ? 0 : 2),
                          itemBuilder: (context, index) {
                            if (index >= state.properties.length) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? DarkColors.darkTextFieldColor
                                      : LightColors.lightTextFieldColor,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: mainThemeColor,
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            }
                            return PropertyTypeListingCard(
                              isDark: isDark,
                              property: state.properties[index],
                            );
                          },
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
}

