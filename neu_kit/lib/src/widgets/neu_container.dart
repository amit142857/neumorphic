import 'package:flutter/material.dart';
import '../core/neu_painter.dart';
import '../core/neu_shape.dart';
import '../core/neu_theme.dart';

/// The foundational neumorphic container widget.
///
/// Blends seamlessly with the surface plane according to [NeuTheme],
/// casting soft shadows or inner recesses based on [shape].
class NeuContainer extends StatelessWidget {
  /// Creates a [NeuContainer].
  const NeuContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.alignment,
    this.shape = NeuShape.flat,
    this.boxShape = BoxShape.rectangle,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
    this.shadowColor,
    this.depth,
    this.distance,
    this.intensity,
    this.curvature,
    this.blurRadiusScale,
    this.lightSource,
    this.border,
    this.customGradient,
    this.clipBehavior = Clip.none,
  });

  /// The widget below this container in the tree.
  final Widget? child;

  /// Optional fixed width for the container.
  final double? width;

  /// Optional fixed height for the container.
  final double? height;

  /// Empty space to inscribe inside the decoration.
  final EdgeInsetsGeometry? padding;

  /// Empty space to surround the container.
  final EdgeInsetsGeometry? margin;

  /// Align the [child] within the container.
  final AlignmentGeometry? alignment;

  /// The neumorphic surface curvature type (flat, convex, concave, pressed).
  final NeuShape shape;

  /// The boundary shape (rectangle or circle).
  final BoxShape boxShape;

  /// Corner radius when [boxShape] is [BoxShape.rectangle].
  final BorderRadiusGeometry? borderRadius;

  /// Surface base color (defaults to [NeuThemeData.baseColor]).
  final Color? baseColor;

  /// Highlight color override.
  final Color? highlightColor;

  /// Shadow color override.
  final Color? shadowColor;

  /// Perceived elevation depth.
  final double? depth;

  /// Shadow displacement distance.
  final double? distance;

  /// Contrast intensity factor (0.0 to 1.0).
  final double? intensity;

  /// Curvature gradient factor (0.0 to 1.0).
  final double? curvature;

  /// Blur scale multiplier applied to distance.
  final double? blurRadiusScale;

  /// Direction of simulated light source.
  final Offset? lightSource;

  /// Optional boundary border stroke.
  final BoxBorder? border;

  /// Optional custom surface gradient override.
  final Gradient? customGradient;

  /// Clip behavior for the container's child.
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final theme = NeuTheme.of(context);
    final textDirection = Directionality.maybeOf(context) ?? TextDirection.ltr;
    final effectiveBorderRadius = borderRadius ?? theme.borderRadius;

    Widget current = child ?? const SizedBox.shrink();

    if (alignment != null) {
      current = Align(alignment: alignment!, child: current);
    }

    if (padding != null) {
      current = Padding(padding: padding!, child: current);
    }

    if (clipBehavior != Clip.none) {
      if (boxShape == BoxShape.circle) {
        current = ClipOval(clipBehavior: clipBehavior, child: current);
      } else {
        current = ClipRRect(
          borderRadius: effectiveBorderRadius.resolve(textDirection),
          clipBehavior: clipBehavior,
          child: current,
        );
      }
    }

    current = CustomPaint(
      painter: NeuPainter.fromTheme(
        theme: theme,
        shape: shape,
        boxShape: boxShape,
        borderRadius: effectiveBorderRadius,
        baseColor: baseColor,
        highlightColor: highlightColor,
        shadowColor: shadowColor,
        lightSource: lightSource,
        depth: depth,
        distance: distance,
        intensity: intensity,
        curvature: curvature,
        blurRadiusScale: blurRadiusScale,
        border: border,
        customGradient: customGradient,
        textDirection: textDirection,
      ),
      child: current,
    );

    if (width != null || height != null) {
      current = SizedBox(
        width: width,
        height: height,
        child: current,
      );
    }

    if (margin != null) {
      current = Padding(padding: margin!, child: current);
    }

    return current;
  }
}
