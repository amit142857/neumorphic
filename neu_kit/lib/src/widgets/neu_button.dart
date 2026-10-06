import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/neu_painter.dart';
import '../core/neu_shape.dart';
import '../core/neu_theme.dart';

/// An interactive neumorphic button with tactile spring animation and optional haptic feedback.
///
/// Smoothly transitions between elevated ([NeuShape.flat] / [NeuShape.convex])
/// and recessed ([NeuShape.pressed]) states on user interaction.
class NeuButton extends StatefulWidget {
  /// Creates a [NeuButton].
  const NeuButton({
    super.key,
    required this.child,
    this.onPressed,
    this.onLongPress,
    this.shape = NeuShape.flat,
    this.pressedShape = NeuShape.pressed,
    this.width,
    this.height,
    this.padding = const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
    this.margin,
    this.borderRadius,
    this.baseColor,
    this.depth,
    this.distance,
    this.border,
    this.enableHapticFeedback = true,
    this.animationDuration = const Duration(milliseconds: 120),
    this.curve = Curves.easeOutCubic,
  });

  /// The widget displayed inside the button.
  final Widget child;

  /// Callback executed on tap. If null, the button is rendered in a disabled state.
  final VoidCallback? onPressed;

  /// Callback executed on long press.
  final VoidCallback? onLongPress;

  /// Surface shape when the button is idle.
  final NeuShape shape;

  /// Surface shape when the button is being pressed.
  final NeuShape pressedShape;

  /// Optional fixed width.
  final double? width;

  /// Optional fixed height.
  final double? height;

  /// Internal padding.
  final EdgeInsetsGeometry padding;

  /// External margin.
  final EdgeInsetsGeometry? margin;

  /// Corner radius. Defaults to [NeuThemeData.borderRadius].
  final BorderRadiusGeometry? borderRadius;

  /// Surface base color.
  final Color? baseColor;

  /// Perceived elevation depth when idle.
  final double? depth;

  /// Shadow distance displacement.
  final double? distance;

  /// Perimeter border stroke.
  final BoxBorder? border;

  /// Whether to trigger subtle haptic vibrations on tap.
  final bool enableHapticFeedback;

  /// Animation duration for the press transition.
  final Duration animationDuration;

  /// Curve of the press animation.
  final Curve curve;

  /// Whether the button is currently interactive.
  bool get isEnabled => onPressed != null || onLongPress != null;

  @override
  State<NeuButton> createState() => _NeuButtonState();
}

class _NeuButtonState extends State<NeuButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isEnabled) return;
    setState(() => _isPressed = true);
    if (widget.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.isEnabled) return;
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    if (!widget.isEnabled) return;
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeuTheme.of(context);
    final textDirection = Directionality.maybeOf(context) ?? TextDirection.ltr;
    final effectiveBorderRadius = widget.borderRadius ?? theme.borderRadius;

    final effectiveShape = !widget.isEnabled
        ? NeuShape.flat
        : (_isPressed ? widget.pressedShape : widget.shape);

    final effectiveDepth = !widget.isEnabled ? 1.0 : (widget.depth ?? theme.depth);

    Widget content = widget.child;
    if (!widget.isEnabled) {
      content = Opacity(opacity: 0.55, child: content);
    }

    final decorated = AnimatedContainer(
      duration: widget.animationDuration,
      curve: widget.curve,
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      child: CustomPaint(
        painter: NeuPainter.fromTheme(
          theme: theme,
          shape: effectiveShape,
          borderRadius: effectiveBorderRadius,
          baseColor: widget.baseColor,
          depth: effectiveDepth,
          distance: widget.distance,
          border: widget.border,
          textDirection: textDirection,
        ),
        child: Padding(
          padding: widget.padding,
          child: Center(
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: content,
          ),
        ),
      ),
    );

    if (!widget.isEnabled) {
      return decorated;
    }

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onPressed,
      onLongPress: widget.onLongPress,
      behavior: HitTestBehavior.opaque,
      child: decorated,
    );
  }
}

/// A circular or rounded neumorphic icon button.
class NeuIconButton extends StatefulWidget {
  /// Creates a [NeuIconButton].
  const NeuIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 48.0,
    this.boxShape = BoxShape.circle,
    this.borderRadius,
    this.baseColor,
    this.shape = NeuShape.flat,
    this.pressedShape = NeuShape.pressed,
    this.enableHapticFeedback = true,
    this.tooltip,
    this.animationDuration = const Duration(milliseconds: 120),
  });

  /// The icon widget to display.
  final Widget icon;

  /// Tap callback. If null, icon button is disabled.
  final VoidCallback? onPressed;

  /// Width and height diameter.
  final double size;

  /// Shape of the icon button boundary.
  final BoxShape boxShape;

  /// Corner radius when [boxShape] is [BoxShape.rectangle].
  final BorderRadiusGeometry? borderRadius;

  /// Base surface color override.
  final Color? baseColor;

  /// Idle surface shape.
  final NeuShape shape;

  /// Pressed surface shape.
  final NeuShape pressedShape;

  /// Whether to produce haptic vibration on tap.
  final bool enableHapticFeedback;

  /// Optional accessibility tooltip.
  final String? tooltip;

  /// Animation duration for press state.
  final Duration animationDuration;

  /// Whether button is enabled.
  bool get isEnabled => onPressed != null;

  @override
  State<NeuIconButton> createState() => _NeuIconButtonState();
}

class _NeuIconButtonState extends State<NeuIconButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isEnabled) return;
    setState(() => _isPressed = true);
    if (widget.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.isEnabled) return;
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    if (!widget.isEnabled) return;
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeuTheme.of(context);
    final textDirection = Directionality.maybeOf(context) ?? TextDirection.ltr;
    final effectiveBorderRadius = widget.borderRadius ?? theme.borderRadius;

    final effectiveShape = !widget.isEnabled
        ? NeuShape.flat
        : (_isPressed ? widget.pressedShape : widget.shape);

    Widget content = Center(child: widget.icon);
    if (!widget.isEnabled) {
      content = Opacity(opacity: 0.5, child: content);
    }

    Widget result = AnimatedContainer(
      duration: widget.animationDuration,
      width: widget.size,
      height: widget.size,
      child: CustomPaint(
        painter: NeuPainter.fromTheme(
          theme: theme,
          shape: effectiveShape,
          boxShape: widget.boxShape,
          borderRadius: effectiveBorderRadius,
          baseColor: widget.baseColor,
          depth: !widget.isEnabled ? 1.0 : null,
          textDirection: textDirection,
        ),
        child: content,
      ),
    );

    if (widget.tooltip != null) {
      result = Tooltip(message: widget.tooltip!, child: result);
    }

    if (!widget.isEnabled) {
      return result;
    }

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onPressed,
      behavior: HitTestBehavior.opaque,
      child: result,
    );
  }
}
