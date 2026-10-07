import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'neu_colors.dart';
import 'neu_shape.dart';
import 'neu_theme_data.dart';

/// High-performance painter for Neumorphic visual styling.
///
/// Implements both elevated drop shadows ([NeuShape.flat], [NeuShape.convex], [NeuShape.concave])
/// and GPU-accelerated inner inset shadows ([NeuShape.pressed]) using [Path.combine]
/// and [MaskFilter.blur], avoiding expensive [BackdropFilter] raster cache misses on Impeller.
class NeuPainter extends CustomPainter {
  /// Creates a [NeuPainter] with the specified geometry and lighting parameters.
  const NeuPainter({
    required this.shape,
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
    this.textDirection = TextDirection.ltr,
  });

  /// Factory constructor resolving defaults from [NeuThemeData].
  factory NeuPainter.fromTheme({
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
    TextDirection textDirection = TextDirection.ltr,
  }) {
    final effectiveBase = baseColor ?? theme.baseColor;
    final effectiveIntensity = intensity ?? theme.intensity;
    return NeuPainter(
      shape: shape,
      boxShape: boxShape,
      borderRadius: borderRadius ?? theme.borderRadius,
      baseColor: effectiveBase,
      highlightColor: highlightColor ??
          theme.customHighlightColor ??
          NeuColors.deriveHighlightColor(effectiveBase, effectiveIntensity),
      shadowColor: shadowColor ??
          theme.customShadowColor ??
          NeuColors.deriveShadowColor(effectiveBase, effectiveIntensity),
      lightSource: lightSource ?? theme.lightSource,
      depth: depth ?? theme.depth,
      distance: distance ?? theme.distance,
      intensity: effectiveIntensity,
      curvature: curvature ?? theme.curvature,
      blurRadiusScale: blurRadiusScale ?? theme.blurRadiusScale,
      border: border,
      customGradient: customGradient,
      textDirection: textDirection,
    );
  }

  /// The surface profile (flat, convex, concave, or pressed).
  final NeuShape shape;

  /// Whether the boundary is a rounded rectangle or circle.
  final BoxShape boxShape;

  /// Corner radius for rectangle shapes.
  final BorderRadiusGeometry? borderRadius;

  /// The primary surface color.
  final Color? baseColor;

  /// Tint for the highlight shadow / edge.
  final Color? highlightColor;

  /// Tint for the lowlight shadow / edge.
  final Color? shadowColor;

  /// Vector indicating the direction of light.
  final Offset lightSource;

  /// Perceived elevation height factor.
  final double depth;

  /// Displacement distance in logical pixels.
  final double distance;

  /// Contrast intensity scaling factor (0.0 to 1.0).
  final double intensity;

  /// Curvature gradient factor (0.0 to 1.0).
  final double curvature;

  /// Blur scale multiplier applied to distance.
  final double blurRadiusScale;

  /// Optional border stroke rendered along the perimeter.
  final BoxBorder? border;

  /// Optional gradient override for the surface body.
  final Gradient? customGradient;

  /// Text direction used to resolve directional border radii.
  final TextDirection textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final rect = Offset.zero & size;
    final shapePath = _buildPath(rect);

    final effectiveBase = baseColor ?? NeuColors.defaultLightSurface;
    final effectiveHighlight = highlightColor ??
        NeuColors.deriveHighlightColor(effectiveBase, intensity);
    final effectiveShadow =
        shadowColor ?? NeuColors.deriveShadowColor(effectiveBase, intensity);

    final effectiveDepth = depth.clamp(0.0, 50.0);
    final depthFactor = (effectiveDepth / 4.0);
    final effectiveDistance = distance * depthFactor;
    final blurRadius = (effectiveDistance * blurRadiusScale).clamp(0.1, 80.0);

    // Compute normalized lighting vector
    final length = math.sqrt(
      lightSource.dx * lightSource.dx + lightSource.dy * lightSource.dy,
    );
    final nx = length == 0.0 ? -0.7071 : (lightSource.dx / length);
    final ny = length == 0.0 ? -0.7071 : (lightSource.dy / length);

    final lightOffset = Offset(nx * effectiveDistance, ny * effectiveDistance);
    final darkOffset = Offset(-nx * effectiveDistance, -ny * effectiveDistance);

    if (shape == NeuShape.pressed) {
      _paintPressed(
        canvas: canvas,
        rect: rect,
        shapePath: shapePath,
        baseColor: effectiveBase,
        highlightColor: effectiveHighlight,
        shadowColor: effectiveShadow,
        lightOffset: lightOffset,
        darkOffset: darkOffset,
        blurRadius: blurRadius,
        effectiveDepth: effectiveDepth,
        effectiveDistance: effectiveDistance,
      );
    } else {
      _paintElevated(
        canvas: canvas,
        rect: rect,
        shapePath: shapePath,
        baseColor: effectiveBase,
        highlightColor: effectiveHighlight,
        shadowColor: effectiveShadow,
        lightOffset: lightOffset,
        darkOffset: darkOffset,
        blurRadius: blurRadius,
        effectiveDepth: effectiveDepth,
      );
    }

    // Paint optional perimeter border
    if (border != null) {
      _paintBorder(canvas, rect);
    }
  }

  void _paintElevated({
    required Canvas canvas,
    required Rect rect,
    required Path shapePath,
    required Color baseColor,
    required Color highlightColor,
    required Color shadowColor,
    required Offset lightOffset,
    required Offset darkOffset,
    required double blurRadius,
    required double effectiveDepth,
  }) {
    if (effectiveDepth > 0.0) {
      // 1. Draw outer dark shadow (cast away from light)
      final darkPaint = Paint()
        ..color = shadowColor
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius);
      canvas.save();
      canvas.translate(darkOffset.dx, darkOffset.dy);
      canvas.drawPath(shapePath, darkPaint);
      canvas.restore();

      // 2. Draw outer light highlight (cast towards light)
      final lightPaint = Paint()
        ..color = highlightColor
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius);
      canvas.save();
      canvas.translate(lightOffset.dx, lightOffset.dy);
      canvas.drawPath(shapePath, lightPaint);
      canvas.restore();
    }

    // 3. Draw surface body
    final surfacePaint = Paint()..style = PaintingStyle.fill;

    if (customGradient != null) {
      surfacePaint.shader = customGradient!.createShader(rect);
    } else if (shape == NeuShape.convex || shape == NeuShape.concave) {
      final gradientColors =
          NeuColors.deriveGradientColors(baseColor, shape, curvature);
      final gradientStops = NeuColors.deriveGradientStops(shape);
      final (beginAlign, endAlign) = NeuColors.deriveAlignment(lightSource);

      surfacePaint.shader = LinearGradient(
        begin: beginAlign,
        end: endAlign,
        colors: gradientColors,
        stops: gradientStops,
      ).createShader(rect);
    } else {
      surfacePaint.color = baseColor;
    }

    canvas.drawPath(shapePath, surfacePaint);
  }

  void _paintPressed({
    required Canvas canvas,
    required Rect rect,
    required Path shapePath,
    required Color baseColor,
    required Color highlightColor,
    required Color shadowColor,
    required Offset lightOffset,
    required Offset darkOffset,
    required double blurRadius,
    required double effectiveDepth,
    required double effectiveDistance,
  }) {
    // 1. Fill recessed background surface
    final basePaint = Paint()
      ..color = baseColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(shapePath, basePaint);

    if (effectiveDepth <= 0.0) return;

    // 2. Hardware-accelerated Inset Shadows via Path Difference clipping.
    // Clip canvas strictly to the inner shape so outer blur doesn't bleed.
    canvas.save();
    canvas.clipPath(shapePath);

    // Create an expanded outer rectangle to create the inverse mask
    final margin = blurRadius * 2.5 + effectiveDistance.abs() * 2.0 + 32.0;
    final outerRect = rect.inflate(margin);
    final outerPath = Path()..addRect(outerRect);
    final inversePath =
        Path.combine(PathOperation.difference, outerPath, shapePath);

    // In a recess, the wall facing the light casts a dark shadow inside.
    // Invert lightOffset so shadow falls along the light vector inside the recess.
    final darkShadowPaint = Paint()
      ..color = shadowColor
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius);
    canvas.save();
    canvas.translate(lightOffset.dx, lightOffset.dy);
    canvas.drawPath(inversePath, darkShadowPaint);
    canvas.restore();

    // The opposing wall catches light and casts a highlight inside.
    final lightShadowPaint = Paint()
      ..color = highlightColor
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius);
    canvas.save();
    canvas.translate(darkOffset.dx, darkOffset.dy);
    canvas.drawPath(inversePath, lightShadowPaint);
    canvas.restore();

    canvas.restore();
  }

  void _paintBorder(Canvas canvas, Rect rect) {
    if (boxShape == BoxShape.circle) {
      border?.paint(
        canvas,
        rect,
        shape: BoxShape.circle,
      );
    } else {
      final rrect = _resolveBorderRadius().resolve(textDirection).toRRect(rect);
      border?.paint(
        canvas,
        rect,
        borderRadius:
            rrect.isRect ? null : _resolveBorderRadius().resolve(textDirection),
      );
    }
  }

  BorderRadiusGeometry _resolveBorderRadius() {
    return borderRadius ?? BorderRadius.zero;
  }

  Path _buildPath(Rect rect) {
    final path = Path();
    if (boxShape == BoxShape.circle) {
      path.addOval(rect);
    } else {
      final rrect = _resolveBorderRadius().resolve(textDirection).toRRect(rect);
      path.addRRect(rrect);
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant NeuPainter oldDelegate) {
    return oldDelegate.shape != shape ||
        oldDelegate.boxShape != boxShape ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.baseColor != baseColor ||
        oldDelegate.highlightColor != highlightColor ||
        oldDelegate.shadowColor != shadowColor ||
        oldDelegate.lightSource != lightSource ||
        oldDelegate.depth != depth ||
        oldDelegate.distance != distance ||
        oldDelegate.intensity != intensity ||
        oldDelegate.curvature != curvature ||
        oldDelegate.blurRadiusScale != blurRadiusScale ||
        oldDelegate.border != border ||
        oldDelegate.customGradient != customGradient ||
        oldDelegate.textDirection != textDirection;
  }
}
