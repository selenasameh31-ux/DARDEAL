import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitial()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<MarkAsRead>(_onMarkAsRead);
    on<ToggleSelection>(_onToggleSelection);
    on<DeleteSelected>(_onDeleteSelected);
    on<FilterByType>(_onFilterByType);
  }

  void _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    await Future.delayed(const Duration(seconds: 1));
    emit(
      NotificationLoaded(
        notifications: _mockData,
        filteredNotifications: _mockData,
      ),
    );
  }

  void _onMarkAsRead(MarkAsRead event, Emitter<NotificationState> emit) {
    if (state is NotificationLoaded) {
      final s = state as NotificationLoaded;
      final updated = s.notifications.map((n) {
        if (n.id == event.id) return n.copyWith(isRead: true);
        return n;
      }).toList();
      emit(
        s.copyWith(
          notifications: updated,
          filteredNotifications: _applyFilter(updated, s.currentType),
        ),
      );
    }
  }

  void _onToggleSelection(
    ToggleSelection event,
    Emitter<NotificationState> emit,
  ) {
    if (state is NotificationLoaded) {
      final s = state as NotificationLoaded;
      final newSelection = Set<String>.from(s.selectedIds);
      if (newSelection.contains(event.id)) {
        newSelection.remove(event.id);
      } else {
        newSelection.add(event.id);
      }
      emit(s.copyWith(selectedIds: newSelection));
    }
  }

  void _onDeleteSelected(
    DeleteSelected event,
    Emitter<NotificationState> emit,
  ) {
    if (state is NotificationLoaded) {
      final s = state as NotificationLoaded;
      final updated = s.notifications
          .where((n) => !s.selectedIds.contains(n.id))
          .toList();
      emit(
        s.copyWith(
          notifications: updated,
          filteredNotifications: _applyFilter(updated, s.currentType),
          selectedIds: const <String>{},
        ),
      );
    }
  }

  void _onFilterByType(FilterByType event, Emitter<NotificationState> emit) {
    if (state is NotificationLoaded) {
      final s = state as NotificationLoaded;
      emit(
        s.copyWith(
          currentType: event.type,
          filteredNotifications: _applyFilter(s.notifications, event.type),
        ),
      );
    }
  }

  List<NotificationEntity> _applyFilter(
    List<NotificationEntity> list,
    String type,
  ) {
    if (type == 'All') return list;
    final mapping = {
      'Offers': 'offer',
      'Payments': 'payment',
      'Rentals': 'rental',
    };
    final mappedType = mapping[type] ?? type.toLowerCase();
    return list.where((n) => n.type == mappedType).toList();
  }

  final _mockData = [
    NotificationEntity(
      id: '1',
      title: 'Offer Accepted! 🎉',
      message:
          'Sarah has accepted your offer for the Maadi Flat. Proceed to payment to secure it.',
      type: 'offer',
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      isRead: false,
    ),
    NotificationEntity(
      id: '2',
      title: 'Action Required: Secure Home',
      message: 'Only 24 hours left to pay the deposit for your accepted offer.',
      type: 'action_required',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: false,
    ),
    NotificationEntity(
      id: '3',
      title: 'Payment Secured 🔒',
      message:
          'Funds for "Modern Villa" are now held in escrow. Move-in scheduled for Jan 15.',
      type: 'payment',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: true,
    ),
    NotificationEntity(
      id: '4',
      title: 'Listing Live! 🏡',
      message:
          'Admin has approved "Ocean View Maadi". It is now visible to seekers.',
      type: 'system',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    NotificationEntity(
      id: '5',
      title: 'Handover Pending',
      message:
          'Meet the owner today at 2:00 PM. Tap to confirm move-in after receiving keys.',
      type: 'rental',
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      isRead: false,
    ),
    NotificationEntity(
      id: '6',
      title: 'Offer Declined',
      message:
          'Your offer for Zamalek Studio was not accepted. Tap to view the owner\'s reason.',
      type: 'declined',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
    ),
  ];
}
