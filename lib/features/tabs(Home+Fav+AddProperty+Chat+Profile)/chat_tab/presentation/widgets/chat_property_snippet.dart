import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class ChatPropertySnippet extends StatelessWidget {
  final VoidCallback onViewTap;

  const ChatPropertySnippet({
    super.key,
    required this.onViewTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final txtColor = isDark ? DarkColors.darkTitleAndSubTitleText : LightColors.lightTitleAndSubTitleText;
    final borderColor = isDark ? DarkColors.darkTextFieldColor : LightColors.lightTextFieldColor;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.tagTextColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Row(
        children: [
          // Property Image
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDark ? DarkColors.darkTextFieldColor : LightColors.lightTextFieldColor,
              borderRadius: BorderRadius.circular(8),
              // image: DecorationImage(image: AssetImage('assets/images/villa.png'), fit: BoxFit.cover), // Uncomment later
            ),
            child: Icon(Icons.home_work_outlined, color: Colors.white54),
          ),
          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Modern Villa, New Cairo',
                  style: TextStyle(
                    fontFamily: AppFonts.font,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: txtColor,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '4,500,000 EGP',
                  style: TextStyle(
                    fontFamily: AppFonts.font,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: LightColors.lightAttentionText, // Orange price color matching design
                  ),
                ),
              ],
            ),
          ),

          // View Button
          GestureDetector(
            onTap: onViewTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: LightColors.lightAttentionText.withOpacity(0.1), // Light orange background
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'View',
                style: TextStyle(
                  fontFamily: AppFonts.font,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: LightColors.lightAttentionText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
