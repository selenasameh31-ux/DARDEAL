
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
abstract class AmenityMetaData {}

class QuietHoursData extends AmenityMetaData {
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String startFmt;
  final String endFmt;

  QuietHoursData({
    required this.startTime,
    required this.endTime,
    required this.startFmt,
    required this.endFmt,
  });
}

/// Represents a selectable amenity / rule / facility in the UI.
///
/// [id]    — A unique string key used for UI equality and local draft storage.
///           For API-backed items this is the stringified integer ID (e.g. "5").
///           For legacy hardcoded items this is a slug (e.g. "air_conditioning").
///
/// [apiId] — The real backend integer ID from /api/v1/Lookups/*.
///           This is what gets sent to the API (amenityIds, ruleIds, etc.).
///           Defaults to 0 for legacy items where no API ID is available.
///
/// [name]  — Human-readable display label.
/// [icon]  — MaterialIcons IconData for display.
class AmenityModel {
  final String id;
  final int apiId;
  final String name;
  final IconData icon;
  final AmenityMetaData? metaData;

  const AmenityModel({
    required this.id,
    required this.name,
    required this.icon,
    this.apiId = 0,
    this.metaData,
  });

  /// Creates an AmenityModel from a LookupItemModel returned by the Lookups API.
  /// Uses [resolveIconName] to convert the API's string icon name to IconData.
  /// [fallbackIcon] is used when the API iconName cannot be resolved.
  factory AmenityModel.fromLookup(
    LookupItemModel lookup, {
    required IconData fallbackIcon,
  }) {
    return AmenityModel(
      id: lookup.id.toString(),
      apiId: lookup.id,
      name: lookup.nameEn,
      icon: resolveIconName(lookup.iconName),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AmenityModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
