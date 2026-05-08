import 'dart:convert';
import 'dart:typed_data';

import 'package:fl_border_gradient/fl_border_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// 1×1 transparent PNG for [MemoryImage] in tests.
final Uint8List _kPng1x1 = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
);

void main() {
  testWidgets(
    'GradientBoxBorder default constructor sets LinearGradient correctly',
    (WidgetTester tester) async {
      final border = GradientBoxBorder(colors: const [Colors.red, Colors.blue]);

      expect(border.dimensions, const EdgeInsets.all(1.0));
      expect(border.gradient, isA<LinearGradient>());
      final gradient = border.gradient as LinearGradient;
      expect(gradient.colors, const [Colors.red, Colors.blue]);
      expect(gradient.begin, Alignment.centerLeft);
      expect(gradient.end, Alignment.centerRight);
    },
  );

  testWidgets('GradientBoxBorder.diagonal creates correct Gradient', (
    WidgetTester tester,
  ) async {
    final border = GradientBoxBorder.diagonal(
      colors: const [Colors.green, Colors.yellow],
      width: 2.0,
    );

    expect(border.dimensions, const EdgeInsets.all(2.0));
    expect(border.gradient, isA<SweepGradient>());
    final gradient = border.gradient as SweepGradient;
    expect(gradient.colors.length, 5);
    expect(gradient.colors.first, Colors.green);
    expect(gradient.colors[1], Colors.yellow);
    expect(gradient.transform, isA<GradientRotation>());
  });

  testWidgets(
    'GradientBoxBorder.diagonal accepts 5 stops for segment control',
    (WidgetTester tester) async {
      final border = GradientBoxBorder.diagonal(
        colors: const [Colors.green, Colors.yellow],
        stops: const [0.0, 0.2, 0.6, 0.85, 1.0],
        width: 2.0,
      );

      expect(border.gradient, isA<SweepGradient>());
      final gradient = border.gradient as SweepGradient;
      expect(gradient.stops, const [0.0, 0.2, 0.6, 0.85, 1.0]);
      expect(gradient.colors.length, 5);
    },
  );

  testWidgets('GradientBoxBorder.diagonal supports colorRatio split', (
    WidgetTester tester,
  ) async {
    final border = GradientBoxBorder.diagonal(
      colors: const [Colors.green, Colors.transparent],
      colorRatio: 0.4,
      width: 2.0,
    );

    expect(border.gradient, isA<SweepGradient>());
    final gradient = border.gradient as SweepGradient;
    expect(gradient.stops, isNotNull);
    final stops = gradient.stops!;
    expect(stops.length, 65);
    expect(stops.first, 0.0);
    expect(stops.last, 1.0);
    expect(gradient.colors.length, 65);
    // Opposite corners should match in periodic ratio mode.
    expect(gradient.colors[0], gradient.colors[32]);
  });

  testWidgets('GradientBoxBorder.diagonal supports crisp ratio edges', (
    WidgetTester tester,
  ) async {
    final border = GradientBoxBorder.diagonal(
      colors: const [Colors.orange, Colors.transparent],
      colorRatio: 0.5,
      mixBand: 0.0,
      width: 2.0,
    );

    final gradient = border.gradient as SweepGradient;
    expect(gradient.stops, isNotNull);
    expect(gradient.stops!.length, 65);
    expect(gradient.colors.first.value, Colors.orange.value);
    expect(gradient.colors[32].value, Colors.orange.value);
  });

  testWidgets('GradientBoxBorder.opposite creates correct SweepGradient', (
    WidgetTester tester,
  ) async {
    final border = GradientBoxBorder.opposite(
      colors: const [Colors.white, Colors.black],
    );

    expect(border.gradient, isA<SweepGradient>());
    final gradient = border.gradient as SweepGradient;
    expect(gradient.colors.length, 5);
    expect(gradient.colors.first, Colors.white);
    expect(gradient.colors[1], Colors.black);
  });

  testWidgets('GradientBoxBorder paints correctly inside BoxDecoration', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                border: GradientBoxBorder(
                  colors: const [Colors.red, Colors.blue],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(Container), findsWidgets);
  });

  testWidgets('GradientSidesBoxBorder partial dimensions', (
    WidgetTester tester,
  ) async {
    final border = GradientSidesBoxBorder(
      gradient: const LinearGradient(colors: [Colors.red, Colors.blue]),
      width: 4,
      includeTop: true,
      includeLeft: true,
    );
    expect(border.dimensions, const EdgeInsets.only(top: 4, left: 4));
    expect(border.isUniform, isFalse);
  });

  testWidgets('GradientSidesBoxBorder full sides is uniform', (
    WidgetTester tester,
  ) async {
    final border = GradientSidesBoxBorder.linear(
      colors: const [Colors.red, Colors.blue],
    );
    expect(border.isUniform, isTrue);
  });

  testWidgets('BoxDecoration image and GradientBoxBorder compose', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: MemoryImage(_kPng1x1),
                  fit: BoxFit.cover,
                ),
                border: GradientBoxBorder(
                  colors: const [Colors.cyan, Colors.indigo],
                  width: 2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('FlBorderGradientTheme.of uses defaults without extension', (
    WidgetTester tester,
  ) async {
    late FlBorderGradientTheme captured;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            captured = FlBorderGradientTheme.of(context);
            return const SizedBox();
          },
        ),
      ),
    );
    expect(captured.defaultBorderWidth, 2.0);
    expect(captured.defaultGradientColors.length, 2);
  });

  testWidgets('FlBorderGradientTheme registered extension', (
    WidgetTester tester,
  ) async {
    const custom = FlBorderGradientTheme(
      defaultBorderWidth: 5,
      defaultGradientColors: [Colors.orange, Colors.pink],
    );
    late FlBorderGradientTheme captured;
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: const [custom]),
        home: Builder(
          builder: (context) {
            captured = FlBorderGradientTheme.of(context);
            return const SizedBox();
          },
        ),
      ),
    );
    expect(captured.defaultBorderWidth, 5.0);
    expect(captured.defaultGradientColors.first, Colors.orange);
  });

  testWidgets('AnimatedGradientBorder pumps', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AnimatedGradientBorder(
            gradientColors: [Colors.red, Colors.blue, Colors.red],
            child: SizedBox(width: 40, height: 40),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(AnimatedGradientBorder), findsOneWidget);
  });

  testWidgets('GlowingGradientBorder pumps', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GlowingGradientBorder(
            border: GradientBoxBorder(
              colors: const [Colors.green, Colors.teal],
            ),
            child: const SizedBox(width: 40, height: 40),
          ),
        ),
      ),
    );
    expect(find.byType(GlowingGradientBorder), findsOneWidget);
  });

  testWidgets('OppositeDirectionalGradientBorder horizontal dimensions', (
    WidgetTester tester,
  ) async {
    const border = OppositeDirectionalGradientBorder(
      colors: [Colors.blue, Colors.transparent],
      width: 2,
      axis: Axis.horizontal,
    );
    expect(border.dimensions, const EdgeInsets.only(top: 2, bottom: 2));
  });

  testWidgets('OppositeDirectionalGradientBorder vertical dimensions', (
    WidgetTester tester,
  ) async {
    const border = OppositeDirectionalGradientBorder(
      colors: [Colors.blue, Colors.transparent],
      width: 3,
      axis: Axis.vertical,
    );
    expect(border.dimensions, const EdgeInsets.only(left: 3, right: 3));
  });

  testWidgets(
    'OppositeDirectionalGradientBorder keeps center alignment on scale',
    (WidgetTester tester) async {
      const border = OppositeDirectionalGradientBorder(
        colors: [Colors.blue, Colors.transparent],
        width: 2,
        axis: Axis.horizontal,
        alignment: BorderGradientAlignment.center,
      );

      final scaled = border.scale(2) as OppositeDirectionalGradientBorder;
      expect(scaled.width, 4);
      expect(scaled.alignment, BorderGradientAlignment.center);
    },
  );

  testWidgets('OppositeDirectionalGradientBorder paints in BoxDecoration', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 120,
              height: 60,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: OppositeDirectionalGradientBorder(
                    colors: [Color(0x990059FF), Color(0x000059FF)],
                    width: 1,
                    axis: Axis.horizontal,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    expect(find.byType(DecoratedBox), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'OppositeDirectionalGradientBorder supports non-zero borderRadius',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 120,
                height: 60,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    border: OppositeDirectionalGradientBorder(
                      colors: [Color(0x990059FF), Color(0x000059FF)],
                      width: 1,
                      axis: Axis.horizontal,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(DecoratedBox), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
