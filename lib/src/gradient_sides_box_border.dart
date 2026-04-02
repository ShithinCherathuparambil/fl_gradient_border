import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

import 'gradient_box_border.dart';

/// A [BoxBorder] that draws a [Gradient] on only the selected sides of a box.
///
/// When all four sides are enabled, painting delegates to [GradientBoxBorder]
/// so circles, rounded rectangles, and dashed borders behave the same.
///
/// **Partial sides** (any subset other than all four) are supported for
/// [BoxShape.rectangle] with [BorderRadius.zero] only. For a full gradient
/// frame on rounded shapes, use [GradientBoxBorder] instead.
class GradientSidesBoxBorder extends BoxBorder {
  /// Creates a border that draws [gradient] on the sides set to true.
  ///
  /// At least one of [includeTop], [includeRight], [includeBottom], or
  /// [includeLeft] must be true.
  const GradientSidesBoxBorder({
    required this.gradient,
    this.width = 1.0,
    this.includeTop = false,
    this.includeRight = false,
    this.includeBottom = false,
    this.includeLeft = false,
    this.dashPattern,
  }) : assert(
          includeTop || includeRight || includeBottom || includeLeft,
          'At least one side must be included.',
        );

  /// Same parameters as [GradientBoxBorder] factory, plus per-side flags.
  factory GradientSidesBoxBorder.linear({
    required List<Color> colors,
    List<double>? stops,
    double width = 1.0,
    bool includeTop = true,
    bool includeRight = true,
    bool includeBottom = true,
    bool includeLeft = true,
    List<double>? dashPattern,
    AlignmentGeometry begin = Alignment.centerLeft,
    AlignmentGeometry end = Alignment.centerRight,
    TileMode tileMode = TileMode.clamp,
    GradientTransform? transform,
  }) {
    return GradientSidesBoxBorder(
      gradient: LinearGradient(
        colors: colors,
        stops: stops,
        begin: begin,
        end: end,
        tileMode: tileMode,
        transform: transform,
      ),
      width: width,
      includeTop: includeTop,
      includeRight: includeRight,
      includeBottom: includeBottom,
      includeLeft: includeLeft,
      dashPattern: dashPattern,
    );
  }

  final Gradient gradient;
  final double width;
  final bool includeTop;
  final bool includeRight;
  final bool includeBottom;
  final bool includeLeft;
  final List<double>? dashPattern;

  bool get _allSides =>
      includeTop && includeRight && includeBottom && includeLeft;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(
        top: includeTop ? width : 0,
        right: includeRight ? width : 0,
        bottom: includeBottom ? width : 0,
        left: includeLeft ? width : 0,
      );

  @override
  bool get isUniform => _allSides;

  @override
  BorderSide get top => BorderSide(
        width: includeTop ? width : 0,
        color: const Color(0x00000000),
      );

  @override
  BorderSide get bottom => BorderSide(
        width: includeBottom ? width : 0,
        color: const Color(0x00000000),
      );

  @override
  ShapeBorder scale(double t) {
    return GradientSidesBoxBorder(
      gradient: gradient,
      width: width * t,
      includeTop: includeTop,
      includeRight: includeRight,
      includeBottom: includeBottom,
      includeLeft: includeLeft,
      dashPattern: dashPattern?.map((e) => e * t).toList(),
    );
  }

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    TextDirection? textDirection,
    BoxShape shape = BoxShape.rectangle,
    BorderRadius? borderRadius,
  }) {
    if (_allSides) {
      GradientBoxBorder.custom(
        gradient: gradient,
        width: width,
        dashPattern: dashPattern,
      ).paint(
        canvas,
        rect,
        textDirection: textDirection,
        shape: shape,
        borderRadius: borderRadius,
      );
      return;
    }

    assert(
      shape == BoxShape.rectangle,
      'GradientSidesBoxBorder with partial sides requires BoxShape.rectangle.',
    );
    assert(
      borderRadius == null || borderRadius == BorderRadius.zero,
      'GradientSidesBoxBorder with partial sides requires BorderRadius.zero.',
    );

    if (dashPattern != null && dashPattern!.isNotEmpty) {
      _paintPartialDashed(canvas, rect);
    } else {
      _paintPartialSolid(canvas, rect);
    }
  }

  void _paintPartialSolid(Canvas canvas, Rect rect) {
    final Paint paint = Paint()..shader = gradient.createShader(rect);
    if (includeTop) {
      canvas.drawRect(
        Rect.fromLTWH(rect.left, rect.top, rect.width, width),
        paint,
      );
    }
    if (includeBottom) {
      canvas.drawRect(
        Rect.fromLTWH(rect.left, rect.bottom - width, rect.width, width),
        paint,
      );
    }
    final double leftTopInset = includeTop ? width : 0;
    final double leftBottomInset = includeBottom ? width : 0;
    if (includeLeft) {
      canvas.drawRect(
        Rect.fromLTWH(
          rect.left,
          rect.top + leftTopInset,
          width,
          rect.height - leftTopInset - leftBottomInset,
        ),
        paint,
      );
    }
    if (includeRight) {
      canvas.drawRect(
        Rect.fromLTWH(
          rect.right - width,
          rect.top + leftTopInset,
          width,
          rect.height - leftTopInset - leftBottomInset,
        ),
        paint,
      );
    }
  }

  void _paintPartialDashed(Canvas canvas, Rect rect) {
    final double inset = width / 2;
    final double l = rect.left + inset;
    final double r = rect.right - inset;
    final double t = rect.top + inset;
    final double b = rect.bottom - inset;

    final Path path = Path();
    void addOpenSide(Offset from, Offset to) {
      path.moveTo(from.dx, from.dy);
      path.lineTo(to.dx, to.dy);
    }

    if (includeTop) {
      addOpenSide(Offset(l, t), Offset(r, t));
    }
    if (includeRight) {
      addOpenSide(Offset(r, t), Offset(r, b));
    }
    if (includeBottom) {
      addOpenSide(Offset(r, b), Offset(l, b));
    }
    if (includeLeft) {
      addOpenSide(Offset(l, b), Offset(l, t));
    }

    final Paint paint = Paint()
      ..strokeWidth = width
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square
      ..shader = gradient.createShader(rect);

    bool draw = true;
    double currentDistance = 0.0;
    int patternIndex = 0;

    for (final ui.PathMetric metric in path.computeMetrics()) {
      while (currentDistance < metric.length) {
        final double dashLength = dashPattern![patternIndex];
        if (draw) {
          canvas.drawPath(
            metric.extractPath(currentDistance, currentDistance + dashLength),
            paint,
          );
        }
        currentDistance += dashLength;
        draw = !draw;
        patternIndex = (patternIndex + 1) % dashPattern!.length;
      }
      currentDistance = 0.0;
      patternIndex = 0;
      draw = true;
    }
  }
}
