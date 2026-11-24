import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class ChatbotWelcomeWidget extends StatelessWidget {
  final ValueChanged<String> onSuggestionSelected;

  const ChatbotWelcomeWidget({super.key, required this.onSuggestionSelected});

  @override
  Widget build(BuildContext context) {
    final suggestions = [
      "فين أرخص الشقق المعروضة دلوقتي؟",
      "عايز شاليه للإيجار في الساحل",
      "إيه هي تفضيلاتي المحفوظة؟",
      "عايز غرفة مشتركة للإيجار في المعادي",
      "إيه الفرق بين الشقة والاستوديو؟",
      "هل عندكم وحدات مفروشة؟",
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Bot Avatar Icon
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image.asset(
              'assets/icons/chatbot/darbot_bot_icon.png',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),

          // Title
          const Text(
            "أهلاً بك! أنا DarBot 👋",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF235265),
              fontFamily: AppFonts.font,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Subtitle
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              "مساعدك الذكي للعثور على العقار المناسب في مصر",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontFamily: AppFonts.font,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),

          // Suggestion Buttons
          ...suggestions.map((suggestion) {
            return Container(
              margin: const EdgeInsets.symmetric(
                vertical: 6.0,
                horizontal: 24.0,
              ),
              constraints: const BoxConstraints(maxWidth: 320),
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => onSuggestionSelected(suggestion),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  suggestion,
                  style: const TextStyle(
                    color: Color(0xFF235265),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.font,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
