import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taxhavistan/screens/globe_widget.dart';
import 'package:taxhavistan/widgets/custom_button.dart';
import 'package:taxhavistan/widgets/start_button.dart';
import 'package:url_launcher/url_launcher.dart';

class MobileScreen extends StatelessWidget {
  const MobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Interactive Globe
            Center(
              child: GlobeWidget(
                zoomIn: 16.0,
              ),
            ),
            // App Bar
            Positioned(
              top: 0, // Place at the top of the screen
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          CustomButton(
                            icon: FontAwesomeIcons.xTwitter,
                            iconSize: 12.0,
                            color: const Color(0xFF2AB7E3),
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
                            iconSize: 12.0,
                            color: const Color(0xFF2AB7E3),
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
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Taxhavistan",
                        style: const TextStyle(
                          fontFamily: "Nabla",
                          fontWeight: FontWeight.w900,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: CustomButton(
                        label: "How to Play?",
                        fontSize: 10.0,
                        color: const Color(0xFF582b84),
                        onTap: () async {
                          const url = "https://x.com/taxhavistan";
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url),
                                mode: LaunchMode.externalApplication);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Informational Message
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF704214),
                        offset: const Offset(-5, 5),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: Color(0xFF2ab7e3), // Use determined button color
                      border: Border.all(color: Colors.black54, width: 1.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "This game is only available on Desktop Browsers.",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: "Audiowide",
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        CustomButton(
                          label: "Learn More",
                          color: Colors.amber,
                          onTap: () {},
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Footer with Buy Button
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
