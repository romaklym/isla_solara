import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
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
      final cachedData = widget.cachedIslandData[widget.squareNumber]!;
      setState(() {
        islandName = cachedData['name'];
        islandPrice = cachedData['price'];
        currentOwner = cachedData['current_owner'];
        timesBought = cachedData['times_bought'];
        islandType = cachedData['type'];
      });
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

  final formatter = NumberFormat("#,##0.00", "en_US");

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
              backgroundColor: const Color(0xFF21c21c),
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
                  "Congratulations! You are now a proud owner of Lot#${widget.squareNumber.toString()}",
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
              backgroundColor: Color(0xFFe85229),
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
          backgroundColor: Color(0xFFe85229),
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
              "Insufficient \$LAND! You need ${formatter.format(islandPrice! - widget.walletBalance).replaceAll(',', '\'')} more to purchase this lot.",
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
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      backgroundColor: Colors.transparent,
      child: Container(
        width: 350,
        height: 500,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF86b9e1), Color(0xFFcda5e1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF704214),
              offset: const Offset(-9, 9),
              blurRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/positioned.png',
                  fit: BoxFit.cover,
                  color: Colors.black.withValues(alpha: 0.1),
                  colorBlendMode: BlendMode.darken,
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
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xFF679a7d),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      border: Border.all(
                        color: const Color(0xFF704214),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(
                            islandName ?? "Loading...",
                            style: TextStyle(
                              fontFamily: "Audiowide",
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: FaIcon(
                            FontAwesomeIcons.xmark,
                            color: Colors.white70,
                            size: 16.0,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                  // Content Area
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Color(0xFF704214),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(4, 4),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/card.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          _buildInfoRow(
                            label: "Price",
                            value:
                                "${formatter.format(islandPrice ?? 0.0).replaceAll(',', '\'')} \$LAND",
                          ),
                          _buildInfoRow(
                            label: "Owner",
                            value: currentOwner != null
                                ? '${currentOwner!.substring(0, (14 ~/ 2) - 1)}...${currentOwner!.substring(currentOwner!.length - ((14 ~/ 2) - 1))}'
                                : "Not Owned",
                          ),
                          _buildInfoRow(
                            label: "Times Bought",
                            value: timesBought?.toString() ?? "0",
                          ),
                          _buildInfoRow(
                            label: "Coordinates",
                            value:
                                "${widget.row.toStringAsFixed(0)}, ${widget.col.toStringAsFixed(0)}",
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Action Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CustomButton(
                      color: Color(0xFF21c21c),
                      fontSize: 14.0,
                      iconSize: 18.0,
                      label:
                          "${formatter.format(islandPrice ?? 0.0).replaceAll(',', '\'')} \$LAND",
                      // icon: Icons.attach_money,
                      onTap: () async {
                        _handleIslandPurchase();
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$label:",
            style: TextStyle(
              fontFamily: "Audiowide",
              fontSize: 14.0,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: "Audiowide",
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF704214),
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
