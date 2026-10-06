import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';

void main() {
  testWidgets('NeuKitShowcaseApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const NeuKitShowcaseApp());
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Neumorphic UI Kit'), findsOneWidget);

    // Switch to Playground tab
    await tester.tap(find.text('Playground'));
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('Live Lighting Lab'), findsOneWidget);

    // Switch to Dashboard tab
    await tester.tap(find.text('Dashboard'));
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('Smart Dashboard'), findsOneWidget);
    expect(find.text('Living Sanctuary'), findsOneWidget);
  });
}
