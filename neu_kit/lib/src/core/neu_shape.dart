/// Defines the geometric and lighting curvature of a neumorphic surface.
enum NeuShape {
  /// A flat surface elevated above the background.
  ///
  /// Casts a highlight shadow towards the light source and a dark shadow
  /// away from the light source.
  flat,

  /// A surface curved outward (convex dome).
  ///
  /// Rendered with a surface gradient from highlight to shadow, along with
  /// elevated outer drop shadows.
  convex,

  /// A surface curved inward (concave dish).
  ///
  /// Rendered with an inverted surface gradient from shadow to highlight,
  /// along with elevated outer drop shadows.
  concave,

  /// A recessed/pressed surface indented into the background.
  ///
  /// Inner shadows are cast inside the boundary, simulating an indentation
  /// or clicked button state.
  pressed,
}
