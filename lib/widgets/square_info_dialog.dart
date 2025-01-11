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
  final Map<int, Map<String, dynamic>> cachedIslandData;

  const SquareInfoDialog({
    super.key,
    required this.squareNumber,
    required this.row,
    required this.col,
    required this.publicKey,
    required this.walletBalance,
    required this.cachedIslandData,
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
    if (widget.cachedIslandData.containsKey(widget.squareNumber)) {
      // Already cached; set local state from cache (no Firestore read!)
      print("Using cached data for island #${widget.squareNumber}");
      final cachedData = widget.cachedIslandData[widget.squareNumber]!;
      setState(() {
        islandName = cachedData['name'];
        islandPrice = cachedData['price'];
        currentOwner = cachedData['current_owner'];
        timesBought = cachedData['times_bought'];
        islandType = cachedData['type'];
      });

      // Print only if you really want to confirm a rebuild from cache
      // print("Rebuild from cache");

      return;
    }

    // If not in cache, now we do a Firestore read
    try {
      final doc = await FirebaseFirestore.instance
          .collection('islands')
          .doc(widget.squareNumber.toString())
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        widget.cachedIslandData[widget.squareNumber] =
            data; // <— store in parent’s cache
        setState(() {
          islandName = data['name'] ?? 'Unknown Island';
          islandPrice = data['price'] ?? 0.0;
          currentOwner = data['current_owner'] ?? 'Unknown Owner';
          timesBought = data['times_bought'] ?? 0;
          islandType = data['type'] ?? 0;

          print("Rebuild from Firestore fetch");
        });
      } else {
        setState(() {
          islandName = "Unknown Island";
          islandPrice = 0.0;
          timesBought = 0;
          islandType = 0;
        });
      }
    } catch (e) {
      print("Error fetching island data from Firestore: $e");
    }
  }

  Future<void> _handleIslandPurchase() async {
    final messenger = ScaffoldMessenger.of(context); // Create local reference
    final price = islandPrice ?? 0.0;

    if (widget.walletBalance >= price) {
      try {
        // Perform the Firestore update
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          final docRef = FirebaseFirestore.instance
              .collection('islands')
              .doc(widget.squareNumber.toString());

          final snapshot = await transaction.get(docRef);

          if (snapshot.exists) {
            final data = snapshot.data()!;
            final newPrice = data['price'] + (data['price'] * 0.015);
            transaction.update(docRef, {
              'owners': FieldValue.arrayUnion([widget.publicKey]),
              'times_bought': FieldValue.increment(1),
              'current_owner': widget.publicKey,
              'price': newPrice,
            });
          }
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
        width: 350,
        height: 550,
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
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              islandName ?? "Loading...",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: "Audiowide",
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: Color(0xFF704214),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const FaIcon(
                              FontAwesomeIcons.xmark,
                              color: Colors.redAccent,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            iconSize: 14.0,
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
                                    width: 320,
                                    height: 220,
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
                                  "Lot #${widget.squareNumber}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: "Audiowide",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
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
