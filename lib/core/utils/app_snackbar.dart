import 'package:graduation_project_flutter/core/routing/routes_export.dart';

/// Defines the type of a SnackBar notification.
/// Each type maps to a specific icon, color, and style.
enum SnackBarType {
  /// Red background - for validation failures and critical errors.
  error,

  /// Green background - for successful operations (saved, published, etc.).
  success,

  /// Amber/orange background - for warnings that need attention.
  warning,

  /// Primary brand color background - for informational messages.
  info,
}

/// A centralized, smart SnackBar utility for the entire app.
///
/// Usage:
/// ```dart
/// AppSnackBar.show(
///   context,
///   message: 'Please select at least one Amenity.',
///   type: SnackBarType.error,
/// );
/// ```
class AppSnackBar {
  AppSnackBar._();

  static Color _bgColor(SnackBarType type) => switch (type) {
    SnackBarType.error => Colors.white, // Premium white background
    SnackBarType.success => Colors.white, // Premium white background
    SnackBarType.warning => const Color(0xFFF59E0B),
    SnackBarType.info => const Color(0xFF0C6B6B),
  };

  static IconData _icon(SnackBarType type) => switch (type) {
    SnackBarType.error => Icons.error_outline_rounded,
    SnackBarType.success => Icons.check_circle_outline_rounded,
    SnackBarType.warning => Icons.warning_amber_rounded,
    SnackBarType.info => Icons.info_outline_rounded,
  };

  static String _simplifyMessage(String message) {
    if (message.contains('SocketException') ||
        message.contains('network') ||
        message.contains('timeout')) {
      return 'Connection error. Please check your internet connection and try again.';
    }
    if (message.contains('DioException')) {
      return 'Network request failed. Please check your connection or try again later.';
    }
    if (message.contains('429') || message.toLowerCase().contains('too many requests') || message.toLowerCase().contains('rate limit')) {
      return 'Please wait before requesting another code. Try again in a moment.';
    }
    if (message.contains('401') || message.contains('Unauthorized')) {
      return 'Your session has expired. Please log in again.';
    }
    if (message.contains('403') || message.contains('Forbidden')) {
      return 'You do not have permission to perform this action.';
    }
    if (message.contains('404')) {
      return 'The requested resource could not be found.';
    }
    if (message.contains('409') || message.contains('Conflict')) {
      return 'This action has already been performed or there is a data conflict.';
    }
    if (message.contains('500') || message.contains('Internal Server Error')) {
      return 'Server error. Our team has been notified. Please try again soon.';
    }
    return message;
  }

  static void show(
    BuildContext context, {
    required String message,
    SnackBarType type = SnackBarType.error,
    Duration duration = const Duration(seconds: 3),
    bool isTop = true, // Default to top for errors as requested
  }) {
    final displayMessage = type == SnackBarType.error
        ? _simplifyMessage(message)
        : message;

    final isPremium =
        type == SnackBarType.error || type == SnackBarType.success;

    final Widget contentWidget = Row(
      children: [
        if (isPremium)
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: type == SnackBarType.error
                  ? Colors.red.shade50
                  : Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _icon(type),
              color: type == SnackBarType.error
                  ? Colors.red.shade700
                  : Colors.green.shade700,
              size: 20,
            ),
          )
        else
          Icon(_icon(type), color: Colors.white, size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isPremium)
                Text(
                  type == SnackBarType.error ? 'Attention Required' : 'Success',
                  style: TextStyle(
                    color: type == SnackBarType.error
                        ? Colors.red.shade900
                        : Colors.green.shade900,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              Text(
                displayMessage,
                style: TextStyle(
                  color: isPremium ? Colors.grey.shade800 : Colors.white,
                  fontSize: 12,
                  fontWeight: isPremium ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    if (isTop) {
      _showTopOverlay(context, contentWidget, type, duration, isPremium);
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: duration,
          behavior: SnackBarBehavior.floating,
          backgroundColor: _bgColor(type),
          elevation: isPremium ? 6 : 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isPremium
                ? BorderSide(
                    color: type == SnackBarType.error
                        ? Colors.red.shade100
                        : Colors.green.shade100,
                    width: 1,
                  )
                : BorderSide.none,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          content: contentWidget,
        ),
      );
    }
  }

  static OverlayEntry? _currentOverlay;

  static void _showTopOverlay(
    BuildContext context,
    Widget content,
    SnackBarType type,
    Duration duration,
    bool isPremium,
  ) {
    _currentOverlay?.remove();
    _currentOverlay = null;

    final overlayState = Overlay.of(context);

    _currentOverlay = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          left: 16,
          right: 16,
          child: Material(
            color: Colors.transparent,
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              tween: Tween(begin: -100.0, end: 0.0),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, value),
                  child: child,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: _bgColor(type),
                  borderRadius: BorderRadius.circular(12),
                  border: isPremium
                      ? Border.all(
                          color: type == SnackBarType.error
                              ? Colors.red.shade100
                              : Colors.green.shade100,
                          width: 1,
                        )
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: isPremium ? 12 : 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: content,
              ),
            ),
          ),
        );
      },
    );

    overlayState.insert(_currentOverlay!);

    Future.delayed(duration).then((_) {
      if (_currentOverlay != null && _currentOverlay!.mounted) {
        _currentOverlay!.remove();
        _currentOverlay = null;
      }
    });
  }

  // ── Convenience shorthands ─────────────────────────────────────────
  static void error(
    BuildContext context,
    String message, {
    Duration? duration,
    bool isTop = true,
  }) => show(
    context,
    message: message,
    type: SnackBarType.error,
    duration: duration ?? const Duration(seconds: 3),
    isTop: isTop,
  );

  /// Use this variant when you need to show an error after an `await` gap
  /// (to avoid use_build_context_synchronously lint). Capture the messenger
  /// before the async call: `final m = ScaffoldMessenger.of(context);`
  static void errorViaMessenger(
    ScaffoldMessengerState messenger,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    final displayMessage = _simplifyMessage(message);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: duration,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.white,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.red.shade100),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          content: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  color: Colors.red.shade700,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Attention Required',
                      style: TextStyle(
                        color: Colors.red.shade900,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      displayMessage,
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }

  static void success(
    BuildContext context,
    String message, {
    Duration? duration,
    bool isTop = true,
  }) => show(
    context,
    message: message,
    type: SnackBarType.success,
    duration: duration ?? const Duration(seconds: 3),
    isTop: isTop,
  );

  static void warning(
    BuildContext context,
    String message, {
    Duration? duration,
    bool isTop = true,
  }) => show(
    context,
    message: message,
    type: SnackBarType.warning,
    duration: duration ?? const Duration(seconds: 3),
    isTop: isTop,
  );

  static void info(
    BuildContext context,
    String message, {
    Duration? duration,
    bool isTop = true,
  }) => show(
    context,
    message: message,
    type: SnackBarType.info,
    duration: duration ?? const Duration(seconds: 3),
    isTop: isTop,
  );
}
