import 'package:flutter/material.dart';

/// Horizontale gestrichelte Trennlinie in Tusche-Optik.
class DashedDivider extends StatelessWidget {
  final Color? color;
  final double thickness;
  final double dashWidth;
  final double dashSpace;
  final EdgeInsets padding;

  const DashedDivider({
    super.key,
    this.color,
    this.thickness = 0.5,
    this.dashWidth = 2,
    this.dashSpace = 3,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final finalColor = color ?? colorScheme.outline;
    return Padding(
      padding: padding,
      child: SizedBox(
        height: thickness,
        child: CustomPaint(
          size: Size.infinite,
          painter: _DashedLinePainter(
            color: finalColor,
            thickness: thickness,
            dashWidth: dashWidth,
            dashSpace: dashSpace,
          ),
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  final double thickness;
  final double dashWidth;
  final double dashSpace;

  const _DashedLinePainter({
    required this.color,
    required this.thickness,
    required this.dashWidth,
    required this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness;

    double x = 0;
    final y = size.height / 2;
    while (x < size.width) {
      canvas.drawLine(Offset(x, y), Offset(x + dashWidth, y), paint);
      x += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter old) =>
      old.color != color ||
      old.thickness != thickness ||
      old.dashWidth != dashWidth ||
      old.dashSpace != dashSpace;
}
