import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taxhavistan/dialogs/tokenomics.dart';
import 'package:taxhavistan/dialogs/how_to_play.dart';
import 'package:taxhavistan/dialogs/unauthorized_dialog.dart';
import 'package:taxhavistan/widgets/custom_button.dart';
import 'package:taxhavistan/widgets/square_info_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  final String publicKey;
  final double tokenBalance;

  const MapScreen({
    super.key,
    required this.publicKey,
    required this.tokenBalance,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Original "native" resolution of the map
  static const double mapWidth = 6144.0;
  static const double mapHeight = 3456.0;

  // Grid dimensions
  static const int rows = 55;
  static const int cols = 55;

  int? tappedCol;
  int? tappedRow;

  int? tappedSquareIndex;

  void _openDialog(Widget dialog) {
    showDialog(
      context: context,
      builder: (_) => dialog,
    );
  }

  @override
  void initState() {
    super.initState();
    // Show the dialog if publicKey is empty
    if (widget.publicKey.isEmpty || widget.publicKey == 'Unknown') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showUnauthorizedDialog();
      });
    }
  }

  void _showUnauthorizedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const UnauthorizedDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the device's available width.
    final screenWidth = MediaQuery.of(context).size.width;

    // We want to fit the map to the screen width while maintaining
    // the 1920×1080 aspect ratio.
    final scaleFactor = screenWidth / mapWidth;
    final scaledHeight = mapHeight * scaleFactor;

    // Each cell’s size in the scaled layout
    final cellWidth = screenWidth / cols;
    final cellHeight = scaledHeight / rows;

    return Scaffold(
      backgroundColor: Color(0xFF86b9e1),
      appBar: AppBar(
        backgroundColor: Color(0xFF86b9e1),
        leadingWidth: 600,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            children: [
              CustomButton(
                icon: FontAwesomeIcons.xTwitter,
                iconSize: 12.0,
                color: const Color(0xFF006992),
                onTap: () async {
                  const url = "https://x.com/taxhavistan";
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url),
                        mode: LaunchMode.externalApplication);
                  }
                },
              ),
              SizedBox(
                width: 16.0,
              ),
              CustomButton(
                icon: FontAwesomeIcons.telegram,
                iconSize: 12.0,
                color: const Color(0xFF298AAA),
                onTap: () async {
                  const url = "https://t.me/taxhavistan";
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url),
                        mode: LaunchMode.externalApplication);
                  }
                },
              ),
              SizedBox(
                width: 16.0,
              ),
              CustomButton(
                icon: FontAwesomeIcons.gamepad,
                label: "How to Play?",
                color: const Color(0xFF51ACC2),
                onTap: () => _openDialog(
                  const HowToPlay(),
                ),
              ),
              SizedBox(
                width: 16.0,
              ),
              CustomButton(
                icon: FontAwesomeIcons.coins,
                label: "Tokenomics",
                color: const Color(0xFF7ACDDA),
                onTap: () => _openDialog(
                  const Tokenomics(),
                ),
              ),
            ],
          ),
        ),
        title: Text(
          "Isla Solara",
          style: const TextStyle(
            fontFamily: "Nabla",
            fontWeight: FontWeight.w900,
            fontSize: 32,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: SizedBox(
              width: 300,
              child: Row(
                children: [
                  CustomButton(
                    icon: FontAwesomeIcons.chartLine,
                    label: "Stats",
                    color: const Color(0xFF7ACDDA),
                    onTap: () => _openDialog(
                      const HowToPlay(),
                    ),
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  CustomButton(
                    color: Color(0xFF51ACC2),
                    onTap: () {},
                    svgPath: "assets/Phantom.svg",
                    label: widget.publicKey.isNotEmpty
                        ? widget.publicKey
                        : 'No Key',
                    maxCharacters: 14,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              // In case the scaled height is taller than the screen, we can scroll.
              child: Center(
                child: SizedBox(
                  // The scaled width/height for the entire map
                  width: screenWidth,
                  height: scaledHeight,
                  child: GestureDetector(
                    onTapDown: (details) {
                      // localPosition is now in the scaled coordinate space
                      final dx = details.localPosition.dx;
                      final dy = details.localPosition.dy;

                      // Compute which column/row was tapped
                      final col = (dx ~/ cellWidth).clamp(0, cols - 1);
                      final row = (dy ~/ cellHeight).clamp(0, rows - 1);

                      final index = row * cols + col + 1;

                      setState(() {
                        tappedCol = col;
                        tappedRow = row;
                        tappedSquareIndex = index;
                      });

                      // Show a dialog about the tapped square
                      showDialog(
                        context: context,
                        builder: (ctx) {
                          return SquareInfoDialog(
                            squareNumber: tappedSquareIndex!,
                            row: row,
                            col: col,
                            publicKey: widget.publicKey,
                            walletBalance: widget.tokenBalance,
                          );
                        },
                      );
                    },
                    child: Stack(
                      children: [
                        // The background map image
                        Positioned.fill(
                          child: Image.asset(
                            'assets/final_map.png',
                            fit: BoxFit.fill, // Fill the scaled area
                          ),
                        ),
                        // Grid overlay + highlight
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
    // size will be the scaled size (e.g., screenWidth × scaledHeight)
    final cellWidth = size.width / cols;
    final cellHeight = size.height / rows;

    // Paint for the grid lines
    final gridPaint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.02;

    // Paint for the tapped cell highlight
    final tappedPaint = Paint()
      ..color = Colors.red.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;

    // Draw the grid
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

    // Highlight the tapped cell
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
