import 'dart:math' as math;
import 'package:flutter/material.dart';

class TypingIndicator extends StatefulWidget {
  final Color dotColor;
  final double dotSize;

  const TypingIndicator({
    super.key,
    this.dotColor = const Color(0xFF144D53),
    this.dotSize = 8.0,
  });

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            double step = _controller.value - (index * 0.15);
            if (step < 0) step += 1.0;
            
            double bounce = math.sin(step * 2 * math.pi);
            double offset = bounce > 0 ? -bounce * 6.0 : 0.0;
            double opacity = 0.4 + (bounce > 0 ? bounce * 0.6 : 0.0);

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3.0),
              transform: Matrix4.translationValues(0.0, offset, 0.0),
              width: widget.dotSize,
              height: widget.dotSize,
              decoration: BoxDecoration(
                color: widget.dotColor.withValues(alpha: opacity.clamp(0.0, 1.0)),
                shape: BoxShape.circle,
              ),
            );
          },
        );
      }),
    );
  }
}
