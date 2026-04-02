import 'package:flutter/widgets.dart';

import 'gradient_box_border.dart';

/// A wrapper widget that casts a perfectly synced blurred gradient glow underneath
/// the actual border.
///
/// Because standard [BoxShadow] does not support gradients, this widget uses
/// a [CustomPainter] and [MaskFilter] to cast a shadow that matches your gradient.
class GlowingGradientBorder extends StatelessWidget {
  /// The inner container or widget.
  final Widget child;

  /// The gradient border configuration to use for both the main border
  /// and the casted shadow/glow.
  final GradientBoxBorder border;

  /// Corner radius for the border and glow (should match inner container).
  final BorderRadiusGeometry? borderRadius;

  /// Box shape (rectangle or circle).
  final BoxShape shape;

  /// How far the glow extends away from the border.
  final double glowSize;

  /// How intense the glow is.
  final double glowOpacity;

  /// When true, the glow layer is excluded from the semantics tree.
  final bool excludeGlowFromSemantics;

  const GlowingGradientBorder({
    super.key,
    required this.child,
    required this.border,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    this.glowSize = 8.0,
    this.glowOpacity = 0.5,
    this.excludeGlowFromSemantics = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget glow = CustomPaint(
      painter: _GlowPainter(
        border: border,
        borderRadius: borderRadius,
        shape: shape,
        glowSize: glowSize,
        glowOpacity: glowOpacity,
      ),
    );
    if (excludeGlowFromSemantics) {
      glow = ExcludeSemantics(child: glow);
    }
    return Stack(
      children: [
        Positioned.fill(child: glow),
        Container(
          decoration: BoxDecoration(
            shape: shape,
            borderRadius: borderRadius,
            border: border,
          ),
          child: child,
        ),
      ],
    );
  }
}

class _GlowPainter extends CustomPainter {
  final GradientBoxBorder border;
  final BorderRadiusGeometry? borderRadius;
  final BoxShape shape;
  final double glowSize;
  final double glowOpacity;

  _GlowPainter({
    required this.border,
    required this.borderRadius,
    required this.shape,
    required this.glowSize,
    required this.glowOpacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (glowSize <= 0 || glowOpacity <= 0) return;

    final rect = Offset.zero & size;
    final strokeRect = rect.deflate(border.width / 2);

    final Path path = Path();
    if (shape == BoxShape.circle) {
      path.addOval(strokeRect);
    } else {
      if (borderRadius != null && borderRadius != BorderRadius.zero) {
        path.addRRect(
          borderRadius!.resolve(TextDirection.ltr).toRRect(strokeRect),
        );
      } else {
        path.addRect(strokeRect);
      }
    }

    final Paint paint = Paint()
      ..strokeWidth = border.width + glowSize
      ..style = PaintingStyle.stroke
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowSize)
      ..shader = border.gradient.createShader(rect);

    // Apply global opacity layer
    canvas.saveLayer(
      rect,
      Paint()..color = Color.fromRGBO(255, 255, 255, glowOpacity),
    );
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _GlowPainter oldDelegate) {
    return oldDelegate.border != border ||
        oldDelegate.glowSize != glowSize ||
        oldDelegate.glowOpacity != glowOpacity ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.shape != shape;
  }
}
