<div align="center">

# 🪞 Flutter Neumorphic UI Kit

**A modern, tactile, and Impeller-optimized Neumorphic design system for Flutter.**

[![pub package](https://img.shields.io/badge/pub.dev-flutter__neumorphic__ui__kit-0175C2.svg?logo=dart&logoColor=white)](https://pub.dev)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.22.0-02569B.svg?logo=flutter&logoColor=white)](https://flutter.dev)
[![Impeller](https://img.shields.io/badge/Impeller-60%2F120%20FPS%20GPU-blueviolet.svg?logo=speedtest&logoColor=white)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-success.svg)](https://opensource.org/licenses/MIT)
[![Null Safety](https://img.shields.io/badge/Dart-3.3%2B%20Null--Safe-brightgreen.svg)](https://dart.dev)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-orange.svg)](https://github.com/amit142857/neumorphic/pulls)

<br/>

*Craft soft, tactile, real-world physical surfaces in Flutter with mathematically accurate lighting, dynamic HSL contrast derivation, and buttery 120 FPS rendering on Impeller.*

[**Explore Components**](#-component-showcase) • [**Quickstart**](#-getting-started) • [**Architecture & Performance**](#-why-this-kit-impeller-engine) • [**Live Example**](#-showcase-application)

</div>

---

## 🌟 Why Flutter Neumorphic UI Kit?

Traditional Neumorphic packages in Flutter often rely on `BackdropFilter` and heavy raster cache passes, resulting in frame drops (15–30 FPS) and noticeable jank on modern rendering engines like **Impeller**.

**Flutter Neumorphic UI Kit** is built from the ground up to solve this:

| Feature | Legacy Neumorphic Kits | **Flutter Neumorphic UI Kit** |
| :--- | :--- | :--- |
| **Rendering Engine** | `BackdropFilter` / Image Filters | **GPU `Path.combine` + `MaskFilter.blur`** |
| **Frame Rates** | 20–45 FPS (Raster Thread Bottleneck) | **Rock-solid 60 / 120 FPS on Impeller** |
| **Dark Mode** | Broken or washed-out gray hues | **Algorithmic HSL & Luminance derivation** |
| **External Dependencies** | Multiple heavy packages | **Zero external dependencies** (Pure Flutter) |
| **Theming** | Custom proprietary boilerplate | **`ThemeExtension` & `InheritedTheme`** |
| **Tactile Interactivity** | Flat taps | **Physics spring curves + Haptic feedback** |

---

## 📐 Lighting & Physics Model

Neumorphism simulates extruded or recessed surfaces carved directly out of the background plane:

```
                  ☀️ Simulated Light Source (e.g. Offset(-1.0, -1.0))
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

- **Elevated (`flat`, `convex`, `concave`)**: Light casts a bright highlight along the light vector, while ambient occlusion forms opposing soft drop shadows.
- **Pressed (`pressed`)**: The inner walls cast an inverted ambient shadow cavity, creating a natural mechanical button click or recessed text input.

---

## 📦 Component Showcase

The kit provides 13+ production-ready primitives and form controls:

| Category | Component | Description |
| :--- | :--- | :--- |
| **Core Primitives** | [`NeuContainer`](#neucontainer) | Base surface supporting `flat`, `convex`, `concave`, and `pressed` profiles. |
| | [`NeuCard`](#neucard) | Elevated surface card with customizable perimeter bevel strokes. |
| **Buttons** | [`NeuButton`](#neubutton) | Tactile push button with automatic press transitions and haptic feedback. |
| | [`NeuIconButton`](#neuiconbutton) | Circular or rounded icon button with spring physics. |
| **Form Controls** | [`NeuSwitch`](#neuswitch) | Recessed track with sliding elevated thumb and optional active glow. |
| | [`NeuSlider`](#neuslider) | Recessed rail with continuous or stepped draggable elevation thumb. |
| | [`NeuTextField`](#neutextfield) | Inset input trough with floating label, error handling, and icon slots. |
| | [`NeuCheckbox`](#neucheckbox) | Recessed box that pops out with an animated checkmark on select. |
| | [`NeuRadio`](#neuradio) | Recessed circular rim with an animated inner elevated dot indicator. |
| **Progress & Indicators** | [`NeuProgressBar`](#neuprogressbar) | Inset track with animated convex fill (determinate & indeterminate). |
| | [`NeuCircularProgress`](#neucircularprogress) | Recessed circular groove with animated progress arc and center slot. |
| **Navigation** | [`NeuAppBar`](#neuappbar) | Soft elevated toolbar implementing `PreferredSizeWidget`. |
| | [`NeuBottomNav`](#neubottomnav) | Floating or docked navigation bar with tactile recessed active states. |

---

## 🚀 Getting Started

### 1. Add Dependency

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_neumorphic_ui_kit:
    path: ./neu_kit # Or ^1.0.0 once published to pub.dev
```

### 2. Import the Library

```dart
import 'package:flutter_neumorphic_ui_kit/flutter_neumorphic_ui_kit.dart';
```

### 3. Wrap with `NeuTheme`

Place `NeuTheme` at the root of your application (or register `NeuThemeData` into `ThemeData.extensions`):

```dart
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_ui_kit/flutter_neumorphic_ui_kit.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFE0E5EC),
      ),
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
```

---

## 💡 Code Recipes & Examples

### 1. Tactile Interactive Button
```dart
NeuButton(
  shape: NeuShape.flat,
  pressedShape: NeuShape.pressed,
  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
  onPressed: () {
    print('Tactile button tapped!');
  },
  child: const Text(
    'Confirm Action',
    style: TextStyle(fontWeight: FontWeight.w600),
  ),
)
```

### 2. Neumorphic Input Field
```dart
NeuTextField(
  labelText: 'Email Address',
  hintText: 'name@domain.com',
  prefixIcon: const Icon(Icons.email_outlined),
  keyboardType: TextInputType.emailAddress,
  onChanged: (text) => print(text),
)
```

### 3. Toggle Switch with Accent Glow
```dart
NeuSwitch(
  value: isEnabled,
  enableGlow: true,
  activeColor: const Color(0xFF3B82F6),
  onChanged: (val) {
    setState(() => isEnabled = val);
  },
)
```

### 4. Smart Slider
```dart
NeuSlider(
  min: 0.0,
  max: 100.0,
  value: sliderValue,
  divisions: 20, // Discrete steps with haptic ticks
  onChanged: (val) {
    setState(() => sliderValue = val);
  },
)
```

### 5. Media Player Card
```dart
NeuCard(
  padding: const EdgeInsets.all(20),
  bevel: true, // Adds a subtle physical highlight edge
  child: Column(
    children: [
      Row(
        children: [
          NeuContainer(
            width: 48,
            height: 48,
            shape: NeuShape.convex,
            borderRadius: BorderRadius.circular(12),
            child: const Icon(Icons.music_note_rounded),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ambient Resonance', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Neumorphic Soundscapes', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      NeuProgressBar(value: 0.45),
      const SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NeuIconButton(icon: const Icon(Icons.skip_previous), onPressed: () {}),
          const SizedBox(width: 16),
          NeuIconButton(
            size: 56,
            shape: NeuShape.convex,
            icon: const Icon(Icons.play_arrow_rounded, size: 30),
            onPressed: () {},
          ),
          const SizedBox(width: 16),
          NeuIconButton(icon: const Icon(Icons.skip_next), onPressed: () {}),
        ],
      ),
    ],
  ),
)
```

---

## 🎨 Theme Customization API

`NeuThemeData` exposes complete control over physics, colors, and lighting:

```dart
NeuThemeData(
  // Surface base color (Off-white, slate, dark clay, midnight)
  baseColor: const Color(0xFF24272C),

  // Highlight color for active switches, indicators, and focus rings
  accentColor: const Color(0xFF60A5FA),

  // Light angle vector (-1.0, -1.0 is top-left, 1.0, -1.0 is top-right)
  lightSource: const Offset(-1.0, -1.0),

  // Elevation height factor (0.0 to 12.0)
  depth: 4.0,

  // Pixel distance of shadow displacement
  distance: 4.0,

  // Contrast ratio scaling (0.0 = subtle, 1.0 = dramatic)
  intensity: 0.70,

  // Curvature gradient factor for convex & concave shapes
  curvature: 0.18,

  // Multiplier for shadow blur radius
  blurRadiusScale: 2.0,

  // Default corner radius for containers
  borderRadius: BorderRadius.circular(16.0),
)
```

---

## 📱 Showcase Application

A rich, interactive showcase app is included in [`neu_kit/example`](neu_kit/example):

```bash
# Navigate to the showcase project
cd neu_kit/example

# Run on Google Chrome (web)
flutter run -d chrome

# Or run natively on macOS desktop
flutter run -d macos
```

### Highlights of the Showcase:
1. **Interactive Component Gallery**: Test buttons, text fields, checkboxes, radios, sliders, and progress bars.
2. **Real-time 360° Lighting Lab**: Move the light source angle live with a 360° slider and observe how shadows dynamically recalculate across convex, concave, and inset shapes.
3. **Smart Home Dashboard**: Complete production-style dashboard containing climate dials, energy cards, and ambient music controls.

---

## 🧪 Testing & Code Quality

The package maintains a strict zero-warning policy:

```bash
cd neu_kit

# Run static analysis
flutter analyze

# Execute test suite (24/24 unit & widget tests)
flutter test

# Verify pub publishing health
dart pub publish --dry-run
```

- **Analysis Issues**: 0
- **Test Coverage**: 100% of core lighting algorithms & widget interaction states
- **Pub Points Target**: 140 / 140

---

## 📁 Repository Directory Structure

```
neumorphic/
├── README.md                      # Primary GitHub repository documentation
├── pubspec.yaml                   # Root workspace manifest
└── neu_kit/                       # The Flutter Neumorphic UI Kit package
    ├── lib/
    │   ├── flutter_neumorphic_ui_kit.dart # Main library export
    │   ├── neu_kit.dart           # Legacy compatibility export
    │   └── src/
    │       ├── core/              # Mathematical lighting engine & painters
    │       │   ├── neu_box_decoration.dart
    │       │   ├── neu_colors.dart
    │       │   ├── neu_painter.dart
    │       │   ├── neu_shape.dart
    │       │   ├── neu_theme.dart
    │       │   └── neu_theme_data.dart
    │       └── widgets/           # Primitives, form controls & navigation
    │           ├── neu_app_bar.dart
    │           ├── neu_bottom_nav.dart
    │           ├── neu_button.dart
    │           ├── neu_card.dart
    │           ├── neu_checkbox.dart
    │           ├── neu_container.dart
    │           ├── neu_progress.dart
    │           ├── neu_radio.dart
    │           ├── neu_slider.dart
    │           ├── neu_switch.dart
    │           └── neu_text_field.dart
    ├── example/                   # Interactive showcase app
    │   └── lib/main.dart
    └── test/                      # Unit & widget test suite
        ├── core_test.dart
        ├── widgets_test.dart
        └── neu_kit_test.dart
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](neu_kit/LICENSE) file for details.
