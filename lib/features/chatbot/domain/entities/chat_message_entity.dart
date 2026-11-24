

class ChatbotProperty {
  final String id;
  final int? realId;
  final String title;
  final String imageUrl;
  final double price;
  final double area;
  final String location;
  final String propertyType;
  final bool isRent;
  final int bedrooms;
  final int bathrooms;

  const ChatbotProperty({
    required this.id,
    this.realId,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.area,
    required this.location,
    this.propertyType = '',
    this.isRent = false,
    this.bedrooms = 0,
    this.bathrooms = 0,
  });
}

class ChatMessageEntity {
  final String id;
  final String text;
  final bool isUserMessage;
  final DateTime timestamp;
  final List<ChatbotProperty>? properties;
  final List<String>? suggestions;
  const ChatMessageEntity({
    required this.id,
    required this.text,
    required this.isUserMessage,
    required this.timestamp,
    this.properties,
    this.suggestions,
  });

  ChatMessageEntity copyWith({
    String? id,
    String? text,
    bool? isUserMessage,
    DateTime? timestamp,
    List<ChatbotProperty>? properties,
    List<String>? suggestions,
  }) {
    return ChatMessageEntity(
      id: id ?? this.id,
      text: text ?? this.text,
      isUserMessage: isUserMessage ?? this.isUserMessage,
      timestamp: timestamp ?? this.timestamp,
      properties: properties ?? this.properties,
      suggestions: suggestions ?? this.suggestions,
    );
  }
}

