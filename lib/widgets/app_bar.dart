import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taxhavistan/dialogs/how_to_play_dialog.dart';
import 'package:taxhavistan/dialogs/tokenomics_dialog.dart';
import 'package:taxhavistan/widgets/app_bar_buttons.dart';
import 'package:taxhavistan/widgets/custom_button.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
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
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
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
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Isla Solara",
                style: const TextStyle(
                  fontFamily: "Nabla",
                  fontWeight: FontWeight.w900,
                  fontSize: 32,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: AppBarButtons(),
            )
          ],
        ),
      ),
    );
  }
}
