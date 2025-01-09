import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'custom_button.dart';

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
  String? islandName;
  double? islandPrice;
  int? timesBought;
  String? owner;

  @override
  void initState() {
    super.initState();
    _loadIslandName();
  }

  Future<void> _loadIslandName() async {
    try {
      // Fetch the document from the Firestore collection 'islands'
      final doc = await FirebaseFirestore.instance
          .collection('islands')
          .doc((widget.squareNumber - 1).toString()) // Document ID is the index
          .get();

      if (doc.exists) {
        setState(() {
          islandName = doc.data()?['name'] ?? 'Unknown Island';
          islandPrice = doc.data()?['price'] ?? 0.0;
          // owner = doc.data()?['owner'] ?? 'Unknown Owner';
          timesBought = doc.data()?['times_bought'] ?? 0;
        });
      } else {
        setState(() {
          islandName = "Unknown Island";
          islandPrice = 0.0;
          timesBought = 0;
        });
      }
    } catch (e) {
      print("Error fetching island name from Firestore: $e");
      setState(() {
        islandName = "Unknown Island";
        islandPrice = 0.0;
        timesBought = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.3;
    final height = MediaQuery.of(context).size.height * 0.6;

    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
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
          borderRadius: BorderRadius.circular(8),
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
                            islandName ?? "Loading...",
                            style: const TextStyle(
                              fontFamily: "Audiowide",
                              fontSize: 18.0,
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
                                "Coordinates: ${widget.row.toStringAsFixed(2)}, ${widget.col.toStringAsFixed(2)}",
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                    fontFamily: "Audiowide"),
                              ),
                              const SizedBox(height: 16),
                              CustomButton(
                                color: const Color(0xFF21c21c),
                                label: islandPrice.toString(),
                                icon: Icons.attach_money,
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
