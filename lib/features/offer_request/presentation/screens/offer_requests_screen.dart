import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_flutter/core/root/injection_container.dart';
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
import 'package:graduation_project_flutter/features/offer_request/presentation/state_management(bloc)/offer_request_cubit.dart';
import 'package:graduation_project_flutter/features/offer_request/presentation/state_management(bloc)/offer_request_state.dart';
import 'package:graduation_project_flutter/features/offer_request/presentation/widgets/offer_request_tab_bar.dart';

class OfferRequestsScreen extends StatefulWidget {
  const OfferRequestsScreen({super.key});

  @override
  State<OfferRequestsScreen> createState() => _OfferRequestsScreenState();
}

class _OfferRequestsScreenState extends State<OfferRequestsScreen> {
  String _selectedTab = "Active (4)";

  void _showSnackBar(String message) {
    AppSnackBar.info(context, message);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: context.scaffoldBgColor,
      appBar: AppBar(
        title: Text(
          "Received Offers",
          style: TextStyle(
            color: context.titleColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: AppFonts.font,
          ),
        ),
        centerTitle: true,
        backgroundColor: context.scaffoldBgColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: context.titleColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.tune, color: context.primaryColor),
            onPressed: () => _showSnackBar('Filter options'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocProvider(
        create: (context) => sl<OfferRequestCubit>()..fetchOfferRequests(),
        child: BlocBuilder<OfferRequestCubit, OfferRequestState>(
          builder: (context, state) {
            if (state is OfferRequestInitial || state is OfferRequestLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OfferRequestError) {
              return Center(child: Text(state.message));
            } else if (state is OfferRequestSuccess) {
              final apiRequests = state.paginatedOfferRequests.offerRequests;
              
              if (apiRequests.isEmpty) {
                return const Center(child: Text("No Offer Requests"));
              }

              return Column(
                children: [
                  Container(
                    color: colors.surface,
                    child: OfferRequestTabBar(
                      selectedTab: _selectedTab,
                      onTabSelected: (tab) {
                        setState(() {
                          _selectedTab = tab;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: apiRequests.length,
                      itemBuilder: (context, index) {
                        final request = apiRequests[index];
                        return OfferRequestCard(
                          name: 'User', // Placeholder as backend may not return sender name
                          time: request.createdAt?.toString() ?? 'Just now',
                          title: 'Offer for Property ID: ${request.propertyId}',
                          price: '${request.offerPrice} EGP',
                          location: 'Location', // Placeholder
                          isNew: request.status.toLowerCase() == 'pending',
                          onAccept: () {
                            _showSnackBar('Accepted offer request ID: ${request.id}');
                          },
                          onReject: () {
                            _showSnackBar('Rejected offer request ID: ${request.id}');
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
