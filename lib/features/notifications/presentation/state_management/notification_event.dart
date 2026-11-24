import 'package:graduation_project_flutter/core/routing/routes_export.dart';

abstract class NotificationEvent {}

class LoadNotifications extends NotificationEvent {}


class MarkAsRead extends NotificationEvent {
  final String id;
  MarkAsRead(this.id);
}

class ToggleSelection extends NotificationEvent {
  final String id;
  ToggleSelection(this.id);
}

class DeleteSelected extends NotificationEvent {}

class FilterByType extends NotificationEvent {
  final String type;
  FilterByType(this.type);
}
