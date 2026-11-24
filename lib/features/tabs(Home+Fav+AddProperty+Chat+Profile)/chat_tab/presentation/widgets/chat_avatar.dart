import 'package:graduation_project_flutter/core/routing/routes_export.dart';

/// Generates a colored circle avatar with the user's initials.
/// Each name gets a consistent color based on a hash.
class ChatAvatar extends StatelessWidget {
  final String name;
  final double radius;
  final bool showOnlineIndicator;

  const ChatAvatar({
    super.key,
    required this.name,
    this.radius = 26,
    this.showOnlineIndicator = false,
  });

  // Curated palette of distinguishable avatar colors
  static const List<Color> _avatarColors = [
    Color(0xFF1A8A7D), // Teal
    Color(0xFFE67E22), // Orange
    Color(0xFF8E44AD), // Purple
    Color(0xFF2980B9), // Blue
    Color(0xFFE74C3C), // Red
    Color(0xFF27AE60), // Green
    Color(0xFFF39C12), // Yellow
    Color(0xFF2C3E50), // Dark navy
  ];

  Color _colorFromName(String name) {
    int hash = 0;
    for (int i = 0; i < name.length; i++) {
      hash = name.codeUnitAt(i) + ((hash << 5) - hash);
    }
    return _avatarColors[hash.abs() % _avatarColors.length];
  }

  String _initialsFromName(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _colorFromName(name);
    final initials = _initialsFromName(name);

    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: bgColor,
          child: Text(
            initials,
            style: TextStyle(
              fontFamily: AppFonts.font,
              fontSize: radius * 0.7,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        if (showOnlineIndicator)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: radius * 0.5,
              height: radius * 0.5,
              decoration: BoxDecoration(
                color: const Color(0xFF10B981),
                shape: BoxShape.circle,
                border: Border.all(
                  color: context.scaffoldBgColor,
                  width: 2.5,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
