import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/neu_shape.dart';
import '../core/neu_theme.dart';
import 'neu_container.dart';

/// A neumorphic checkbox widget with recessed unselected state and animated pop-out checked state.
class NeuCheckbox extends StatelessWidget {
  /// Creates a [NeuCheckbox].
  const NeuCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = 26.0,
    this.borderRadius,
    this.activeColor,
    this.checkColor,
    this.tristate = false,
    this.enableHapticFeedback = true,
  });

  /// Whether the checkbox is checked (`true`), unchecked (`false`), or indeterminate (`null`).
  final bool? value;

  /// Callback when state toggles. If null, the checkbox is disabled.
  final ValueChanged<bool?>? onChanged;

  /// Width and height dimension.
  final double size;

  /// Corner radius. Defaults to `BorderRadius.circular(8.0)`.
  final BorderRadiusGeometry? borderRadius;

  /// Accent color for active state.
  final Color? activeColor;

  /// Color of the checkmark icon.
  final Color? checkColor;

  /// Whether checkbox supports indeterminate (null) state.
  final bool tristate;

  /// Whether to emit haptics on toggle.
  final bool enableHapticFeedback;

  bool get _isEnabled => onChanged != null;

  void _handleTap() {
    if (!_isEnabled) return;
    if (enableHapticFeedback) {
      HapticFeedback.selectionClick();
    }
    if (tristate) {
      if (value == null) {
        onChanged!(false);
      } else if (!value!) {
        onChanged!(true);
      } else {
        onChanged!(null);
      }
    } else {
      onChanged!(!(value ?? false));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeuTheme.of(context);
    final accent = activeColor ?? theme.accentColor;
    final iconColor = checkColor ?? Colors.white;
    final effectiveRadius = borderRadius ?? BorderRadius.circular(8.0);
    final isChecked = value == true;
    final isIndeterminate = value == null;

    Widget checkIcon = const SizedBox.shrink();
    if (isChecked) {
      checkIcon = Icon(
        Icons.check_rounded,
        size: size * 0.70,
        color: iconColor,
      );
    } else if (isIndeterminate) {
      checkIcon = Container(
        width: size * 0.45,
        height: 3.0,
        decoration: BoxDecoration(
          color: iconColor,
          borderRadius: BorderRadius.circular(2.0),
        ),
      );
    }

    final isElevated = isChecked || isIndeterminate;

    return Opacity(
      opacity: _isEnabled ? 1.0 : 0.5,
      child: GestureDetector(
        onTap: _handleTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: size,
          height: size,
          child: NeuContainer(
            shape: isElevated ? NeuShape.convex : NeuShape.pressed,
            borderRadius: effectiveRadius,
            baseColor: isElevated ? accent : theme.baseColor,
            depth: isElevated ? 3.5 : 2.5,
            distance: isElevated ? 2.5 : 2.0,
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 140),
                child: checkIcon,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
