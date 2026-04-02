import 'package:flutter/material.dart';

/// Theme defaults for [fl_border_gradient](https://pub.dev/packages/fl_border_gradient)
/// widgets, applied via [ThemeData.extensions].
///
/// Register in your app theme:
///
/// ```dart
/// MaterialApp(
///   theme: ThemeData(
///     extensions: const [
///       FlBorderGradientTheme(),
///     ],
///   ),
/// );
/// ```
@immutable
class FlBorderGradientTheme extends ThemeExtension<FlBorderGradientTheme> {
  const FlBorderGradientTheme({
    this.defaultGradientColors = const [
      Color(0xFF6366F1),
      Color(0xFFA855F7),
    ],
    this.defaultBorderWidth = 2.0,
    this.defaultGlowSize = 8.0,
    this.defaultGlowOpacity = 0.5,
  });

  /// Default two-stop palette for themed borders and animated borders.
  final List<Color> defaultGradientColors;

  /// Default stroke width for borders.
  final double defaultBorderWidth;

  /// Default blur extent for [GlowingGradientBorder].
  final double defaultGlowSize;

  /// Default glow layer opacity for [GlowingGradientBorder].
  final double defaultGlowOpacity;

  /// Resolved theme, or [FlBorderGradientTheme] defaults if none is registered.
  static FlBorderGradientTheme of(BuildContext context) {
    return Theme.of(context).extension<FlBorderGradientTheme>() ??
        const FlBorderGradientTheme();
  }

  /// Registered extension, or null.
  static FlBorderGradientTheme? maybeOf(BuildContext context) {
    return Theme.of(context).extension<FlBorderGradientTheme>();
  }

  @override
  FlBorderGradientTheme copyWith({
    List<Color>? defaultGradientColors,
    double? defaultBorderWidth,
    double? defaultGlowSize,
    double? defaultGlowOpacity,
  }) {
    return FlBorderGradientTheme(
      defaultGradientColors: defaultGradientColors ?? this.defaultGradientColors,
      defaultBorderWidth: defaultBorderWidth ?? this.defaultBorderWidth,
      defaultGlowSize: defaultGlowSize ?? this.defaultGlowSize,
      defaultGlowOpacity: defaultGlowOpacity ?? this.defaultGlowOpacity,
    );
  }

  @override
  FlBorderGradientTheme lerp(
    ThemeExtension<FlBorderGradientTheme>? other,
    double t,
  ) {
    if (other is! FlBorderGradientTheme) {
      return this;
    }
    final List<Color> a = defaultGradientColors;
    final List<Color> b = other.defaultGradientColors;
    final int n = a.length < b.length ? a.length : b.length;
    if (n == 0) {
      return t < 0.5 ? this : other;
    }
    final List<Color> lerped = List<Color>.generate(
      n,
      (int i) => Color.lerp(a[i], b[i], t)!,
      growable: false,
    );
    return FlBorderGradientTheme(
      defaultGradientColors: lerped,
      defaultBorderWidth:
          defaultBorderWidth + (other.defaultBorderWidth - defaultBorderWidth) * t,
      defaultGlowSize:
          defaultGlowSize + (other.defaultGlowSize - defaultGlowSize) * t,
      defaultGlowOpacity:
          defaultGlowOpacity + (other.defaultGlowOpacity - defaultGlowOpacity) * t,
    );
  }
}
