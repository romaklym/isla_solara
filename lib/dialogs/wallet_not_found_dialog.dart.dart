import 'package:flutter/material.dart';
import 'package:taxhavistan/widgets/custom_button.dart';

class WalletNotFoundDialog extends StatelessWidget {
  const WalletNotFoundDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.4;
    final height = MediaQuery.of(context).size.height * 0.3;

    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.transparent,
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
                  fit: BoxFit.cover,
                ),
              ),
              // Transparent Grid Overlay
              Positioned.fill(
                child: CustomPaint(
                  painter: _RetroGridPainter(),
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
                            "Wallet Not Found",
                            style: const TextStyle(
                              fontFamily: "Audiowide",
                              fontSize: 14.0,
                              color: Color(0xFF704214),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Content Area
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Phantom wallet is not detected. Please ensure it is installed and try again.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Audiowide",
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 16),
                            CustomButton(
                              color: const Color(0xFFe85229),
                              onTap: () {
                                Navigator.of(context).pop(); // Close dialog
                              },
                              label: "OK",
                            ),
                          ],
                        ),
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
