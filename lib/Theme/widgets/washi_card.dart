import 'package:flutter/material.dart';
import 'package:steapleaf/Theme/tokens/spacing.dart';

/// Papier-Karte — zentrales Container-Element.
class WashiCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? borderColor;
  final double borderWidth;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  final bool accentCorners;
  final double cornerSize;
  final double cornerStroke;

  const WashiCard({
    super.key,
    required this.child,
    this.padding,
    this.borderColor,
    this.borderWidth = 1.0,
    this.backgroundColor,
    this.onTap,
    this.accentCorners = false,
    this.cornerSize = 8,
    this.cornerStroke = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final border = borderColor ?? colorScheme.outline;
    final bg = backgroundColor ?? colorScheme.surface;
    final p = padding ?? SteapLeafSpacing.card;

    Widget container;
    if (onTap != null) {
      container = Container(
        decoration: BoxDecoration(
          border: Border.all(color: border, width: borderWidth),
        ),
        child: Material(
          color: bg,
          child: InkWell(
            onTap: onTap,
            child: Padding(padding: p, child: child),
          ),
        ),
      );
    } else {
      container = Container(
        padding: p,
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: border, width: borderWidth),
        ),
        child: child,
      );
    }

    if (!accentCorners) return container;

    return _CornerAccented(
      accentColor: colorScheme.primary,
      cornerSize: cornerSize,
      cornerStroke: cornerStroke,
      child: container,
    );
  }
}

/// Vier L-Eckenmarken um ein beliebiges Widget.
class _CornerAccented extends StatelessWidget {
  final Widget child;
  final Color accentColor;
  final double cornerSize;
  final double cornerStroke;
  const _CornerAccented({
    required this.child,
    required this.accentColor,
    this.cornerSize = 8,
    this.cornerStroke = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    final offset = -(cornerStroke + 1);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: offset, left: offset,
          child: _CornerMark(
              size: cornerSize, stroke: cornerStroke,
              color: accentColor, top: true, left: true,),
        ),
        Positioned(
          top: offset, right: offset,
          child: _CornerMark(
              size: cornerSize, stroke: cornerStroke,
              color: accentColor, top: true, left: false,),
        ),
        Positioned(
          bottom: offset, left: offset,
          child: _CornerMark(
              size: cornerSize, stroke: cornerStroke,
              color: accentColor, top: false, left: true,),
        ),
        Positioned(
          bottom: offset, right: offset,
          child: _CornerMark(
              size: cornerSize, stroke: cornerStroke,
              color: accentColor, top: false, left: false,),
        ),
      ],
    );
  }
}

/// Einzelne L-Eckenmarke (ein Quadrant).
class _CornerMark extends StatelessWidget {
  final double size;
  final double stroke;
  final Color color;
  final bool top;
  final bool left;

  const _CornerMark({
    required this.size,
    required this.stroke,
    required this.color,
    required this.top,
    required this.left,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _CornerPainter(
            stroke: stroke,
            color: color,
            top: top,
            left: left,
          ),
        ),
      );
}

class _CornerPainter extends CustomPainter {
  final double stroke;
  final Color color;
  final bool top;
  final bool left;

  const _CornerPainter({
    required this.stroke,
    required this.color,
    required this.top,
    required this.left,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke;

    final hY = top ? stroke / 2 : size.height - stroke / 2;
    final vX = left ? stroke / 2 : size.width - stroke / 2;

    canvas.drawLine(Offset(0, hY), Offset(size.width, hY), paint);
    canvas.drawLine(Offset(vX, 0), Offset(vX, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant _CornerPainter old) =>
      old.color != color || old.stroke != stroke ||
      old.top != top || old.left != left;
}
