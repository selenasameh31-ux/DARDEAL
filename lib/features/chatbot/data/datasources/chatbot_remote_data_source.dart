import 'package:graduation_project_flutter/core/routing/routes_export.dart';

abstract class ChatbotRemoteDataSource {
  Future<ChatMessageModel> sendMessage(String message);
  Future<List<ChatMessageModel>> getChatHistory();
}

class ChatbotRemoteDataSourceImpl implements ChatbotRemoteDataSource {
  final ApiConsumer api;
  final CacheHelper cacheHelper;

  ChatbotRemoteDataSourceImpl({required this.api, required this.cacheHelper});

  String get _token => cacheHelper.getToken() ?? '';

  List<String> _getRandomSuggestions() {
    final allSuggestions = [
      "عايز أبحث بالميزانية 💰",
      "عايز أأجر عقار 🔑",
      "عايز أشتري عقار 🏠",
      "عايز أبحث بالمنطقة 📍",
      "فين أرخص الشقق المعروضة دلوقتي؟ 📉",
      "عايز شاليه للإيجار في الساحل 🏖️",
      "إيه هي تفضيلاتي المحفوظة؟ ❤️",
      "عايز غرفة مشتركة للإيجار في المعادي 🛏️",
      "إيه الفرق بين الشقة والاستوديو؟ 🏢",
      "هل عندكم وحدات مفروشة؟ 🛋️",
      "عايز فيلا للبيع في التجمع 🏡",
      "أحدث العقارات المضافة؟ ✨",
    ];
    allSuggestions.shuffle();
    return allSuggestions.take(4).toList();
  }

  // ─────────────────────────────────────────────────────────
  // Helper: Build ChatMessageModel from a clean Map
  // ─────────────────────────────────────────────────────────
  Future<ChatMessageModel> _parseMapToMessage(Map<String, dynamic> data) async {
    final text =
        data['message'] as String? ??
        data['response'] as String? ??
        data['reply'] as String? ??
        data['text'] as String? ??
        data['content'] as String? ??
        data.toString();

    // ── Verify ALL properties to filter out AI hallucinations ──
    final Set<int> allIds = {};

    // 1. Extract IDs from 'properties' array if the AI returned full objects
    if (data['properties'] != null && data['properties'] is List) {
      for (var p in data['properties']) {
        if (p is Map<String, dynamic>) {
          final idStr = p['realId']?.toString() ?? p['propertyId']?.toString() ?? p['id']?.toString();
          final n = int.tryParse(idStr ?? '');
          if (n != null) allIds.add(n);
        }
      }
    }

    // 2. Extract IDs from 'propertyIds' array
    if (data['propertyIds'] != null && data['propertyIds'] is List) {
      for (var id in data['propertyIds']) {
        final n = int.tryParse(id.toString());
        if (n != null) allIds.add(n);
      }
    }

    // 3. Fetch real details for all unique IDs. This naturally filters out fake IDs (404).
    List<ChatbotPropertyModel>? properties;
    if (allIds.isNotEmpty) {
      properties = [];
      for (int id in allIds.take(5)) {
        try {
          final response = await api.get(EndPoints.property(id), token: _token);
          if (response.data['success'] == true) {
            final propertyData = response.data['data'];
            if (propertyData is Map<String, dynamic>) {
              propertyData['id'] = id;
            }
            final homeProperty = HomePropertyModel.fromJson(propertyData);
            debugPrint('[CHATBOT] Verified & Fetched property $id');
            properties.add(ChatbotPropertyModel.fromHomeProperty(homeProperty));
          }
        } catch (e) {
          debugPrint('[CHATBOT] Filtered out fake/invalid property $id: $e');
        }
      }
    }

    // Parse optional suggestions if the backend returns them.
    List<String>? suggestions;
    if (data['suggestions'] != null && data['suggestions'] is List) {
      suggestions = (data['suggestions'] as List)
          .map((s) => s.toString())
          .toList();
    } else {
      suggestions = _getRandomSuggestions();
    }

    return ChatMessageModel(
      id:
          data['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isUserMessage: false,
      timestamp: DateTime.now(),
      properties: properties,
      suggestions: suggestions,
    );
  }

  // ─────────────────────────────────────────────────────────
  // Helper: Parse a Python-style dict string (single-quoted keys)
  // into a ChatMessageModel by extracting fields with regex.
  // ─────────────────────────────────────────────────────────
  Future<ChatMessageModel> _parsePythonDict(String raw) async {
    debugPrint('[CHATBOT] _parsePythonDict called with ${raw.length} chars');

    // ── Extract propertyIds (always a list of numbers) ──
    final List<int> propertyIds = [];
    final propsMatch = RegExp(r"['\x22]propertyIds['\x22]\s*:\s*\[([\d,\s]*)\]").firstMatch(raw);
    if (propsMatch != null) {
      for (final s in (propsMatch.group(1) ?? '').split(',')) {
        final n = int.tryParse(s.trim());
        if (n != null) propertyIds.add(n);
      }
    }

    // ── Extract suggestions (list of quoted strings) ──
    final List<String> suggestions = [];
    final suggsMatch = RegExp(r"['\x22]suggestions['\x22]\s*:\s*\[(.*?)\]", dotAll: true).firstMatch(raw);
    if (suggsMatch != null) {
      final suggsStr = suggsMatch.group(1) ?? '';
      // Match strings in either single or double quotes
      for (final m in RegExp(r"""['\x22]([^'\x22]{2,})['\x22]""").allMatches(suggsStr)) {
        final s = m.group(1);
        if (s != null && s.isNotEmpty && !s.contains(':')) suggestions.add(s);
      }
    }

    // ── Extract message ──
    // The message value uses double quotes while keys use single quotes.
    // Pattern: 'message': "...text...", 'propertyIds': [...]
    String? message;

    // Attempt 1: 'message': "...", 'propertyIds|suggestions|extractedPreferences':
    final msgPattern1 = RegExp(
      r"""['\x22]message['\x22]\s*:\s*\x22(.*?)\x22\s*,\s*['\x22](?:propertyIds|suggestions|extractedPreferences)['\x22]""",
      dotAll: true,
    ).firstMatch(raw);
    if (msgPattern1 != null) {
      message = msgPattern1.group(1);
    }

    // Attempt 2: 'message': '...' (single-quoted value)
    if (message == null) {
      final msgPattern2 = RegExp(
        r"""['\x22]message['\x22]\s*:\s*'(.*?)'\s*,\s*['\x22](?:propertyIds|suggestions|extractedPreferences)['\x22]""",
        dotAll: true,
      ).firstMatch(raw);
      if (msgPattern2 != null) {
        message = msgPattern2.group(1);
      }
    }

    // Attempt 3: Broadest — grab everything after 'message': until the next key
    if (message == null) {
      final msgPattern3 = RegExp(
        r"""['\x22]message['\x22]\s*:\s*['\x22]([\s\S]*?)['\x22]\s*,\s*['\x22]""",
      ).firstMatch(raw);
      if (msgPattern3 != null) {
        message = msgPattern3.group(1);
      }
    }

    debugPrint('[CHATBOT] extracted message: ${message?.substring(0, (message.length).clamp(0, 60))}...');
    debugPrint('[CHATBOT] extracted propertyIds: $propertyIds');
    debugPrint('[CHATBOT] extracted suggestions: $suggestions');

    return await _parseMapToMessage({
      'message': message ?? '',
      'propertyIds': propertyIds,
      if (suggestions.isNotEmpty) 'suggestions': suggestions,
    });
  }

  // ═════════════════════════════════════════════════════════
  //  POST /api/v1/AI/chat  →  Send a message & get bot reply
  // ═════════════════════════════════════════════════════════
  @override
  Future<ChatMessageModel> sendMessage(String message) async {
    final response = await api.post(
      EndPoints.aiChat,
      data: {'message': message},
      token: _token,
    );

    final data = response.data;

    debugPrint('[CHATBOT] response.data runtimeType = ${data.runtimeType}');

    // ── CASE 1: data is already a Map (Dio auto-parsed valid JSON) ──
    if (data is Map<String, dynamic>) {
      // Check if the extracted message text looks like a raw Python dict
      final text =
          data['message'] as String? ??
          data['response'] as String? ??
          data['text'] as String? ??
          data['content'] as String?;

      if (text != null && text.contains('propertyIds') && text.contains('message')) {
        debugPrint('[CHATBOT] Map message value contains raw dict — re-parsing');
        return await _parsePythonDict(text);
      }

      return await _parseMapToMessage(data);
    }

    // ── CASE 2: data is a String ──
    if (data is String) {
      // Try standard JSON decode first
      try {
        final parsed = jsonDecode(data);
        if (parsed is Map<String, dynamic>) {
          return await _parseMapToMessage(parsed);
        }
      } catch (_) {}

      // Try parsing as Python-style dict
      if (data.contains('propertyIds') || data.contains('message')) {
        debugPrint('[CHATBOT] String looks like Python dict — parsing');
        return await _parsePythonDict(data);
      }

      // Plain text response
      return ChatMessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: data,
        isUserMessage: false,
        timestamp: DateTime.now(),
        suggestions: _getRandomSuggestions(),
      );
    }

    // ── CASE 3: Fallback ──
    final fallbackStr = data?.toString() ?? '';
    if (fallbackStr.contains('propertyIds') && fallbackStr.contains('message')) {
      return await _parsePythonDict(fallbackStr);
    }

    return ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: fallbackStr.isEmpty ? 'No response received.' : fallbackStr,
      isUserMessage: false,
      timestamp: DateTime.now(),
      suggestions: _getRandomSuggestions(),
    );
  }

  // ═════════════════════════════════════════════════════════
  //  GET /api/v1/AI/chat/init  →  Load chat history / init session
  // ═════════════════════════════════════════════════════════

  Future<ChatMessageModel> _verifyHistoryMessage(ChatMessageModel msg) async {
    if (msg.properties == null || msg.properties!.isEmpty) return msg;

    final List<ChatbotPropertyModel> validProperties = [];
    for (var prop in msg.properties!.take(5)) {
      final id = prop.realId;
      if (id != null && id > 0) {
        try {
          final response = await api.get(EndPoints.property(id), token: _token);
          if (response.data['success'] == true) {
            final propertyData = response.data['data'];
            if (propertyData is Map<String, dynamic>) {
              propertyData['id'] = id;
            }
            final homeProperty = HomePropertyModel.fromJson(propertyData);
            validProperties.add(ChatbotPropertyModel.fromHomeProperty(homeProperty));
          }
        } catch (_) {}
      }
    }

    return ChatMessageModel(
      id: msg.id,
      text: msg.text,
      isUserMessage: msg.isUserMessage,
      timestamp: msg.timestamp,
      properties: validProperties.isNotEmpty ? validProperties : null,
      suggestions: msg.suggestions == null || msg.suggestions!.isEmpty 
                   ? _getRandomSuggestions() 
                   : msg.suggestions,
    );
  }

  @override
  Future<List<ChatMessageModel>> getChatHistory() async {
    final response = await api.get(EndPoints.aiChatInit, token: _token);

    final data = response.data;

    // If the backend returns a list of messages
    if (data is List) {
      final futures = data.map((item) async {
        final msg = ChatMessageModel.fromJson(item as Map<String, dynamic>);
        return await _verifyHistoryMessage(msg);
      });
      return await Future.wait(futures);
    }

    // If the backend returns an object with a messages array
    if (data is Map<String, dynamic>) {
      final messages = data['messages'] ?? data['chatHistory'] ?? data['data'];
      if (messages is List) {
        final futures = messages.map((item) async {
          final msg = ChatMessageModel.fromJson(item as Map<String, dynamic>);
          return await _verifyHistoryMessage(msg);
        });
        return await Future.wait(futures);
      }
      // If it returns a single welcome message
      if (data['message'] != null || data['text'] != null) {
        // Parse optional suggestions
        List<String>? suggestions;
        if (data['suggestions'] != null && data['suggestions'] is List) {
          suggestions = (data['suggestions'] as List)
              .map((s) => s.toString())
              .toList();
        } else {
          suggestions = _getRandomSuggestions();
        }

        return [
          ChatMessageModel(
            id:
                data['id']?.toString() ??
                DateTime.now().millisecondsSinceEpoch.toString(),
            text: (data['message'] ?? data['text']) as String,
            isUserMessage: false,
            timestamp: DateTime.now(),
            suggestions: suggestions,
          ),
        ];
      }
    }

    // If it returns a plain string (welcome message)
    if (data is String && data.isNotEmpty) {
      return [
        ChatMessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: data,
          isUserMessage: false,
          timestamp: DateTime.now(),
          suggestions: _getRandomSuggestions(),
        ),
      ];
    }

    // Default: empty history → show welcome screen
    return [];
  }
}
