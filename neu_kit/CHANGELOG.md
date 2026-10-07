# Changelog

## 1.0.0

### Initial Release
- **Core Engine & Lighting Architecture**:
  - `NeuTheme` & `NeuThemeData` (`InheritedTheme` and `ThemeExtension` support).
  - Algorithmic HSL & perceptual color derivation for light and dark surfaces (`NeuColors`).
  - Four surface shapes: `NeuShape.flat`, `NeuShape.convex`, `NeuShape.concave`, and `NeuShape.pressed`.
  - Impeller-optimized `NeuPainter` and `NeuBoxDecoration` with hardware-accelerated inset clipping via `Path.combine` and `MaskFilter.blur`.
- **Primitives & Containers**:
  - `NeuContainer` with configurable shapes, borders, dimensions, padding, and alignments.
  - `NeuCard` with customizable elevation and crisp bevel border strokes.
- **Buttons & Interactive Components**:
  - `NeuButton` with tactile spring transitions and haptic feedback.
  - `NeuIconButton` supporting circular and rounded boundary geometry.
- **Form Controls**:
  - `NeuSwitch` with inset recessed track and sliding elevated thumb.
  - `NeuSlider` with drag gesture tracking, steps/divisions, and haptic feedback.
  - `NeuTextField` with recessed trough, floating label, error states, and prefix/suffix slots.
  - `NeuCheckbox` with inset and pop-out checked states.
  - `NeuRadio` with inset recessed base and animated pop-out dot.
- **Indicators & Navigation**:
  - `NeuProgressBar` with determinate and indeterminate animations.
  - `NeuCircularProgress` with recessed circular channel and animated arc.
  - `NeuAppBar` conforming to `PreferredSizeWidget`.
  - `NeuBottomNav` with tactile recessed active states.
- **Showcase Application**:
  - Live Lighting Lab, Component Gallery, and Smart Home Dashboard.
- **Test Suite**:
  - Comprehensive unit and widget tests covering lighting mathematics, widget state transitions, and user gestures.

## 1.0.1
- Formatted all files with `dart format`.
- Updated repository links and optimized description for pub.dev.

