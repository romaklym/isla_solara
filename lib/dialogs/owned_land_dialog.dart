import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

// An optional extension to safely find the first matching entry or return null:
extension FirstWhereOrNull<K, V> on Iterable<MapEntry<K, V>> {
  MapEntry<K, V>? firstWhereOrNull(bool Function(MapEntry<K, V>) test) {
    for (var element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}

class OwnedDialog extends StatefulWidget {
  final String publicKey;
  final double walletBalance;
  final Map<int, Map<String, dynamic>> cachedIslandData;

  const OwnedDialog({
    super.key,
    required this.publicKey,
    required this.walletBalance,
    required this.cachedIslandData,
  });

  @override
  State<OwnedDialog> createState() => _OwnedDialogState();
}

class _OwnedDialogState extends State<OwnedDialog> {
  final formatter = NumberFormat("#,##0.00", "en_US");

  Map<String, dynamic>? ownedLot;

  @override
  void initState() {
    super.initState();
    _findOwnedLot();
  }

  String formatOwner(String owner) {
    const int maxLength = 16;
    if (owner.length <= maxLength) {
      // If the owner's length is already short, return it directly
      return owner;
    }

    final int visibleLength = maxLength ~/ 2 - 1;
    return '${owner.substring(0, visibleLength)}...${owner.substring(owner.length - visibleLength)}';
  }

  /// Looks for the owned lot in the local cache first. If not found, queries Firestore.
  Future<void> _findOwnedLot() async {
    // If we've already found (and set) the ownedLot, no need to do anything.
    if (ownedLot != null) {
      return;
    }

    // 1) Try to find the lot in our local cache
    final cachedEntry = widget.cachedIslandData.entries.firstWhereOrNull(
      (entry) => entry.value['current_owner'] == widget.publicKey,
    );

    if (cachedEntry != null) {
      // Found it in cache; just use that!
      setState(() {
        ownedLot = {"id": cachedEntry.key, ...cachedEntry.value};
      });
      return;
    }

    // 2) If not in cache, then query Firestore
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('islands')
          .where('current_owner', isEqualTo: widget.publicKey)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        final data = doc.data();
        final id = int.tryParse(doc.id) ?? 0;

        // Populate our cache so we don't have to query Firestore again
        widget.cachedIslandData[id] = data;

        setState(() {
          ownedLot = {"id": id, ...data};
        });
      }
    } catch (e) {
      print("Error finding owned lot: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableBalance = widget.walletBalance - (ownedLot?['price'] ?? 0.0);

    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: 300,
        height: 300,
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
                  color: Colors.black.withAlpha(25),
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
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF404F89),
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
                            "Owned Lot",
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
                            color: Colors.redAccent,
                            size: 16.0,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Available Balance:",
                          style: TextStyle(
                            fontFamily: "Audiowide",
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF704214),
                          ),
                        ),
                        Text(
                          "${formatter.format(availableBalance).replaceAll(',', '\'')} \$LAND",
                          style: TextStyle(
                            fontFamily: "Audiowide",
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: availableBalance >= 0
                                ? Color(0xFF704214)
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ownedLot == null
                      ? const Expanded(
                          child: Center(
                            child: Text(
                              "You don't own any lots yet.",
                              style: TextStyle(
                                fontFamily: "Audiowide",
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        )
                      : _buildLotInfo(
                          title: "Lot ${ownedLot!['id']}",
                          lot: ownedLot!,
                          color: Colors.blueAccent,
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLotInfo({
    required String title,
    required Map<String, dynamic> lot,
    required Color color,
  }) {
    final int id = lot['id'] ?? 0;
    final int row = ((id - 1) ~/ 55) + 1;
    final int col = ((id - 1) % 55) + 1;
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha(50),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: "Audiowide",
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF704214),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Name: ${lot['name'] ?? 'Unknown'}",
            style: const TextStyle(
              fontFamily: "Audiowide",
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          Text(
            "Price: ${formatter.format(lot['price'] ?? 0).replaceAll(',', '\'')} \$LAND",
            style: const TextStyle(
              fontFamily: "Audiowide",
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          Text(
            'Owner: ${formatOwner(lot['current_owner'] ?? 'Unknown')}',
            style: const TextStyle(
              fontFamily: "Audiowide",
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          Text(
            "Coordinates: $row, $col",
            style: const TextStyle(
              fontFamily: "Audiowide",
              fontSize: 14,
              color: Colors.black54,
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
