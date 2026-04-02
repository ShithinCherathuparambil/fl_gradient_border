import 'dart:math' as math;
import 'package:flutter/widgets.dart';

import 'gradient_box_border.dart';

/// A widget that automatically animates a spinning gradient border around its child.
///
/// It uses a [SweepGradient] internally and rotates it endlessly using an
/// embedded [AnimationController], avoiding the need to write boilerplate animation code.
class AnimatedGradientBorder extends StatefulWidget {
  /// The inner widget to wrap with the animated border.
  final Widget child;

  /// The colors to sweep around the border.
  final List<Color> gradientColors;

  /// The thickness of the animated border.
  final double borderWidth;

  /// The corner radius of the border.
  final BorderRadiusGeometry? borderRadius;

  /// The shape of the Box. If circle, [borderRadius] must be null.
  final BoxShape shape;

  /// How long one complete 360-degree rotation takes.
  final Duration animationTime;

  /// A dash pattern to optionally render the animated border as dashes.
  final List<double>? dashPattern;

  /// The stops for the gradient colors.
  final List<double>? stops;

  /// When true, the animated border ring is omitted from the semantics tree so
  /// assistive technologies focus on [child]. The border is decorative motion.
  final bool excludeBorderFromSemantics;

  const AnimatedGradientBorder({
    super.key,
    required this.child,
    required this.gradientColors,
    this.borderWidth = 1.0,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    this.animationTime = const Duration(seconds: 3),
    this.dashPattern,
    this.stops,
    this.excludeBorderFromSemantics = true,
  });

  @override
  State<AnimatedGradientBorder> createState() => _AnimatedGradientBorderState();
}

class _AnimatedGradientBorderState extends State<AnimatedGradientBorder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationTime,
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant AnimatedGradientBorder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animationTime != widget.animationTime) {
      _controller.duration = widget.animationTime;
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final Widget borderLayer = DecoratedBox(
          decoration: BoxDecoration(
            shape: widget.shape,
            borderRadius: widget.borderRadius,
            border: GradientBoxBorder.sweep(
              colors: widget.gradientColors,
              stops: widget.stops,
              width: widget.borderWidth,
              dashPattern: widget.dashPattern,
              transform: GradientRotation(_controller.value * 2 * math.pi),
            ),
          ),
          child: const SizedBox.expand(),
        );

        final Widget decorated = widget.excludeBorderFromSemantics
            ? ExcludeSemantics(child: borderLayer)
            : borderLayer;

        return Stack(
          fit: StackFit.passthrough,
          children: [
            Positioned.fill(child: decorated),
            Padding(
              padding: EdgeInsets.all(widget.borderWidth),
              child: child,
            ),
          ],
        );
      },
      child: widget.child,
    );
  }
}
