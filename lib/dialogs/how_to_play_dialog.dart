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
  Widget _buildStepContainer({
    required String stepNumber,
    required RichText text,
    required String imagePath,
    required Color color,
  }) {
    return Container(
      width: 400,
      height: 220,
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
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image Section
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: const Color(0xFF704214),
                width: 1.5,
              ),
            ),
            clipBehavior: Clip.hardEdge,
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 8),
          // Text Section
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Step $stepNumber:",
                  style: const TextStyle(
                    fontFamily: "Audiowide",
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF704214),
                  ),
                ),
                const SizedBox(height: 4),
                text,
              ],
            ),
          ),
        ],
      ),
    );
  }

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
              Positioned.fill(
                child: CustomPaint(
                  painter: _RetroGridPainter(),
                ),
              ),
              // Content
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
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Text(
                            "How To Play?",
                            style: TextStyle(
                              fontFamily: "Audiowide",
                              fontSize: 18.0,
                              color: Color(0xFF704214),
                            ),
                          ),
                        ),
                        const Spacer(),
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
                  // Content Area
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(),
                          Wrap(
                            spacing: 16.0,
                            runSpacing: 16.0,
                            alignment: WrapAlignment.start,
                            children: [
                              _buildStepContainer(
                                stepNumber: "1",
                                text: RichText(
                                  text: TextSpan(
                                    text: "Buy ",
                                    style: const TextStyle(
                                      fontFamily: "Audiowide",
                                      fontSize: 12.0,
                                      color: Colors.black54,
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
                                imagePath: "assets/1.png",
                                color: const Color(0xFFF5E6CC),
                              ),
                              _buildStepContainer(
                                stepNumber: "2",
                                text: RichText(
                                  text: TextSpan(
                                    text: "Go to ",
                                    style: const TextStyle(
                                      fontFamily: "Audiowide",
                                      fontSize: 12.0,
                                      color: Colors.black54,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "islasolara.com",
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            _launchUrl(
                                                "https://islasolara.com");
                                          },
                                      ),
                                      const TextSpan(
                                        text: " and press on View Map button.",
                                      ),
                                    ],
                                  ),
                                ),
                                imagePath: "assets/2.png",
                                color: const Color(0xFFF5E6CC),
                              ),
                              _buildStepContainer(
                                stepNumber: "3",
                                text: RichText(
                                  text: TextSpan(
                                    text: "Login with a wallet holding ",
                                    style: const TextStyle(
                                      fontFamily: "Audiowide",
                                      fontSize: 12.0,
                                      color: Colors.black54,
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
                                      const TextSpan(text: " tokens."),
                                    ],
                                  ),
                                ),
                                imagePath: "assets/3.png",
                                color: const Color(0xFFF5E6CC),
                              ),
                              _buildStepContainer(
                                stepNumber: "4",
                                text: RichText(
                                  text: TextSpan(
                                    text:
                                        "Choose a land lot you wish and claim it using the coins in your wallet. ",
                                    style: const TextStyle(
                                      fontFamily: "Audiowide",
                                      fontSize: 12.0,
                                      color: Colors.black54,
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
                                            "; you just need to hold them to claim land.",
                                      ),
                                    ],
                                  ),
                                ),
                                imagePath: "assets/4.png",
                                color: const Color(0xFFF5E6CC),
                              ),
                              _buildStepContainer(
                                stepNumber: "5",
                                text: RichText(
                                  text: TextSpan(
                                    text: "Congratulations!",
                                    style: const TextStyle(
                                      fontFamily: "Audiowide",
                                      fontSize: 12.0,
                                      color: Colors.purple,
                                    ),
                                    children: [
                                      const TextSpan(
                                        text:
                                            " You are now a proud owner of a land lot on Isla Solara. Wait for random drops of \$LAND tokens to your wallet as rewards for holding land.",
                                        style: TextStyle(
                                          fontFamily: "Audiowide",
                                          fontSize: 12.0,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                imagePath: "assets/5.png",
                                color: const Color(0xFFF5E6CC),
                              ),
                              _buildStepContainer(
                                stepNumber: "Sidenote",
                                text: RichText(
                                  text: TextSpan(
                                    text:
                                        "Other players can buy the land from you. Strategize and pay attention if you get outbid. Each purchase increases the land value by ",
                                    style: const TextStyle(
                                      fontFamily: "Audiowide",
                                      fontSize: 12.0,
                                      color: Colors.black54,
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
                                imagePath: "assets/step_sidenote.png",
                                color: const Color(0xFFF5E6CC),
                              ),
                            ],
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
