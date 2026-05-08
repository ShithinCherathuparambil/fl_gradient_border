import 'package:flutter/widgets.dart';

/// Controls where the strongest gradient colors are anchored.
enum BorderGradientAlignment {
  /// Anchor at the start side (left for horizontal, top for vertical).
  start,

  /// Anchor at the center and mirror toward both ends.
  center,

  /// Anchor at the end side (right for horizontal, bottom for vertical).
  end,
}

/// Draws two opposite-side gradient accents with mirrored direction.
///
/// Use [axis] to select which opposite edges are painted:
/// - [Axis.horizontal] => top + bottom
/// - [Axis.vertical] => left + right
///
/// The second side can reverse direction via [reverseSecondSide], which creates
/// the "opposite directional" look.
class OppositeDirectionalGradientBorder extends BoxBorder {
  const OppositeDirectionalGradientBorder({
    required this.colors,
    this.stops,
    this.width = 1.0,
    this.axis = Axis.horizontal,
    this.alignment = BorderGradientAlignment.start,
    this.reverseSecondSide = true,
    this.tileMode = TileMode.clamp,
    this.transform,
  });

  final List<Color> colors;
  final List<double>? stops;
  final double width;
  final Axis axis;
  final BorderGradientAlignment alignment;
  final bool reverseSecondSide;
  final TileMode tileMode;
  final GradientTransform? transform;

  @override
  EdgeInsetsGeometry get dimensions => axis == Axis.horizontal
      ? EdgeInsets.only(top: width, bottom: width)
      : EdgeInsets.only(left: width, right: width);

  @override
  bool get isUniform => false;

  @override
  BorderSide get top => BorderSide(
    width: axis == Axis.horizontal ? width : 0,
    color: const Color(0x00000000),
  );

  @override
  BorderSide get bottom => BorderSide(
    width: axis == Axis.horizontal ? width : 0,
    color: const Color(0x00000000),
  );

  @override
  ShapeBorder scale(double t) {
    return OppositeDirectionalGradientBorder(
      colors: colors,
      stops: stops,
      width: width * t,
      axis: axis,
      alignment: alignment,
      reverseSecondSide: reverseSecondSide,
      tileMode: tileMode,
      transform: transform,
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
    assert(colors.length >= 2, 'At least 2 colors are required.');
    assert(
      shape == BoxShape.rectangle,
      'OppositeDirectionalGradientBorder supports BoxShape.rectangle only.',
    );

    if (axis == Axis.horizontal) {
      _paintHorizontal(canvas, rect, textDirection, borderRadius);
    } else {
      _paintVertical(canvas, rect, textDirection, borderRadius);
    }
  }

  LinearGradient _gradient(bool reverse) {
    final _ResolvedGradientData data = _resolveGradientData(reverse);
    return LinearGradient(
      begin: reverse ? Alignment.centerRight : Alignment.centerLeft,
      end: reverse ? Alignment.centerLeft : Alignment.centerRight,
      colors: data.colors,
      stops: data.stops,
      tileMode: tileMode,
      transform: transform,
    );
  }

  _ResolvedGradientData _resolveGradientData(bool reverse) {
    final List<Color> baseColors = reverse
        ? colors.reversed.toList(growable: false)
        : List<Color>.from(colors, growable: false);

    final bool hasValidStops = stops != null && stops!.length == colors.length;
    final List<double>? baseStops = hasValidStops
        ? (reverse
              ? stops!.reversed.toList(growable: false)
              : List<double>.from(stops!, growable: false))
        : null;

    switch (alignment) {
      case BorderGradientAlignment.start:
        return _ResolvedGradientData(baseColors, baseStops);
      case BorderGradientAlignment.end:
        return _ResolvedGradientData(
          baseColors.reversed.toList(growable: false),
          baseStops?.reversed.toList(growable: false),
        );
      case BorderGradientAlignment.center:
        final List<Color> centeredColors = [
          ...baseColors.reversed,
          ...baseColors.skip(1),
        ];
        List<double>? centeredStops;
        if (baseStops != null) {
          centeredStops = [
            ...baseStops.reversed.map((s) => 0.5 * (1 - s)),
            ...baseStops.skip(1).map((s) => 0.5 + (0.5 * s)),
          ];
        }
        return _ResolvedGradientData(centeredColors, centeredStops);
    }
  }

  void _paintHorizontal(
    Canvas canvas,
    Rect rect,
    TextDirection? textDirection,
    BorderRadius? borderRadius,
  ) {
    final Rect topRect = Rect.fromLTWH(rect.left, rect.top, rect.width, width);
    final Rect bottomRect = Rect.fromLTWH(
      rect.left,
      rect.bottom - width,
      rect.width,
      width,
    );

    final Paint topPaint = Paint()
      ..shader = _gradient(false).createShader(topRect);
    final Paint bottomPaint = Paint()
      ..shader = _gradient(reverseSecondSide).createShader(bottomRect);

    if (borderRadius != null && borderRadius != BorderRadius.zero) {
      final RRect clipRRect = borderRadius.resolve(textDirection).toRRect(rect);
      canvas.save();
      canvas.clipRRect(clipRRect);
      canvas.drawRect(topRect, topPaint);
      canvas.drawRect(bottomRect, bottomPaint);
      canvas.restore();
      return;
    }

    canvas.drawRect(topRect, topPaint);
    canvas.drawRect(bottomRect, bottomPaint);
  }

  void _paintVertical(
    Canvas canvas,
    Rect rect,
    TextDirection? textDirection,
    BorderRadius? borderRadius,
  ) {
    final Rect leftRect = Rect.fromLTWH(
      rect.left,
      rect.top,
      width,
      rect.height,
    );
    final Rect rightRect = Rect.fromLTWH(
      rect.right - width,
      rect.top,
      width,
      rect.height,
    );

    final _ResolvedGradientData firstData = _resolveGradientData(false);
    final _ResolvedGradientData secondData = _resolveGradientData(
      reverseSecondSide,
    );

    final LinearGradient first = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: firstData.colors,
      stops: firstData.stops,
      tileMode: tileMode,
      transform: transform,
    );
    final LinearGradient second = LinearGradient(
      begin: reverseSecondSide ? Alignment.bottomCenter : Alignment.topCenter,
      end: reverseSecondSide ? Alignment.topCenter : Alignment.bottomCenter,
      colors: secondData.colors,
      stops: secondData.stops,
      tileMode: tileMode,
      transform: transform,
    );

    final Paint leftPaint = Paint()..shader = first.createShader(leftRect);
    final Paint rightPaint = Paint()..shader = second.createShader(rightRect);

    if (borderRadius != null && borderRadius != BorderRadius.zero) {
      final RRect clipRRect = borderRadius.resolve(textDirection).toRRect(rect);
      canvas.save();
      canvas.clipRRect(clipRRect);
      canvas.drawRect(leftRect, leftPaint);
      canvas.drawRect(rightRect, rightPaint);
      canvas.restore();
      return;
    }

    canvas.drawRect(leftRect, leftPaint);
    canvas.drawRect(rightRect, rightPaint);
  }
}

class _ResolvedGradientData {
  const _ResolvedGradientData(this.colors, this.stops);

  final List<Color> colors;
  final List<double>? stops;
}
