import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taxhavistan/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

class AppBarButtons extends StatelessWidget {
  const AppBarButtons({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 410,
      child: Row(
        children: [
          CustomButton(
              svgPath: 'assets/dex.svg',
              label: 'DexScreener',
              color: const Color(0xFF298AAA),
              onTap: () => _launchUrl(
                  "https://dexscreener.com/solana/ED5nyyWEzpPPiWimP8vYm7sD7TD3LAt3Q3gRTWHzPJBY")),
          SizedBox(
            width: 16.0,
          ),
          CustomButton(
            svgPath: 'assets/dextools.svg',
            label: 'DexTools',
            color: const Color(0xFF006992),
            onTap: () => _launchUrl(
                "https://dexscreener.com/solana/ED5nyyWEzpPPiWimP8vYm7sD7TD3LAt3Q3gRTWHzPJBY"),
          ),
          SizedBox(
            width: 16.0,
          ),
          CustomButton(
            icon: FontAwesomeIcons.xTwitter,
            iconSize: 16.0,
            color: const Color(0xFF006992),
            onTap: () async {
              const url = "https://x.com/taxhavistan";
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
            color: const Color(0xFF298AAA),
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
    );
  }
}
