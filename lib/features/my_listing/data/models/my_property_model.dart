class MyPropertyModel {
  final int? id;
  final int? ownerId;
  final String? title;
  final String? propertyType;
  final String? listingType;
  final String? rentalModel;
  final String? category;
  final double? price;
  final double? dailyPrice;
  final String? currency;
  final String? coverPhoto;
  final String? location;
  final int? bedrooms;
  final int? bathrooms;
  final double? areaSquareMeters;
  final String? furnishingStatus;
  final bool? isVerified;
  final bool? isFeatured;
  final int? viewCount;
  final String? publishedAt;
  final String? status;

  MyPropertyModel({
    this.id,
    this.ownerId,
    this.title,
    this.propertyType,
    this.listingType,
    this.rentalModel,
    this.category,
    this.price,
    this.dailyPrice,
    this.currency,
    this.coverPhoto,
    this.location,
    this.bedrooms,
    this.bathrooms,
    this.areaSquareMeters,
    this.furnishingStatus,
    this.isVerified,
    this.isFeatured,
    this.viewCount,
    this.publishedAt,
    this.status,
  });

  factory MyPropertyModel.fromJson(Map<String, dynamic> json) {
    return MyPropertyModel(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      ownerId: json['ownerId'] != null ? int.tryParse(json['ownerId'].toString()) : null,
      title: json['title']?.toString(),
      propertyType: json['propertyType']?.toString(),
      listingType: json['listingType']?.toString(),
      rentalModel: json['rentalModel']?.toString(),
      category: json['category']?.toString(),
      price: json['price'] != null ? double.tryParse(json['price'].toString()) : null,
      dailyPrice: json['dailyPrice'] != null ? double.tryParse(json['dailyPrice'].toString()) : null,
      currency: json['currency']?.toString(),
      coverPhoto: json['coverPhoto']?.toString(),
      location: json['location']?.toString(),
      bedrooms: json['bedrooms'] != null ? int.tryParse(json['bedrooms'].toString()) : null,
      bathrooms: json['bathrooms'] != null ? int.tryParse(json['bathrooms'].toString()) : null,
      areaSquareMeters: json['areaSquareMeters'] != null ? double.tryParse(json['areaSquareMeters'].toString()) : null,
      furnishingStatus: json['furnishingStatus']?.toString(),
      isVerified: json['isVerified'] == true || json['isVerified'] == 'true' || json['isVerified'] == 1,
      isFeatured: json['isFeatured'] == true || json['isFeatured'] == 'true' || json['isFeatured'] == 1,
      viewCount: json['viewCount'] != null ? int.tryParse(json['viewCount'].toString()) : null,
      publishedAt: json['publishedAt']?.toString(),
      status: json['status']?.toString(),
    );
  }
}

class PaginatedMyPropertiesModel {
  final List<MyPropertyModel> items;
  final int totalCount;
  final int page;
  final int pageSize;
  final int totalPages;

  PaginatedMyPropertiesModel({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  factory PaginatedMyPropertiesModel.fromJson(Map<String, dynamic> json) {
    return PaginatedMyPropertiesModel(
      items: (json['items'] as List?)?.map((e) => MyPropertyModel.fromJson(e)).toList() ?? [],
      totalCount: json['totalCount'] ?? 0,
      page: json['page'] ?? 1,
      pageSize: json['pageSize'] ?? 20,
      totalPages: json['totalPages'] ?? 1,
    );
  }
}
