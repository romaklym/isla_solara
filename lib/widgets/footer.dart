import 'package:flutter/material.dart';
import 'package:taxhavistan/widgets/buy_button.dart';
import 'package:taxhavistan/widgets/custom_button.dart';
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
                left: 32.0,
                bottom: 32.0,
              ),
              child: BuyButton(
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
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 32.0),
              child: CustomButton(
                color: Color(0xFFe85229),
                onTap: () {},
                label: "About",
                icon: Icons.people,
              ),
            ),
          )
        ],
      ),
    );
  }
}
