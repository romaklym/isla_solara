import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taxhavistan/widgets/footer.dart';
import 'package:taxhavistan/widgets/custom_button.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

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
                RichText(
                  text: TextSpan(
                    text: "Own the ",
                    style: const TextStyle(
                      fontFamily: "Audiowide",
                      fontWeight: FontWeight.w900,
                      fontSize: 28.0,
                      color: Color(0xFF2f124a),
                    ),
                    children: [
                      TextSpan(
                        text: "\$LAND",
                        style: const TextStyle(
                          color:
                              Color(0xFF61821C), // Highlight the clickable text
                          decoration:
                              TextDecoration.underline, // Optional underline
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            const url =
                                "https://raydium.io/swap/?inputMint=2zMMhcVQEXDtdE6vsFS7S7D5oUodfJHE8vd1gnBouauv&outputMint=sol";
                            if (await canLaunchUrl(Uri.parse(url))) {
                              await launchUrl(Uri.parse(url),
                                  mode: LaunchMode.externalApplication);
                            }
                          },
                      ),
                      TextSpan(
                        text: ". Earn the Rewards.",
                        style: const TextStyle(
                          fontFamily: "Audiowide",
                          fontWeight: FontWeight.w900,
                          fontSize: 28.0,
                          color: Color(0xFF2f124a),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  "Claim land, earn passive income, and compete for the ultimate prize pool.",
                  style: const TextStyle(
                    fontFamily: "Audiowide",
                    fontWeight: FontWeight.w900,
                    fontSize: 18.0,
                    color: Color(0xFF2f124a),
                  ),
                  textAlign: TextAlign.center,
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
