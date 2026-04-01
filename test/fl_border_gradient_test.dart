import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fl_border_gradient/fl_border_gradient.dart';

void main() {
  testWidgets('GradientBoxBorder default constructor sets LinearGradient correctly', (WidgetTester tester) async {
    final border = GradientBoxBorder(
      colors: const [Colors.red, Colors.blue],
    );

    expect(border.dimensions, const EdgeInsets.all(1.0));
    expect(border.gradient, isA<LinearGradient>());
    final gradient = border.gradient as LinearGradient;
    expect(gradient.colors, const [Colors.red, Colors.blue]);
    expect(gradient.begin, Alignment.centerLeft);
    expect(gradient.end, Alignment.centerRight);
  });

  testWidgets('GradientBoxBorder.diagonal creates correct Gradient', (WidgetTester tester) async {
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

  testWidgets('GradientBoxBorder.opposite creates correct SweepGradient', (WidgetTester tester) async {
    final border = GradientBoxBorder.opposite(
      colors: const [Colors.white, Colors.black],
    );

    expect(border.gradient, isA<SweepGradient>());
    final gradient = border.gradient as SweepGradient;
    expect(gradient.colors.length, 5); // To wrap around the sweep
    expect(gradient.colors.first, Colors.white);
    expect(gradient.colors[1], Colors.black);
  });

  testWidgets('GradientBoxBorder paints correctly inside BoxDecoration', (WidgetTester tester) async {
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

    // It should pump without rendering errors
    final containerFinder = find.byType(Container);
    expect(containerFinder, findsWidgets);
  });
}
