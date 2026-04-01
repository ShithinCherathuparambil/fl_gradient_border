import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

/// A [BoxBorder] subclass that allows drawing gradient borders around a [BoxDecoration].
///
/// This provides a flexible way to add gradient colors to your container borders
/// while nicely integrating with Flutter's standard `BoxDecoration` and `BorderRadius`.
class GradientBoxBorder extends BoxBorder {
  /// The underlying gradient used to paint the border.
  final Gradient gradient;

  /// The width (thickness) of the border.
  final double width;

  /// Optional pattern for drawing dashed borders.
  /// E.g., `[5.0, 5.0]` draws a 5px solid line and a 5px gap.
  final List<double>? dashPattern;

  /// Private constructor to accept a fully constructed gradient.
  const GradientBoxBorder.custom({
    required this.gradient,
    this.width = 1.0,
    this.dashPattern,
  });

  /// Default constructor that allows directly passing gradient parameters.
  /// This creates a [LinearGradient] by default for ease of use.
  factory GradientBoxBorder({
    required List<Color> colors,
    List<double>? stops,
    double width = 1.0,
    List<double>? dashPattern,
    AlignmentGeometry begin = Alignment.centerLeft,
    AlignmentGeometry end = Alignment.centerRight,
    TileMode tileMode = TileMode.clamp,
    GradientTransform? transform,
  }) {
    return GradientBoxBorder.custom(
      width: width,
      dashPattern: dashPattern,
      gradient: LinearGradient(
        colors: colors,
        stops: stops,
        begin: begin,
        end: end,
        tileMode: tileMode,
        transform: transform,
      ),
    );
  }

  /// Convenience constructor to create a gradient border drawn across corners.
  /// The first color spans the top-left and bottom-right corners.
  /// The second color spans the top-right and bottom-left corners.
  factory GradientBoxBorder.diagonal({
    required List<Color> colors,
    List<double>? stops,
    double width = 1.0,
    List<double>? dashPattern,
    TileMode tileMode = TileMode.clamp,
  }) {
    assert(
      colors.length >= 2,
      'The diagonal factory constructor requires at least 2 colors.',
    );
    // If exactly 2 colors are provided, we map them to the 4 corners:
    // Color 1: top-left & bottom-right
    // Color 2: top-right & bottom-left
    final Gradient gradient;
    if (colors.length == 2) {
      if (stops != null && stops.length == 2) {
        // Map the 2-point linear stops geometrically across the four corners.
        final s1 = stops[0].clamp(0.0, 1.0);
        final s2 = stops[1].clamp(0.0, 1.0);
        final c1 = colors[0];
        final c2 = colors[1];
        
        gradient = SweepGradient(
          colors: [
            c1, c1, c2, c2,
            c2, c2, c1, c1,
            c1, c1, c2, c2,
            c2, c2, c1, c1,
          ],
          stops: [
            0.0, s1 * 0.25, s2 * 0.25, 0.25,
            0.25, 0.25 + (1 - s2) * 0.25, 0.25 + (1 - s1) * 0.25, 0.50,
            0.50, 0.50 + s1 * 0.25, 0.50 + s2 * 0.25, 0.75,
            0.75, 0.75 + (1 - s2) * 0.25, 0.75 + (1 - s1) * 0.25, 1.0,
          ],
          transform: const GradientRotation(3.1415926535897932 / 4),
          tileMode: tileMode,
        );
      } else {
        // Default perfectly blended 4-corner sweep
        gradient = SweepGradient(
          colors: [
            colors[0],
            colors[1],
            colors[0],
            colors[1],
            colors[0],
          ],
          stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
          transform: const GradientRotation(3.1415926535897932 / 4),
          tileMode: tileMode,
        );
      }
    } else {
      // Fallback for more than 2 colors if needed, just a linear diagonal
      gradient = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colors,
        stops: stops,
        tileMode: tileMode,
      );
    }

    return GradientBoxBorder.custom(
      width: width,
      dashPattern: dashPattern,
      gradient: gradient,
    );
  }

  /// Convenience constructor to create an 'opposite' sweeping gradient border.
  /// It places the first color on opposing corners/sides and the second color
  /// on the other opposing corners/sides.
  factory GradientBoxBorder.opposite({
    required List<Color> colors,
    List<double>? stops,
    double width = 1.0,
    List<double>? dashPattern,
    TileMode tileMode = TileMode.clamp,
    GradientTransform? transform,
  }) {
    assert(
      colors.length == 2,
      'The opposite factory constructor requires exactly 2 colors.',
    );
    return GradientBoxBorder.custom(
      width: width,
      dashPattern: dashPattern,
      gradient: SweepGradient(
        colors: [
          colors[0],
          colors[1],
          colors[0],
          colors[1],
          colors[0],
        ],
        stops: stops ?? const [0.0, 0.25, 0.5, 0.75, 1.0],
        tileMode: tileMode,
        transform: transform,
      ),
    );
  }

  /// Convenience constructor to create a RadialGradient border.
  factory GradientBoxBorder.radial({
    required List<Color> colors,
    List<double>? stops,
    double width = 1.0,
    List<double>? dashPattern,
    AlignmentGeometry center = Alignment.center,
    double radius = 0.5,
    TileMode tileMode = TileMode.clamp,
    AlignmentGeometry? focal,
    double focalRadius = 0.0,
    GradientTransform? transform,
  }) {
    return GradientBoxBorder.custom(
      width: width,
      dashPattern: dashPattern,
      gradient: RadialGradient(
        colors: colors,
        stops: stops,
        center: center,
        radius: radius,
        tileMode: tileMode,
        focal: focal,
        focalRadius: focalRadius,
        transform: transform,
      ),
    );
  }

  /// Convenience constructor to create a typical SweepGradient border.
  factory GradientBoxBorder.sweep({
    required List<Color> colors,
    List<double>? stops,
    double width = 1.0,
    List<double>? dashPattern,
    AlignmentGeometry center = Alignment.center,
    double startAngle = 0.0,
    double endAngle = 3.1415926535897932 * 2, // math.pi * 2
    TileMode tileMode = TileMode.clamp,
    GradientTransform? transform,
  }) {
    return GradientBoxBorder.custom(
      width: width,
      dashPattern: dashPattern,
      gradient: SweepGradient(
        colors: colors,
        stops: stops,
        center: center,
        startAngle: startAngle,
        endAngle: endAngle,
        tileMode: tileMode,
        transform: transform,
      ),
    );
  }

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(width);

  @override
  bool get isUniform => true;

  @override
  BorderSide get top => BorderSide(width: width, color: const Color(0x00000000));

  @override
  BorderSide get bottom => BorderSide(width: width, color: const Color(0x00000000));

  @override
  ShapeBorder scale(double t) {
    return GradientBoxBorder.custom(
      gradient: gradient,
      width: width * t,
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
    if (isUniform) {
      if (dashPattern != null && dashPattern!.isNotEmpty) {
        _paintDashed(canvas, rect, shape, borderRadius);
      } else {
        switch (shape) {
          case BoxShape.circle:
            assert(
              borderRadius == null,
              'A borderRadius can only be given for rectangular boxes.',
            );
            _paintCircle(canvas, rect);
            break;
          case BoxShape.rectangle:
            if (borderRadius != null && borderRadius != BorderRadius.zero) {
              _paintRRect(canvas, rect, borderRadius);
            } else {
              _paintRect(canvas, rect);
            }
            break;
        }
      }
    }
  }

  void _paintDashed(
    Canvas canvas,
    Rect rect,
    BoxShape shape,
    BorderRadius? borderRadius,
  ) {
    final Path path = Path();
    
    // Inflate slightly because stroke paints centered on the path
    final Rect strokeRect = rect.deflate(width / 2);

    if (shape == BoxShape.circle) {
      path.addOval(strokeRect);
    } else {
      if (borderRadius != null && borderRadius != BorderRadius.zero) {
        path.addRRect(borderRadius.toRRect(strokeRect));
      } else {
        path.addRect(strokeRect);
      }
    }

    final Paint paint = Paint()
      ..strokeWidth = width
      ..style = PaintingStyle.stroke
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
      draw = true; // reset draw for next contour
    }
  }

  void _paintCircle(Canvas canvas, Rect rect) {
    final double radius = (rect.shortestSide - width) / 2.0;
    final Paint paint = Paint()
      ..strokeWidth = width
      ..style = PaintingStyle.stroke
      ..shader = gradient.createShader(rect);

    canvas.drawCircle(rect.center, radius, paint);
  }

  void _paintRect(Canvas canvas, Rect rect) {
    final Rect inner = rect.deflate(width);
    final Paint paint = Paint()..shader = gradient.createShader(rect);

    canvas.drawDRRect(
      RRect.fromRectAndRadius(rect, Radius.zero),
      RRect.fromRectAndRadius(inner, Radius.zero),
      paint,
    );
  }

  void _paintRRect(Canvas canvas, Rect rect, BorderRadius borderRadius) {
    final RRect outer = borderRadius.toRRect(rect);
    final RRect inner = outer.deflate(width);
    final Paint paint = Paint()..shader = gradient.createShader(rect);

    canvas.drawDRRect(outer, inner, paint);
  }
}
