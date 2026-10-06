import 'package:flutter/material.dart';
import 'neu_theme_data.dart';

/// An [InheritedTheme] that provides [NeuThemeData] to descendant neumorphic widgets.
///
/// Widgets such as [NeuContainer], [NeuButton], and [NeuSwitch] query this theme
/// to obtain their surface colors, lighting vectors, and depth parameters.
///
/// If no [NeuTheme] exists in the ancestor chain, widgets will look for a
/// [NeuThemeData] registered in [ThemeData.extensions], falling back to a sensible
/// default based on [Theme.of(context).brightness].
class NeuTheme extends InheritedTheme {
  /// Creates a [NeuTheme] providing [data] to [child].
  const NeuTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The neumorphic configuration data provided to descendants.
  final NeuThemeData data;

  /// Retrieves the nearest [NeuThemeData] in the widget hierarchy, or returns null.
  static NeuThemeData? maybeOf(BuildContext context) {
    final inherited = context.dependOnInheritedWidgetOfExactType<NeuTheme>();
    if (inherited != null) return inherited.data;

    final themeExt = Theme.of(context).extension<NeuThemeData>();
    return themeExt;
  }

  /// Retrieves the nearest [NeuThemeData] in the widget hierarchy, or provides
  /// a fallback matching the active brightness.
  static NeuThemeData of(BuildContext context) {
    final data = maybeOf(context);
    if (data != null) return data;

    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? NeuThemeData.dark() : NeuThemeData.light();
  }

  @override
  bool updateShouldNotify(NeuTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    return NeuTheme(data: data, child: child);
  }
}
