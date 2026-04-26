import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Generischer Spider-/Radar-Chart für beliebig viele Achsen (min. 3).
class SpiderChart extends StatelessWidget {
  final List<String> labels;
  final List<double> values;
  final double size;
  final bool showLabels;
  final double maxValue;

  /// Akzentfarbe für Datenfläche und Punkte. Null = colorScheme.primary.
  final Color? color;

  const SpiderChart({
    super.key,
    required this.labels,
    required this.values,
    this.size = 200,
    this.showLabels = true,
    this.maxValue = 5.0,
    this.color,
  }) : assert(labels.length == values.length);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final resolvedColor = color ?? colorScheme.primary;
    final gridColor = colorScheme.onSurface.withValues(alpha: 0.22);
    final labelStyle = (textTheme.labelSmall ?? const TextStyle()).copyWith(
      color: colorScheme.onSurfaceVariant,
      fontSize: 10,
    );

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _SpiderPainter(
          labels: labels,
          values: values,
          showLabels: showLabels,
          maxValue: maxValue,
          color: resolvedColor,
          gridColor: gridColor,
          labelStyle: labelStyle,
        ),
      ),
    );
  }
}

class _SpiderPainter extends CustomPainter {
  final List<String> labels;
  final List<double> values;
  final bool showLabels;
  final double maxValue;
  final Color color;
  final Color gridColor;
  final TextStyle labelStyle;

  const _SpiderPainter({
    required this.labels,
    required this.values,
    required this.showLabels,
    required this.maxValue,
    required this.color,
    required this.gridColor,
    required this.labelStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final n = labels.length;
    if (n < 3) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) * (showLabels ? 0.60 : 0.75);

    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Hintergrund-Polygon-Raster
    for (int level = 1; level <= maxValue.ceil(); level++) {
      final r = radius * (level / maxValue);
      final path = Path();
      for (int i = 0; i < n; i++) {
        final angle = _angleFor(i, n);
        final x = center.dx + r * math.cos(angle);
        final y = center.dy + r * math.sin(angle);
        i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
      }
      path.close();
      _drawDashedPath(canvas, path, gridPaint);
    }

    // Achsen
    for (int i = 0; i < n; i++) {
      final angle = _angleFor(i, n);
      final end = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      _drawDashedLine(canvas, center, end, gridPaint);
    }

    // Daten-Polygon
    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = color
      ..strokeWidth = 1.3
      ..style = PaintingStyle.stroke;
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final dataPath = Path();
    for (int i = 0; i < n; i++) {
      final angle = _angleFor(i, n);
      final r = radius * (values[i].clamp(0, maxValue) / maxValue);
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);
      i == 0 ? dataPath.moveTo(x, y) : dataPath.lineTo(x, y);
    }
    dataPath.close();
    canvas.drawPath(dataPath, fillPaint);
    canvas.drawPath(dataPath, strokePaint);

    // Datenpunkte
    for (int i = 0; i < n; i++) {
      final angle = _angleFor(i, n);
      final r = radius * (values[i].clamp(0, maxValue) / maxValue);
      canvas.drawCircle(
        Offset(center.dx + r * math.cos(angle), center.dy + r * math.sin(angle)),
        2.5,
        dotPaint,
      );
    }

    // Achsenbeschriftungen
    if (showLabels) {
      for (int i = 0; i < n; i++) {
        final angle = _angleFor(i, n);
        final labelR = radius + size.width * 0.09;
        final x = center.dx + labelR * math.cos(angle);
        final y = center.dy + labelR * math.sin(angle);

        final tp = TextPainter(
          text: TextSpan(text: labels[i], style: labelStyle),
          textDirection: TextDirection.ltr,
        )..layout();

        tp.paint(canvas, Offset(x - tp.width / 2, y - tp.height / 2));
      }
    }
  }

  double _angleFor(int i, int n) => (2 * math.pi * i / n) - math.pi / 2;

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      bool drawing = true;
      while (distance < metric.length) {
        final len = drawing ? 2.0 : 3.0;
        if (drawing) {
          canvas.drawPath(
            metric.extractPath(
                distance, (distance + len).clamp(0, metric.length)),
            paint,
          );
        }
        distance += len;
        drawing = !drawing;
      }
    }
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    final total = (end - start).distance;
    final dir = (end - start) / total;
    double pos = 0;
    bool drawing = true;
    while (pos < total) {
      final len = drawing ? 2.0 : 3.0;
      if (drawing) {
        canvas.drawLine(
            start + dir * pos, start + dir * (pos + len).clamp(0, total), paint);
      }
      pos += len;
      drawing = !drawing;
    }
  }

  @override
  bool shouldRepaint(covariant _SpiderPainter old) =>
      old.showLabels != showLabels ||
      old.maxValue != maxValue ||
      old.color != color ||
      old.gridColor != gridColor ||
      old.values.length != values.length ||
      old.labels.length != labels.length ||
      _anyDiff(old.values, values) ||
      _anyDiff(old.labels, labels);

  bool _anyDiff<T>(List<T> a, List<T> b) {
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return true;
    }
    return false;
  }
}
