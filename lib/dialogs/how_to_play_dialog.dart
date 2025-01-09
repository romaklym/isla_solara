import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taxhavistan/widgets/copy_text.dart';

class HowToPlay extends StatefulWidget {
  const HowToPlay({super.key});

  @override
  State<HowToPlay> createState() => _HowToPlayState();
}

class _HowToPlayState extends State<HowToPlay> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.6;
    final height = MediaQuery.of(context).size.height * 0.6;

    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.transparent, // Transparent to show background image
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFF704214), // Retro brown color
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF704214), // Shadow color
              offset: const Offset(-9, 9),
              blurRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Image.asset(
                  'assets/positioned.png',
                  fit: BoxFit.cover, // Cover entire container
                ),
              ),
              // Transparent Grid Overlay
              Positioned.fill(
                child: CustomPaint(
                  painter: _RetroGridPainter(), // Paint the grid
                ),
              ),
              Column(
                children: [
                  // Title Bar
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFC978), // Retro yellow-orange
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                      border: const Border(
                        bottom: BorderSide(
                          color: Color(0xFF704214), // Retro brown border
                          width: 2,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(
                            "How To Play?",
                            style: TextStyle(
                              fontFamily: "Audiowide",
                              fontSize: 14.0,
                              color: const Color(0xFF704214),
                            ),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const FaIcon(
                            FontAwesomeIcons.x,
                            color: Colors.redAccent,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          iconSize: 14.0,
                        ),
                      ],
                    ),
                  ),
                  // Content Area
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CopyTextWidget(
                                  addressFontSize: 12.0,
                                  addressIconSize: 12.0,
                                  contWidth: 420,
                                  copyText:
                                      "0x532f27101965dd16442E59d40670FaF5eBB142E4",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
