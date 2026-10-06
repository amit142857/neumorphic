import 'package:flutter/material.dart';
import '../core/neu_shape.dart';
import '../core/neu_theme.dart';
import 'neu_container.dart';

/// An elevated neumorphic card widget with customizable bevels and corner curvature.
class NeuCard extends StatelessWidget {
  /// Creates a [NeuCard].
  const NeuCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
    this.width,
    this.height,
    this.borderRadius,
    this.baseColor,
    this.depth,
    this.distance,
    this.shape = NeuShape.flat,
    this.bevel = false,
    this.bevelColor,
    this.bevelWidth = 1.0,
  });

  /// The child content within the card.
  final Widget child;

  /// Internal padding.
  final EdgeInsetsGeometry padding;

  /// External margin around the card.
  final EdgeInsetsGeometry? margin;

  /// Optional fixed width.
  final double? width;

  /// Optional fixed height.
  final double? height;

  /// Corner radius.
  final BorderRadiusGeometry? borderRadius;

  /// Surface color override.
  final Color? baseColor;

  /// Perceived elevation depth.
  final double? depth;

  /// Distance offset of shadows.
  final double? distance;

  /// Card shape profile (flat, convex, concave).
  final NeuShape shape;

  /// Whether to render a subtle crisp perimeter bevel stroke.
  final bool bevel;

  /// Color of the perimeter bevel stroke.
  final Color? bevelColor;

  /// Width of the perimeter bevel stroke.
  final double bevelWidth;

  @override
  Widget build(BuildContext context) {
    final theme = NeuTheme.of(context);
    final isDark = theme.isDark;

    BoxBorder? border;
    if (bevel) {
      final defaultBevel = bevelColor ??
          (isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.white.withValues(alpha: 0.60));
      border = Border.all(
        color: defaultBevel,
        width: bevelWidth,
      );
    }

    return NeuContainer(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      shape: shape,
      borderRadius: borderRadius ?? theme.borderRadius,
      baseColor: baseColor,
      depth: depth ?? (theme.depth * 1.25),
      distance: distance,
      border: border,
      child: child,
    );
  }
}
