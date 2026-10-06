import 'package:flutter/material.dart';
import 'neu_painter.dart';
import 'neu_shape.dart';
import 'neu_theme_data.dart';

/// A neumorphic [Decoration] that can be applied to standard Flutter widgets like [Container]
/// and [DecoratedBox].
///
/// Supports [NeuShape.flat], [NeuShape.convex], [NeuShape.concave], and [NeuShape.pressed]
/// surfaces, with dynamic lighting, custom corner radii, borders, and circular shapes.
@immutable
class NeuBoxDecoration extends Decoration {
  /// Creates a [NeuBoxDecoration].
  const NeuBoxDecoration({
    this.shape = NeuShape.flat,
    this.boxShape = BoxShape.rectangle,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
    this.shadowColor,
    this.lightSource = const Offset(-1.0, -1.0),
    this.depth = 4.0,
    this.distance = 4.0,
    this.intensity = 0.65,
    this.curvature = 0.15,
    this.blurRadiusScale = 2.0,
    this.border,
    this.customGradient,
  });

  /// Factory constructor that resolves default parameters from [theme].
  factory NeuBoxDecoration.fromTheme({
    required NeuThemeData theme,
    NeuShape shape = NeuShape.flat,
    BoxShape boxShape = BoxShape.rectangle,
    BorderRadiusGeometry? borderRadius,
    Color? baseColor,
    Color? highlightColor,
    Color? shadowColor,
    Offset? lightSource,
    double? depth,
    double? distance,
    double? intensity,
    double? curvature,
    double? blurRadiusScale,
    BoxBorder? border,
    Gradient? customGradient,
  }) {
    final effectiveBase = baseColor ?? theme.baseColor;
    return NeuBoxDecoration(
      shape: shape,
      boxShape: boxShape,
      borderRadius: borderRadius ?? theme.borderRadius,
      baseColor: effectiveBase,
      highlightColor: highlightColor ?? theme.highlightColor,
      shadowColor: shadowColor ?? theme.shadowColor,
      lightSource: lightSource ?? theme.lightSource,
      depth: depth ?? theme.depth,
      distance: distance ?? theme.distance,
      intensity: intensity ?? theme.intensity,
      curvature: curvature ?? theme.curvature,
      blurRadiusScale: blurRadiusScale ?? theme.blurRadiusScale,
      border: border,
      customGradient: customGradient,
    );
  }

  /// The neumorphic surface curvature type.
  final NeuShape shape;

  /// The shape of the container boundary (rectangle or circle).
  final BoxShape boxShape;

  /// The corner radius when [boxShape] is [BoxShape.rectangle].
  final BorderRadiusGeometry? borderRadius;

  /// The surface base color.
  final Color? baseColor;

  /// The light highlight color.
  final Color? highlightColor;

  /// The dark shadow color.
  final Color? shadowColor;

  /// Normalized vector indicating the direction of light.
  final Offset lightSource;

  /// Perceived elevation factor.
  final double depth;

  /// Shadow displacement distance in logical pixels.
  final double distance;

  /// Contrast intensity factor (0.0 to 1.0).
  final double intensity;

  /// Gradient curvature factor (0.0 to 1.0).
  final double curvature;

  /// Blur scale multiplier applied to distance.
  final double blurRadiusScale;

  /// Optional border rendered along the boundary.
  final BoxBorder? border;

  /// Optional gradient override for the surface.
  final Gradient? customGradient;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _NeuBoxDecorationPainter(this, onChanged);
  }

  /// Creates a copy of this decoration with the given fields replaced.
  NeuBoxDecoration copyWith({
    NeuShape? shape,
    BoxShape? boxShape,
    BorderRadiusGeometry? borderRadius,
    Color? baseColor,
    Color? highlightColor,
    Color? shadowColor,
    Offset? lightSource,
    double? depth,
    double? distance,
    double? intensity,
    double? curvature,
    double? blurRadiusScale,
    BoxBorder? border,
    Gradient? customGradient,
  }) {
    return NeuBoxDecoration(
      shape: shape ?? this.shape,
      boxShape: boxShape ?? this.boxShape,
      borderRadius: borderRadius ?? this.borderRadius,
      baseColor: baseColor ?? this.baseColor,
      highlightColor: highlightColor ?? this.highlightColor,
      shadowColor: shadowColor ?? this.shadowColor,
      lightSource: lightSource ?? this.lightSource,
      depth: depth ?? this.depth,
      distance: distance ?? this.distance,
      intensity: intensity ?? this.intensity,
      curvature: curvature ?? this.curvature,
      blurRadiusScale: blurRadiusScale ?? this.blurRadiusScale,
      border: border ?? this.border,
      customGradient: customGradient ?? this.customGradient,
    );
  }

  @override
  Path getClipPath(Rect rect, TextDirection textDirection) {
    if (boxShape == BoxShape.circle) {
      return Path()..addOval(rect);
    }
    if (borderRadius != null) {
      return Path()..addRRect(borderRadius!.resolve(textDirection).toRRect(rect));
    }
    return Path()..addRect(rect);
  }

  @override
  bool hitTest(Size size, Offset position, {TextDirection? textDirection}) {
    if (boxShape == BoxShape.circle) {
      final center = size.center(Offset.zero);
      final radius = size.shortestSide / 2.0;
      return (position - center).distanceSquared <= radius * radius;
    }
    return super.hitTest(size, position, textDirection: textDirection);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NeuBoxDecoration &&
        other.shape == shape &&
        other.boxShape == boxShape &&
        other.borderRadius == borderRadius &&
        other.baseColor == baseColor &&
        other.highlightColor == highlightColor &&
        other.shadowColor == shadowColor &&
        other.lightSource == lightSource &&
        other.depth == depth &&
        other.distance == distance &&
        other.intensity == intensity &&
        other.curvature == curvature &&
        other.blurRadiusScale == blurRadiusScale &&
        other.border == border &&
        other.customGradient == customGradient;
  }

  @override
  int get hashCode => Object.hash(
        shape,
        boxShape,
        borderRadius,
        baseColor,
        highlightColor,
        shadowColor,
        lightSource,
        depth,
        distance,
        intensity,
        curvature,
        blurRadiusScale,
        border,
        customGradient,
      );
}

class _NeuBoxDecorationPainter extends BoxPainter {
  _NeuBoxDecorationPainter(this._decoration, super.onChanged);

  final NeuBoxDecoration _decoration;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    final size = configuration.size!;
    if (size.isEmpty) return;

    final rect = offset & size;
    final textDir = configuration.textDirection ?? TextDirection.ltr;

    final painter = NeuPainter(
      shape: _decoration.shape,
      boxShape: _decoration.boxShape,
      borderRadius: _decoration.borderRadius,
      baseColor: _decoration.baseColor,
      highlightColor: _decoration.highlightColor,
      shadowColor: _decoration.shadowColor,
      lightSource: _decoration.lightSource,
      depth: _decoration.depth,
      distance: _decoration.distance,
      intensity: _decoration.intensity,
      curvature: _decoration.curvature,
      blurRadiusScale: _decoration.blurRadiusScale,
      border: _decoration.border,
      customGradient: _decoration.customGradient,
      textDirection: textDir,
    );

    canvas.save();
    canvas.translate(rect.left, rect.top);
    painter.paint(canvas, rect.size);
    canvas.restore();
  }
}
