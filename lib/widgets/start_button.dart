import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StartButton extends StatelessWidget {
  final VoidCallback onTap; // Pass a custom function for onTap
  final double iconSize;
  final double fontSize;
  final double sizedBoxSize;

  const StartButton({
    super.key,
    required this.onTap, // Require onTap function
    this.iconSize = 16.0, // Default icon size
    this.fontSize = 14.0, // Default font size
    this.sizedBoxSize = 8.0, // Default spacing size
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF704214), // Shadow color
            offset: const Offset(-5, 5),
            blurRadius: 0,
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap, // Use the passed function
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.amber, // Start color
                Colors.amberAccent, // End color
              ],
              begin: Alignment.centerLeft, // Start position of the gradient
              end: Alignment.centerRight, // End position of the gradient
            ),
            border: Border.all(
              color: const Color(0xFF704214),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                FontAwesomeIcons.dollarSign,
                color: Colors.black54,
                size: iconSize, // Use customizable icon size
              ),
              SizedBox(width: sizedBoxSize), // Use customizable spacing
              Text(
                "Buy",
                style: TextStyle(
                  fontFamily: "Audiowide",
                  fontSize: fontSize, // Use customizable font size
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
