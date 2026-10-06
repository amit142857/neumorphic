import 'package:flutter/material.dart';
import '../core/neu_shape.dart';
import '../core/neu_theme.dart';
import 'neu_container.dart';

/// A neumorphic application bar conforming to [PreferredSizeWidget].
class NeuAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a [NeuAppBar].
  const NeuAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.height = kToolbarHeight,
    this.shape = NeuShape.flat,
    this.baseColor,
    this.depth = 3.0,
    this.distance = 3.0,
    this.bottom,
    this.borderRadius,
  });

  /// Primary title widget.
  final Widget? title;

  /// Leading widget (e.g., back button or drawer toggle).
  final Widget? leading;

  /// Trailing action widgets.
  final List<Widget>? actions;

  /// Whether title is centered.
  final bool centerTitle;

  /// Height of the toolbar content.
  final double height;

  /// Surface profile shape.
  final NeuShape shape;

  /// Base surface color override.
  final Color? baseColor;

  /// Perceived elevation depth.
  final double depth;

  /// Shadow displacement distance.
  final double distance;

  /// Optional widget displayed at the bottom of the app bar.
  final PreferredSizeWidget? bottom;

  /// Optional corner radius (for floating app bars).
  final BorderRadiusGeometry? borderRadius;

  @override
  Size get preferredSize =>
      Size.fromHeight(height + (bottom?.preferredSize.height ?? 0.0));

  @override
  Widget build(BuildContext context) {
    final theme = NeuTheme.of(context);
    final topPadding = MediaQuery.paddingOf(context).top;

    Widget toolbar = NavigationToolbar(
      leading: leading,
      middle: title != null
          ? DefaultTextStyle(
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: theme.isDark ? Colors.white : Colors.black87,
                letterSpacing: -0.2,
              ),
              child: title!,
            )
          : null,
      trailing: actions != null && actions!.isNotEmpty
          ? Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: actions!,
            )
          : null,
      centerMiddle: centerTitle,
      middleSpacing: NavigationToolbar.kMiddleSpacing,
    );

    return NeuContainer(
      shape: shape,
      baseColor: baseColor ?? theme.baseColor,
      depth: depth,
      distance: distance,
      borderRadius: borderRadius,
      padding: EdgeInsets.only(top: topPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: toolbar,
            ),
          ),
          if (bottom != null) bottom!,
        ],
      ),
    );
  }
}
