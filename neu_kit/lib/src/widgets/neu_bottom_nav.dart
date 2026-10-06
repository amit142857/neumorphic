import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/neu_shape.dart';
import '../core/neu_theme.dart';
import 'neu_container.dart';

/// An individual item descriptor for [NeuBottomNav].
class NeuBottomNavItem {
  /// Creates a [NeuBottomNavItem].
  const NeuBottomNavItem({
    required this.icon,
    this.activeIcon,
    this.label,
    this.badge,
  });

  /// Default icon displayed when unselected.
  final Widget icon;

  /// Icon displayed when selected. If null, [icon] is used.
  final Widget? activeIcon;

  /// Optional textual label.
  final String? label;

  /// Optional badge widget displayed at the top right of the icon.
  final Widget? badge;
}

/// A floating or docked neumorphic bottom navigation bar with tactile feedback and recessed item active states.
class NeuBottomNav extends StatelessWidget {
  /// Creates a [NeuBottomNav].
  const NeuBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.height = 70.0,
    this.margin = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    this.borderRadius,
    this.baseColor,
    this.activeColor,
    this.inactiveColor,
    this.depth = 4.0,
    this.enableHapticFeedback = true,
  }) : assert(items.length >= 2);

  /// Currently selected tab index.
  final int currentIndex;

  /// Tap callback when user selects an item.
  final ValueChanged<int> onTap;

  /// Navigation items list. Must contain at least 2 items.
  final List<NeuBottomNavItem> items;

  /// Height of the navigation bar.
  final double height;

  /// External margin around the bar (useful for floating pill designs).
  final EdgeInsetsGeometry margin;

  /// Corner radius. Defaults to `BorderRadius.circular(24.0)`.
  final BorderRadiusGeometry? borderRadius;

  /// Surface background color.
  final Color? baseColor;

  /// Accent highlight color for active item.
  final Color? activeColor;

  /// Color for unselected item icons and labels.
  final Color? inactiveColor;

  /// Perceived elevation depth.
  final double depth;

  /// Whether to produce haptic vibrations on tab changes.
  final bool enableHapticFeedback;

  @override
  Widget build(BuildContext context) {
    final theme = NeuTheme.of(context);
    final accent = activeColor ?? theme.accentColor;
    final unselected = inactiveColor ?? (theme.isDark ? Colors.white54 : Colors.black45);
    final effectiveRadius = borderRadius ?? BorderRadius.circular(24.0);

    return SafeArea(
      top: false,
      child: Padding(
        padding: margin,
        child: NeuContainer(
          height: height,
          shape: NeuShape.flat,
          borderRadius: effectiveRadius,
          baseColor: baseColor ?? theme.baseColor,
          depth: depth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (int i = 0; i < items.length; i++)
                _buildNavItem(
                  context: context,
                  index: i,
                  item: items[i],
                  isSelected: i == currentIndex,
                  activeColor: accent,
                  inactiveColor: unselected,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required NeuBottomNavItem item,
    required bool isSelected,
    required Color activeColor,
    required Color inactiveColor,
  }) {
    final effectiveIcon = isSelected ? (item.activeIcon ?? item.icon) : item.icon;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (enableHapticFeedback && !isSelected) {
            HapticFeedback.selectionClick();
          }
          onTap(index);
        },
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
            child: NeuContainer(
              shape: isSelected ? NeuShape.pressed : NeuShape.flat,
              borderRadius: BorderRadius.circular(16.0),
              depth: isSelected ? 2.5 : 0.0,
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconTheme(
                        data: IconThemeData(
                          color: isSelected ? activeColor : inactiveColor,
                          size: 22.0,
                        ),
                        child: effectiveIcon,
                      ),
                      if (item.badge != null)
                        Positioned(
                          right: -8.0,
                          top: -6.0,
                          child: item.badge!,
                        ),
                    ],
                  ),
                  if (item.label != null) ...[
                    const SizedBox(height: 3.0),
                    Text(
                      item.label!,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? activeColor : inactiveColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
