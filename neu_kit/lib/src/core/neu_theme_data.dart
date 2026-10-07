import 'dart:ui';
import 'package:flutter/material.dart';
import 'neu_colors.dart';

/// Configuration data defining the physical lighting model, depth, surface colors,
/// and border curvature of neumorphic widgets.
///
/// Can be registered directly in Flutter's [ThemeData.extensions] as a [ThemeExtension],
/// or provided hierarchically via the [NeuTheme] inherited widget.
@immutable
class NeuThemeData extends ThemeExtension<NeuThemeData> {
  /// Creates a neumorphic theme configuration.
  const NeuThemeData({
    this.baseColor = NeuColors.defaultLightSurface,
    this.accentColor = const Color(0xFF3B82F6),
    this.lightSource = const Offset(-1.0, -1.0),
    this.intensity = 0.65,
    this.depth = 4.0,
    this.distance = 4.0,
    this.curvature = 0.15,
    this.blurRadiusScale = 2.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(16.0)),
    this.customHighlightColor,
    this.customShadowColor,
  });

  /// Factory constructor for a pre-configured light neumorphic theme.
  factory NeuThemeData.light({
    Color baseColor = NeuColors.defaultLightSurface,
    Color accentColor = const Color(0xFF3B82F6),
    Offset lightSource = const Offset(-1.0, -1.0),
    double intensity = 0.65,
    double depth = 4.0,
    double distance = 4.0,
    double curvature = 0.15,
    double blurRadiusScale = 2.0,
    BorderRadiusGeometry borderRadius =
        const BorderRadius.all(Radius.circular(16.0)),
    Color? customHighlightColor,
    Color? customShadowColor,
  }) {
    return NeuThemeData(
      baseColor: baseColor,
      accentColor: accentColor,
      lightSource: lightSource,
      intensity: intensity,
      depth: depth,
      distance: distance,
      curvature: curvature,
      blurRadiusScale: blurRadiusScale,
      borderRadius: borderRadius,
      customHighlightColor: customHighlightColor,
      customShadowColor: customShadowColor,
    );
  }

  /// Factory constructor for a pre-configured dark neumorphic theme.
  factory NeuThemeData.dark({
    Color baseColor = NeuColors.defaultDarkSurface,
    Color accentColor = const Color(0xFF60A5FA),
    Offset lightSource = const Offset(-1.0, -1.0),
    double intensity = 0.70,
    double depth = 4.0,
    double distance = 4.0,
    double curvature = 0.18,
    double blurRadiusScale = 2.0,
    BorderRadiusGeometry borderRadius =
        const BorderRadius.all(Radius.circular(16.0)),
    Color? customHighlightColor,
    Color? customShadowColor,
  }) {
    return NeuThemeData(
      baseColor: baseColor,
      accentColor: accentColor,
      lightSource: lightSource,
      intensity: intensity,
      depth: depth,
      distance: distance,
      curvature: curvature,
      blurRadiusScale: blurRadiusScale,
      borderRadius: borderRadius,
      customHighlightColor: customHighlightColor,
      customShadowColor: customShadowColor,
    );
  }

  /// The primary surface background color of the neumorphic plane.
  final Color baseColor;

  /// The accent color used for activated states (active switches, progress bars, highlights).
  final Color accentColor;

  /// Normalized vector indicating the direction of the simulated light source.
  ///
  /// Defaults to `Offset(-1.0, -1.0)` which positions the light source at the top-left.
  final Offset lightSource;

  /// Contrast intensity scaling factor from `0.0` (subtle) to `1.0` (dramatic).
  final double intensity;

  /// Perceived elevation height factor.
  final double depth;

  /// Physical distance displacement (in logical pixels) for cast shadows.
  final double distance;

  /// Curvature gradient factor used for [NeuShape.convex] and [NeuShape.concave].
  final double curvature;

  /// Multiplier applied to [distance] to compute shadow blur radius.
  final double blurRadiusScale;

  /// Default border radius applied to neumorphic containers.
  final BorderRadiusGeometry borderRadius;

  /// Optional manual override for highlight color (if null, dynamically derived).
  final Color? customHighlightColor;

  /// Optional manual override for shadow color (if null, dynamically derived).
  final Color? customShadowColor;

  /// Resolves the effective highlight color based on [baseColor] and [intensity].
  Color get highlightColor =>
      customHighlightColor ??
      NeuColors.deriveHighlightColor(baseColor, intensity);

  /// Resolves the effective shadow color based on [baseColor] and [intensity].
  Color get shadowColor =>
      customShadowColor ?? NeuColors.deriveShadowColor(baseColor, intensity);

  /// Whether this theme represents a perceptually dark surface.
  bool get isDark => NeuColors.isDark(baseColor);

  /// Computes effective blur radius based on [distance] and [blurRadiusScale].
  double get blurRadius => distance * blurRadiusScale;

  @override
  NeuThemeData copyWith({
    Color? baseColor,
    Color? accentColor,
    Offset? lightSource,
    double? intensity,
    double? depth,
    double? distance,
    double? curvature,
    double? blurRadiusScale,
    BorderRadiusGeometry? borderRadius,
    Color? customHighlightColor,
    Color? customShadowColor,
  }) {
    return NeuThemeData(
      baseColor: baseColor ?? this.baseColor,
      accentColor: accentColor ?? this.accentColor,
      lightSource: lightSource ?? this.lightSource,
      intensity: intensity ?? this.intensity,
      depth: depth ?? this.depth,
      distance: distance ?? this.distance,
      curvature: curvature ?? this.curvature,
      blurRadiusScale: blurRadiusScale ?? this.blurRadiusScale,
      borderRadius: borderRadius ?? this.borderRadius,
      customHighlightColor: customHighlightColor ?? this.customHighlightColor,
      customShadowColor: customShadowColor ?? this.customShadowColor,
    );
  }

  @override
  NeuThemeData lerp(ThemeExtension<NeuThemeData>? other, double t) {
    if (other is! NeuThemeData) return this;
    return NeuThemeData(
      baseColor: Color.lerp(baseColor, other.baseColor, t) ?? baseColor,
      accentColor: Color.lerp(accentColor, other.accentColor, t) ?? accentColor,
      lightSource:
          Offset.lerp(lightSource, other.lightSource, t) ?? lightSource,
      intensity: lerpDouble(intensity, other.intensity, t) ?? intensity,
      depth: lerpDouble(depth, other.depth, t) ?? depth,
      distance: lerpDouble(distance, other.distance, t) ?? distance,
      curvature: lerpDouble(curvature, other.curvature, t) ?? curvature,
      blurRadiusScale: lerpDouble(blurRadiusScale, other.blurRadiusScale, t) ??
          blurRadiusScale,
      borderRadius:
          BorderRadiusGeometry.lerp(borderRadius, other.borderRadius, t) ??
              borderRadius,
      customHighlightColor:
          Color.lerp(customHighlightColor, other.customHighlightColor, t),
      customShadowColor:
          Color.lerp(customShadowColor, other.customShadowColor, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NeuThemeData &&
        other.baseColor == baseColor &&
        other.accentColor == accentColor &&
        other.lightSource == lightSource &&
        other.intensity == intensity &&
        other.depth == depth &&
        other.distance == distance &&
        other.curvature == curvature &&
        other.blurRadiusScale == blurRadiusScale &&
        other.borderRadius == borderRadius &&
        other.customHighlightColor == customHighlightColor &&
        other.customShadowColor == customShadowColor;
  }

  @override
  int get hashCode => Object.hash(
        baseColor,
        accentColor,
        lightSource,
        intensity,
        depth,
        distance,
        curvature,
        blurRadiusScale,
        borderRadius,
        customHighlightColor,
        customShadowColor,
      );

  @override
  String toString() {
    return 'NeuThemeData(baseColor: $baseColor, depth: $depth, distance: $distance, lightSource: $lightSource)';
  }
}
