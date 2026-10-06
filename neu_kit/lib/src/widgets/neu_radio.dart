import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/neu_shape.dart';
import '../core/neu_theme.dart';
import 'neu_container.dart';

/// A neumorphic radio button control with recessed track and pop-out dot indicator.
class NeuRadio<T> extends StatelessWidget {
  /// Creates a [NeuRadio].
  const NeuRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.size = 26.0,
    this.activeColor,
    this.dotColor,
    this.enableHapticFeedback = true,
  });

  /// The value represented by this radio button.
  final T value;

  /// The currently selected value for the radio group.
  final T? groupValue;

  /// Callback when this radio button is selected. If null, radio is disabled.
  final ValueChanged<T?>? onChanged;

  /// Outer diameter of the radio.
  final double size;

  /// Accent color for active state.
  final Color? activeColor;

  /// Center dot color override.
  final Color? dotColor;

  /// Whether to emit haptics on selection.
  final bool enableHapticFeedback;

  bool get _isSelected => value == groupValue;
  bool get _isEnabled => onChanged != null;

  void _handleTap() {
    if (!_isEnabled) return;
    if (enableHapticFeedback) {
      HapticFeedback.selectionClick();
    }
    onChanged!(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeuTheme.of(context);
    final accent = activeColor ?? theme.accentColor;
    final dot = dotColor ?? accent;

    return Opacity(
      opacity: _isEnabled ? 1.0 : 0.5,
      child: GestureDetector(
        onTap: _handleTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: size,
          height: size,
          child: NeuContainer(
            boxShape: BoxShape.circle,
            shape: NeuShape.pressed,
            baseColor: theme.baseColor,
            depth: 2.5,
            child: Center(
              child: AnimatedScale(
                scale: _isSelected ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutBack,
                child: NeuContainer(
                  width: size * 0.50,
                  height: size * 0.50,
                  boxShape: BoxShape.circle,
                  shape: NeuShape.convex,
                  baseColor: dot,
                  depth: 3.0,
                  distance: 1.5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
