import 'package:flutter/material.dart';
import 'package:taxhavistan/widgets/start_button.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                bottom: 16.0,
              ),
              child: StartButton(
                onTap: () async {
                  const url =
                      "https://raydium.io/swap/?inputMint=2zMMhcVQEXDtdE6vsFS7S7D5oUodfJHE8vd1gnBouauv&outputMint=sol";
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url),
                        mode: LaunchMode.externalApplication);
                  }
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              "© 2025. All rights reserved!",
              style: const TextStyle(
                fontFamily: "Audiowide",
                fontSize: 12.0,
                color: Color(0xFF80A8FF),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
