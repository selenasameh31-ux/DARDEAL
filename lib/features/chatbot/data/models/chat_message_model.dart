import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class ChatbotPropertyModel extends ChatbotProperty {
  const ChatbotPropertyModel({
    required super.id,
    super.realId,
    required super.title,
    required super.imageUrl,
    required super.price,
    required super.area,
    required super.location,
    super.propertyType,
    super.isRent,
    super.bedrooms,
    super.bathrooms,
  });

  factory ChatbotPropertyModel.fromJson(Map<String, dynamic> json) {
    return ChatbotPropertyModel(
      id: json['id']?.toString() ?? '',
      realId: json['realId'] as int? ?? 
              (json['propertyId'] != null ? int.tryParse(json['propertyId'].toString()) : null) ?? 
              int.tryParse(json['id']?.toString() ?? ''),
      title: json['title'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      area: (json['area'] as num?)?.toDouble() ?? 0.0,
      location: json['location'] as String? ?? '',
    );
  }

  /// Build a ChatbotPropertyModel directly from a HomePropertyModel (real backend data).
  factory ChatbotPropertyModel.fromHomeProperty(HomePropertyModel property) {
    return ChatbotPropertyModel(
      id: property.id?.toString() ?? '',
      realId: property.id,
      title: property.title,
      imageUrl: property.imageUrl ?? '',
      price: property.price,
      area: 0.0,
      location: property.address,
      propertyType: property.propertyType,
      isRent: property.propertyType.toLowerCase().contains('rent'),
      bedrooms: 0,
      bathrooms: 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'realId': realId,
      'title': title,
      'imageUrl': imageUrl,
      'price': price,
      'area': area,
      'location': location,
      'propertyType': propertyType,
      'isRent': isRent,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
    };
  }

  factory ChatbotPropertyModel.fromEntity(ChatbotProperty entity) {
    return ChatbotPropertyModel(
      id: entity.id,
      realId: entity.realId,
      title: entity.title,
      imageUrl: entity.imageUrl,
      price: entity.price,
      area: entity.area,
      location: entity.location,
      propertyType: entity.propertyType,
      isRent: entity.isRent,
      bedrooms: entity.bedrooms,
      bathrooms: entity.bathrooms,
    );
  }
}

class ChatMessageModel extends ChatMessageEntity {
  const ChatMessageModel({
    required super.id,
    required super.text,
    required super.isUserMessage,
    required super.timestamp,
    super.properties,
    super.suggestions,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String? ?? '',
      text: json['text'] as String? ?? '',
      isUserMessage: json['isUserMessage'] as bool? ?? false,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
      properties: json['properties'] != null
          ? (json['properties'] as List<dynamic>)
                .map(
                  (p) =>
                      ChatbotPropertyModel.fromJson(p as Map<String, dynamic>),
                )
                .toList()
          : null,
      suggestions: json['suggestions'] != null
          ? (json['suggestions'] as List<dynamic>)
                .map((e) => e.toString())
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isUserMessage': isUserMessage,
      'timestamp': timestamp.toIso8601String(),
      'properties': properties
          ?.map((p) => ChatbotPropertyModel.fromEntity(p).toJson())
          .toList(),
      'suggestions': suggestions,
    };
  }

  factory ChatMessageModel.fromEntity(ChatMessageEntity entity) {
    return ChatMessageModel(
      id: entity.id,
      text: entity.text,
      isUserMessage: entity.isUserMessage,
      timestamp: entity.timestamp,
      properties: entity.properties,
      suggestions: entity.suggestions,
    );
  }
}
