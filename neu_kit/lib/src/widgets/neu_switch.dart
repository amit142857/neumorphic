import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/neu_shape.dart';
import '../core/neu_theme.dart';
import 'neu_container.dart';

/// A neumorphic toggle switch consisting of an inset track and an elevated sliding thumb.
class NeuSwitch extends StatelessWidget {
  /// Creates a [NeuSwitch].
  const NeuSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.width = 60.0,
    this.height = 32.0,
    this.thumbSize = 24.0,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.enableGlow = true,
    this.enableHapticFeedback = true,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeInOutCubic,
    this.activeThumbIcon,
    this.inactiveThumbIcon,
  });

  /// Whether the switch is checked/on.
  final bool value;

  /// Callback when state toggles. If null, the switch is disabled.
  final ValueChanged<bool>? onChanged;

  /// Width of the switch track.
  final double width;

  /// Height of the switch track.
  final double height;

  /// Diameter of the sliding thumb.
  final double thumbSize;

  /// Background/glow color when switch is on. Defaults to [NeuThemeData.accentColor].
  final Color? activeColor;

  /// Track color override when switch is off.
  final Color? inactiveColor;

  /// Color of the elevated thumb.
  final Color? thumbColor;

  /// Whether to render an accent glow around the track when active.
  final bool enableGlow;

  /// Whether to produce haptic vibration when toggled.
  final bool enableHapticFeedback;

  /// Animation duration for thumb travel.
  final Duration duration;

  /// Motion curve for thumb travel.
  final Curve curve;

  /// Optional icon placed inside the thumb when active.
  final Widget? activeThumbIcon;

  /// Optional icon placed inside the thumb when inactive.
  final Widget? inactiveThumbIcon;

  bool get _isEnabled => onChanged != null;

  void _handleTap() {
    if (!_isEnabled) return;
    if (enableHapticFeedback) {
      HapticFeedback.selectionClick();
    }
    onChanged!(!value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeuTheme.of(context);
    final accent = activeColor ?? theme.accentColor;
    final baseSurface = inactiveColor ?? theme.baseColor;

    final trackRadius = BorderRadius.circular(height / 2.0);
    final padding = (height - thumbSize) / 2.0;
    final maxTravel = width - thumbSize - (padding * 2.0);

    final trackColor = value && enableGlow
        ? Color.alphaBlend(accent.withValues(alpha: 0.15), baseSurface)
        : baseSurface;

    Widget switchWidget = Opacity(
      opacity: _isEnabled ? 1.0 : 0.5,
      child: NeuContainer(
        width: width,
        height: height,
        shape: NeuShape.pressed,
        borderRadius: trackRadius,
        baseColor: trackColor,
        depth: 3.0,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            // Sliding thumb
            AnimatedPositioned(
              duration: duration,
              curve: curve,
              left: padding + (value ? maxTravel : 0.0),
              top: padding,
              child: NeuContainer(
                width: thumbSize,
                height: thumbSize,
                boxShape: BoxShape.circle,
                shape: NeuShape.convex,
                baseColor: thumbColor ?? (value && enableGlow ? accent : null),
                depth: 3.5,
                distance: 2.5,
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 150),
                    child: value
                        ? (activeThumbIcon ?? const SizedBox.shrink())
                        : (inactiveThumbIcon ?? const SizedBox.shrink()),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: switchWidget,
    );
  }
}
