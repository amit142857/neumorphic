import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_neumorphic_ui_kit/flutter_neumorphic_ui_kit.dart';

void main() {
  group('NeuColors & Dynamic Derivation Tests', () {
    test('Light surface dynamic highlight and shadow derivation', () {
      const lightBase = Color(0xFFE0E5EC);
      expect(NeuColors.isDark(lightBase), isFalse);

      final highlight = NeuColors.deriveHighlightColor(lightBase, 0.65);
      final shadow = NeuColors.deriveShadowColor(lightBase, 0.65);

      // Light surface highlight should be translucent white
      expect(highlight.r, closeTo(1.0, 0.05));
      expect(highlight.g, closeTo(1.0, 0.05));
      expect(highlight.b, closeTo(1.0, 0.05));
      expect(highlight.a, greaterThan(0.5));

      // Light surface shadow should be darker than base surface
      expect(shadow.computeLuminance(), lessThan(lightBase.computeLuminance()));
    });

    test('Dark surface dynamic highlight and shadow derivation', () {
      const darkBase = Color(0xFF24272C);
      expect(NeuColors.isDark(darkBase), isTrue);

      final highlight = NeuColors.deriveHighlightColor(darkBase, 0.70);
      final shadow = NeuColors.deriveShadowColor(darkBase, 0.70);

      // Dark surface highlight luminance should be higher than base
      expect(highlight.computeLuminance(), greaterThan(darkBase.computeLuminance()));

      // Dark surface shadow should be deep black with opacity
      expect(shadow.r, closeTo(0.0, 0.05));
      expect(shadow.g, closeTo(0.0, 0.05));
      expect(shadow.b, closeTo(0.0, 0.05));
      expect(shadow.a, greaterThan(0.5));
    });

    test('Gradient derivation for convex and concave shapes', () {
      const base = Color(0xFFE0E5EC);
      final convexColors = NeuColors.deriveGradientColors(base, NeuShape.convex, 0.15);
      final concaveColors = NeuColors.deriveGradientColors(base, NeuShape.concave, 0.15);

      expect(convexColors.length, equals(3));
      expect(concaveColors.length, equals(3));

      // Convex starts brighter than base and ends darker than base
      expect(convexColors.first.computeLuminance(), greaterThan(convexColors.last.computeLuminance()));

      // Concave starts darker than base and ends brighter than base
      expect(concaveColors.first.computeLuminance(), lessThan(concaveColors.last.computeLuminance()));
    });

    test('Light source alignment vector calculations', () {
      final (begin, end) = NeuColors.deriveAlignment(const Offset(-1.0, -1.0));
      expect(begin.x, lessThan(0.0));
      expect(begin.y, lessThan(0.0));
      expect(end.x, greaterThan(0.0));
      expect(end.y, greaterThan(0.0));
    });
  });

  group('NeuThemeData & NeuTheme Tests', () {
    test('Default values and factory constructors', () {
      final lightTheme = NeuThemeData.light();
      final darkTheme = NeuThemeData.dark();

      expect(lightTheme.isDark, isFalse);
      expect(darkTheme.isDark, isTrue);
      expect(lightTheme.lightSource, equals(const Offset(-1.0, -1.0)));
      expect(lightTheme.depth, equals(4.0));
      expect(lightTheme.blurRadius, equals(8.0));
    });

    test('copyWith properly overrides values', () {
      final theme = NeuThemeData.light();
      final modified = theme.copyWith(
        depth: 10.0,
        intensity: 0.9,
        baseColor: const Color(0xFF112233),
      );

      expect(modified.depth, equals(10.0));
      expect(modified.intensity, equals(0.9));
      expect(modified.baseColor, equals(const Color(0xFF112233)));
      expect(modified.distance, equals(theme.distance));
    });

    test('lerp smoothly interpolates between two NeuThemeData', () {
      final a = NeuThemeData.light(depth: 2.0);
      final b = NeuThemeData.light(depth: 6.0);
      final mid = a.lerp(b, 0.5);

      expect(mid.depth, closeTo(4.0, 0.001));
    });

    testWidgets('NeuTheme provides data via context', (tester) async {
      final customTheme = NeuThemeData.light(depth: 9.0);
      late NeuThemeData resolved;

      await tester.pumpWidget(
        NeuTheme(
          data: customTheme,
          child: Builder(
            builder: (context) {
              resolved = NeuTheme.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(resolved.depth, equals(9.0));
    });

    testWidgets('NeuTheme falls back to brightness when unprovided', (tester) async {
      late NeuThemeData resolved;

      await tester.pumpWidget(
        Theme(
          data: ThemeData(brightness: Brightness.dark),
          child: Builder(
            builder: (context) {
              resolved = NeuTheme.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(resolved.isDark, isTrue);
    });
  });

  group('NeuBoxDecoration Tests', () {
    test('NeuBoxDecoration equality and hit testing', () {
      const dec1 = NeuBoxDecoration(shape: NeuShape.convex, depth: 5.0);
      const dec2 = NeuBoxDecoration(shape: NeuShape.convex, depth: 5.0);
      const dec3 = NeuBoxDecoration(shape: NeuShape.pressed, depth: 5.0);

      expect(dec1, equals(dec2));
      expect(dec1 == dec3, isFalse);

      expect(
        dec1.hitTest(const Size(100, 100), const Offset(50, 50)),
        isTrue,
      );
    });
  });
}
