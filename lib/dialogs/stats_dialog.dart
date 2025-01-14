import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class StatsDialog extends StatefulWidget {
  final String publicKey;
  final Map<int, Map<String, dynamic>> cachedIslandData;

  const StatsDialog({
    super.key,
    required this.publicKey,
    required this.cachedIslandData,
  });

  @override
  State<StatsDialog> createState() => _StatsDialogState();
}

class _StatsDialogState extends State<StatsDialog> {
  final formatter = NumberFormat("#,##0.00", "en_US");

  /// Whether we've already fetched data from Firestore
  bool _statsLoaded = false;

  Map<String, dynamic>? cheapestLot;
  Map<String, dynamic>? mostExpensiveLot;
  List<Map<String, dynamic>> ownedLots = [];

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  String formatOwner(String owner) {
    const int maxLength = 16;
    if (owner.length <= maxLength) {
      return owner;
    }
    final int visibleLength = maxLength ~/ 2 - 1;
    return '${owner.substring(0, visibleLength)}...${owner.substring(owner.length - visibleLength)}';
  }

  /// Loads stats (either from the cache if already loaded or from Firestore if not).
  Future<void> _loadStats() async {
    // If we already loaded stats once, just compute stats from cache
    if (_statsLoaded) {
      _generateStatsFromCache();
      return;
    }

    // If the cache is empty, we need to fetch everything from Firestore
    if (widget.cachedIslandData.isEmpty) {
      try {
        final snapshot =
            await FirebaseFirestore.instance.collection('islands').get();

        for (var doc in snapshot.docs) {
          final data = doc.data();
          final id = int.tryParse(doc.id) ?? 0;
          widget.cachedIslandData[id] = data; // Populate the cache
        }
      } catch (e) {
        print("Error loading stats: $e");
      }
    }

    // Now we have data (either newly fetched or was already in the cache).
    _statsLoaded = true;
    _generateStatsFromCache();
  }

  /// Generates cheapestLot, mostExpensiveLot, and ownedLots from the cache.
  void _generateStatsFromCache() {
    final islands = widget.cachedIslandData.entries.map((entry) {
      return {"id": entry.key, ...entry.value};
    }).toList();

    if (islands.isEmpty) {
      setState(() {
        cheapestLot = null;
        mostExpensiveLot = null;
        ownedLots = [];
      });
      return;
    }

    setState(() {
      // Filter islands with valid prices to avoid errors
      final validIslands =
          islands.where((island) => island['price'] != null).toList();

      // Find the cheapest lot
      cheapestLot = validIslands.reduce((a, b) {
        final priceA = a['price'] as num;
        final priceB = b['price'] as num;
        return priceA < priceB ? a : b;
      });

      // Find the most expensive lot
      mostExpensiveLot = validIslands.reduce((a, b) {
        final priceA = a['price'] as num;
        final priceB = b['price'] as num;
        return priceA > priceB ? a : b;
      });

      // Find lots owned by the user
      ownedLots = validIslands
          .where((island) => island['current_owner'] == widget.publicKey)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: 365,
        height: 365,
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
                      color: const Color(0xFFf8c3b6),
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
                            "Statistics",
                            style: TextStyle(
                              fontFamily: "Audiowide",
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Color(0xFF704214),
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
                  if (cheapestLot != null) ...[
                    _buildLotInfo(
                      title: "Cheapest Lot",
                      lot: cheapestLot!,
                      color: Colors.green,
                    ),
                  ],
                  if (mostExpensiveLot != null) ...[
                    _buildLotInfo(
                      title: "Most Expensive Lot",
                      lot: mostExpensiveLot!,
                      color: Colors.red,
                    ),
                  ],
                  // Potentially show your ownedLots here if desired
                  // ...
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
      width: 340,
      margin: const EdgeInsets.symmetric(vertical: 8),
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
              color: color,
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
