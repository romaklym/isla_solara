import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'custom_button.dart';
import 'package:flutter/services.dart' show rootBundle;

class SquareInfoDialog extends StatefulWidget {
  final int squareNumber;
  final int row;
  final int col;
  final String publicKey;
  final double walletBalance;

  const SquareInfoDialog({
    super.key,
    required this.squareNumber,
    required this.row,
    required this.col,
    required this.publicKey,
    required this.walletBalance,
  });

  @override
  State<SquareInfoDialog> createState() => _SquareInfoDialogState();
}

class _SquareInfoDialogState extends State<SquareInfoDialog> {
  String? _islandName;

  @override
  void initState() {
    super.initState();
    _loadIslandName();
  }

  Future<void> _loadIslandName() async {
    try {
      // Load the JSON file
      final String response =
          await rootBundle.loadString('assets/island_names.json');
      final List<dynamic> islandNames = json.decode(response);

      setState(() {
        // Fetch the name corresponding to the squareNumber
        _islandName = islandNames[widget.squareNumber - 1];
      });
    } catch (e) {
      print("Error loading island names: $e");
      setState(() {
        _islandName = "Unknown Island"; // Fallback in case of an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.4;
    final height = MediaQuery.of(context).size.height * 0.6;

    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: const Color(0xFF704214),
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF704214),
              offset: const Offset(-5, 5),
              blurRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/positioned.png',
                  fit: BoxFit.cover,
                ),
              ),
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
                        top: Radius.circular(4),
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
                            _islandName ?? "Loading...",
                            style: const TextStyle(
                              fontFamily: "Audiowide",
                              fontSize: 14.0,
                              color: Color(0xFF704214),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Lot #${widget.squareNumber}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: "Audiowide",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Username #${widget.publicKey}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: "Audiowide",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Balance: ${widget.walletBalance} \$TAX",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: "Audiowide",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Coordinates: Latitude: ${widget.row.toStringAsFixed(2)}, Longitude: ${widget.col.toStringAsFixed(2)}",
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                    fontFamily: "Audiowide"),
                              ),
                              const SizedBox(height: 16),
                              CustomButton(
                                color: const Color(0xFFFFC978),
                                label: 'Close',
                                icon: Icons.close,
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                fontSize: 16.0,
                                iconSize: 20.0,
                              ),
                            ],
                          ),
                        ),
                      ],
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
      ..color = Colors.black.withValues(alpha: 0.1)
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
