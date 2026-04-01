import 'package:flutter/material.dart';
import 'package:fl_border_gradient/fl_border_gradient.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gradient Border Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ExamplePage(),
    );
  }
}

class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('fl_border_gradient'),
        backgroundColor: const Color(0xFF1E1E1E),
        scrolledUnderElevation: 0,
        surfaceTintColor: const Color(0xFF1E1E1E),
      ),
      backgroundColor: const Color(0xFF1E1E1E), // Dark background
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSection(
              title: "Linear Border (Requested Style)",
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2C),
                  borderRadius: BorderRadius.circular(20),
                  border: GradientBoxBorder(
                    colors: const [Color(0xFFFFFFFF), Color(0xFF639AFF)],
                    stops: const [0.0, 1.0],
                    tileMode: TileMode.mirror,
                    width: 2.0,
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Standard Linear Border",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: "Diagonal Border (With Mixing Stops)",
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2C),
                  borderRadius: BorderRadius.circular(12),
                  border: GradientBoxBorder.diagonal(
                    colors: const [Colors.redAccent, Colors.transparent],
                    stops: const [
                      0.5,
                      0.9,
                    ], // Controls where mixing starts/stops!
                    width: 1,
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Diagonal Flow (Sharp Corners)",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: "Opposite Corners Border",
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2C),
                  borderRadius: BorderRadius.circular(30),
                  border: GradientBoxBorder.opposite(
                    colors: const [Colors.amber, Colors.teal],
                    width: 3.0,
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Sweeping Opposite Effects",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: "Radial Border",
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2C),
                  borderRadius: BorderRadius.circular(20),
                  border: GradientBoxBorder.radial(
                    colors: const [Colors.orange, Colors.deepOrange],
                    radius: 0.8,
                    width: 3.0,
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Radial Focus",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: "Standard Sweep Border",
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2C),
                  borderRadius: BorderRadius.circular(20),
                  border: GradientBoxBorder.sweep(
                    colors: const [
                      Colors.blue,
                      Colors.green,
                      Colors.yellow,
                      Colors.red,
                      Colors.blue
                    ],
                    width: 3.0,
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Multi-Color Sweep",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: "Dashed Linear Border",
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2C),
                  borderRadius: BorderRadius.circular(20),
                  border: GradientBoxBorder(
                    colors: const [Colors.white, Colors.blue],
                    width: 3.0,
                    dashPattern: const [10.0, 5.0], // 10px dash, 5px gap!
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Dashed Support",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: "Glowing Gradient Border",
              child: GlowingGradientBorder(
                glowSize: 15.0,
                glowOpacity: 0.8,
                borderRadius: BorderRadius.circular(12),
                border: GradientBoxBorder.diagonal(
                  colors: const [Colors.redAccent, Colors.purpleAccent],
                  width: 3.0,
                ),
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2C),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      "Neon Glow!",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildSection(
              title: "Animated Spinning Border",
              child: AnimatedGradientBorder(
                gradientColors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.purple,
                  Colors.red,
                  Colors.green,
                ],
                borderWidth: 4.0,
                borderRadius: BorderRadius.circular(30),
                animationTime: const Duration(seconds: 4),
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(
                    child: Text(
                      "Spinning Magic",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}
