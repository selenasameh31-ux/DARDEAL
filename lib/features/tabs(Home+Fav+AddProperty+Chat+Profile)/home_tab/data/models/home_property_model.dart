// class HomePropertyModel {
//   final int? id;
//   final String title;
//   final String address;
//   final double price;
//   final String? imageUrl;
//   final String propertyType;
//   final bool isVerified;
//   final bool isFeatured;

//   HomePropertyModel({
//     this.id,
//     required this.title,
//     required this.address,
//     required this.price,
//     this.imageUrl,
//     required this.propertyType,
//     this.isVerified = false,
//     this.isFeatured = false,
//   });

//   factory HomePropertyModel.fromJson(Map<String, dynamic> json) {
//     return HomePropertyModel(
//       id: json['id'],
//       title: json['title'] ?? json['name'] ?? 'Unknown Property',
//       address: json['address'] ?? json['location'] ?? 'Unknown Location',
//       price: (json['price'] ?? json['rentPrice'] ?? json['salePrice'] ?? 0.0).toDouble(),
//       imageUrl: json['imageUrl'] ?? json['mainImage'] ?? json['image'],
//       propertyType: json['propertyType'] ?? json['type'] ?? 'Unknown',
//       isVerified: json['isVerified'] ?? false,
//       isFeatured: json['isFeatured'] ?? false,
//     );
//   }
// }



// import 'package:graduation_project_flutter/core/routing/routes_export.dart';


// class HomePropertyModel {
//   final int? id;
//   final String title;
//   final String address;
//   final double price;
//   final String? imageUrl;
//   final String propertyType;
//   final bool isVerified;
//   final bool isFeatured;
//   final String? listingType; // ✅ إضافة listingType

//   HomePropertyModel({
//     this.id,
//     required this.title,
//     required this.address,
//     required this.price,
//     this.imageUrl,
//     required this.propertyType,
//     this.isVerified = false,
//     this.isFeatured = false,
//     this.listingType, // ✅ إضافة listingType
//   });

//   factory HomePropertyModel.fromJson(Map<String, dynamic> json) {
//     return HomePropertyModel(
//       id: json['id'],
//       title: json['title'] ?? json['name'] ?? 'Unknown Property',
//       address: json['address'] ?? json['location'] ?? 'Unknown Location',
//       price: (json['price'] ?? json['rentPrice'] ?? json['salePrice'] ?? 0.0)
//           .toDouble(),
//       imageUrl: _getFullImageUrl(
//         json['coverPhoto'] ??
//             json['imageUrl'] ??
//             json['mainImage'] ??
//             json['image'] ??
//             ((json['images'] != null && (json['images'] as List).isNotEmpty)
//                 ? json['images'][0]
//                 : null) ??
//             ((json['media'] != null && (json['media'] as List).isNotEmpty)
//                 ? json['media'][0]
//                 : null),
//       ),
//       propertyType: json['propertyType'] ?? json['type'] ?? 'Unknown',
//       isVerified: json['isVerified'] ?? false,
//       isFeatured: json['isFeatured'] ?? false,
//       // ✅ قراءة listingType من الـ API (يجرب مفاتيح مختلفة)
//       listingType:
//           json['listingType'] ?? json['intent'] ?? json['transactionType'],
//     );
//   }

//   static String _getFullImageUrl(dynamic path) {
//     if (path == null || path.toString().isEmpty) return '';
//     String url = path.toString();
//     if (url.startsWith('http')) return url;
//     if (!url.startsWith('/')) url = '/$url';
//     return '${EndPoints.baseUrl}$url';
//   }
// }




import 'package:graduation_project_flutter/core/database/api/end_points.dart';

class HomePropertyModel {
  final int? id;
  final String title;
  final String address;
  final double price;
  final String? imageUrl;
  final String propertyType;
  final bool isVerified;
  final bool isFeatured;
  final String? listingType;
  final String? description;
  final int? bedrooms;
  final double? areaSquareMeters;
  final String? furnishingStatus;

  HomePropertyModel({
    this.id,
    required this.title,
    required this.address,
    required this.price,
    this.imageUrl,
    required this.propertyType,
    this.isVerified = false,
    this.isFeatured = false,
    this.listingType,
    this.description,
    this.bedrooms,
    this.areaSquareMeters,
    this.furnishingStatus,
  });

  factory HomePropertyModel.fromJson(Map<String, dynamic> json) {
    final specs = json['specs'] as Map<String, dynamic>?;
    return HomePropertyModel(
      id: json['id'],
      title: json['title'] ?? json['name'] ?? 'Unknown Property',
      address: json['address'] ?? json['location'] ?? 'Unknown Location',
      price: (json['price'] ?? json['rentPrice'] ?? json['salePrice'] ?? 0.0)
          .toDouble(),
      imageUrl: _getFullImageUrl(
        json['coverPhoto'] ??
            json['imageUrl'] ??
            json['mainImage'] ??
            json['image'] ??
            ((json['images'] != null && (json['images'] as List).isNotEmpty)
                ? json['images'][0]
                : null) ??
            ((json['media'] != null && (json['media'] as List).isNotEmpty)
                ? json['media'][0]
                : null),
      ),
      propertyType: json['propertyType'] ?? json['type'] ?? 'Unknown',
      isVerified: json['isVerified'] ?? false,
      isFeatured: json['isFeatured'] ?? false,
      listingType:
          json['listingType'] ?? json['intent'] ?? json['transactionType'],
      description: json['description'],
      bedrooms: _parseInt(specs?['bedrooms'] ?? json['bedrooms'] ?? json['beds']),
      areaSquareMeters: _parseDouble(specs?['areaSquareMeters'] ?? json['areaSquareMeters'] ?? json['totalArea'] ?? json['area']),
      furnishingStatus: specs?['furnishingStatus'] ?? json['furnishingStatus'],
    );
  }

  static String _getFullImageUrl(dynamic path) {
    if (path == null || path.toString().isEmpty) return '';
    String url = path.toString();
    if (url.startsWith('http')) return url;
    if (!url.startsWith('/')) url = '/$url';
    return '${EndPoints.baseUrl}$url';
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
