import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taxhavistan/dialogs/how_to_play_dialog.dart';
import 'package:taxhavistan/dialogs/tokenomics_dialog.dart';
import 'package:taxhavistan/dialogs/wallet_not_found_dialog.dart.dart';
import 'package:taxhavistan/services/wallet_services.dart';
import 'package:taxhavistan/widgets/custom_button.dart';
import 'package:taxhavistan/widgets/square_info_dialog.dart';
import 'dart:html' as html;
import 'dart:js' as js;

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const double mapWidth = 6144.0;
  static const double mapHeight = 3456.0;
  static const int rows = 55;
  static const int cols = 55;

  final WalletService _walletService = WalletService();
  String _publicKey = "";
  double _tokenBalance = 0.0;

  int? tappedCol;
  int? tappedRow;
  int? tappedSquareIndex;

  @override
  void initState() {
    super.initState();

    // Retrieve stored values
    final storedPublicKey = html.window.localStorage['publicKey'];
    final storedTokenBalance = html.window.localStorage['tokenBalance'];

    if (storedPublicKey != null && storedTokenBalance != null) {
      setState(() {
        _publicKey = storedPublicKey;
        _tokenBalance = double.tryParse(storedTokenBalance) ?? 0.0;
      });
    } else if (_publicKey.isEmpty || _publicKey == 'Unknown') {
      WidgetsBinding.instance.addPostFrameCallback((_) {});
    }
  }

  void logout() {
    html.window.localStorage.remove('publicKey');
    html.window.localStorage.remove('tokenBalance');
    setState(() {
      _publicKey = "";
      _tokenBalance = 0.0;
    });
  }

  Future<void> connectWallet() async {
    try {
      // Check for Phantom wallet
      final solana = js.context['solana'];
      if (solana == null || solana['isPhantom'] != true) {
        if (!mounted) return; // Check if widget is still mounted
        showDialog(
          context: context,
          builder: (_) => const WalletNotFoundDialog(),
        );
        return;
      }

      // Request wallet connection
      final promise = solana.callMethod('request', [
        js.JsObject.jsify({'method': 'connect'}),
      ]);

      if (promise == null) {
        throw Exception("Failed to connect to the wallet.");
      }

      await _jsPromiseToFuture(promise);

      // Retrieve the public key
      final publicKeyObj = solana['publicKey'];
      final publicKey = publicKeyObj?.callMethod('toString') ?? "";

      if (publicKey.isEmpty) {
        throw Exception("Failed to retrieve public key.");
      }

      // Fetch token balance
      const mintAddress = "ED5nyyWEzpPPiWimP8vYm7sD7TD3LAt3Q3gRTWHzPJBY";
      final tokenBalance =
          await _walletService.getTokenBalance(publicKey, mintAddress);

      if (!mounted) return;

      // Save to localStorage
      html.window.localStorage['publicKey'] = publicKey;
      html.window.localStorage['tokenBalance'] = tokenBalance.toString();

      // Update state
      setState(() {
        _publicKey = publicKey;
        _tokenBalance = tokenBalance;
      });
    } catch (e) {
      if (!mounted) return; // Check if widget is still mounted
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<dynamic> _jsPromiseToFuture(dynamic jsPromise) {
    final completer = Completer<dynamic>();
    jsPromise.callMethod('then', [
      js.allowInterop((result) => completer.complete(result)),
      js.allowInterop((error) => completer.completeError(error)),
    ]);
    return completer.future;
  }

  void _openDialog(Widget dialog) {
    showDialog(
      context: context,
      builder: (_) => dialog,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth / mapWidth;
    final scaledHeight = mapHeight * scaleFactor;

    final cellWidth = screenWidth / cols;
    final cellHeight = scaledHeight / rows;

    return Scaffold(
      backgroundColor: const Color(0xFF86b9e1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF564e95),
        actions: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Row(
                    children: [
                      CustomButton(
                        icon: FontAwesomeIcons.gamepad,
                        label: "How to Play?",
                        color: const Color(0xFF679a7d),
                        onTap: () => _openDialog(
                          const HowToPlay(),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      CustomButton(
                        icon: FontAwesomeIcons.coins,
                        label: "Tokenomics",
                        color: const Color(0xFFaebc6e),
                        onTap: () => _openDialog(
                          const Tokenomics(),
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  "Isla Solara",
                  style: TextStyle(
                    fontFamily: "Nabla",
                    fontWeight: FontWeight.w900,
                    fontSize: 32,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Row(
                    children: [
                      CustomButton(
                        icon: FontAwesomeIcons.chartLine,
                        label: "Stats",
                        color: const Color(0xFFf8c3b6),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              width: 300,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: const Color(0xFF86b9e1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(
                                    color: Colors.black54, width: 2),
                              ),
                              content: Container(
                                alignment: Alignment.center,
                                child: const Text(
                                  "Statistics are coming soon! Stay tuned.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Audiowide",
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      if (_publicKey.isNotEmpty && _publicKey != "Unknown") ...[
                        const SizedBox(width: 16.0),
                        CustomButton(
                          color: const Color(0xFF666A75),
                          onTap: () {},
                          icon: Icons.attach_money,
                          label: _tokenBalance.toStringAsFixed(2),
                        ),
                      ],
                      const SizedBox(width: 16.0),
                      CustomButton(
                        color: const Color(0xFFAB9FF2),
                        onTap: _publicKey.isEmpty || _publicKey == "Unknown"
                            ? connectWallet
                            : logout,
                        svgPath: "assets/Phantom.svg",
                        label: _publicKey.isEmpty || _publicKey == "Unknown"
                            ? 'Connect Wallet'
                            : _publicKey,
                        maxCharacters:
                            _publicKey.isEmpty || _publicKey == "Unknown"
                                ? null
                                : 8,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  width: screenWidth,
                  height: scaledHeight,
                  child: GestureDetector(
                    onTapDown: (details) {
                      final dx = details.localPosition.dx;
                      final dy = details.localPosition.dy;

                      final col = (dx ~/ cellWidth).clamp(0, cols - 1);
                      final row = (dy ~/ cellHeight).clamp(0, rows - 1);

                      final index = row * cols + col + 1;

                      setState(() {
                        tappedCol = col;
                        tappedRow = row;
                        tappedSquareIndex = index;
                      });

                      showDialog(
                        context: context,
                        builder: (ctx) {
                          return SquareInfoDialog(
                            squareNumber: tappedSquareIndex!,
                            row: row,
                            col: col,
                            publicKey: _publicKey,
                            walletBalance: _tokenBalance,
                          );
                        },
                      );
                    },
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            'assets/final_map.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                        CustomPaint(
                          size: Size(screenWidth, scaledHeight),
                          painter: IslandPainter(
                            rows: rows,
                            cols: cols,
                            tappedCol: tappedCol,
                            tappedRow: tappedRow,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IslandPainter extends CustomPainter {
  final int rows;
  final int cols;
  final int? tappedCol;
  final int? tappedRow;

  IslandPainter({
    required this.rows,
    required this.cols,
    this.tappedCol,
    this.tappedRow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cellWidth = size.width / cols;
    final cellHeight = size.height / rows;

    final gridPaint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.02;

    final tappedPaint = Paint()
      ..color = Colors.red.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final rect = Rect.fromLTWH(
          col * cellWidth,
          row * cellHeight,
          cellWidth,
          cellHeight,
        );
        canvas.drawRect(rect, gridPaint);
      }
    }

    if (tappedCol != null && tappedRow != null) {
      final rect = Rect.fromLTWH(
        tappedCol! * cellWidth,
        tappedRow! * cellHeight,
        cellWidth,
        cellHeight,
      );
      canvas.drawRect(rect, tappedPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
