import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/neu_shape.dart';
import '../core/neu_theme.dart';
import 'neu_container.dart';

/// A linear neumorphic progress bar featuring an inset recessed trough and an elevated fill bar.
class NeuProgressBar extends StatefulWidget {
  /// Creates a [NeuProgressBar].
  const NeuProgressBar({
    super.key,
    this.value,
    this.height = 14.0,
    this.borderRadius,
    this.progressColor,
    this.trackColor,
    this.animationDuration = const Duration(milliseconds: 300),
  }) : assert(value == null || (value >= 0.0 && value <= 1.0));

  /// Progress fraction from 0.0 to 1.0. If null, displays an indeterminate animation.
  final double? value;

  /// Height of the progress bar track.
  final double height;

  /// Corner radius of the track and fill bar.
  final BorderRadiusGeometry? borderRadius;

  /// Accent color of the progress bar fill.
  final Color? progressColor;

  /// Recessed track background color.
  final Color? trackColor;

  /// Animation duration when value updates.
  final Duration animationDuration;

  @override
  State<NeuProgressBar> createState() => _NeuProgressBarState();
}

class _NeuProgressBarState extends State<NeuProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _indeterminateController;

  @override
  void initState() {
    super.initState();
    _indeterminateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    if (widget.value == null) {
      _indeterminateController.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant NeuProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == null && !oldWidget.value.isNull) {
      _indeterminateController.repeat();
    } else if (widget.value != null && oldWidget.value == null) {
      _indeterminateController.stop();
    }
  }

  @override
  void dispose() {
    _indeterminateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeuTheme.of(context);
    final accent = widget.progressColor ?? theme.accentColor;
    final trackRadius =
        widget.borderRadius ?? BorderRadius.circular(widget.height / 2.0);

    return NeuContainer(
      height: widget.height,
      shape: NeuShape.pressed,
      borderRadius: trackRadius,
      baseColor: widget.trackColor ?? theme.baseColor,
      depth: 3.0,
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;

          if (widget.value != null) {
            final progress = widget.value!.clamp(0.0, 1.0);
            return AnimatedContainer(
              duration: widget.animationDuration,
              curve: Curves.easeOutCubic,
              width: totalWidth * progress,
              child: NeuContainer(
                shape: NeuShape.convex,
                borderRadius: trackRadius,
                baseColor: accent,
                depth: 2.5,
                distance: 1.5,
              ),
            );
          }

          // Indeterminate pulse animation
          return AnimatedBuilder(
            animation: _indeterminateController,
            builder: (context, child) {
              final t = _indeterminateController.value;
              final barWidth = totalWidth * 0.35;
              final left = (totalWidth + barWidth) * t - barWidth;

              return Stack(
                children: [
                  Positioned(
                    left: left,
                    width: barWidth,
                    top: 0,
                    bottom: 0,
                    child: NeuContainer(
                      shape: NeuShape.convex,
                      borderRadius: trackRadius,
                      baseColor: accent,
                      depth: 2.5,
                      distance: 1.5,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

extension on double? {
  bool get isNull => this == null;
}

/// A circular neumorphic progress indicator with an inset recessed groove and an animated elevated arc.
class NeuCircularProgress extends StatefulWidget {
  /// Creates a [NeuCircularProgress].
  const NeuCircularProgress({
    super.key,
    this.value,
    this.size = 80.0,
    this.strokeWidth = 8.0,
    this.progressColor,
    this.trackColor,
    this.child,
    this.animationDuration = const Duration(milliseconds: 300),
  }) : assert(value == null || (value >= 0.0 && value <= 1.0));

  /// Current progress fraction from 0.0 to 1.0. If null, displays an indeterminate spinning animation.
  final double? value;

  /// Outer diameter of the circular progress indicator.
  final double size;

  /// Thickness of the progress stroke.
  final double strokeWidth;

  /// Accent color of the active arc.
  final Color? progressColor;

  /// Background track color.
  final Color? trackColor;

  /// Optional widget displayed in the center of the ring (e.g., percentage text).
  final Widget? child;

  /// Animation duration for progress changes.
  final Duration animationDuration;

  @override
  State<NeuCircularProgress> createState() => _NeuCircularProgressState();
}

class _NeuCircularProgressState extends State<NeuCircularProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _indeterminateController;

  @override
  void initState() {
    super.initState();
    _indeterminateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    if (widget.value == null) {
      _indeterminateController.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant NeuCircularProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == null && oldWidget.value != null) {
      _indeterminateController.repeat();
    } else if (widget.value != null && oldWidget.value == null) {
      _indeterminateController.stop();
    }
  }

  @override
  void dispose() {
    _indeterminateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeuTheme.of(context);
    final accent = widget.progressColor ?? theme.accentColor;
    final baseTrack = widget.trackColor ??
        (theme.isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.06));

    Widget progressArc;

    if (widget.value != null) {
      progressArc = TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: widget.value!),
        duration: widget.animationDuration,
        curve: Curves.easeOutCubic,
        builder: (context, val, _) {
          return CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _CircularArcPainter(
              progress: val,
              strokeWidth: widget.strokeWidth,
              trackColor: baseTrack,
              progressColor: accent,
            ),
          );
        },
      );
    } else {
      progressArc = AnimatedBuilder(
        animation: _indeterminateController,
        builder: (context, _) {
          return Transform.rotate(
            angle: _indeterminateController.value * 2 * math.pi,
            child: CustomPaint(
              size: Size(widget.size, widget.size),
              painter: _CircularArcPainter(
                progress: 0.28,
                strokeWidth: widget.strokeWidth,
                trackColor: baseTrack,
                progressColor: accent,
              ),
            ),
          );
        },
      );
    }

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background recessed plate
          NeuContainer(
            width: widget.size,
            height: widget.size,
            boxShape: BoxShape.circle,
            shape: NeuShape.pressed,
            depth: 2.0,
            baseColor: theme.baseColor,
          ),
          progressArc,
          if (widget.child != null) Center(child: widget.child!),
        ],
      ),
    );
  }
}

class _CircularArcPainter extends CustomPainter {
  _CircularArcPainter({
    required this.progress,
    required this.strokeWidth,
    required this.trackColor,
    required this.progressColor,
  });

  final double progress;
  final double strokeWidth;
  final Color trackColor;
  final Color progressColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - strokeWidth) / 2.0;

    // Track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    // Active arc
    if (progress > 0.0) {
      final progressPaint = Paint()
        ..color = progressColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      final sweepAngle = 2 * math.pi * progress;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CircularArcPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.progressColor != progressColor;
  }
}
