import 'package:flutter/material.dart';
import 'package:taxhavistan/widgets/app_bar.dart';
import 'package:taxhavistan/widgets/custom_button.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/back.png',
              fit: BoxFit.cover, // Cover entire container
            ),
          ),
          // Transparent Grid Overlay
          Positioned.fill(
            child: CustomPaint(
              painter: _RetroGridPainter(), // Paint the grid
            ),
          ),
          Positioned(
            top: 0, // Place at the top of the screen
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Isla Solara",
                      style: const TextStyle(
                        fontFamily: "Nabla",
                        fontWeight: FontWeight.w900,
                        fontSize: 36.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          CustomAppBar(),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  icon: Icons.map_rounded,
                  color: const Color(0xFF269b4b),
                  label: "Claim Land",
                  onTap: () {
                    context.go('/map');
                  },
                  fontSize: 16.0,
                  iconSize: 20.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RetroGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withAlpha(25)
      ..strokeWidth = 0.5;

    const gridSpacing = 15.0;

    for (double x = 0; x <= size.width; x += gridSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += gridSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
