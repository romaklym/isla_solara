import 'package:flutter/material.dart';
import 'package:flutter_gradient_animation_text/flutter_gradient_animation_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taxhavistan/widgets/footer.dart';
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
      backgroundColor: const Color(0xFF86b9e1),
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

          Footer(),

          Center(
            // Use Center to position the Column in the middle of the screen
            child: Column(
              mainAxisSize: MainAxisSize.min, // Minimize height of the Column
              children: [
                GradientAnimationText(
                  text: Text(
                    "Own the \$LAND. Earn the Rewards.",
                    style: TextStyle(
                      fontFamily: "Audiowide",
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  duration: const Duration(seconds: 10), // Animation duration
                  colors: const [
                    Colors.greenAccent,
                    Colors.lightBlueAccent,
                    Colors.purpleAccent,
                    Colors.pinkAccent,
                    Colors.yellowAccent,
                  ],
                ),
                const SizedBox(height: 8.0),
                GradientAnimationText(
                  text: Text(
                    "Claim land, earn passive income, and compete for the ultimate prize pool.",
                    style: TextStyle(
                      fontFamily: "Audiowide",
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  duration: const Duration(seconds: 10), // Animation duration
                  colors: const [
                    Color(0xFF006992),
                    Color(0xFF298AAA),
                    Color(0xFF51ACC2),
                    Color(0xFF7ACDDA),
                    Color(0xFFA2EEF2),
                  ],
                ),
                const SizedBox(height: 32.0),
                CustomButton(
                  icon: FontAwesomeIcons.mapLocationDot,
                  color: const Color(0xFFe85229),
                  label: "View Map",
                  onTap: () {
                    context.go('/map');
                  },
                  fontSize: 20.0,
                  iconSize: 24.0,
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
      ..color = Colors.black.withValues(alpha: 0.1)
      ..strokeWidth = 0.5;

    const gridSpacing = 20.0;

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
