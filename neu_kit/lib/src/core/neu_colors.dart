import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'neu_shape.dart';

/// Algorithmic color derivation for neumorphic surfaces.
///
/// Neumorphism requires exact contrast ratios between highlights, surface bodies,
/// and shadows to create tactile physical depth without harsh edges.
/// [NeuColors] derives physically accurate highlight and lowlight tones for both
/// light and dark surfaces using perceptual luminance and HSL transforms.
abstract final class NeuColors {
  /// Default surface color for light neumorphic themes (soft off-white/cool grey).
  static const Color defaultLightSurface = Color(0xFFE0E5EC);

  /// Default surface color for dark neumorphic themes (soft charcoal slate).
  static const Color defaultDarkSurface = Color(0xFF24272C);

  /// Returns whether [color] is perceptually dark based on relative luminance.
  static bool isDark(Color color) {
    return color.computeLuminance() < 0.45;
  }

  /// Calculates the dynamic highlight color cast towards the light source.
  ///
  /// [baseColor] is the underlying surface color.
  /// [intensity] is a scaling factor between 0.0 and 1.0 (default 0.65).
  static Color deriveHighlightColor(Color baseColor,
      [double intensity = 0.65]) {
    final clampedIntensity = intensity.clamp(0.0, 1.0);
    final dark = isDark(baseColor);

    if (dark) {
      // In dark mode, pure white highlights appear harsh and destroy the surface illusion.
      // Instead, we blend a subtle white sheen over the base surface color.
      final hsl = HSLColor.fromColor(baseColor);
      final boostedLightness =
          (hsl.lightness + (0.12 * clampedIntensity)).clamp(0.0, 1.0);
      final boostedColor = hsl.withLightness(boostedLightness).toColor();
      final alpha = (0.15 + (0.25 * clampedIntensity)).clamp(0.0, 1.0);
      return Color.alphaBlend(
          Colors.white.withValues(alpha: alpha), boostedColor);
    } else {
      // In light mode, pure white highlight with intensity-scaled opacity.
      final alpha = (0.65 + (0.35 * clampedIntensity)).clamp(0.0, 1.0);
      return Colors.white.withValues(alpha: alpha);
    }
  }

  /// Calculates the dynamic lowlight shadow color cast opposite the light source.
  ///
  /// [baseColor] is the underlying surface color.
  /// [intensity] is a scaling factor between 0.0 and 1.0 (default 0.65).
  static Color deriveShadowColor(Color baseColor, [double intensity = 0.65]) {
    final clampedIntensity = intensity.clamp(0.0, 1.0);
    final dark = isDark(baseColor);

    if (dark) {
      // In dark mode, deep black drop shadows create ambient occlusion.
      final alpha = (0.55 + (0.40 * clampedIntensity)).clamp(0.0, 1.0);
      return Colors.black.withValues(alpha: alpha);
    } else {
      // In light mode, shadow is derived by darkening the base hue to avoid muddy greys.
      final hsl = HSLColor.fromColor(baseColor);
      final darkened = hsl
          .withLightness((hsl.lightness * (1.0 - (0.22 * clampedIntensity)))
              .clamp(0.0, 1.0))
          .withSaturation((hsl.saturation * 1.15).clamp(0.0, 1.0))
          .toColor();
      final alpha = (0.30 + (0.45 * clampedIntensity)).clamp(0.0, 1.0);
      return darkened.withValues(alpha: alpha);
    }
  }

  /// Derives the surface gradient for [NeuShape.convex] or [NeuShape.concave].
  ///
  /// [curvature] controls the contrast range between surface edges (0.0 to 1.0).
  static List<Color> deriveGradientColors(
    Color baseColor,
    NeuShape shape, [
    double curvature = 0.15,
  ]) {
    final c = curvature.clamp(0.0, 1.0);
    final dark = isDark(baseColor);
    final hsl = HSLColor.fromColor(baseColor);

    final lightDelta = dark ? (0.08 * c) : (0.09 * c);
    final darkDelta = dark ? (0.09 * c) : (0.12 * c);

    final highlightLightness = (hsl.lightness + lightDelta).clamp(0.0, 1.0);
    final shadowLightness = (hsl.lightness - darkDelta).clamp(0.0, 1.0);

    final lightStep = hsl.withLightness(highlightLightness).toColor();
    final darkStep = hsl.withLightness(shadowLightness).toColor();

    return switch (shape) {
      NeuShape.convex => [lightStep, baseColor, darkStep],
      NeuShape.concave => [darkStep, baseColor, lightStep],
      _ => [baseColor, baseColor],
    };
  }

  /// Calculates gradient stops corresponding to the light curvature.
  static List<double> deriveGradientStops(NeuShape shape) {
    return switch (shape) {
      NeuShape.convex => const [0.0, 0.5, 1.0],
      NeuShape.concave => const [0.0, 0.5, 1.0],
      _ => const [0.0, 1.0],
    };
  }

  /// Calculates the gradient alignment matching the direction of [lightSource].
  static (Alignment begin, Alignment end) deriveAlignment(Offset lightSource) {
    final length = math.sqrt(
      lightSource.dx * lightSource.dx + lightSource.dy * lightSource.dy,
    );
    if (length == 0.0) {
      return (Alignment.topLeft, Alignment.bottomRight);
    }
    final nx = (lightSource.dx / length).clamp(-1.0, 1.0);
    final ny = (lightSource.dy / length).clamp(-1.0, 1.0);

    return (
      Alignment(nx, ny),
      Alignment(-nx, -ny),
    );
  }
}
