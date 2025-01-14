import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taxhavistan/dialogs/how_to_play_dialog.dart';
import 'package:taxhavistan/widgets/app_bar_mobile.dart';
import 'package:taxhavistan/widgets/custom_button.dart';
import 'package:taxhavistan/widgets/footer_mobile.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({super.key});

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  void _openDialog(Widget dialog) {
    showDialog(
      context: context,
      builder: (_) => dialog,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF86b9e1),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/back_mobile.png',
                fit: BoxFit.cover, // Cover entire container
              ),
            ),
            // Transparent Grid Overlay
            Positioned.fill(
              child: CustomPaint(
                painter: _RetroGridPainter(), // Paint the grid
              ),
            ),
            // App Bar
            AppBarMobile(),
            // Footer
            FooterMobile(),

            // Informational Message
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Container(
                  width: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF704214),
                        offset: const Offset(-5, 5),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: Color(0xFF86aed1), // Use determined button color
                      border: Border.all(color: Colors.black54, width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "This game is only available on Desktop Browsers.",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: "Audiowide",
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        CustomButton(
                          icon: FontAwesomeIcons.gamepad,
                          label: "How to Play?",
                          color: const Color(0xFF679a7d),
                          onTap: () => _openDialog(
                            const HowToPlay(
                              widthRes: 0.9,
                              heightRes: 0.8,
                            ),
                          ),
                          fontSize: 10.0,
                          iconSize: 12.0,
                        ),
                      ],
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
