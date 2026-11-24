
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
class InteriorStep extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const InteriorStep({super.key, required this.onNext, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = context.primaryColor;

    return BlocBuilder<AddPropertyBloc, AddPropertyState>(
      builder: (context, state) {
        final rooms = state.rooms;
        return Material(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const StepHeader(),
                const SizedBox(height: 32),

                Text(
                  "Property Interior",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                    color: context.primaryColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Add details for each room in the property to give buyers a complete view.",
                  style: TextStyle(
                    fontSize: 14,
                    color: context.titleColor,
                  ),
                ),
                const SizedBox(height: 32),

                Text(
                  "ADDED ROOMS (${rooms.length})",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: isDark ? Colors.white : const Color(0xFF1E2A2E),
                  ),
                ),
                const SizedBox(height: 16),

                ...List.generate(rooms.length, (index) {
                  final room = rooms[index];
                  return RoomCardWidget(
                    model: room,
                    onEdit: () async {
                      final updated = await showAddRoomBottomSheet(
                        context,
                        existing: room,
                      );
                      if (updated != null && context.mounted) {
                        context.read<AddPropertyBloc>().add(
                          EditRoomEvent(index, updated),
                        );
                      }
                    },
                    onDelete: () {
                      context.read<AddPropertyBloc>().add(
                        DeleteRoomEvent(index),
                      );
                    },
                  );
                }),

                const SizedBox(height: 16),

                _buildAddAnotherRoomButton(context, primaryColor, isDark),

                const SizedBox(height: 48),

                StepNavigationButtons(
                  step: 8,
                  onNext: () {
                    if (rooms.isEmpty) {
                      AppSnackBar.error(
                        context,
                        'Please add at least one room.',
                      );
                    } else {
                      onNext();
                    }
                  },
                  onBack: onBack,
                  onSaveDraft: () {
                    context.read<AddPropertyBloc>().add(SaveDraftEvent());
                    AppSnackBar.success(
                      context,
                      'Draft saved successfully!',
                      isTop: true,
                    );
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Routes.mainLayout,
                      (route) => false,
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddAnotherRoomButton(
    BuildContext context,
    Color primaryColor,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: () async {
        final newRoom = await showAddRoomBottomSheet(context);
        if (newRoom != null && context.mounted) {
          context.read<AddPropertyBloc>().add(AddRoomEvent(newRoom));
        }
      },
      child: CustomPaint(
        painter: _DashedBorderPainter(color: primaryColor, borderRadius: 16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: isDark
                ? primaryColor.withOpacity(0.05)
                : const Color(0xFFF2F9F9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.add, color: primaryColor, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                "Add another room",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double borderRadius;

  _DashedBorderPainter({required this.color, required this.borderRadius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.5)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    Path path = Path()..addRRect(rrect);
    Path dashPath = _createDashedPath(path, 8, 4);

    canvas.drawPath(dashPath, paint);
  }

  Path _createDashedPath(Path source, double dashLength, double dashSpace) {
    final Path dest = Path();
    for (final PathMetric metric in source.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final double len = min(dashLength, metric.length - distance);
        dest.addPath(metric.extractPath(distance, distance + len), Offset.zero);
        distance += len + dashSpace;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
