import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['All', 'Offers', 'Payments', 'Rentals'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark
        ? DarkColors.darkBackGround
        : const Color(0xFFF8F9FA);

    final appBarColor = isDark ? DarkColors.darkBackGround : Colors.white;

    final iconColor = isDark
        ? DarkColors.darkTitleAndSubTitleText
        : LightColors.lightTitleAndSubTitleText;

    return BlocProvider(
      create: (context) {
        final bloc = NotificationBloc()..add(LoadNotifications());
        _tabController.addListener(() {
          if (!_tabController.indexIsChanging) {
            bloc.add(FilterByType(_tabs[_tabController.index]));
          }
        });
        return bloc;
      },
      child: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          final hasSelection = state.selectedIds.isNotEmpty;

          return Scaffold(
            backgroundColor: bgColor,
            appBar: AppBar(
              backgroundColor: appBarColor,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: iconColor,
                  size: 20,
                ),
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
              ),
              title: Text(
                'Notifications',
                style: TextStyle(
                  color: iconColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFonts.font,
                ),
              ),
              centerTitle: true,
              actions: [
                if (hasSelection)
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: LightColors.lightmaincolor,
                    ),
                    tooltip: 'Delete selected',
                    onPressed: () {
                      context.read<NotificationBloc>().add(DeleteSelected());
                    },
                  ),
              ],
            ),
            body: Column(
              children: [
                Container(
                  color: appBarColor,
                  padding: const EdgeInsets.only(bottom: 8),
                  child: NotificationsTabs(tabController: _tabController),
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (state is NotificationLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is NotificationLoaded) {
                        if (state.filteredNotifications.isEmpty) {
                          return const Center(
                            child: Text(
                              "No notifications found.",
                              style: TextStyle(fontFamily: AppFonts.font),
                            ),
                          );
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: state.filteredNotifications.length,
                          itemBuilder: (context, index) {
                            final notification =
                                state.filteredNotifications[index];
                            final isSelected = state.selectedIds.contains(
                              notification.id,
                            );

                            return NotificationItem(
                              notification: notification,
                              isSelected: isSelected,
                              onTap: () {
                                if (state.selectedIds.isNotEmpty) {
                                  context.read<NotificationBloc>().add(
                                    ToggleSelection(notification.id),
                                  );
                                } else {
                                  context.read<NotificationBloc>().add(
                                    MarkAsRead(notification.id),
                                  );
                                  
                                  // TODO: Navigate to respective pages based on notification type.
                                  // Example implementation ready to be connected:
                                  final String type = notification.type.toLowerCase();
                                  
                                  if (type.contains('offer')) {
                                    // Navigator.pushNamed(context, Routes.offerDetails, arguments: notification.id);
                                    AppSnackBar.info(context, 'Navigate to Offers (Logic ready)');
                                  } else if (type.contains('payment')) {
                                    // Navigator.pushNamed(context, Routes.paymentDetails, arguments: notification.id);
                                    AppSnackBar.info(context, 'Navigate to Payments (Logic ready)');
                                  } else if (type.contains('rental')) {
                                    // Navigator.pushNamed(context, Routes.rentalDetails, arguments: notification.id);
                                    AppSnackBar.info(context, 'Navigate to Rentals (Logic ready)');
                                  } else {
                                    // Default fallback action
                                    AppSnackBar.info(context, 'Notification tapped: ${notification.title}');
                                  }
                                }
                              },
                              onLongPress: () {
                                context.read<NotificationBloc>().add(
                                  ToggleSelection(notification.id),
                                );
                              },
                            );
                          },
                        );
                      } else if (state is NotificationError) {
                        return Center(
                          child: Text(
                            state.message,
                            style: const TextStyle(fontFamily: AppFonts.font),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
