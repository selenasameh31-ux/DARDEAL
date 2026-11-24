import 'package:graduation_project_flutter/core/routing/routes_export.dart';

abstract class NotificationState {
  final Set<String> selectedIds;
  final String currentType;

  NotificationState({
    this.selectedIds = const <String>{},
    this.currentType = 'All',
  });
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<NotificationEntity> notifications;
  final List<NotificationEntity> filteredNotifications;

  NotificationLoaded({
    required this.notifications,
    required this.filteredNotifications,
    super.selectedIds,
    super.currentType,
  });

  NotificationLoaded copyWith({
    List<NotificationEntity>? notifications,
    List<NotificationEntity>? filteredNotifications,
    Set<String>? selectedIds,
    String? currentType,
  }) {
    return NotificationLoaded(
      notifications: notifications ?? this.notifications,
      filteredNotifications: filteredNotifications ?? this.filteredNotifications,
      selectedIds: selectedIds ?? this.selectedIds,
      currentType: currentType ?? this.currentType,
    );
  }
}

class NotificationError extends NotificationState {
  final String message;

  NotificationError({required this.message});
}
