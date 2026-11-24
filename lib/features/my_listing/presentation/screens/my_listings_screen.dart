import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class MyListingsScreen extends StatefulWidget {
  const MyListingsScreen({super.key});

  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> {
  String _selectedTab = "All";

  @override
  void initState() {
    super.initState();
    _fetchListings();
  }

  void _fetchListings() {
    String? apiStatus;
    switch (_selectedTab) {
      case "Draft":
        apiStatus = "draft";
        break;
      case "Review":
        apiStatus = "pending";
        break;
      case "Rejected":
        apiStatus = "rejected";
        break;
      case "Live":
        apiStatus = "active";
        break;
      default:
        apiStatus = null;
    }
    context.read<MyListingCubit>().loadListings(status: apiStatus);
  }

  void _showSnackBar(String message) {
    AppSnackBar.info(context, message);
  }

  void _confirmDelete(int? listingId, String? title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Delete Listing?",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: context.primaryColor,
            ),
          ),
          content: Text(
            "This action cannot be undone. Are you sure you want to permanently delete this listing?",
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).textTheme.bodyMedium?.color,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(color: context.primaryColor),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                if (listingId != null) {
                  context.read<MyListingCubit>().deleteProperty(listingId);
                  _showSnackBar('Deleted $title');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text("Yes, Delete"),
            ),
          ],
        );
      },
    );
  }

  ListingStatus _mapStatus(String? status) {
    if (status == null) return ListingStatus.draft;
    final lower = status.toLowerCase();
    if (lower.contains('active') || lower.contains('live')) return ListingStatus.live;
    if (lower.contains('pending') || lower.contains('review') || lower.contains('pendingreview')) return ListingStatus.review;
    if (lower.contains('reject')) return ListingStatus.rejected;
    if (lower.contains('draft')) return ListingStatus.draft;
    return ListingStatus.draft;
  }

  String _buildImageUrl(String? path) {
    if (path == null || path.isEmpty) {
      return 'https://images.unsplash.com/photo-1560185007-cde436f6a4d0?w=400';
    }
    if (path.startsWith('http')) return path;
    return '${EndPoints.baseUrl}$path';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: context.scaffoldBgColor,
      appBar: AppBar(
        title: Text(
          "My Listings",
          style: TextStyle(
            color: context.titleColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: AppFonts.font,
          ),
        ),
        backgroundColor: context.scaffoldBgColor,
        elevation: 0,
        scrolledUnderElevation: 0.0,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: context.titleColor),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: context.primaryColor),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddPropertyScreen(startFresh: true),
                ),
              );
              if (mounted) _fetchListings();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListingTabBar(
              selectedTab: _selectedTab,
              onTabSelected: (tab) {
                setState(() {
                  _selectedTab = tab;
                });
                _fetchListings();
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: BlocConsumer<MyListingCubit, MyListingState>(
              listener: (context, state) {
                if (state is MyListingError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is MyListingLoading || state is MyListingInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MyListingDeleting) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 12),
                        Text('Deleting...'),
                      ],
                    ),
                  );
                } else if (state is MyListingError) {
                  // Error is shown via SnackBar — reload the listings
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MyListingLoaded) {
                  final listings = state.data.items;
                  if (listings.isEmpty) {
                    return Center(
                      child: Text(
                        "No properties found.",
                        style: TextStyle(color: context.titleColor, fontFamily: AppFonts.font),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: listings.length,
                    itemBuilder: (context, index) {
                      final property = listings[index];
                      return ListingCard(
                        title: property.title ?? 'Untitled',
                        location: property.location ?? 'Unknown location',
                        price: "${property.currency ?? 'EGP'} ${property.price ?? 0}",
                        views: (property.viewCount ?? 0).toString(),
                        messages: "0",
                        saves: "0",
                        imageUrl: _buildImageUrl(property.coverPhoto),
                        status: _mapStatus(property.status),
                        expDate: "N/A", // Not from API yet
                        listingId: "PR-${property.id}",
                        completionPercent: 100.0,
                        reviewMessage: property.status == 'rejected' ? 'Review feedback.' : null,
                        onEdit: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (_) => sl<AddPropertyBloc>()
                                  ..add(LoadDraftEvent())
                                  ..add(LoadLookupsEvent()),
                                child: const AddPropertyScreen(),
                              ),
                            ),
                          );
                          if (mounted) _fetchListings();
                        },
                        onBoost: () {
                          showDialog(
                            context: context,
                            builder: (_) => const BoostDialog(),
                          );
                        },
                        onInsights: () => _showSnackBar('Viewing insights of ${property.title}'),
                        onPreview: () => _showSnackBar('Preview ${property.title}'),
                        onChat: () => _showSnackBar('Chat about ${property.title}'),
                        onFixIssues: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ResolutionCenterScreen(),
                            ),
                          );
                        },
                        onAppeal: () => _showSnackBar('Appeal for ${property.title}'),
                        onResume: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (_) => sl<AddPropertyBloc>()
                                  ..add(LoadDraftEvent())
                                  ..add(LoadLookupsEvent()),
                                child: const AddPropertyScreen(resumeMode: true),
                              ),
                            ),
                          );
                          if (mounted) _fetchListings();
                        },
                        onDelete: () => _confirmDelete(property.id, property.title),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
