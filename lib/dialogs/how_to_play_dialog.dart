import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HowToPlay extends StatefulWidget {
  final double widthRes;
  final double heightRes;
  const HowToPlay({
    super.key,
    this.widthRes = 0.7,
    this.heightRes = 0.95,
  });

  @override
  State<HowToPlay> createState() => _HowToPlayState();
}

class _HowToPlayState extends State<HowToPlay> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * widget.widthRes;
    final height = MediaQuery.of(context).size.height * widget.heightRes;

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
                      color: const Color(0xFF679a7d),
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
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(
                            "How To Play?",
                            style: const TextStyle(
                              fontFamily: "Audiowide",
                              fontSize: 18.0,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const FaIcon(
                            FontAwesomeIcons.x,
                            color: Colors.white70,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          iconSize: 14.0,
                        ),
                      ],
                    ),
                  ),
                  // Content Area
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildStepContainer(
                            stepNumber: 1,
                            text: RichText(
                              text: TextSpan(
                                text: "Buy ",
                                style: const TextStyle(
                                  fontFamily: "Audiowide",
                                  fontSize: 14.0,
                                  color: Colors.black87,
                                ),
                                children: [
                                  TextSpan(
                                    text: "\$LAND",
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        _launchUrl(
                                            "https://raydium.io/swap/?inputMint=2zMMhcVQEXDtdE6vsFS7S7D5oUodfJHE8vd1gnBouauv&outputMint=sol");
                                      },
                                  ),
                                  const TextSpan(text: " token."),
                                ],
                              ),
                            ),
                            color: const Color(0xFFB8D6A1),
                          ),
                          const SizedBox(height: 16.0),
                          _buildStepContainer(
                            stepNumber: 2,
                            text: RichText(
                              text: TextSpan(
                                text: "Login with a wallet that holds ",
                                style: const TextStyle(
                                  fontFamily: "Audiowide",
                                  fontSize: 14.0,
                                  color: Colors.black87,
                                ),
                                children: [
                                  TextSpan(
                                    text: "\$LAND",
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        _launchUrl(
                                            "https://raydium.io/swap/?inputMint=2zMMhcVQEXDtdE6vsFS7S7D5oUodfJHE8vd1gnBouauv&outputMint=sol");
                                      },
                                  ),
                                  const TextSpan(
                                      text: " tokens on our website: "),
                                  TextSpan(
                                    text: "islasolara.com/map",
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        _launchUrl(
                                            "https://islasolara.com/#/map");
                                      },
                                  ),
                                ],
                              ),
                            ),
                            color: const Color(0xFFD4E6F1),
                          ),
                          const SizedBox(height: 16.0),
                          _buildStepContainer(
                            stepNumber: 3,
                            text: RichText(
                              text: TextSpan(
                                text:
                                    "Choose a land lot you wish and claim it using the coins in your wallet. ",
                                style: const TextStyle(
                                  fontFamily: "Audiowide",
                                  fontSize: 14.0,
                                  color: Colors.black87,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Coins are not withdrawn",
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const TextSpan(
                                      text:
                                          "; you just need to hold them to claim land."),
                                ],
                              ),
                            ),
                            color: const Color(0xFFFFE0B2),
                          ),
                          const SizedBox(height: 16.0),
                          _buildStepContainer(
                            stepNumber: 4,
                            text: RichText(
                              text: TextSpan(
                                text: "Congratulations!",
                                style: const TextStyle(
                                  fontFamily: "Audiowide",
                                  fontSize: 14.0,
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  const TextSpan(
                                    text:
                                        " You are now a proud owner of a land lot on Isla Solara.",
                                    style: TextStyle(
                                      fontFamily: "Audiowide",
                                      fontSize: 14.0,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            color: const Color(0xFFF8BBD0),
                          ),
                          const SizedBox(height: 16.0),
                          _buildStepContainer(
                            stepNumber: 5,
                            text: RichText(
                              text: TextSpan(
                                text: "Wait for random drops of ",
                                style: const TextStyle(
                                  fontFamily: "Audiowide",
                                  fontSize: 14.0,
                                  color: Colors.black87,
                                ),
                                children: [
                                  TextSpan(
                                    text: "\$LAND",
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        _launchUrl(
                                            "https://raydium.io/swap/?inputMint=2zMMhcVQEXDtdE6vsFS7S7D5oUodfJHE8vd1gnBouauv&outputMint=sol");
                                      },
                                  ),
                                  const TextSpan(
                                      text:
                                          " tokens to your wallet as rewards for holding land."),
                                ],
                              ),
                            ),
                            color: const Color(0xFFC8E6C9),
                          ),
                          const SizedBox(height: 16.0),
                          _buildStepContainer(
                            stepNumber: "Sidenote",
                            text: RichText(
                              text: TextSpan(
                                text:
                                    "Other players can buy the land from you. Strategize and pay attention if you get outbid. Each purchase increases the land value by ",
                                style: const TextStyle(
                                  fontFamily: "Audiowide",
                                  fontSize: 14.0,
                                  color: Colors.black87,
                                ),
                                children: [
                                  const TextSpan(
                                    text: "1.5%",
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const TextSpan(text: ". "),
                                  TextSpan(
                                    text: "\$LAND",
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        _launchUrl(
                                            "https://raydium.io/swap/?inputMint=2zMMhcVQEXDtdE6vsFS7S7D5oUodfJHE8vd1gnBouauv&outputMint=sol");
                                      },
                                  ),
                                  const TextSpan(
                                    text:
                                        " drops are distributed equally among ",
                                  ),
                                  const TextSpan(
                                    text: "all 3025",
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: " land lot owners.",
                                  ),
                                ],
                              ),
                            ),
                            color: const Color(0xFFF5E6CC),
                          ),
                        ],
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

  Widget _buildStepContainer({
    required dynamic stepNumber,
    required Widget text,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF704214),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF704214),
            offset: const Offset(-4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Step $stepNumber:",
            style: const TextStyle(
              fontFamily: "Audiowide",
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF704214),
            ),
          ),
          const SizedBox(height: 8.0),
          text,
        ],
      ),
    );
  }

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not launch $url";
    }
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
