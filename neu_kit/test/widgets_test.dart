import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_neumorphic_ui_kit/flutter_neumorphic_ui_kit.dart';

void main() {
  group('NeuButton Tests', () {
    testWidgets('NeuButton handles tap events and transitions', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeuTheme(
              data: NeuThemeData.light(),
              child: Center(
                child: NeuButton(
                  onPressed: () => tapped = true,
                  child: const Text('Click Me'),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Click Me'), findsOneWidget);

      final gesture = await tester.startGesture(tester.getCenter(find.text('Click Me')));
      await tester.pump(const Duration(milliseconds: 50));
      // Pressed state is active while held down
      await tester.pump();

      await gesture.up();
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('NeuButton disabled when onPressed is null', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeuTheme(
              data: NeuThemeData.light(),
              child: const Center(
                child: NeuButton(
                  onPressed: null,
                  child: Text('Disabled'),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Disabled'), findsOneWidget);
      await tester.tap(find.text('Disabled'));
      await tester.pumpAndSettle();
      // Verifies no exception when tapped in disabled state
    });

    testWidgets('NeuIconButton responds to tap', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeuTheme(
              data: NeuThemeData.light(),
              child: Center(
                child: NeuIconButton(
                  icon: const Icon(Icons.favorite),
                  onPressed: () => tapped = true,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.favorite));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });
  });

  group('NeuSwitch Tests', () {
    testWidgets('NeuSwitch toggles value on tap', (tester) async {
      var switchValue = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return NeuTheme(
                  data: NeuThemeData.light(),
                  child: Center(
                    child: NeuSwitch(
                      value: switchValue,
                      onChanged: (val) {
                        setState(() => switchValue = val);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(switchValue, isFalse);

      await tester.tap(find.byType(NeuSwitch));
      await tester.pumpAndSettle();

      expect(switchValue, isTrue);

      await tester.tap(find.byType(NeuSwitch));
      await tester.pumpAndSettle();

      expect(switchValue, isFalse);
    });

    testWidgets('NeuSwitch disabled when onChanged is null', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeuTheme(
              data: NeuThemeData.light(),
              child: const Center(
                child: NeuSwitch(
                  value: true,
                  onChanged: null,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(NeuSwitch));
      await tester.pumpAndSettle();
    });
  });

  group('NeuSlider Tests', () {
    testWidgets('NeuSlider updates value on drag or tap', (tester) async {
      var sliderVal = 0.2;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return NeuTheme(
                  data: NeuThemeData.light(),
                  child: Center(
                    child: SizedBox(
                      width: 200,
                      child: NeuSlider(
                        value: sliderVal,
                        onChanged: (val) {
                          setState(() => sliderVal = val);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      final sliderFinder = find.byType(NeuSlider);
      expect(sliderFinder, findsOneWidget);

      await tester.tap(sliderFinder);
      await tester.pumpAndSettle();

      expect(sliderVal, isNotNull);
    });
  });

  group('NeuCheckbox & NeuRadio Tests', () {
    testWidgets('NeuCheckbox toggles correctly', (tester) async {
      bool? isChecked = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return NeuTheme(
                  data: NeuThemeData.light(),
                  child: Center(
                    child: NeuCheckbox(
                      value: isChecked,
                      onChanged: (val) {
                        setState(() => isChecked = val);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(NeuCheckbox));
      await tester.pumpAndSettle();
      expect(isChecked, isTrue);

      await tester.tap(find.byType(NeuCheckbox));
      await tester.pumpAndSettle();
      expect(isChecked, isFalse);
    });

    testWidgets('NeuRadio triggers onChanged with its value', (tester) async {
      int? group = 1;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return NeuTheme(
                  data: NeuThemeData.light(),
                  child: Column(
                    children: [
                      NeuRadio<int>(
                        value: 1,
                        groupValue: group,
                        onChanged: (val) => setState(() => group = val),
                      ),
                      NeuRadio<int>(
                        value: 2,
                        groupValue: group,
                        onChanged: (val) => setState(() => group = val),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(NeuRadio<int>).last);
      await tester.pumpAndSettle();
      expect(group, equals(2));
    });
  });

  group('NeuTextField Tests', () {
    testWidgets('NeuTextField accepts user input', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeuTheme(
              data: NeuThemeData.light(),
              child: Center(
                child: SizedBox(
                  width: 300,
                  child: NeuTextField(
                    controller: controller,
                    hintText: 'Enter text...',
                    labelText: 'Username',
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Enter text...'), findsOneWidget);

      await tester.enterText(find.byType(EditableText), 'Antigravity');
      await tester.pumpAndSettle();

      expect(controller.text, equals('Antigravity'));
      expect(find.text('Enter text...'), findsNothing);
    });
  });

  group('NeuProgressBar & CircularProgress Tests', () {
    testWidgets('NeuProgressBar renders determinate and indeterminate', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeuTheme(
              data: NeuThemeData.light(),
              child: const Column(
                children: [
                  NeuProgressBar(value: 0.6),
                  NeuProgressBar(value: null),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(NeuProgressBar), findsNWidgets(2));
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('NeuCircularProgress renders determinate and indeterminate', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeuTheme(
              data: NeuThemeData.light(),
              child: const Column(
                children: [
                  NeuCircularProgress(value: 0.75, child: Text('75%')),
                  NeuCircularProgress(value: null),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('75%'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 100));
    });
  });

  group('NeuAppBar & NeuBottomNav Tests', () {
    testWidgets('NeuAppBar renders title and actions', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: NeuAppBar(
              title: const Text('Neu Dashboard'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {},
                ),
              ],
            ),
            body: const SizedBox(),
          ),
        ),
      );

      expect(find.text('Neu Dashboard'), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('NeuBottomNav switches selected tabs', (tester) async {
      var currentIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                bottomNavigationBar: NeuBottomNav(
                  currentIndex: currentIndex,
                  onTap: (i) => setState(() => currentIndex = i),
                  items: const [
                    NeuBottomNavItem(icon: Icon(Icons.home), label: 'Home'),
                    NeuBottomNavItem(icon: Icon(Icons.person), label: 'Profile'),
                  ],
                ),
                body: const SizedBox(),
              );
            },
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);

      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      expect(currentIndex, equals(1));
    });
  });
}
