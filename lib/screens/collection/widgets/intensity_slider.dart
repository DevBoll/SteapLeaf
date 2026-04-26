import 'package:flutter/material.dart';
import '../../../theme/steapleaf_theme.dart';

/// Beschrifteter Slider für ganzzahlige Intensitätswerte 0–5.
class IntensitySlider extends StatelessWidget {
  final String label;
  final int value;
  final int max;
  final ValueChanged<int> onChanged;
  final String? startLabel;
  final String? endLabel;
  final double labelWidth;

  const IntensitySlider({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.max = 5,
    this.startLabel,
    this.endLabel,
    this.labelWidth = 88,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final ext = Theme.of(context).extension<SteapLeafThemeExtension>();
    final activeColor = ext?.sliderActive ?? colorScheme.primary;
    final inactiveColor = ext?.sliderInactive ?? colorScheme.outlineVariant;

    final sliderTheme = SliderThemeData(
      activeTrackColor: activeColor,
      inactiveTrackColor: inactiveColor,
      thumbColor: ext?.sliderThumb ?? colorScheme.primary,
      overlayColor: activeColor.withValues(alpha: 0.13),
      trackHeight: 1.5,
      thumbShape: const _SquareThumbShape(),
      tickMarkShape: const _SquareTickMarkShape(),
      activeTickMarkColor: colorScheme.onPrimary,
      inactiveTickMarkColor: inactiveColor,
    );

    final hasPolarLabels = startLabel != null || endLabel != null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: labelWidth,
                child: Text(
                  label,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Expanded(
                child: SliderTheme(
                  data: sliderTheme,
                  child: Slider(
                    value: value.toDouble(),
                    min: 0,
                    max: max.toDouble(),
                    divisions: max,
                    onChanged: (v) => onChanged(v.round()),
                  ),
                ),
              ),
              SizedBox(
                width: 18,
                child: Text(
                  value > 0 ? value.toString() : '–',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          if (hasPolarLabels)
            Padding(
              padding: EdgeInsets.only(left: labelWidth + 12, right: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    startLabel ?? '',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                    ),
                  ),
                  Text(
                    endLabel ?? '',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _SquareThumbShape extends SliderComponentShape {
  const _SquareThumbShape();

  static const double size = 6;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      Size(size * 2, size * 2);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    context.canvas.drawRect(
      Rect.fromCenter(center: center, width: size * 2, height: size * 2),
      Paint()..color = sliderTheme.thumbColor ?? Colors.grey,
    );
  }
}

class _SquareTickMarkShape extends SliderTickMarkShape {
  const _SquareTickMarkShape();

  static const double size = 3;

  @override
  Size getPreferredSize({
    required SliderThemeData sliderTheme,
    required bool isEnabled,
  }) =>
      const Size(size, size);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    required bool isEnabled,
  }) {
    final isActive = textDirection == TextDirection.ltr
        ? center.dx <= thumbCenter.dx
        : center.dx >= thumbCenter.dx;

    final color = isActive
        ? (sliderTheme.activeTickMarkColor ?? Colors.white)
        : (sliderTheme.inactiveTickMarkColor ?? Colors.grey);

    context.canvas.drawRect(
      Rect.fromCenter(center: center, width: size, height: size),
      Paint()..color = color,
    );
  }
}
