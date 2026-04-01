# fl_border_gradient

[![pub package](https://img.shields.io/badge/pub-v1.0.0-blue.svg)](https://pub.dev/packages/fl_border_gradient)
[![license](https://img.shields.io/badge/license-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![platform](https://img.shields.io/badge/platform-android%20|%20ios%20|%20web%20|%20macos%20|%20windows%20|%20linux-blue.svg)](https://flutter.dev)

A powerful and flexible Flutter package for creating stunning gradient borders for Containers and other widgets. Supports linear, diagonal, sweeping, and radial gradients with advanced features like **animations**, **glowing effects**, and **dashed borders**.

---

## 🎨 Features

*   **Customizable Gradients**: Linear, Sweep, Radial, Diagonal, and Opposite corners.
*   **Animated Borders**: Create spinning gradient effects with just one widget.
*   **Glowing Effects**: Add a perfectly synced blurred glow underneath your gradient borders.
*   **Dashed Borders**: Support for dashed and dotted borders with gradient flow.
*   **Universal Compatibility**: Works with `BoxDecoration`, `BorderRadius`, and all shapes (Rectangle, Circle).

---

## 🚀 Getting Started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  fl_border_gradient: ^1.0.0
```

Import the package:

```dart
import 'package:fl_border_gradient/fl_border_gradient.dart';
```

---

## 📖 Usage Examples

### 1. Standard Linear Border
The most straightforward way to add a gradient border to any `BoxDecoration`.

![Linear Border](https://raw.githubusercontent.com/ShithinCherathuparambil/fl_gradient_border/main/assets/Linear%20Border.png)

```dart
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    border: GradientBoxBorder(
      colors: const [Color(0xFFFFFFFF), Color(0xFF639AFF)],
      stops: const [0.0, 1.0],
      tileMode: TileMode.mirror,
      width: 2.0,
    ),
  ),
  child: Center(child: Text("Linear Border")),
)
```

### 2. Diagonal Border
A specialized constructor that aligns colors to opposing corners (Top-Left to Bottom-Right and Top-Right to Bottom-Left).

![Diagonal Border](https://raw.githubusercontent.com/ShithinCherathuparambil/fl_gradient_border/main/assets/Diagonal%20Border.png)

```dart
Container(
  decoration: BoxDecoration(
    border: GradientBoxBorder.diagonal(
      colors: const [Colors.redAccent, Colors.purpleAccent],
      stops: const [0.5, 0.9], // Controls where mixing starts/stops!
      width: 1,
    ),
  ),
)
```

### 3. Opposite Corners Border
Creates a sweeping effect where opposite edges mirror each other.

![Opposite Border](https://raw.githubusercontent.com/ShithinCherathuparambil/fl_gradient_border/main/assets/Oppostie%20Cornera%20Border.png)

```dart
Container(
  decoration: BoxDecoration(
    border: GradientBoxBorder.opposite(
      colors: const [Colors.amber, Colors.teal],
      width: 3.0,
    ),
  ),
)
```

### 4. Radial & Sweep Borders
Full support for standard Flutter radial and sweep shapes.

| Radial Border | Standard Sweep |
| :---: | :---: |
| ![Radial](https://raw.githubusercontent.com/ShithinCherathuparambil/fl_gradient_border/main/assets/Radial%20Border.png) | ![Sweep](https://raw.githubusercontent.com/ShithinCherathuparambil/fl_gradient_border/main/assets/Standard%20Sweep%20Color.png) |

```dart
// Radial
GradientBoxBorder.radial(
  colors: const [Colors.orange, Colors.deepOrange],
  radius: 0.8,
)

// Sweep
GradientBoxBorder.sweep(
  colors: const [Colors.blue, Colors.green, Colors.yellow, Colors.red, Colors.blue],
  width: 3.0,
)
```

### 5. Dashed Borders
Add a `dashPattern` to any `GradientBoxBorder`.

![Dashed Border](https://raw.githubusercontent.com/ShithinCherathuparambil/fl_gradient_border/main/assets/Dashed%20Linera%20Border.png)

```dart
GradientBoxBorder(
  colors: const [Colors.white, Colors.blue],
  width: 3.0,
  dashPattern: const [10.0, 5.0], // 10px dash, 5px gap
)
```

---

## ✨ Advanced Features

### Animated Spinning Border
Use the `AnimatedGradientBorder` widget to add an infinite spinning effect.

![Animated Border](https://raw.githubusercontent.com/ShithinCherathuparambil/fl_gradient_border/main/assets/Animated%20Spinning%20Border.png)

```dart
AnimatedGradientBorder(
  gradientColors: const [Colors.green, Colors.blue, Colors.purple, Colors.red, Colors.green],
  borderWidth: 4.0,
  borderRadius: BorderRadius.circular(30),
  animationTime: const Duration(seconds: 4),
  child: Container( /* ... */ ),
)
```

### Glowing Gradient Border
Add a neon-style glow effect that matches your gradient perfectly.

![Glowing Border](https://raw.githubusercontent.com/ShithinCherathuparambil/fl_gradient_border/main/assets/Glowing%20Gradient%20Border.png)

```dart
GlowingGradientBorder(
  glowSize: 15.0,
  glowOpacity: 0.8,
  borderRadius: BorderRadius.circular(12),
  border: GradientBoxBorder.diagonal(
    colors: const [Colors.redAccent, Colors.purpleAccent],
    width: 3.0,
  ),
  child: Container( /* ... */ ),
)
```

---

## 🏗️ Shape Support
Built-in support for `BoxShape.circle` and high `BorderRadius` values.

![Circle Support](https://raw.githubusercontent.com/ShithinCherathuparambil/fl_gradient_border/main/assets/Circle%20Shape%20Support.png)

---

## 📜 MIT License

Copyright (c) 2026 Shithin Cp

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

---

Made with ❤️ by [Shithin Cp](https://github.com/shithin)
