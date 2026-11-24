
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
class RoomModel {
  final String id;
  final String title;
  final int capacity;
  final double size;
  final double price;
  final IconData icon;
  final String? imagePath;

  const RoomModel({
    required this.id,
    required this.title,
    required this.capacity,
    required this.size,
    required this.price,
    required this.icon,
    this.imagePath,
  });

  RoomModel copyWith({
    String? id,
    String? title,
    int? capacity,
    double? size,
    double? price,
    IconData? icon,
    String? imagePath,
  }) {
    return RoomModel(
      id: id ?? this.id,
      title: title ?? this.title,
      capacity: capacity ?? this.capacity,
      size: size ?? this.size,
      price: price ?? this.price,
      icon: icon ?? this.icon,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  String get capacityLabel => '$capacity Guest${capacity == 1 ? '' : 's'}';
  String get sizeLabel => '${size.toStringAsFixed(0)} sq ft';
  
  String get priceNumber {
    return price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  String get priceLabel => '$priceNumber EGP /mo';
}
