class PropertyTypeModel {
  final int id;
  final String code;
  final String nameEn;
  final String nameAr;
  final String iconName;

  PropertyTypeModel({
    required this.id,
    required this.code,
    required this.nameEn,
    required this.nameAr,
    required this.iconName,
  });

  factory PropertyTypeModel.fromJson(Map<String, dynamic> json) {
    return PropertyTypeModel(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      nameEn: json['nameEn'] ?? 'Unknown',
      nameAr: json['nameAr'] ?? 'غير معروف',
      iconName: json['iconName'] ?? 'home',
    );
  }
}
