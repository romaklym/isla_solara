import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taxhavistan/dialogs/how_to_play_dialog.dart';
import 'package:taxhavistan/dialogs/tokenomics_mobile.dart';
import 'package:taxhavistan/widgets/buy_button.dart';
import 'package:taxhavistan/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterMobile extends StatefulWidget {
  const FooterMobile({super.key});

  @override
  State<FooterMobile> createState() => _FooterMobileState();
}

class _FooterMobileState extends State<FooterMobile> {
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
                BuyButton(
                  onTap: () async {
                    const url =
                        "https://raydium.io/swap/?inputMint=2zMMhcVQEXDtdE6vsFS7S7D5oUodfJHE8vd1gnBouauv&outputMint=sol";
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url),
                          mode: LaunchMode.externalApplication);
                    }
                  },
                  fontSize: 12.0,
                  iconSize: 14.0,
                  sizedBoxSize: 16.0,
                ),
                CustomButton(
                  icon: FontAwesomeIcons.gamepad,
                  label: "How to Play?",
                  color: const Color(0xFF679a7d),
                  onTap: () => _openDialog(
                    const HowToPlay(),
                  ),
                  fontSize: 10.0,
                  iconSize: 12.0,
                ),
                CustomButton(
                  icon: FontAwesomeIcons.coins,
                  label: "Tokenomics",
                  color: const Color(0xFFaebc6e),
                  onTap: () => _openDialog(
                    const TokenomicsMobile(),
                  ),
                  fontSize: 10.0,
                  iconSize: 12.0,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
