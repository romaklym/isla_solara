import 'package:flutter/material.dart';
import 'package:taxhavistan/widgets/svg_button.dart';

class AppBarButtons extends StatelessWidget {
  const AppBarButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Row(
        children: [
          SvgButtonWithText(
            svgPath: 'assets/dex.svg', // Path to your SVG file
            text: 'DexScreener',
            url:
                "https://dexscreener.com/solana/ED5nyyWEzpPPiWimP8vYm7sD7TD3LAt3Q3gRTWHzPJBY",
            svgSize: 16.0,
            textStyle: const TextStyle(
              fontFamily: "Audiowide",
              fontSize: 12.0,
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
            containerWidth: 135.0,
            buttonColor: Color(0xFF298AAA),
          ),
          SizedBox(
            width: 16.0,
          ),
          SvgButtonWithText(
            svgPath: 'assets/dextools.svg', // Path to your SVG file
            text: 'DexTools',
            url:
                "https://dexscreener.com/solana/ED5nyyWEzpPPiWimP8vYm7sD7TD3LAt3Q3gRTWHzPJBY",
            svgSize: 16.0,
            textStyle: const TextStyle(
              fontFamily: "Audiowide",
              fontSize: 12.0,
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
            containerWidth: 120.0,
            buttonColor: Color(0xFF006992),
          ),
        ],
      ),
    );
  }
}
