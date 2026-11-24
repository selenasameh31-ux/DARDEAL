import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class ProfileMenuTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isLogout;
  final VoidCallback? onTap;

  const ProfileMenuTile({
    super.key,
    required this.title,
    required this.icon,
    this.isLogout = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap:
            onTap ??
            () {
              AppSnackBar.info(context, '$title');
            },
        borderRadius: BorderRadius.circular(12),
        splashColor: isLogout
            ? Colors.red.withValues(alpha: 0.1)
            : context.primaryColor.withValues(alpha: 0.1),
        highlightColor: isLogout
            ? Colors.red.withValues(alpha: 0.05)
            : context.primaryColor.withValues(alpha: 0.05),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          child: Row(
            children: [
              Icon(
                icon,
                size: 24,
                color: isLogout ? Colors.red : context.primaryColor,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isLogout ? Colors.red : context.titleColor,
                    fontFamily: AppFonts.font,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: isLogout
                    ? Colors.red.withValues(alpha: 0.7)
                    : context.hintColor.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
