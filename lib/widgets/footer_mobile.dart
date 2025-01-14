import 'package:flutter/material.dart';
import 'package:islasolara/widgets/buy_button.dart';
import 'package:islasolara/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterMobile extends StatefulWidget {
  const FooterMobile({super.key});

  @override
  State<FooterMobile> createState() => _FooterMobileState();
}

class _FooterMobileState extends State<FooterMobile> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0, // Place at the top of the screen
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
                BuyButton(
                  onTap: () async {
                    const url =
                        "https://raydium.io/swap/?inputMint=2zMMhcVQEXDtdE6vsFS7S7D5oUodfJHE8vd1gnBouauv&outputMint=sol";
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url),
                          mode: LaunchMode.externalApplication);
                    }
                  },
                  fontSize: 14.0,
                  iconSize: 16.0,
                  sizedBoxSize: 14.0,
                ),
                Row(
                  children: [
                    CustomButton(
                      svgPath: 'assets/dex.svg',
                      label: 'DexScreener',
                      color: const Color(0xFFf8c3b6),
                      onTap: () async {
                        const url =
                            "https://dexscreener.com/solana/ED5nyyWEzpPPiWimP8vYm7sD7TD3LAt3Q3gRTWHzPJBY";

                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url),
                              mode: LaunchMode.externalApplication);
                        }
                      },
                      fontSize: 10.0,
                      iconSize: 12.0,
                    ),
                    SizedBox(width: 8.0),
                    CustomButton(
                      svgPath: 'assets/dextools.svg',
                      label: 'DexTools',
                      color: const Color(0xFF666A75),
                      onTap: () async {
                        const url =
                            "https://dexscreener.com/solana/ED5nyyWEzpPPiWimP8vYm7sD7TD3LAt3Q3gRTWHzPJBY";

                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url),
                              mode: LaunchMode.externalApplication);
                        }
                      },
                      fontSize: 10.0,
                      iconSize: 12.0,
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
