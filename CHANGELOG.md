## 1.1.0

* Added `GradientSidesBoxBorder` for gradient strokes on selected edges (all four sides delegate to `GradientBoxBorder`).
* Added `FlBorderGradientTheme` (`ThemeExtension`) for shared default colors, border width, and glow settings.
* `AnimatedGradientBorder`: border painted in a separate layer with `excludeBorderFromSemantics` (default `true`).
* `GlowingGradientBorder`: `excludeGlowFromSemantics` for the glow layer (default `true`).
* Tests: themed borders, per-side border dimensions, `BoxDecoration` with image and border.
* README: theme setup, per-side usage, decoration stacking, and accessibility notes.

## 1.0.1

* Shortened `pubspec.yaml` `description` to meet pub.dev length guidelines (60–180 characters).

## 1.0.0

* Initial release of `fl_border_gradient`.
* Full support for Linear, Sweep, Radial, Diagonal, and Opposite Corner gradients.
* Advanced features: Animated spinning borders, Glowing neon effects, and Dashed/Dotted borders.
* Comprehensive documentation and examples.
* Support for all Flutter platforms (Android, iOS, Web, macOS, Windows, Linux).
