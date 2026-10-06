# Flutter Neumorphic UI Kit

[![pub package](https://img.shields.io/badge/pub.dev-flutter__neumorphic__ui__kit-blue.svg)](https://pub.dev)
[![license](https://img.shields.io/badge/license-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.22.0-02569B.svg?logo=flutter)](https://flutter.dev)
[![Impeller Ready](https://img.shields.io/badge/Impeller-60%2F120%20FPS-purple.svg)](https://flutter.dev)

A modern, high-performance, Impeller-optimized Neumorphic UI kit for Flutter. Built from the ground up with zero heavy third-party dependencies, dynamic light/dark algorithmic color derivation, and GPU-accelerated inset clipping that avoids raster-thread jank.

---

## ✨ Highlights & Architecture

- ⚡ **Impeller 60/120 FPS Optimized**: Inset and pressed shadows are computed using `Path.combine` and hardware `MaskFilter.blur`, avoiding expensive `BackdropFilter` and GPU texture readbacks.
- 🎨 **Dynamic HSL & Perceptual Color Derivation**: Automatically derives realistic highlight and shadow stops from any base surface color in both light and dark modes.
- 🌓 **Seamless Light & Dark Mode**: Implements Flutter's `ThemeExtension` and `InheritedTheme` for global or scoped configuration.
- 🕹️ **Complete Primitive & Form Kit**: `NeuContainer`, `NeuButton`, `NeuIconButton`, `NeuCard`, `NeuSwitch`, `NeuSlider`, `NeuTextField`, `NeuCheckbox`, `NeuRadio`, `NeuProgressBar`, `NeuCircularProgress`, `NeuAppBar`, and `NeuBottomNav`.
- 📳 **Tactile Micro-Interactions**: Built-in spring physics and optional haptic feedback on interactive controls.
- 📦 **Zero Heavy Dependencies**: Pure Flutter framework primitives.

---

## 🚀 Getting Started

### Installation

Add `flutter_neumorphic_ui_kit` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_neumorphic_ui_kit: ^1.0.0
```

Then import the library:

```dart
import 'package:flutter_neumorphic_ui_kit/flutter_neumorphic_ui_kit.dart';
```

---

## 💡 Quick Start

Wrap your widget tree with `NeuTheme` (or configure `NeuThemeData` inside `ThemeData.extensions`):

```dart
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_ui_kit/flutter_neumorphic_ui_kit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Neumorphic UI Kit',
      home: NeuTheme(
        data: NeuThemeData.light(
          baseColor: const Color(0xFFE0E5EC),
          lightSource: const Offset(-1.0, -1.0), // Top-left light source
          depth: 4.0,
          intensity: 0.65,
        ),
        child: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _switchVal = true;
  double _sliderVal = 0.5;

  @override
  Widget build(BuildContext context) {
    final theme = NeuTheme.of(context);

    return Scaffold(
      backgroundColor: theme.baseColor,
      appBar: const NeuAppBar(
        title: Text('Flutter Neumorphic UI Kit'),
      ),
      body: Center(
        child: NeuCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NeuButton(
                onPressed: () {},
                child: const Text('Elevated Button'),
              ),
              const SizedBox(height: 20),
              NeuSwitch(
                value: _switchVal,
                onChanged: (val) => setState(() => _switchVal = val),
              ),
              const SizedBox(height: 20),
              NeuSlider(
                value: _sliderVal,
                onChanged: (val) => setState(() => _sliderVal = val),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 🧩 Component Catalog

### 1. NeuContainer & Shapes
The foundational building block supporting four geometric lighting surfaces:
- `NeuShape.flat`: Outer drop shadows and highlight.
- `NeuShape.convex`: Outward curved gradient dome.
- `NeuShape.concave`: Inward curved gradient dish.
- `NeuShape.pressed`: Recessed inner shadows.

```dart
NeuContainer(
  width: 120,
  height: 120,
  shape: NeuShape.convex,
  borderRadius: BorderRadius.circular(24),
  child: const Center(child: Text('Convex')),
)
```

### 2. NeuButton & NeuIconButton
Tactile interactive button with spring transitions between idle and pressed states:

```dart
NeuButton(
  shape: NeuShape.flat,
  onPressed: () => print('Tapped!'),
  child: const Text('Confirm Action'),
)

NeuIconButton(
  icon: const Icon(Icons.favorite),
  onPressed: () {},
)
```

### 3. Form Controls
- **NeuSwitch**: Inset recessed track with an elevated sliding thumb.
- **NeuSlider**: Drag gesture slider with live haptics and optional divisions.
- **NeuTextField**: Inset text entry trough with focus border and prefix/suffix slots.
- **NeuCheckbox**: Inset checkbox with pop-out animated checked indicator.
- **NeuRadio**: Inset circle with pop-out inner convex dot.

```dart
NeuTextField(
  labelText: 'Email Address',
  hintText: 'user@example.com',
  prefixIcon: Icon(Icons.email_outlined),
)

NeuSwitch(
  value: isEnabled,
  onChanged: (val) => setState(() => isEnabled = val),
)
```

### 4. Progress Indicators
- **NeuProgressBar**: Recessed trough with animated convex fill bar (supports determinate & indeterminate modes).
- **NeuCircularProgress**: Recessed circular base with animated progress arc and optional center widget.

```dart
NeuProgressBar(value: 0.75)

NeuCircularProgress(
  value: 0.85,
  child: Text('85%'),
)
```

### 5. Navigation
- **NeuAppBar**: Elevated app bar implementing `PreferredSizeWidget`.
- **NeuBottomNav**: Elevated floating or docked bottom bar with recessed active states.

```dart
NeuBottomNav(
  currentIndex: _selectedIndex,
  onTap: (index) => setState(() => _selectedIndex = index),
  items: const [
    NeuBottomNavItem(icon: Icon(Icons.home), label: 'Home'),
    NeuBottomNavItem(icon: Icon(Icons.settings), label: 'Settings'),
  ],
)
```

---

## 🎨 Theme Customization

`NeuThemeData` provides fine-grained control over lighting vectors, blur scaling, depth, and colors:

```dart
NeuThemeData(
  baseColor: const Color(0xFF24272C),      // Surface background
  accentColor: const Color(0xFF60A5FA),    // Active elements
  lightSource: const Offset(-1.0, -1.0),   // Light angle vector
  depth: 4.0,                              // Elevation factor
  distance: 4.0,                           // Shadow displacement (px)
  intensity: 0.70,                         // Contrast ratio (0.0 to 1.0)
  curvature: 0.18,                         // Gradient curve factor
  blurRadiusScale: 2.0,                    // Shadow blur multiplier
)
```

---

## 📱 Interactive Showcase App

Run the included showcase application in `example/`:

```bash
cd example
flutter run
```

---

## 📄 License

MIT License. See [LICENSE](LICENSE) for details.
