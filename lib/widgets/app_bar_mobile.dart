import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:islasolara/dialogs/tokenomics_mobile.dart';
import 'package:islasolara/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

class AppBarMobile extends StatefulWidget {
  const AppBarMobile({super.key});

  @override
  State<AppBarMobile> createState() => _AppBarMobileState();
}

class _AppBarMobileState extends State<AppBarMobile> {
  void _openDialog(Widget dialog) {
    showDialog(
      context: context,
      builder: (_) => dialog,
    );
  }

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
                        const url = "https://x.com/islasolara";
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
            ),
          ],
        ),
      ),
    );
  }
}
