import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_neumorphic_ui_kit/flutter_neumorphic_ui_kit.dart';

void main() {
  test('Flutter Neumorphic UI Kit exports and instantiates correctly', () {
    final light = NeuThemeData.light();
    final dark = NeuThemeData.dark();

    expect(light.isDark, isFalse);
    expect(dark.isDark, isTrue);
    expect(NeuShape.values.length, equals(4));
  });
}
