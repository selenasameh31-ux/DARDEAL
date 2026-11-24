import 'package:graduation_project_flutter/core/routing/routes_export.dart';
import 'package:graduation_project_flutter/core/utils/top_snack_bar.dart';

class ChatActionDialogs {
  static void showBanConfirmation(BuildContext context, String userName) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final txtColor = isDark ? DarkColors.darkTitleAndSubTitleText : LightColors.lightTitleAndSubTitleText;
    final bgColor = isDark ? DarkColors.darkTextFieldColor : Colors.white;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.block, color: Colors.red),
            const SizedBox(width: 10),
            Text(
              'Block User', 
              style: TextStyle(fontFamily: AppFonts.font, fontSize: 18, fontWeight: FontWeight.bold, color: txtColor),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to block $userName? You will no longer receive messages or property updates from them.',
          style: TextStyle(fontFamily: AppFonts.font, fontSize: 14, color: txtColor.withOpacity(0.8), height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel', 
              style: TextStyle(fontFamily: AppFonts.font, fontWeight: FontWeight.bold, color: txtColor.withOpacity(0.6)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              showTopSnackBar(context, '$userName blocked successfully');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            child: const Text('Block', style: TextStyle(fontFamily: AppFonts.font, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  static void showReportMenu(BuildContext context, Offset tapPosition, String userName) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final txtColor = isDark ? DarkColors.darkTitleAndSubTitleText : LightColors.lightTitleAndSubTitleText;
    final bgColor = isDark ? DarkColors.darkTextFieldColor : Colors.white;

    final reasons = [
      'Spam or misleading',
      'Inappropriate content',
      'Scam or fraud',
      'Harassment',
      'Other'
    ];

    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    final value = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        overlay.size.width - 200, // Left (shift to right)
        tapPosition.dy,           // Top
        20,                       // Right
        0,                        // Bottom
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: bgColor,
      elevation: 4,
      items: reasons.map((reason) {
        return PopupMenuItem<String>(
          value: reason,
          child: Text(
            reason,
            style: TextStyle(
              fontFamily: AppFonts.font,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: txtColor,
            ),
          ),
        );
      }).toList(),
    );

    if (value != null) {
      showTopSnackBar(context, 'Reported for: $value. Thank you.');
    }
  }
}
