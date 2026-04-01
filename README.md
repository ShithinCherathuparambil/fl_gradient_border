# fl_border_gradient

A beautifully engineered Flutter package that empowers you with highly customizable and effortless gradient borders inside `BoxDecoration`, complete with out-of-the-box support for **Dashing**, **Shadow/Glow Syncing**, and **Infinite Animations**.

![Example Image](https://your-image-url.com) *(Add a screenshot here!)*

## Getting Started

Add this package to your `pubspec.yaml`
```yaml
dependencies:
  fl_border_gradient: ^0.0.1
```

Import it in your Dart file:
```dart
import 'package:fl_border_gradient/fl_border_gradient.dart';
```

## Advanced Features

### 1. Animated Spinning Borders
Creating a gradient border that endlessly rotates is incredibly popular but writing animation controllers is tedious. Use the `AnimatedGradientBorder` wrapper for an instant rotating sweep gradient:

```dart
AnimatedGradientBorder(
  gradientColors: const [
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.red,
    Colors.green, // close the loop!
  ],
  borderWidth: 4.0,
  borderRadius: BorderRadius.circular(30),
  animationTime: const Duration(seconds: 4), // 4 seconds per full rotation
  child: Container(
    height: 100,
    decoration: BoxDecoration(
      color: const Color(0xFF1E1E1E),
      borderRadius: BorderRadius.circular(30), // match the border wrapper!
    ),
    // ...
  ),
)
```

### 2. Glowing Gradient Borders
You can cast a perfectly synced, adjustable gradient glow underneath your outer border without writing complex painters.

```dart
GlowingGradientBorder(
  glowSize: 15.0, // Blur radius
  glowOpacity: 0.8,
  borderRadius: BorderRadius.circular(12),
  border: GradientBoxBorder.diagonal(
    colors: const [Colors.redAccent, Colors.purpleAccent],
    width: 3.0,
  ),
  child: Container(
    // ... same borderRadius to match ...
  ),
)
```

### 3. Dashed Gradient Borders
Want to turn any gradient border into a coupon style dashed rim? Simply pass `dashPattern` array:

```dart
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    border: GradientBoxBorder(
      colors: const [Colors.white, Colors.blue],
      width: 3.0,
      dashPattern: const [10.0, 5.0], // 10px solid, 5px gap!
    ),
  ),
  child: ...,
)
```

## Basic Styling Reference

Use the `border:` property inside standard `BoxDecorations`:

### Diagonal Corners
```dart
GradientBoxBorder.diagonal(
  colors: const [Colors.redAccent, Colors.purpleAccent],
  stops: const [0.1, 0.9], // Controls where mixing perfectly starts and stops geometrically!
  width: 4.0,
)
```

### Opposite Corners (Sweeping Effect)
Produces a border where opposite edges seamlessly mirror each other mathematically.
```dart
GradientBoxBorder.opposite(
  colors: const [Colors.amber, Colors.teal],
  width: 3.0,
)
```

## Included Forms
We fully support passing `tileMode` and custom `transform: GradientRotation(...)` overrides to all of the built-in constructors:
- `GradientBoxBorder(...)` for standards-compliant LinearGradients.
- `GradientBoxBorder.diagonal(...)`
- `GradientBoxBorder.opposite(...)`
- `GradientBoxBorder.sweep(...)` manually override sweep values natively.
- `GradientBoxBorder.radial(...)` manually align 2D radial bubbles.
# fl_gradient_border
