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
  String? currentOwner;
  int? islandType;

  @override
  void initState() {
    super.initState();
    _loadIslandName();
  }

  Future<void> _loadIslandName() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('islands')
          .doc((widget.squareNumber).toString())
          .get();

      if (doc.exists) {
        setState(() {
          islandName = doc.data()?['name'] ?? 'Unknown Island';
          islandPrice = doc.data()?['price'] ?? 0.0;
          currentOwner = doc.data()?['current_owner'] ?? 'Unknown Owner';
          timesBought = doc.data()?['times_bought'] ?? 0;
          islandType = doc.data()?['type'] ?? 0; // Default to 0
        });
      } else {
        setState(() {
          islandName = "Unknown Island";
          islandPrice = 0.0;
          timesBought = 0;
          islandType = 0; // Default to 0
        });
      }
    } catch (e) {
      print("Error fetching island data from Firestore: $e");
      setState(() {
        islandName = "Unknown Island";
        islandPrice = 0.0;
        timesBought = 0;
        islandType = 0; // Default to 0
      });
    }
  }

  Future<void> _handleIslandPurchase() async {
    final messenger = ScaffoldMessenger.of(context); // Create local reference
    final price = islandPrice ?? 0.0;

    if (widget.walletBalance >= price) {
      final docId = widget.squareNumber.toString();

      try {
        final newPrice = price + (price * 0.015);
        // Perform the Firestore update
        await FirebaseFirestore.instance
            .collection('islands')
            .doc(docId)
            .update({
          'owners': FieldValue.arrayUnion([widget.publicKey]),
          'times_bought': FieldValue.increment(1),
          'current_owner': widget.publicKey,
          'price': newPrice,
        });

        // Show success snack bar
        if (mounted) {
          messenger.showSnackBar(
            SnackBar(
              width: MediaQuery.of(context).size.width / 3,
              behavior: SnackBarBehavior.floating,
              backgroundColor: const Color(0xFF86b9e1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  8.0,
                ),
                side: const BorderSide(
                  color: Color(0xFF704214),
                  width: 2,
                ),
              ),
              content: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: const Text(
                  "Congratulations! You now own this island.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Audiowide",
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }

        // Close the dialog safely
        if (mounted) {
          Navigator.of(context)
              .pop(); // Ensure mounted before calling Navigator
        }
      } catch (error) {
        // Check if widget is still mounted before showing error
        if (mounted) {
          messenger.showSnackBar(
            SnackBar(
              width: MediaQuery.of(context).size.width / 3,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Color(0xFFf96574),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  8.0,
                ),
                side: const BorderSide(
                  color: Color(0xFF704214),
                  width: 2,
                ),
              ),
              content: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  "Error: $error",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Audiowide",
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }
      }
    } else {
      Navigator.of(context).pop();
      // Insufficient funds warning
      messenger.showSnackBar(
        SnackBar(
          width: MediaQuery.of(context).size.width / 3,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFFf96574),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              8.0,
            ),
            side: const BorderSide(
              color: Color(0xFF704214),
              width: 2,
            ),
          ),
          content: Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: const Text(
              "Insufficient funds to purchase!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Audiowide",
                color: Colors.white70,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: 400,
        height: 500,
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
                      color: const Color(0xFFFFC978),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                      border: const Border(
                        bottom: BorderSide(
                          color: Color(0xFF704214),
                          width: 2,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "Lot #${widget.squareNumber}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: "Audiowide",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                  color: Color(0xFF704214),
                                ),
                              ),
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
                        ],
                      ),
                    ),
                  ),
                  // Content Area
                  Expanded(
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 50.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Show image based on the island type
                                if (islandType != null)
                                  Container(
                                    width: 250,
                                    height: 250,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xFF704214),
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Image.asset(
                                        'assets/card.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 16),
                                Text(
                                  currentOwner == null || currentOwner!.isEmpty
                                      ? "Lot hasn't been sold yet"
                                      : "Current Owner: $currentOwner",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: "Audiowide",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.0,
                                    color: Color(0xFF704214),
                                  ),
                                ),
                                Text(
                                  "Coordinates: ${widget.row.toStringAsFixed(0)}, ${widget.col.toStringAsFixed(0)}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                    fontFamily: "Audiowide",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: CustomButton(
                              color: const Color(0xFF21c21c),
                              label: islandPrice?.toStringAsFixed(2),
                              icon: Icons.attach_money,
                              onTap: () async {
                                _handleIslandPurchase();
                              },
                              fontSize: 16.0,
                              iconSize: 20.0,
                            ),
                          ),
                        )
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
