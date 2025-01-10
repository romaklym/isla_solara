import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taxhavistan/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

class AppBarMobile extends StatefulWidget {
  const AppBarMobile({super.key});

  @override
  State<AppBarMobile> createState() => _AppBarMobileState();
}

class _AppBarMobileState extends State<AppBarMobile> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0, // Place at the top of the screen
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 8.0,
        ),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CustomButton(
                      svgPath: 'assets/dex.svg',
                      label: 'Dex',
                      color: const Color(0xFF666A75),
                      onTap: () async {
                        const url =
                            "https://dexscreener.com/solana/ED5nyyWEzpPPiWimP8vYm7sD7TD3LAt3Q3gRTWHzPJBY";

                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url),
                              mode: LaunchMode.externalApplication);
                        }
                      },
                    ),
                  ],
                ),
                Text(
                  "Isla Solara",
                  style: const TextStyle(
                    fontFamily: "Nabla",
                    fontWeight: FontWeight.w900,
                    fontSize: 22.0,
                  ),
                ),
                Row(
                  children: [
                    CustomButton(
                      icon: FontAwesomeIcons.xTwitter,
                      iconSize: 16.0,
                      color: const Color(0xFF718DAC),
                      onTap: () async {
                        const url = "https://x.com/taxhavistan";
                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url),
                              mode: LaunchMode.externalApplication);
                        }
                      },
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    CustomButton(
                      icon: FontAwesomeIcons.telegram,
                      iconSize: 16.0,
                      color: const Color(0xFF86aed1),
                      onTap: () async {
                        const url = "https://t.me/taxhavistan";
                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url),
                              mode: LaunchMode.externalApplication);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
