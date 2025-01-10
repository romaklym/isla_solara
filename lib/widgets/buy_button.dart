import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BuyButton extends StatelessWidget {
  final VoidCallback onTap; // Pass a custom function for onTap
  final double iconSize;
  final double fontSize;
  final double sizedBoxSize;

  const BuyButton({
    super.key,
    required this.onTap, // Require onTap function
    this.iconSize = 20.0, // Default icon size
    this.fontSize = 18.0, // Default font size
    this.sizedBoxSize = 8.0, // Default spacing size
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
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
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF9CBD88), // Start color
                const Color(0xFF7A9858),
                const Color(0xFF5A7446),
                const Color(0xFF425D37),
              ],
              begin: Alignment.centerLeft, // Start position of the gradient
              end: Alignment.centerRight, // End position of the gradient
            ),
            border: Border.all(
              color: Colors.black54,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                FontAwesomeIcons.dollarSign,
                color: Colors.white70,
                size: iconSize, // Use customizable icon size
              ),
              SizedBox(width: sizedBoxSize), // Use customizable spacing
              Text(
                "Buy",
                style: TextStyle(
                  fontFamily: "Audiowide",
                  fontSize: fontSize, // Use customizable font size
                  color: Colors.white70,
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
