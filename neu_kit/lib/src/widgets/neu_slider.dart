import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/neu_shape.dart';
import '../core/neu_theme.dart';
import 'neu_container.dart';

/// A neumorphic slider with an inset recessed track and an elevated sliding thumb.
class NeuSlider extends StatefulWidget {
  /// Creates a [NeuSlider].
  const NeuSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.trackHeight = 12.0,
    this.thumbSize = 28.0,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.enableHapticFeedback = true,
  }) : assert(min <= max);

  /// Current value of the slider.
  final double value;

  /// Callback when user changes the value. If null, slider is disabled.
  final ValueChanged<double>? onChanged;

  /// Minimum value.
  final double min;

  /// Maximum value.
  final double max;

  /// Number of discrete intervals.
  final int? divisions;

  /// Height of the inset track.
  final double trackHeight;

  /// Diameter of the elevated thumb.
  final double thumbSize;

  /// Color of the active portion of the track.
  final Color? activeColor;

  /// Color of the inactive portion of the track.
  final Color? inactiveColor;

  /// Color override for the thumb.
  final Color? thumbColor;

  /// Whether to emit haptic feedback during drag / step changes.
  final bool enableHapticFeedback;

  @override
  State<NeuSlider> createState() => _NeuSliderState();
}

class _NeuSliderState extends State<NeuSlider> {
  bool _isDragging = false;
  double? _lastHapticValue;

  bool get _isEnabled => widget.onChanged != null;

  double _getFraction(double value) {
    if (widget.max == widget.min) return 0.0;
    return ((value - widget.min) / (widget.max - widget.min)).clamp(0.0, 1.0);
  }

  void _updateValue(double localX, double totalWidth) {
    if (!_isEnabled) return;
    final halfThumb = widget.thumbSize / 2.0;
    final usableWidth = totalWidth - widget.thumbSize;
    if (usableWidth <= 0) return;

    final progress = ((localX - halfThumb) / usableWidth).clamp(0.0, 1.0);
    var newValue = widget.min + progress * (widget.max - widget.min);

    if (widget.divisions != null && widget.divisions! > 0) {
      final step = (widget.max - widget.min) / widget.divisions!;
      newValue = ((newValue - widget.min) / step).round() * step + widget.min;
      newValue = newValue.clamp(widget.min, widget.max);
    }

    if (widget.enableHapticFeedback && _lastHapticValue != newValue) {
      if (widget.divisions != null) {
        HapticFeedback.selectionClick();
      }
      _lastHapticValue = newValue;
    }

    widget.onChanged!(newValue);
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeuTheme.of(context);
    final accent = widget.activeColor ?? theme.accentColor;
    final trackRadius = BorderRadius.circular(widget.trackHeight / 2.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final fraction = _getFraction(widget.value);
        final usableWidth =
            (totalWidth - widget.thumbSize).clamp(0.0, double.infinity);
        final thumbLeft = fraction * usableWidth;

        return Opacity(
          opacity: _isEnabled ? 1.0 : 0.5,
          child: GestureDetector(
            onHorizontalDragStart: (details) {
              if (!_isEnabled) return;
              setState(() => _isDragging = true);
              _updateValue(details.localPosition.dx, totalWidth);
            },
            onHorizontalDragUpdate: (details) {
              if (!_isEnabled) return;
              _updateValue(details.localPosition.dx, totalWidth);
            },
            onHorizontalDragEnd: (details) {
              if (!_isEnabled) return;
              setState(() => _isDragging = false);
            },
            onTapDown: (details) {
              if (!_isEnabled) return;
              _updateValue(details.localPosition.dx, totalWidth);
            },
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: totalWidth,
              height: widget.thumbSize + 12.0,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  // Recessed track
                  Positioned(
                    left: 0,
                    right: 0,
                    child: NeuContainer(
                      height: widget.trackHeight,
                      shape: NeuShape.pressed,
                      borderRadius: trackRadius,
                      baseColor: widget.inactiveColor ?? theme.baseColor,
                      depth: 3.0,
                      child: fraction > 0.0
                          ? FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: fraction,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: trackRadius,
                                  gradient: LinearGradient(
                                    colors: [
                                      accent.withValues(alpha: 0.65),
                                      accent,
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : null,
                    ),
                  ),

                  // Elevated sliding thumb
                  Positioned(
                    left: thumbLeft,
                    child: NeuContainer(
                      width: widget.thumbSize,
                      height: widget.thumbSize,
                      boxShape: BoxShape.circle,
                      shape: _isDragging ? NeuShape.convex : NeuShape.flat,
                      depth: _isDragging ? 5.0 : 3.5,
                      distance: _isDragging ? 3.0 : 2.5,
                      baseColor: widget.thumbColor ?? theme.baseColor,
                      child: Center(
                        child: Container(
                          width: 8.0,
                          height: 8.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: accent,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
