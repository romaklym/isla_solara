import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:islasolara/dialogs/how_to_play_dialog.dart';
import 'package:islasolara/dialogs/tokenomics_dialog.dart';
import 'package:islasolara/widgets/buy_button.dart';
import 'package:islasolara/widgets/copy_text.dart';
import 'package:islasolara/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatefulWidget {
  const Footer({super.key});

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  void _openDialog(Widget dialog) {
    showDialog(
      context: context,
      builder: (_) => dialog,
    );
  }

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
                Row(
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
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                    CustomButton(
                      icon: FontAwesomeIcons.gamepad,
                      label: "How to Play?",
                      color: const Color(0xFF679a7d),
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
                      color: const Color(0xFFaebc6e),
                      onTap: () => _openDialog(
                        const Tokenomics(),
                      ),
                    ),
                  ],
                ),
                CopyTextWidget(
                  addressFontSize: 10.0,
                  addressIconSize: 12.0,
                  contWidth: 380,
                  copyText: "0x532f27101965dd16442E59d40670FaF5eBB142E4",
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
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
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
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                    CustomButton(
                      icon: FontAwesomeIcons.xTwitter,
                      iconSize: 16.0,
                      color: const Color(0xFF718DAC),
                      onTap: () async {
                        const url = "https://x.com/islasolara";
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
                      iconSize: 16.0,
                      color: const Color(0xFF86aed1),
                      onTap: () async {
                        const url = "https://t.me/islasolara";
                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url),
                              mode: LaunchMode.externalApplication);
                        }
                      },
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
