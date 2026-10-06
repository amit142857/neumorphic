# Flutter Neumorphic UI Kit

[![pub package](https://img.shields.io/badge/pub.dev-flutter__neumorphic__ui__kit-0175C2.svg?logo=dart&logoColor=white)](https://pub.dev)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.22.0-02569B.svg?logo=flutter&logoColor=white)](https://flutter.dev)
[![Impeller](https://img.shields.io/badge/Impeller-60%2F120%20FPS%20GPU-blueviolet.svg?logo=speedtest&logoColor=white)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-success.svg)](https://opensource.org/licenses/MIT)
[![Null Safety](https://img.shields.io/badge/Dart-3.3%2B%20Null--Safe-brightgreen.svg)](https://dart.dev)

A modern, high-performance, Impeller-optimized Neumorphic UI kit for Flutter. Built from the ground up with zero heavy third-party dependencies, dynamic light/dark algorithmic color derivation, and GPU-accelerated inset clipping that avoids raster-thread jank.

---

## ⚡ Why This Kit? (Impeller GPU Optimization)

Legacy neumorphic packages in Flutter frequently suffer from raster-thread stutters and 15–30 FPS frame drops because they rely on `BackdropFilter` or nested image-filtering passes.

**Flutter Neumorphic UI Kit** is engineered specifically for modern Flutter rendering:
- **GPU Inset Shadows**: Recessed surfaces ([NeuShape.pressed]) are rendered via geometric difference clipping ([Path.combine]) and [MaskFilter.blur]. This uses zero raster save layers or texture readbacks, running at 60/120 FPS on Impeller.
- **Dynamic HSL Derivation**: Automatically calculates physically accurate highlights and shadows from any surface [Color] using perceptual luminance and HSL transforms.
- **Zero Heavy Dependencies**: Pure Flutter framework primitives.

---

## 📐 Lighting Architecture

```
                  ☀️ Simulated Light Source (Offset(-1.0, -1.0))
                           \
                            \
        [Elevated Surface]   \         [Pressed / Recessed Surface]
     ┌────────────────────────┐         \┌───┐                 ┌───┐/
     │ Highlight (top-left)   │          │   │ Dark Cavity     │   │
     │ ────────────────────── │          │   │ Inner Shadow    │   │
     │ Dark Shadow (btm-right)│          │   └─────────────────┘   │
     └────────────────────────┘          │ Highlight Reflection    │
                                         └─────────────────────────┘
```

The kit supports four physical surface profiles:
- **`NeuShape.flat`**: Elevated surface with opposing outer highlight and drop shadow.
- **`NeuShape.convex`**: Outward curved surface gradient along the light vector.
- **`NeuShape.concave`**: Inward curved surface gradient opposing the light vector.
- **`NeuShape.pressed`**: Cavity recess with hardware-clipped inner shadows.

---

## 📦 Component Overview

| Component | Description | Key Features |
| :--- | :--- | :--- |
| **`NeuContainer`** | Foundational building block | Flat, convex, concave, pressed, custom radii, borders, circular shapes. |
| **`NeuButton`** | Tactile push button | Spring animation, automatic pressed state transitions, haptic clicks, disabled dimming. |
| **`NeuIconButton`** | Circular/rounded icon button | Spring physics, tooltip, custom size and shape. |
| **`NeuCard`** | Elevated surface card | Optional physical bevel border stroke, custom padding and curvature. |
| **`NeuSwitch`** | Toggle switch | Inset track, elevated sliding thumb, active accent glow, custom icons. |
| **`NeuSlider`** | Tactile slider | Inset track, elevated draggable thumb, step divisions, haptic feedback ticks. |
| **`NeuTextField`** | Neumorphic text input | Recessed trough, focus glow border, floating label, error handling, icon slots. |
| **`NeuCheckbox`** | Tactile checkbox | Recessed unselected state, animated convex pop-out active state. |
| **`NeuRadio`** | Radio button | Inset circular well with animated inner convex dot indicator. |
| **`NeuProgressBar`** | Linear progress bar | Inset track with animated convex fill (determinate & indeterminate). |
| **`NeuCircularProgress`** | Circular progress meter | Inset circular channel with animated progress arc and custom center slot. |
| **`NeuAppBar`** | Neumorphic app bar | Conforms to `PreferredSizeWidget`, soft bottom elevation shadow. |
| **`NeuBottomNav`** | Bottom navigation bar | Floating or docked navigation bar with tactile recessed active states. |

---

## 🚀 Installation & Quickstart

Add `flutter_neumorphic_ui_kit` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_neumorphic_ui_kit: ^1.0.0
```

Import the package:

```dart
import 'package:flutter_neumorphic_ui_kit/flutter_neumorphic_ui_kit.dart';
```

Wrap your application in `NeuTheme`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_ui_kit/flutter_neumorphic_ui_kit.dart';

void main() => runApp(const MyApp());

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
        title: Text('Neumorphic Dashboard'),
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

## 💡 Code Recipes

### Tactile Interactive Button
```dart
NeuButton(
  shape: NeuShape.flat,
  pressedShape: NeuShape.pressed,
  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
  onPressed: () => print('Button tapped!'),
  child: const Text('Confirm Order'),
)
```

### Inset Text Field with Focus Glow
```dart
NeuTextField(
  labelText: 'Full Name',
  hintText: 'John Doe',
  prefixIcon: const Icon(Icons.person_outline),
  onChanged: (value) => print(value),
)
```

### Toggle Switch with Accent Glow
```dart
NeuSwitch(
  value: isEnabled,
  enableGlow: true,
  activeColor: const Color(0xFF3B82F6),
  onChanged: (val) => setState(() => isEnabled = val),
)
```

### Circular Progress Indicator with Center Content
```dart
NeuCircularProgress(
  value: 0.75,
  size: 90,
  strokeWidth: 9,
  child: Text(
    '75%',
    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
  ),
)
```

---

## 🎨 Theme Configuration

`NeuThemeData` allows full control over colors, depth, and shadow vectors:

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

Features included in the showcase:
- **Interactive Component Gallery**: Test buttons, text fields, checkboxes, radios, sliders, and progress bars.
- **Real-time 360° Lighting Lab**: Move the light source angle live with a 360° slider and observe how shadows dynamically recalculate across convex, concave, and inset shapes.
- **Smart Home Dashboard**: Complete production-style dashboard containing climate dials, energy cards, and ambient music controls.

---

## 📄 License

MIT License. See [LICENSE](LICENSE) for details.
